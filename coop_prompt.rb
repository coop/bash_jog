require_relative 'bash_prompt'

prompt = PromptString.build do
  new_line
  command CommandWrappedString.build("__ssh_connected") {
    color :yellow, '\u@\h '
  }
  color :blue, '\w'
  space
  command CommandWrappedString.build("__git_ps1") {
    color [96, 97, 96], "%s"
  }
  command CommandWrappedString.build("__git_dirty") {
    color [96, 97, 96], "*"
  }
  new_line
  command CommandWrappedString.build("__git_dirty") {
    color :red, "❯"
  }
  command CommandWrappedString.build("__git_clean") {
    color :magenta, "❯"
  }
  space
end

puts PromptString.prepare prompt
