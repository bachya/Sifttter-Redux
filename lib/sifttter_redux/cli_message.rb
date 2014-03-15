require 'readline'

module SifttterRedux
  #  ======================================================
  #  CliManager Module
  #  Singleton to manage common CLI interfacing
  #  ======================================================
  module CLIMessage
    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  activate_logging method
    #
    #  Creates a simple logger to use
    #  @return Void
    #  ----------------------------------------------------
    def self.activate_logging
      @@logger = Logger.new(File.join(ENV['HOME'], '.sifttter_redux_log'))
    end

    #  ----------------------------------------------------
    #  deactivate_logging method
    #
    #  Stops logging to file.
    #  @return Void
    #  ----------------------------------------------------
    def self.deactivate_logging
      @@logger = nil
    end

    #  ----------------------------------------------------
    #  debug method
    #
    #  Logs a debug message to the logfile.
    #  @param m The message to log
    #  @return Void
    #  ----------------------------------------------------
    def self.debug(m)
      @@logger.debug(m.blue) unless @@logger.nil?
    end

    #  ----------------------------------------------------
    #  error method
    #
    #  Outputs a formatted-red error message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.error(m)
      puts "# #{ m }".red
      @@logger.error(m.red) unless @@logger.nil?
    end

    #  ----------------------------------------------------
    #  info method
    #
    #  Outputs a formatted-blue informational message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.info(m)
      puts "# #{ m }".blue
      @@logger.debug(m.blue) unless @@logger.nil?
    end

    #  ----------------------------------------------------
    #  info_block method
    #
    #  Wraps a block in an opening and closing info message.
    #  @param m1 The opening message to output
    #  @param m2 The closing message to output
    #  @param multiline Whether the message should be multiline
    #  @return Void
    #  ----------------------------------------------------
    def self.info_block(m1, m2 = 'Done.', multiline = false)
      if block_given?
        if multiline
          info(m1)
        else
          print "# #{ m1 }".blue
        end

        yield

        if multiline
          info(m2)
        else
          puts m2.blue
        end
      else
        fail ArgumentError, 'Did not specify a valid block'
      end
    end

    #  ----------------------------------------------------
    #  prompt method
    #
    #  Outputs a prompt, collects the user's response, and
    #  returns it.
    #  @param prompt The prompt to output
    #  @param default The default option
    #  @return String
    #  ----------------------------------------------------
    def self.prompt(prompt, default = nil)
      print "# #{ prompt } #{ default.nil? ? '' : "[default: #{ default }]:" } ".green
      choice = $stdin.gets.chomp
      if choice.empty?
        r = default
      else
        r = choice
      end
      @@logger.debug("Answer to \"#{ prompt }\": #{ r }") unless @@logger.nil?
      r
    end

    #  ----------------------------------------------------
    #  prompt_for_filepath method
    #
    #  Outputs a prompt, collects the user's response, and
    #  returns it; adds in readline support for path
    #  completion.
    #
    #  "ruby readline filename tab completion" - William Morgan
    #  http://masanjin.net/blog/ruby-readline-tab-completion
    #
    #  @param prompt The prompt to output
    #  @param default The default option
    #  @param start_dir The directory in which to start
    #  @return String
    #  ----------------------------------------------------
    def self.prompt_for_filepath(prompt, default = nil, start_dir = '')
      Readline.completion_append_character = nil
      Readline.completion_proc = lambda do |prefix|
        files = Dir["#{start_dir}#{prefix}*"]
        files.
          map { |f| File.expand_path(f) }.
          map { |f| File.directory?(f) ? f + "/" : f }
      end
      choice = Readline.readline("# #{ prompt } #{ default.nil? ? '' : "[default: #{ default }]:" } ".green)
      if choice.empty?
        r = default
      else
        r = choice
      end
      @@logger.debug("Answer to \"#{ prompt }\": #{ r }") unless @@logger.nil?
      r
    end

    #  ----------------------------------------------------
    #  section method
    #
    #  Outputs a formatted-purple section message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.section(m)
      puts "---> #{ m }".purple
      @@logger.debug(m.purple) unless @@logger.nil?
    end

    #  ----------------------------------------------------
    #  section_block method
    #
    #  Wraps a block in an opening and closing section
    #  message.
    #  @param m1 The opening message to output
    #  @param m2 The closing message to output
    #  @param multiline A multiline message or not
    #  @return Void
    #  ----------------------------------------------------
    def self.section_block(m, multiline = true)
      if block_given?
        if multiline
          section(m)
        else
          print "---> #{ m }".purple
        end

        yield
      else
        error = 'Did not specify a valid block'
        fail ArgumentError, error
      end
    end

    #  ----------------------------------------------------
    #  success method
    #
    #  Outputs a formatted-green success message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.success(m)
      puts "# #{ m }".green
      @@logger.debug(m.green) unless @@logger.nil?
    end

    #  ----------------------------------------------------
    #  warning method
    #
    #  Outputs a formatted-yellow warning message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.warning(m)
      puts "# #{ m }".yellow
      @@logger.warn(m.yellow) unless @@logger.nil?
    end
  end
end

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
