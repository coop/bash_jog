require 'paint'

class PromptString
  def initialize &block
    @buf = ""
    instance_eval &block
  end

  ESC = ''
  BASH_ESC = '\e'
  COLOR_IN = '\['
  COLOR_OUT = '\]'

  def self.prepare prompt_string
<<EOP.chomp
__ssh_connected() {
  [[ -n "$SSH_CONNECTION" ]] && echo "$1"
}
__gitdir() {
  if [ -z "${1-}" ]; then
    if [ -n "${__git_dir-}" ]; then
      echo "$__git_dir"
    elif [ -n "${GIT_DIR-}" ]; then
      test -d "${GIT_DIR-}" || return 1
      echo "$GIT_DIR"
    elif [ -d .git ]; then
      echo .git
    else
      git rev-parse --git-dir 2>/dev/null
    fi
  elif [ -d "$1/.git" ]; then
    echo "$1/.git"
  else
    echo "$1"
  fi
}
__git_in_repo() { __gitdir > /dev/null; }
__git_is_dirty() { git status --porcelain | grep -q .; }
__git_dirty() { __git_in_repo && __git_is_dirty && echo "$1"; }
__git_clean() { __git_in_repo && (__git_is_dirty || echo "$1"); }

export PS1='#{prompt_string}'
EOP
  end

  def self.build &block
    new(&block).optimize
  end

  def optimize
    string
      .gsub(ESC, BASH_ESC)
      .gsub('\]\[', '')
      .gsub(/\\e\[(\d+)m\\e\[(\d+)/, '\e[\1;\2')
  end

  def string
    @buf
  end

  def command cmd
    @buf << "$(#{cmd})"
  end

  def color color, str
    @buf << COLOR_IN
    @buf << Paint.color(color)
    @buf << COLOR_OUT
    @buf << str
    @buf << COLOR_IN
    @buf << Paint::NOTHING
    @buf << COLOR_OUT
  end

  def bare str
    @buf << str
  end

  def new_line
    @buf << '\n'
  end

  def space
    @buf << ' '
  end
end

class CommandWrappedString < PromptString
  def self.build(cmd, &block)
    %[#{cmd} "#{super(&block)}"]
  end
end
