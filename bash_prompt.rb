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
function __git_in_repo() { __gitdir > /dev/null; }
function __git_is_dirty() { git status --porcelain | grep -q .; }
function __git_dirty() { __git_in_repo && __git_is_dirty && echo "$1"; }
function __git_clean() { __git_in_repo && (__git_is_dirty || echo "$1"); }
function __jobs_any() { jobs | grep -q . && echo "$1"; }

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
end

class CommandWrappedString < PromptString
  def self.build(cmd, &block)
    %[#{cmd} "#{super(&block)}"]
  end
end
