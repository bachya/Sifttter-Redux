require 'singleton'

#|  ======================================================
#|  ConfigManager Class
#|
#|  Singleton to manage the YAML config file
#|  for this script
#|  ======================================================

class ConfigManager
  include Singleton
  
  attr_accessor :configFile
  
  #|  ------------------------------------------------------
  #|  initialize method
  #|
  #|  Initializes this singleton with data from the config
  #|  file. If the file doesn't exist, an empty hash is
  #|  created in anticipation of future config saves.
  #|  @return Void
  #|  ------------------------------------------------------
  def initialize
    @configFile = SifttterRedux::SRD_CONFIG_FILEPATH
    
    if File.exists?(SifttterRedux::SRD_CONFIG_FILEPATH) 
      @data = YAML.load_file(SifttterRedux::SRD_CONFIG_FILEPATH)
      @data.each do |k, v|
        define_singleton_method(k) { return v }
      end
    else
      @data = {}
    end
  end
  
  #|  ------------------------------------------------------
  #|  _dump method
  #|
  #|  Convenience method that dumps the configuration hash's
  #|  data.
  #|  @return Void
  #|  ------------------------------------------------------
  def _dump
    puts @data
  end
  
  #|  ------------------------------------------------------
  #|  add_to_section method
  #|
  #|  Adds a hash to the configuration data.
  #|  @param hash The hash to add to configuration
  #|  @param section The section into which the hash goes
  #|  @return Void
  #|  ------------------------------------------------------
  def add_to_section(hash, section)
    unless @data.has_key?(section)
      CliMessage.warning("Attempting to insert into a non-existing section: #{section}; skipping...")
      return 
    end
    
    @data[section].merge!(hash)
  end
  
  #|  ------------------------------------------------------
  #|  create_section method
  #|
  #|  Creates a new section in the configuration hash.
  #|  @param section The section to create
  #|  @return Void
  #|  ------------------------------------------------------
  def create_section(section)
    if @data.has_key?(section)
      CliMessage.warning("Attempting to create existing section (#{section}); skipping...")
      return
    end

    define_singleton_method(section) { return @data[section] }
    @data.merge!(section => {})
  end
  
  #|  ------------------------------------------------------
  #|  delete_section method
  #|
  #|  Deletes a section in the configuration hash.
  #|  @param section The section to delete
  #|  @return Void
  #|  ------------------------------------------------------
  def delete_section(section)
    unless @data.has_key?(section)
      CliMessage.warning("Attempting to delete non-existing section (#{section}); skipping...")
      return
    end
    
    remove_singleton_method(section)
    @data.delete(section)
  end
  
  #|  ------------------------------------------------------
  #|  remove_singleton_method method
  #|
  #|  Removes a hash from the configuration data based on
  #|  its key.
  #|  @param hash The hash key remove
  #|  @param section The section from which the key comes
  #|  @return Void
  #|  ------------------------------------------------------
  def remove_from_section(key, section)
    unless @data.has_key?(section) && @data[section].has_key?(key)
      CliMessage.warning("Attempting to remove a non-existing key: #{section}.#{key}; skipping...")
      return
    end
    
    @data[section].delete(key)
  end
  
  #|  ------------------------------------------------------
  #|  reset method
  #|
  #|  Clears out the configuration data by resetting the hash.
  #|  @return Void
  #|  ------------------------------------------------------
  def reset
    @data = {}
  end
  
  #|  ------------------------------------------------------
  #|  save_configuration method
  #|
  #|  Saves the configuration data to the filesystem.
  #|  @return File
  #|  ------------------------------------------------------
  def save_configuration
    return File.open(@configFile, 'w') { |f| f.write(@data.to_yaml) }
  end
  
end