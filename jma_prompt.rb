require_relative 'bash_prompt'

prompt = PromptString.build do
  command CommandWrappedString.build("__git_ps1") {
    color :white, "("
  }
  command CommandWrappedString.build("__git_dirty") {
    color :red, "✗"
  }
  command CommandWrappedString.build("__git_clean") {
    color :green, "✓"
  }
  command CommandWrappedString.build("__git_ps1") {
    bare ' '
    color :blue, "%s"
    color :white, ")"
    bare ' '
  }
  command CommandWrappedString.build("__jobs_any") {
    color :yellow, "ꕚ "
  }
  color :cyan, '\w'
  color :yellow, '\$'
  bare ' '
end

puts PromptString.prepare prompt
