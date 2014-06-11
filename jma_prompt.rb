require_relative 'bash_prompt'
require_relative 'unicode_escaper'

prompt = PromptString.build do
  command CommandWrappedString.build("__git_ps1") {
    color :white, "("
  }
  command CommandWrappedString.build("__git_dirty") {
    color :magenta, UnicodeEscaper.escape("✗")
  }
  command CommandWrappedString.build("__git_clean") {
    color :green, UnicodeEscaper.escape("✓")
  }
  command CommandWrappedString.build("__git_ps1") {
    bare ' '
    color :blue, "%s"
    color :white, ")"
    bare ' '
  }
  color :cyan, '\w'
  color :yellow, '\$'
  bare ' '
end

puts PromptString.prepare prompt
