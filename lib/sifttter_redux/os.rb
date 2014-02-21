module SifttterRedux
  #  ======================================================
  #  OS Module
  #
  #  Module to easily find the running operating system
  #  ======================================================
  module OS
    #  ----------------------------------------------------
    #  linux? method
    #
    #  Returns true if the host OS is Linux.
    #  @return Bool
    #  ----------------------------------------------------
    def OS.linux?
      self.unix? and not self.mac?
    end

    #  ----------------------------------------------------
    #  mac? method
    #
    #  Returns true if the host OS is OS X.
    #  @return Bool
    #  ----------------------------------------------------
    def OS.mac?
      !(/darwin/ =~ RUBY_PLATFORM).nil?
    end

    #  ----------------------------------------------------
    #  unix? method
    #
    #  Returns true if the host OS is Unix.
    #  @return Bool
    #  ----------------------------------------------------
    def OS.unix?
      !self.windows?
    end

    #  ----------------------------------------------------
    #  windows? method
    #
    #  Returns true if the host OS is Windows
    #  @return Bool
    #  ----------------------------------------------------
    def OS.windows?
      !(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
    end
  end
end
