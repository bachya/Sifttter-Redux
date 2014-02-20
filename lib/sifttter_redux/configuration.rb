require 'yaml'

module SifttterRedux
  #  ======================================================
  #  Configuration Module
  #
  #  Manages any configuration values and the flat file
  #  into which they get stored.
  #  ======================================================
  module Configuration
  
    #  ======================================================
    #  SectionError Class
    #
    #  Custom exception for adding/removing bad sections to
    #  the configuration data.
    #  ======================================================
    class SectionError < StandardError; end
  
    #  ------------------------------------------------------
    #  [] method
    #
    #  Returns the Hash of data for a particular section.
    #  @param section_name The section in which to look
    #  @return Hash
    #  ------------------------------------------------------
    def self.[](section_name)
      @data[section_name]
    end
  
    #  ------------------------------------------------------
    #  add_section method
    #
    #  Creates a new section in the configuration data.
    #  @param section_name The section to add
    #  @return Void
    #  ------------------------------------------------------
    def self.add_section(section_name)
      unless self.section_exists?(section_name)
        @data[section_name] = {}
      else
        raise SectionError, "Can't create pre-existing section #{section_name}"
      end
    end
  
    #  ------------------------------------------------------
    #  config_path method
    #
    #  Returns the filepath to the flat configuration file.
    #  @return String
    #  ------------------------------------------------------
    def self.config_path
      @configPath
    end
  
    #  ------------------------------------------------------
    #  delete_section method
    #
    #  Deletes a section from the configuration data.
    #  @param section_name The section to delete
    #  @return Void
    #  ------------------------------------------------------
    def self.delete_section(section_name)
      if self.section_exists?(section_name)
        @data.delete(section_name)
      else
        raise SectionError, "Can't delete non-existing section #{section_name}"
      end
    end
  
    #  ------------------------------------------------------
    #  load method
    #
    #  Loads the configuration data (if it exists) and sets
    #  the filepath to the flat file.
    #  @param path The filepath
    #  @return Void
    #  ------------------------------------------------------
    def self.load(path)
      @configPath = path
    
      if File.exists?(path)
        @data = YAML.load_file(path)
      else
        @data = {}
      end
    end
  
    #  ------------------------------------------------------
    #  reset method
    #
    #  Clears the configuration data.
    #  @return Void
    #  ------------------------------------------------------
    def self.reset
      @data = {}
    end
  
    #  ------------------------------------------------------
    #  save method
    #
    #  Saves the configuration data to the previously
    #  stored flat file.
    #  @return Void
    #  ------------------------------------------------------
    def self.save
      File.open(@configPath, 'w') { |f| f.write(@data.to_yaml) }
    end
  
    #  ------------------------------------------------------
    #  section_exists? method
    #
    #  Checks for the existance of the passed section.
    #  @param section_name The section to look for
    #  @return Bool
    #  ------------------------------------------------------
    def self.section_exists?(section_name)
      @data.has_key?(section_name)
    end
  
    #  ------------------------------------------------------
    #  to_s method
    #
    #  Method to output this Module as a String.
    #  @return Void
    #  ------------------------------------------------------
    def self.to_s
      puts @data
    end
  end
end