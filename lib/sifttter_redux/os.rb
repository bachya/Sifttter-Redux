module SifttterRedux
  #  ======================================================
  #  OS Module
  #
  #  Module to easily find the running operating system
  #  ======================================================
  module OS

    #  ------------------------------------------------------
    #  linux? method
    #
    #  Returns true if the host OS is Linux (false otherwise).
    #  @return Bool
    #  ------------------------------------------------------
    def OS.linux?
      OS.unix? and not OS.mac?
    end
  
    #  ------------------------------------------------------
    #  mac? method
    #
    #  Returns true if the host OS is OS X (false otherwise).
    #  @return Bool
    #  ------------------------------------------------------
    def OS.mac?
     (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    #  ------------------------------------------------------
    #  unix? method
    #
    #  Returns true if the host OS is Unix (false otherwise).
    #  @return Bool
    #  ------------------------------------------------------
    def OS.unix?
      !OS.windows?
    end
  
    #  ------------------------------------------------------
    #  windows? method
    #
    #  Returns true if the host OS is Windows (false otherwise).
    #  @return Bool
    #  ------------------------------------------------------
    def OS.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
  end
end