#|  ======================================================
#|  METHODS
#|  ======================================================

#|  ------------------------------------------------------
#|  collect_preferences method
#|
#|  Collects preferences from the user and stores the
#|  entered values into a configuration file.
#|  @return Void
#|  ------------------------------------------------------
def collect_preferences
  CliMessage.section('COLLECTING PREFERENCES...')
  
  pref = CliMessage.prompt("Location for downloaded Sifttter files from Dropbox", SifttterRedux::SFT_LOCAL_FILEPATH)
  $config.add_to_section({"sifttter_local_filepath" => pref}, "sifttter_redux")
  
  pref = CliMessage.prompt("Location of Sifttter files in Dropbox", SifttterRedux::SFT_REMOTE_FILEPATH)
  $config.add_to_section({"sifttter_remote_filepath" => pref}, "sifttter_redux")
  
  pref = CliMessage.prompt("Location for downloaded Day One files from Dropbox", SifttterRedux::DO_LOCAL_FILEPATH)
  $config.add_to_section({"dayone_local_filepath" => pref}, "sifttter_redux")
  
  pref = CliMessage.prompt("Location of Day One files in Dropbox", SifttterRedux::DO_REMOTE_FILEPATH)
  $config.add_to_section({"dayone_remote_filepath" => pref}, "sifttter_redux")
end

#|  ------------------------------------------------------
#|  download_sifttter_files method
#|
#|  Downloads Sifttter files from Dropbox
#|  @return Void
#|  ------------------------------------------------------
def download_sifttter_files
  # Download all Sifttter files from Dropbox.
  CliMessage.info('Downloading Sifttter files...', false)
  `#{$db_uploader} download #{$config.sifttter_redux["sifttter_remote_filepath"]} #{$config.sifttter_redux["sifttter_local_filepath"]}`
  CliMessage.finish_message('DONE.')
end

#|  ------------------------------------------------------
#|  initialize_procedures method
#|
#|  Initializes Sifttter Redux by downloading and collecting
#|  all necessary items and info.
#|  @return Void
#|  ------------------------------------------------------
def initialize_procedures
  $config.reset
  $config.create_section("sifttter_redux")
  $config.add_to_section({"config_location" => $config.configFile}, "sifttter_redux")
  
  install_db_uploader 
  collect_preferences
  
  CliMessage.section("INITIALIZATION COMPLETE!")
  
  $config.save_configuration
end

#|  ------------------------------------------------------
#|  install_db_uploader method
#|
#|  Installs Dropbox Uploader to a user-specified location
#|  by cloning the git repository.
#|  @return Void
#|  ------------------------------------------------------
def install_db_uploader
  valid_directory_chosen = false
  
  CliMessage.section('DOWNLOADING DROPBOX UPLOADER...')
  
  # Create a new configuration section for Dropbox-Uploader
  $config.create_section("db_uploader")
  
  until valid_directory_chosen
    # Prompt the user for a location to save Dropbox Uploader. "
    db_uploader_location = CliMessage.prompt("Location for Dropbox-Uploader", SifttterRedux::DBU_LOCAL_FILEPATH)
    db_uploader_location.chop! if db_uploader_location.end_with?('/')
    db_uploader_location = "/usr/local/opt" if db_uploader_location.empty?
    
    # If the entered directory exists, clone the repository.
    if File.directory?(db_uploader_location)
      valid_directory_chosen = true
      db_uploader_location << "/Dropbox-Uploader"
      
      # If, for some reason, Dropbox Uploader alread exists at this location,
      # skip the clone.
      if File.directory?(db_uploader_location)
        CliMessage.info("You seem to already have Dropbox Uploader at this location; skipping...")
      else
        %x{git clone https://github.com/andreafabrizi/Dropbox-Uploader.git #{db_uploader_location}}
      end
      
      # Save config data to YAML.
      $config.add_to_section({"local_filepath" => db_uploader_location}, "db_uploader")
    else
      puts "Sorry, but #{db_uploader_location} isn't a valid directory."
    end
  end
end

#|  ------------------------------------------------------
#|  run_sifttter method
#|
#|  Modified form of Sifttter
#| 
#|  Sifttter: An IFTTT-to-Day One Logger by Craig Eley 2014
#|  Based on tp-dailylog.rb by Brett Terpstra 2012
#|  @param date The date to use when scanning Sifttter files
#|  @return Void
#|  ------------------------------------------------------
def run_sifttter(date)
  uuid_command = "uuidgen" if OS.mac?
  uuid_command = "uuid" if OS.linux?
  uuid = %x{#{uuid_command}}.gsub(/-/,'').strip 
  
  date_for_title = date.strftime('%B %d, %Y')
  datestamp = date.to_time.utc.iso8601
  starred = false

  template = ERB.new <<-XMLTEMPLATE
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
  	<key>Creation Date</key>
  	<date><%= datestamp %></date>
  	<key>Entry Text</key>
  	<string><%= entrytext %></string>
  	<key>Starred</key>
  	<<%= starred %>/>
  	<key>Tags</key>
  	<array>
  		<string>daily logs</string>
  	</array>
  	<key>UUID</key>
  	<string><%= uuid %></string>
  </dict>
  </plist>
  XMLTEMPLATE

  date_regex = "#{date.strftime('%B')} 0?#{date.strftime('%-d')}, #{date.strftime('%Y')}"
  time_regex = "\d{1,2}:\d{1,2}\s?[AaPpMm]{2}"

  files = %x{find #{$config.sifttter_redux["sifttter_local_filepath"]} -type f -name '*.txt' | grep -v -i daily | sort}

  projects = []
  files.split("\n").each do |file|
  	if File.exists?(file.strip)
  		f = File.open(file.strip, encoding: 'UTF-8')
  		lines = f.read
  		f.close
  		project = "### " + File.basename(file).gsub(/^.*?\/([^\/]+)$/,"\\1") + "\n"

  		found_completed = false
  		lines.each_line do |line|
  			if line =~ /&/
  				line.gsub!(/[&]/, 'and')
  			end
  			if line =~ /#{date_regex}/
  				found_completed = true
  				project += line.gsub(/@done/,'').gsub(/#{date_regex}\s(-|at)\s/, '').gsub(/#{time_regex}\s-\s/, '').strip + "\n"
  			end
  		end
  	end
  	if found_completed
  		projects.push(project)
  	end
  end
  
  if projects.length <=0
  	CliMessage.error("No entries found...")
    exit!
  end

  if projects.length > 0  
  	entrytext = "# Things done on #{date_for_title}\n\n"
  	projects.each do |project|
  		entrytext += project.gsub(/.txt/, ' ') + "\n\n"
  	end
    
    Dir.mkdir($config.sifttter_redux["dayone_local_filepath"]) if !Dir.exists?($config.sifttter_redux["dayone_local_filepath"])
    
  	fh = File.new(File.expand_path($config.sifttter_redux["dayone_local_filepath"] + "/" + uuid + ".doentry"), 'w+')
  	fh.puts template.result(binding)
  	fh.close
  	CliMessage.success("Entry logged for #{date_for_title}...")
  end
end