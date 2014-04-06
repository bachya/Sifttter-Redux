module SifttterRedux
  # DropboxUploader Class
  # Wrapper class for the Dropbox Uploader project
  class DropboxUploader
    # Stores the local filepath.
    # @return [String]
    attr_accessor :local_target

    # Stores the remote filepath.
    # @return [String]
    attr_accessor :remote_target

    # Stores the message to display.
    # @return [String]
    attr_accessor :message

    # Stores the verbosity level.
    # @return [Boolean]
    attr_accessor :verbose

    # Loads the location of dropbox_uploader.sh.
    # @param [String] dbu_path The local filepath to the script
    # @param [Logger] A Logger to use
    # @return [void]
    def initialize(dbu_path, logger = nil)
      @dbu = dbu_path
      @logger = logger
    end

    # Downloads files from Dropbox (assumes that both
    # local_target and remote_target have been set).
    # @return [void]
    def download
      if !@local_target.nil? && !@remote_target.nil?
        if @verbose
          system "#{ @dbu } download #{ @remote_target } #{ @local_target }"
        else
          exec = `#{ @dbu } download #{ @remote_target } #{ @local_target }`
        end
      else
        error_msg = 'Local and remote targets cannot be nil'
        @logger.error(error_msg) if @logger
        fail StandardError, error_msg
      end
    end

    # Uploads files tro Dropbox (assumes that both
    # local_target and remote_target have been set).
    # @return [void]
    def upload
      if !@local_target.nil? && !@remote_target.nil?
        if @verbose
          system "#{ @dbu } upload #{ @local_target } #{ @remote_target }"
        else
          exec = `#{ @dbu } upload #{ @local_target } #{ @remote_target }`
        end
      else
        error_msg = 'Local and remote targets cannot be nil'
        @logger.error(error_msg) if @logger
        fail StandardError, error_msg
      end
    end
  end
end