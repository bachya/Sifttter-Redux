module SifttterRedux
  # Sifttter Module
  # Used to examine Sifttter data and create
  # Day One entries as necessary.
  module Sifttter
    extend self

    class << self
      # Stores the collection of entries to create.
      # @return [Hash]
      attr_accessor :entries
    end

    # Generates an ERB template for a Day One entry
    # @param [String] datestamp The ISO8601 datestamp
    # @param [String] entrytext The text of the entry
    # @param [Boolean] starred Whether the entry should be starred
    # @param [String] uuid The UUID of the entry
    def generate_template(datestamp, entrytext, starred, uuid)
      ERB.new <<-XMLTEMPLATE
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
    end

    # Opens a filepath and parses it for Sifttter
    # data for the passed date.
    # @param [String] file The filepath to parse
    # @return [void]
    def parse_sifttter_file(filepath)
      title = File.basename(filepath).gsub(/^.*?\/([^\/]+)$/, "\\1") + "\n"

      date_regex = "(?:#{ date.strftime("%B") } 0?#{ date.strftime("%-d") }, #{ date.strftime("%Y") })"
      time_regex = "(?:\d{1,2}:\d{1,2}\s?[AaPpMm]{2})"
      entry_regex = /@begin\n@date\s#{ date_regex }(?: at (.*?)\n)?(.*?)@end/m
      
      contents = File.read(filepath)
      cur_entries = contents.scan(entry_regex)
      unless cur_entries.empty?
        @entries.merge!(title => []) unless @entries.key?(title)
        cur_entries.each { |e| @entries[title] << [e[0], e[1].strip] }
      end
    end

    # Finds Siftter data for the passed date and
    # creates corresponding Day One entries.
    # @param [Date] date The date to search for
    # @return [void]
    def self.run(date)
      @entries = {}
      uuid = SecureRandom.uuid.upcase.gsub(/-/, '').strip
      date_for_title = date.strftime('%B %d, %Y')
      datestamp = date.to_time.utc.iso8601
      starred = false

      output_dir = configuration.sifttter_redux[:dayone_local_filepath]
      Dir.mkdir(output_dir) unless Dir.exists?(output_dir)
      
      files = `find #{ configuration.sifttter_redux[:sifttter_local_filepath] } -type f -name "*.txt" | grep -v -i daily | sort`
      if files.empty?
        messenger.error('No Sifttter files to parse...')
        messenger.error('Is Dropbox Uploader configured correctly?')
        messenger.error("Is #{ configuration.sifttter_redux[:sifttter_remote_filepath] } the correct remote filepath?")
        exit!(1)
      end
      
      files.split("\n").each do |file|
        file.strip!
        if File.exists?(file)
          parse_sifttter_file(file)
        end
      end
      
      if entries.length > 0
        entrytext = "# Things done on #{ date_for_title }\n\n"
        @entries.each do |key, value|
          entrytext += '### ' + key.gsub(/.txt/, '') + "\n\n"
          value.each { |v| entrytext += v[1] }
          template = generate_template(datestamp, entrytext, starred, uuid)
          
          p template
        end
      else
        messenger.warn('No entries found...')
      end
    end
    # Sifttter: An IFTTT-to-Day One Logger by Craig Eley
    # Based on tp-dailylog.rb by Brett Terpstra 2012
    # @param [Date] date The date to use when scanning Sifttter
    # @return [void]
    # def self.run(date)
    #   uuid = SecureRandom.uuid.upcase.gsub(/-/, '').strip
    #
    #   date_for_title = date.strftime('%B %d, %Y')
    #   datestamp = date.to_time.utc.iso8601
    #   starred = false
    #
    #   template = ERB.new <<-XMLTEMPLATE
    #   <?xml version="1.0" encoding="UTF-8"?>
    #   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    #   <plist version="1.0">
    #   <dict>
    #     <key>Creation Date</key>
    #     <date><%= datestamp %></date>
    #     <key>Entry Text</key>
    #     <string><%= entrytext %></string>
    #     <key>Starred</key>
    #     <<%= starred %>/>
    #     <key>Tags</key>
    #     <array>
    #       <string>daily logs</string>
    #     </array>
    #     <key>UUID</key>
    #     <string><%= uuid %></string>
    #   </dict>
    #   </plist>
    #   XMLTEMPLATE
    #
    #   date_regex = "(?:#{ date.strftime("%B") } 0?#{ date.strftime("%-d") }, #{ date.strftime("%Y") })"
    #   time_regex = "(?:\d{1,2}:\d{1,2}\s?[AaPpMm]{2})"
    #
    #   files = `find #{ configuration.sifttter_redux[:sifttter_local_filepath] } -type f -name "*.txt" | grep -v -i daily | sort`
    #   if files.empty?
    #     messenger.error('No Sifttter files to parse...')
    #     messenger.error('Is Dropbox Uploader configured correctly?')
    #     messenger.error("Is #{ configuration.sifttter_redux[:sifttter_remote_filepath] } the correct remote filepath?")
    #     exit!(1)
    #   end
    #
    #   projects = []
    #   files.split("\n").each do |file|
    #     if File.exists?(file.strip)
    #       f = File.open(file.strip, encoding: 'UTF-8')
    #       lines = f.read
    #       f.close
    #       project = '### ' + File.basename(file).gsub(/^.*?\/([^\/]+)$/, "\\1") + "\n"
    #
    #       found_completed = false
    #       lines.each_line do |line|
    #         if line =~ /&/
    #           line.gsub!(/[&]/, 'and')
    #         end
    #         if line =~ /#{ date_regex }/
    #           found_completed = true
    #           project += line.gsub(/@done/,"").gsub(/#{ date_regex }\s(-|at)\s/, "").gsub(/#{ time_regex }\s-\s/, "").strip + "\n"
    #         end
    #       end
    #     end
    #
    #     if found_completed
    #       projects.push(project)
    #     end
    #   end
    #
    #   if projects.length > 0
    #     entrytext = "# Things done on #{ date_for_title }\n\n"
    #     projects.each do |project|
    #       entrytext += project.gsub(/.txt/, ' ') + "\n\n"
    #     end
    #
    #     Dir.mkdir(configuration.sifttter_redux[:dayone_local_filepath]) if !Dir.exists?(configuration.sifttter_redux[:dayone_local_filepath])
    #
    #     fh = File.new(File.expand_path(configuration.sifttter_redux[:dayone_local_filepath] + '/' + uuid + '.doentry'), 'w+')
    #     fh.puts template.result(binding)
    #     fh.close
    #     messenger.success("Entry logged for #{ date_for_title }...")
    #   else
    #     messenger.warn('No entries found...')
    #   end
    # end
  end
end
