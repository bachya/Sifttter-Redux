#|  ======================================================
#|  CliManager Module
#|  Singleton to manage common CLI interfacing
#|  ======================================================
module CliMessage
  
  ERROR   = 1
  INFO    = 2
  SECTION = 3
  WARNING = 4
  
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
  #|  Outputs a formatted-orange section message.
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
  #|  success method
  #|
  #|  Outputs a formatted-green success message.
  #|  @param message The message to output
  #|  @return Void
  #|  ------------------------------------------------------
  def self.success(message, addNewline = true)
    if addNewline
      puts "---> SUCCESS: #{message}".green
    else
      print "---> SUCCESS: #{message}".green
    end
    
    @@last_message_type = WARNING
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