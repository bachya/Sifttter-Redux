#  ======================================================
#  String Class
#  ======================================================
class String
  #  ----------------------------------------------------
  #  colorize method
  #
  #  Outputs a string in a formatted color.
  #  @param color_code The code to use
  #  @return Void
  #  ----------------------------------------------------
  def colorize(color_code)
    "\e[#{ color_code }m#{ self }\e[0m"
  end

  #  ----------------------------------------------------
  #  blue method
  #
  #  Convenience method to output a blue string
  #  @return Void
  #  ----------------------------------------------------
  def blue
    colorize(34)
  end

  #  ----------------------------------------------------
  #  green method
  #
  #  Convenience method to output a green string
  #  @return Void
  #  ----------------------------------------------------
  def green
    colorize(32)
  end

  #  ----------------------------------------------------
  #  purple method
  #
  #  Convenience method to output a purple string
  #  @return Void
  #  ----------------------------------------------------
  def purple
    colorize(35)
  end
  
  #  ----------------------------------------------------
  #  rchomp method
  #
  #  Removes a character from the beginning of a string
  #  @return String
  #  ----------------------------------------------------
  def rchomp(sep = $/)
    self.start_with?(sep) ? self[sep.size..-1] : self
  end

  #  ----------------------------------------------------
  #  red method
  #
  #  Convenience method to output a red string
  #  @return Void
  #  ----------------------------------------------------
  def red
    colorize(31)
  end

  #  ----------------------------------------------------
  #  yellow method
  #
  #  Convenience method to output a yellow string
  #  @return Void
  #  ----------------------------------------------------
  def yellow
    colorize(33)
  end
end
