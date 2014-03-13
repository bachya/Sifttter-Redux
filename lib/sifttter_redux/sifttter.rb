module SifttterRedux
  #  ======================================================
  #  Sifttter Module
  #
  #  Wrapper module for Sifttter itself
  #  ======================================================
  module Sifttter
    include SifttterRedux::OS

    #  ----------------------------------------------------
    #  run_sifttter method
    #
    #  Modified form of Sifttter
    #
    #  Sifttter: An IFTTT-to-Day One Logger by Craig Eley
    #  Based on tp-dailylog.rb by Brett Terpstra 2012
    #  @param date The date to use when scanning Sifttter
    #  @return Void
    #  ----------------------------------------------------
    def self.run(date)
      uuid_command = 'uuidgen' if OS.mac?
      uuid_command = 'uuid' if OS.linux?
      uuid = %x{#{ uuid_command }}.gsub(/-/, '').strip

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

      date_regex = "(?:#{ date.strftime("%B") } 0?#{ date.strftime("%-d") }, #{ date.strftime("%Y") })"
      time_regex = "(?:\d{1,2}:\d{1,2}\s?[AaPpMm]{2})"

      files = `find #{ Configuration['sifttter_redux']['sifttter_local_filepath'] } -type f -name "*.txt" | grep -v -i daily | sort`
      if files.empty?
        m = "Couldn't download Sifttter files; is #{ Configuration['sifttter_redux']['sifttter_remote_filepath'] } the correct remote filepath?"
        CLIMessage.error(m)
        return
      end

      projects = []
      files.split("\n").each do |file|
        if File.exists?(file.strip)
      		f = File.open(file.strip, encoding: 'UTF-8')
      		lines = f.read
      		f.close
      		project = '### ' + File.basename(file).gsub(/^.*?\/([^\/]+)$/, "\\1") + "\n"

      		found_completed = false
      		lines.each_line do |line|
      			if line =~ /&/
      				line.gsub!(/[&]/, 'and')
      			end
      			if line =~ /#{ date_regex }/
      				found_completed = true
      				project += line.gsub(/@done/,"").gsub(/#{ date_regex }\s(-|at)\s/, "").gsub(/#{ time_regex }\s-\s/, "").strip + "\n"
      			end
      		end
      	end
      	if found_completed
      		projects.push(project)
      	end
      end

      if projects.length <=0
      	CLIMessage::warning('No entries found...')
      end

      if projects.length > 0
      	entrytext = "# Things done on #{ date_for_title }\n\n"
      	projects.each do |project|
      		entrytext += project.gsub(/.txt/, ' ') + "\n\n"
      	end

        Dir.mkdir(Configuration['sifttter_redux']['dayone_local_filepath']) if !Dir.exists?(Configuration['sifttter_redux']['dayone_local_filepath'])

      	fh = File.new(File.expand_path(Configuration['sifttter_redux']['dayone_local_filepath'] + '/' + uuid + '.doentry'), 'w+')
      	fh.puts template.result(binding)
      	fh.close
      	CLIMessage::success("Entry logged for #{ date_for_title }...")
      end
    end
  end
end
