#!/usr/bin/env ruby
#
# Sifttter Redux
#
# Based on Sifttter, an IFTTT-to-Day One Logger by Craig Eley 2014 <http://craigeley.com>
#
# Copyright (C) 2014 Aaron Bach <bachya1208@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#

require 'optparse'
require 'yaml'

# CONSTANTS (DON'T CHANGE THESE)
CONFIG_FILEPATH = "#{ENV['HOME']}/.sr-config"
SCRIPT_FILEPATH = File.expand_path File.dirname(__FILE__)
VERSION = 0.1

# Installs Dropbox Uploader from Github
def install_db_uploader
  
  valid_directory_chosen = false
  
  until valid_directory_chosen
    # Prompt the user for a location to save Dropbox Uploader.
    print "Location for Dropbox-Uploader (default: /usr/local/opt): "
    $db_uploader_location = $stdin.gets.chomp
    $db_uploader_location.chop! if $db_uploader_location.end_with?('/')
    $db_uploader_location = "/usr/local/opt" if $db_uploader_location.empty?
    
    # If the entered directory exists, clone the repository.
    if File.directory?($db_uploader_location)
      valid_directory_chosen = true
      $db_uploader_location << "/Dropbox-Uploader"
      %x{git clone https://github.com/andreafabrizi/Dropbox-Uploader.git #{$db_uploader_location}}
    else
      puts "Sorry, but #{$db_uploader_location} isn't a valid directory."
    end
  end
end

options = {}

opt_parser = OptionParser.new do |opt|
  script_name = File.basename($0)
  opt.banner = "\nSifttter Redux v#{VERSION}\nAaron Bach - bachya1208@gmail.com\nUsage: #{script_name} COMMAND [PARAMETERS]..."
  opt.separator ""
  opt.separator "COMMANDS:"
  opt.separator "    #{script_name} exec\t\# Execute the script"
  opt.separator "    #{script_name} init\t\# Initialize dependencies and install"
  opt.separator "    #{script_name} help\t\# Show this help message"
  opt.separator ""
  opt.separator "OPTIONAL PARAMETERS:"

  opt.on("-f" "\t\t# Load config from a specific file") do |filepath|

  end
  
  opt.separator ""
  opt.separator "For more info and examples, please see the README file.\n"
  
end

opt_parser.parse!

case ARGV[0]
when "exec"
  
when "init"
  puts "### INITIALIZING..."
  if File.exists?(CONFIG_FILEPATH)
    puts "It looks like you've already initialized Sifttter Redux."
  else
    install_db_uploader
    puts $db_uploader_location
  end
else
  puts opt_parser
end

# if (File.exists?(CONFIG_FILEPATH))
#   config_yaml = YAML.load_file(CONFIG_FILEPATH)
# else
#   config_yaml = {}
# end
# 
# usage

# config_yaml['aaron'] = "test"
# File.open(config_file, 'w') { |f| f.write config_yaml.to_yaml }
