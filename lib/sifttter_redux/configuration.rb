require 'yaml'

module SifttterRedux
  #  ======================================================
  #  Configuration Module
  #
  #  Manages any configuration values and the flat file
  #  into which they get stored.
  #  ======================================================
  module Configuration
    #  ----------------------------------------------------
    #  [] method
    #
    #  Returns the Hash of data for a particular section.
    #  @param section_name The section in which to look
    #  @return Hash
    #  ----------------------------------------------------
    def self.[](section_name)
      if section_exists?(section_name)
        @data[section_name]
      else
        error = "Section does not exist: #{ section_name }"
        Methadone::CLILogging.error(error)
        fail ArgumentError, error
      end
    end
    
    #  ----------------------------------------------------
    #  []= method
    #
    #  Assigns the passed hash to the section. NOTE THAT THE
    #  PREVIOUS CONTENTS OF THAT SECTION ARE DELETED.
    #  @param section_name The section in which to look
    #  @param hash The Hash that gets merged into the section
    #  @return Void
    #  ----------------------------------------------------
    def self.[]=(section_name, hash)
      if hash.is_a?(Hash)
        @data[section_name] = {}
        @data[section_name].merge!(hash)
      else
        error = "Parameter is not a Hash: #{ hash }"
        Methadone::CLILogging.error(error)
        fail ArgumentError, error
      end
    end

    #  ----------------------------------------------------
    #  add_section method
    #
    #  Creates a new section in the configuration data.
    #  @param section_name The section to add
    #  @return Void
    #  ----------------------------------------------------
    def self.add_section(section_name)
      if !self.section_exists?(section_name)
        @data[section_name] = {}
      else
        CLIMessage::warning("Can't create already-existing section: #{ section_name }")
      end
    end

    #  ----------------------------------------------------
    #  config_path method
    #
    #  Returns the filepath to the flat configuration file.
    #  @return String
    #  ----------------------------------------------------
    def self.config_path
      @config_path
    end

    #  ----------------------------------------------------
    #  delete_section method
    #
    #  Deletes a section from the configuration data.
    #  @param section_name The section to delete
    #  @return Void
    #  ----------------------------------------------------
    def self.delete_section(section_name)
      if self.section_exists?(section_name)
        @data.delete(section_name)
      else
        CLIMessage::warning("Can't delete non-existing section: #{ section_name }")
      end
    end
    
    #  ----------------------------------------------------
    #  dump method
    #
    #  Returns the data Hash
    #  @return Hash
    #  ----------------------------------------------------
    def self.dump
      @data
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
      @config_path = path

      if File.exists?(path)
        @data = YAML.load_file(path)
      else
        @data = {}
      end
    end

    #  ----------------------------------------------------
    #  reset method
    #
    #  Clears the configuration data.
    #  @return Void
    #  ----------------------------------------------------
    def self.reset
      @data = {}
    end

    #  ----------------------------------------------------
    #  save method
    #
    #  Saves the configuration data to the previously
    #  stored flat file.
    #  @return Void
    #  ----------------------------------------------------
    def self.save
      File.open(@config_path, 'w') { |f| f.write(@data.to_yaml) }
    end

    #  ----------------------------------------------------
    #  section_exists? method
    #
    #  Checks for the existance of the passed section.
    #  @param section_name The section to look for
    #  @return Bool
    #  ----------------------------------------------------
    def self.section_exists?(section_name)
      @data.key?(section_name)
    end
  end
end
