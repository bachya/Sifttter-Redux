module SifttterRedux
  #  ======================================================
  #  OS Module
  #
  #  Module to easily find the running operating system
  #  ======================================================
  class Plugin
    def self.plugins
      @plugins ||= []
    end
    
    def self.inherited(klass)
      @plugins ||= []
      @plugins << klass
    end
    
    def self.name
      puts @name
    end
  end
end