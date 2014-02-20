require 'yaml'

module Configuration
  
  class SectionError < StandardError; end
  
  def self.[](section_name)
    @data[section_name]
  end
  
  def self.add_section(section_name)
    unless self.section_exists?(section_name)
      @data[section_name] = {}
    else
      raise SectionError, "Can't create pre-existing section #{section_name}"
    end
  end
  
  def self.config_path
    @configPath
  end
  
  def self.delete_section(section_name)
    if self.section_exists?(section_name)
      @data.delete(section_name)
    else
      raise SectionError, "Can't delete non-existing section #{section_name}"
    end
  end
  
  def self.load(path)
    @configPath = path
    
    if File.exists?(path)
      @data = YAML.load_file(path)
    else
      @data = {}
    end
  end
  
  def self.reset
    @data = {}
  end
  
  def self.save
    File.open(@configPath, 'w') { |f| f.write(@data.to_yaml) }
  end
  
  def self.section_exists?(section_name)
    @data.has_key?(section_name)
  end
  
  def self.to_s
    puts @data
  end
end