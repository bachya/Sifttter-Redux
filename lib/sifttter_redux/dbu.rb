module SifttterRedux
  #  ======================================================
  #  DBU Module
  #
  #  Wrapper module for the Dropbox Uploader project
  #  ======================================================
  module DBU
    
    DEFAULT_MESSAGE = 'RUNNING DROPBOX UPLOADER'

    #  ----------------------------------------------------
    #  download method
    #
    #  Downloads the files at the remote Dropbox filepath
    #  to a filepath on the local filesystem.
    #  @return Void
    #  ----------------------------------------------------
    def self.download
      unless (@local_path.nil? || @remote_path.nil?)
        CliMessage.info_block(@message ||= DEFAULT_MESSAGE, 'Done.', SifttterRedux.verbose) do
          if SifttterRedux.verbose
            system "#{@dbu} download #{@remote_path} #{@local_path}"
          else
            exec = `#{@dbu} download #{@remote_path} #{@local_path}`
          end
        end
      else
        fail ArgumentError, "Local and remote DBU targets cannot be nil"
      end
    end
    
    #  ----------------------------------------------------
    #  install_wizard method
    #
    #  Runs a wizard that installs Dropbox Uploader on the
    #  local filesystem.
    #  @return Void
    #  ----------------------------------------------------
    def self.install_wizard
      valid_directory_chosen = false
      
      CliMessage.section_block('CONFIGURING DROPBOX UPLOADER...') do
        until valid_directory_chosen
          # Prompt the user for a location to save Dropbox Uploader. '
          path = CliMessage.prompt('Location for Dropbox-Uploader', DBU_LOCAL_FILEPATH)
          path.chop! if path.end_with?('/')
          path = '/usr/local/opt' if path.empty?
        
          # If the entered directory exists, clone the repository.
          if File.directory?(path)
            valid_directory_chosen = true
            path << '/Dropbox-Uploader'

            if File.directory?(path)
              CliMessage.warning("Using pre-existing Dropbox Uploader at #{ path }...")
            else
              CliMessage.info_block('Downloading Dropbox Uploader to #{ path }...', 'Done.', true) do
                system "git clone https://github.com/andreafabrizi/Dropbox-Uploader.git #{ path }"
              end
            end

            Configuration.add_section('db_uploader')
            Configuration['db_uploader'].merge!('local_filepath' => path)
          else
            puts "Sorry, but #{ path } isn't a valid directory."
          end
        end
      end
    end

    #  ----------------------------------------------------
    #  load method
    #
    #  Loads the location of dropbox_uploader.sh.
    #  @param dbu_path The local filepath to the script
    #  @return Void
    #  ----------------------------------------------------
    def self.load(dbu_path)
      @dbu = dbu_path
    end

    #  ----------------------------------------------------
    #  set_local_target method
    #
    #  Sets the local filesystem path to which files will
    #  be downloaded.
    #  @param path A local filepath
    #  @return Void
    #  ----------------------------------------------------
    def self.set_local_target(path)
      @local_path = path
    end

    #  ----------------------------------------------------
    #  set_message method
    #
    #  Sets the message to be displayed just before
    #  downloading commences.
    #  @param message The string to display
    #  @return Void
    #  ----------------------------------------------------
    def self.set_message(message)
      @message = message
    end

    #  ----------------------------------------------------
    #  set_remote_target method
    #
    #  Sets the remote Dropbox path from which files will
    #  be downloaded.
    #  @param path A remote Dropbox filepath
    #  @return Void
    #  ----------------------------------------------------
    def self.set_remote_target(path)
      @remote_path = path
    end
    
    #  ----------------------------------------------------
    #  upload method
    #
    #  Uploads the files from the local filesystem path to
    #  the remote Dropbox path.
    #  @return Void
    #  ----------------------------------------------------
    def self.upload
      unless (@local_path.nil? || @remote_path.nil?)
        CliMessage.info_block(@message ||= DEFAULT_MESSAGE, 'Done.', SifttterRedux.verbose) do
          if SifttterRedux.verbose
            system "#{@dbu} upload #{@local_path} #{@remote_path}"
          else
            exec = `#{@dbu} upload #{@local_path} #{@remote_path}`
          end
        end
      else
        fail ArgumentError, "Local and remote DBU targets cannot be nil"
      end
    end
    
  end
end