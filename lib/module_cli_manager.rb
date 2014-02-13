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

require 'colored'

#|  ======================================================
#|  CliManager Module
#|  Singleton to manage common CLI interfacing
#|  ======================================================
module CliMessage
  
  ERROR   = 1
  INFO    = 2
  SECTION = 3
  WARNING = 4
  
  @@last_message_type
  
  #|  ------------------------------------------------------
  #|  error method
  #|
  #|  Outputs a formatted-red error message.
  #|  @param message The message to output
  #|  @return Void
  #|  ------------------------------------------------------
  def self.error(message, addNewline = true)
    if addNewline
      puts "---> ERROR: #{message}".red
    else
      print "---> ERROR: #{message}".red 
    end
    
    @@last_message_type = ERROR
  end
  
  #|  ------------------------------------------------------
  #|  finish_message method
  #|
  #|  Finishes a previous message by appending "DONE" in the
  #|  correct color.
  #|  @return Void
  #|  ------------------------------------------------------
  def self.finish_message(message)
    case @@last_message_type
    when ERROR
      puts message.red
    when INFO
      puts message.blue
    when SECTION
      puts message.green
    when WARNING
      puts message.yellow
    end
  end
  
  #|  ------------------------------------------------------
  #|  info method
  #|
  #|  Outputs a formatted-blue informational message.
  #|  @param message The message to output
  #|  @return Void
  #|  ------------------------------------------------------
  def self.info(message, addNewline = true)
    if addNewline
      puts "---> INFO: #{message}".blue
    else
      print "---> INFO: #{message}".blue 
    end
    
    @@last_message_type = INFO
  end
  
  #|  ------------------------------------------------------
  #|  prompt method
  #|
  #|  Outputs a prompt, collects the user's response, and
  #|  returns it.
  #|  @param prompt The prompt to output
  #|  @param default The default option
  #|  @return String
  #|  ------------------------------------------------------
  def self.prompt(prompt, default)
    print "#{prompt} [default: #{default}]: "
    choice = $stdin.gets.chomp
    if choice.empty?
      return default
    else
      return choice
    end
  end
  
  #|  ------------------------------------------------------
  #|  section method
  #|
  #|  Outputs a formatted-green section message.
  #|  @param message The message to output
  #|  @return Void
  #|  ------------------------------------------------------
  def self.section(message, addNewline = true)
    if addNewline
      puts "#### #{message}".green
    else
      print "#### #{message}".green 
    end
    
    @@last_message_type = SECTION
  end
  
  #|  ------------------------------------------------------
  #|  warning method
  #|
  #|  Outputs a formatted-yellow warning message.
  #|  @param message The message to output
  #|  @return Void
  #|  ------------------------------------------------------
  def self.warning(message, addNewline = true)
    if addNewline
      puts "---> WARNING: #{message}".yellow
    else
      print "---> WARNING: #{message}".yellow
    end
    
    @@last_message_type = WARNING
  end
end