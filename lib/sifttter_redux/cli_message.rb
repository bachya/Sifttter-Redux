require File.join(File.dirname(__FILE__), 'string_extensions.rb')

module SifttterRedux
  #  ======================================================
  #  CliManager Module
  #  Singleton to manage common CLI interfacing
  #  ======================================================
  module CliMessage
    #  ----------------------------------------------------
    #  error method
    #
    #  Outputs a formatted-red error message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.error(m)
      puts "---> ERROR: #{ m }".red
    end

    #  ----------------------------------------------------
    #  info method
    #
    #  Outputs a formatted-blue informational message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.info(m)
      puts "---> INFO: #{ m }".blue
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
      if multiline
        info(m1)
      else
        print "---> INFO: #{ m1 }".blue
      end

      yield

      if multiline
        info(m2)
      else
        puts m2.blue
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
    def self.prompt(prompt, default)
      print "#{ prompt } [default: #{ default }]: "
      choice = $stdin.gets.chomp
      if choice.empty?
        return default
      else
        return choice
      end
    end

    #  ----------------------------------------------------
    #  section method
    #
    #  Outputs a formatted-orange section message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.section(m)
      puts "#### #{ m }".purple
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
      if multiline
        section(m)
      else
        print "#### #{ m }".purple
      end

      yield
    end

    #  ----------------------------------------------------
    #  success method
    #
    #  Outputs a formatted-green success message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.success(m)
      puts "---> SUCCESS: #{ m }".green
    end

    #  ----------------------------------------------------
    #  warning method
    #
    #  Outputs a formatted-yellow warning message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def self.warning(m)
      puts "---> WARNING: #{ m }".yellow
    end
  end
end
