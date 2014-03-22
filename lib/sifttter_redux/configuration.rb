require 'yaml'

module SifttterRedux
  #  ======================================================
  #  Configuration Module
  #
  #  Manages any configuration values and the flat file
  #  into which they get stored.
  #  ======================================================
  module Configuration
    extend self
    
    @_data = {}
    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  deep_merge! method
    #
    #  Deep merges two hashes.
    #  deep_merge by Stefan Rusterholz;
    #  see http://www.ruby-forum.com/topic/142809
    #  @return Void
    #  ----------------------------------------------------
    def deep_merge!(target, data)
      merger = proc{|key, v1, v2|
        Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      target.merge! data, &merger
    end

    #  ----------------------------------------------------
    #  method_missing method
    #
    #  Allows this module to return data from the config
    #  Hash when given a method name that matches a key.
    #  @param name
    #  @param *args
    #  @param &block
    #  @return Hash
    #  ----------------------------------------------------    
    def method_missing(name, *args, &block)
      @_data[name.to_sym] || @_data.merge!(name.to_sym => {})
    end

    #  ----------------------------------------------------
    #  add_section method
    #
    #  Adds a new section to the config file (if it doesn't
    #  already exist).
    #  @param section_name The section to add
    #  @return Void
    #  ----------------------------------------------------
    def self.add_section(section_name)
      @_data[section_name] = {} unless @_data.key?(section_name)
    end

    #  ----------------------------------------------------
    #  config_path method
    #
    #  Returns the path to the configuration file
    #  @return String
    #  ----------------------------------------------------
    def self.config_path
      @_config_path
    end

    #  ----------------------------------------------------
    #  delete_section method
    #
    #  Removes a section to the config file (if it exists).
    #  @param section_name The section to remove
    #  @return Void
    #  ----------------------------------------------------
    def self.delete_section(section_name)
      @_data.delete(section_name) if @_data.key?(section_name)
    end

    #  ----------------------------------------------------
    #  dump method
    #
    #  Returns the config Hash.
    #  @return Hash
    #  ----------------------------------------------------    
    def self.dump
      @_data
    end

    #  ----------------------------------------------------
    #  load method
    #
    #  Loads the configuration data (if it exists) and sets
    #  the filepath to the flat file.
    #  @param path The filepath
    #  @return Void
    #  ----------------------------------------------------
    def self.load(path)
      @_config_path = path
      
      if File.exists?(path)
        data = YAML.load_file(path)
        deep_merge!(@_data, data)
      end
    end

    #  ----------------------------------------------------
    #  reset method
    #
    #  Clears the configuration data.
    #  @return Void
    #  ----------------------------------------------------
    def self.reset
      @_data = {}
    end

    #  ----------------------------------------------------
    #  save method
    #
    #  Saves the configuration data to the previously
    #  stored flat file.
    #  @return Void
    #  ----------------------------------------------------
    def self.save
      File.open(@_config_path, 'w') { |f| f.write(@_data.to_yaml) }
    end
  end
end
