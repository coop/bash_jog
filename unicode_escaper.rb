# Bash/readline/something gets confused by the length of unicode characters. To
# fix this, we trick it by wrapping the unicode character in \[\], then using a
# sc and rc terminal escapes together with some space padding to figure out the
# correct width.
#
# See:
# http://stackoverflow.com/questions/7112774/how-to-escape-unicode-characters-in-bash-prompt-correctly/7123564#7123564
class UnicodeEscaper
  def self.escape str
    new(str).escape
  end

  def initialize str
    @str = str
  end

  def escape
    [
      hidden_unicode,
      store_cursor,
      padding,
      restore_cursor,
    ].join
  end

  private

  def width
    @str.codepoints.size
  end

  def bytes
    @str.bytes.size
  end

  def hidden_unicode
    hidden @str
  end

  def store_cursor
    hidden sh "tput sc"
  end

  def restore_cursor
    hidden sh "tput rc"
  end

  def sh cmd
    "$(#{cmd})"
  end

  def hidden str
    [
      '\[',
      str,
      '\]',
    ].join
  end

  def padding
    " " * bytes
  end
end
