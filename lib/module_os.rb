#-------------------------------------------------------------------------------------------------------------
#  Sifttter Redux
#
#  A modification of Craig Eley's Sifttter that allows for smart installation on a standalone *NIX
#  device (such as a Raspberry Pi).
#
#  Sifttter copyright Craig Eley 2014 <http://craigeley.com>
#
#  Copyright (c) 2014
#  Aaron Bach <bachya1208@gmail.com>
#  
#  Permission is hereby granted, free of charge, to any person
#  obtaining a copy of this software and associated documentation
#  files (the "Software"), to deal in the Software without
#  restriction, including without limitation the rights to use,
#  copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following
#  conditions:
#  
#  The above copyright notice and this permission notice shall be
#  included in all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#  OTHER DEALINGS IN THE SOFTWARE.
#-------------------------------------------------------------------------------------------------------------

#|  ======================================================
#|  OS Module
#|
#|  Module to easily find the running operating system
#|  ======================================================
module OS

  #|  ------------------------------------------------------
  #|  linux? method
  #|
  #|  Returns true if the host OS is Linux (false otherwise).
  #|  @return Bool
  #|  ------------------------------------------------------
  def OS.linux?
    OS.unix? and not OS.mac?
  end
  
  #|  ------------------------------------------------------
  #|  mac? method
  #|
  #|  Returns true if the host OS is OS X (false otherwise).
  #|  @return Bool
  #|  ------------------------------------------------------
  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  #|  ------------------------------------------------------
  #|  unix? method
  #|
  #|  Returns true if the host OS is Unix (false otherwise).
  #|  @return Bool
  #|  ------------------------------------------------------
  def OS.unix?
    !OS.windows?
  end
  
  #|  ------------------------------------------------------
  #|  windows? method
  #|
  #|  Returns true if the host OS is Windows (false otherwise).
  #|  @return Bool
  #|  ------------------------------------------------------
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end
end