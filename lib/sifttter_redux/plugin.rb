module SifttterRedux
  #  ======================================================
  #  OS Module
  #
  #  Module to easily find the running operating system
  #  ======================================================
  class Plugin
    attr_accessor :name
    
    def self.plugins
      @plugins ||= []
    end
    
    def self.inherited(klass)
      @plugins ||= []
      @plugins << klass
    end

    def initialize
      @name = "Unknown Plugin"
    end
    
    def method_missing(name, *args)
      raise "#{self.class.name} doesn't implement `#{name}`"
    end
    
    def respond_to_missing?(method_name, include_private)
      super
    end
  end
end

# class HelloPlugin < Plugin
#   def initialize
#     @name = 'HelloPlugin'
#   end
#   
#   def say_statement
#     "Hello!"
#   end
# end
# 
# class GoodbyePlugin < Plugin
#   def initialize
#     @name = 'GoodbyePlugin'
#   end
#   
#   def say_statement
#     "Goodbye!"
#   end
# end
# 
# h = HelloPlugin.new
# puts "#{h.class} says: #{h.say_statement}"
# 
# g = GoodbyePlugin.new
# puts "#{g.class} says: #{g.say_statement}"