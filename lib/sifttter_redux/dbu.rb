module SifttterRedux
  #  ======================================================
  #  DBU Module
  #
  #  Wrapper module for the Dropbox Uploader project
  #  ======================================================
  module DBU
    #  ====================================================
    #  Constants
    #  ====================================================
    CONFIG_FILEPATH = File.join(ENV['HOME'], '.dropbox_uploader')
    DEFAULT_MESSAGE = 'RUNNING DROPBOX UPLOADER'

    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  download method
    #
    #  Downloads the files at the remote Dropbox filepath
    #  to a filepath on the local filesystem.
    #  @return Void
    #  ----------------------------------------------------
    def self.download
      if !@local_path.nil? && !@remote_path.nil?
        CLIMessage::info_block(@message ||= DEFAULT_MESSAGE, 'Done.', SifttterRedux.verbose) do
          if SifttterRedux.verbose
            system "#{ @dbu } download #{ @remote_path } #{ @local_path }"
          else
            exec = `#{ @dbu } download #{ @remote_path } #{ @local_path }`
          end
        end
      else
        error = 'Local and remote DBU targets cannot be nil'
        Methadone::CLILogging.error(error)
        fail ArgumentError, error
      end
    end

    #  ----------------------------------------------------
    #  install_wizard method
    #
    #  Runs a wizard that installs Dropbox Uploader on the
    #  local filesystem.
    #  @return Void
    #  ----------------------------------------------------
    def self.install_wizard(reinit = false)
      valid_path_chosen = false
      
      CLIMessage::section_block('CONFIGURING DROPBOX UPLOADER...') do
        until valid_path_chosen
          # Prompt the user for a location to save Dropbox Uploader.
          if reinit && !Configuration['db_uploader']['base_filepath'].nil?
            default = Configuration['db_uploader']['base_filepath']
          else
            default = DBU_LOCAL_FILEPATH
          end
          path = CLIMessage::prompt('Location for Dropbox-Uploader', default)
          path.chop! if path.end_with?('/')
          
          # If the entered directory exists, clone the repository.
          if File.directory?(path)
            valid_path_chosen = true
            
            dbu_path = File.join(path, 'Dropbox-Uploader')
            executable_path = File.join(dbu_path, 'dropbox_uploader.sh')

            if File.directory?(dbu_path)
              CLIMessage::warning("Using pre-existing Dropbox Uploader at #{ dbu_path }...")
            else
              CLIMessage::info_block("Downloading Dropbox Uploader to #{ dbu_path }...", 'Done.', true) do
                system "git clone https://github.com/andreafabrizi/Dropbox-Uploader.git #{ dbu_path }"
              end
            end

            # If the user has never configured Dropbox Uploader, have them do it here.
            unless File.exists?(CONFIG_FILEPATH)
              CLIMessage::info_block('Initializing Dropbox Uploader...') { system "#{ executable_path }" }
            end

            Configuration::add_section('db_uploader') unless reinit
            Configuration['db_uploader'].merge!('base_filepath' => path, 'dbu_filepath' => dbu_path, 'exe_filepath' => executable_path)
          else
            CLIMessage::error("Sorry, but #{ path } isn't a valid directory.")
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
    def self.local_target=(path)
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
    def self.message=(message)
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
    def self.remote_target=(path)
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
      if !@local_path.nil? && !@remote_path.nil?
        CLIMessage::info_block(@message ||= DEFAULT_MESSAGE, 'Done.', SifttterRedux.verbose) do
          if SifttterRedux.verbose
            system "#{ @dbu } upload #{ @local_path } #{ @remote_path }"
          else
            exec = `#{ @dbu } upload #{ @local_path } #{ @remote_path }`
          end
        end
      else
        error = 'Local and remote DBU targets cannot be nil'
        Methadone::CLILogging.error(error)
        fail ArgumentError, error
      end
    end
  end
end
