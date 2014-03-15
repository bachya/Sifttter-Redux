module SifttterRedux
  #  ======================================================
  #  DropboxUploader Class
  #
  #  Wrapper class for the Dropbox Uploader project
  #  ======================================================
  class DropboxUploader
    #  ====================================================
    #  Constants
    #  ====================================================
    CONFIG_FILEPATH = File.join(ENV['HOME'], '.dropbox_uploader')
    DEFAULT_MESSAGE = 'RUNNING DROPBOX UPLOADER'

    #  ====================================================
    #  Attributes
    #  ====================================================
    attr_accessor :local_target, :remote_target, :message, :verbose

    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  initialize method
    #
    #  Loads the location of dropbox_uploader.sh.
    #  @param dbu_path The local filepath to the script
    #  @logger A Logger to use
    #  @return Void
    #  ----------------------------------------------------
    def initialize(dbu_path, logger = nil)
      @dbu = dbu_path
      @logger = logger
    end

    #  ----------------------------------------------------
    #  download method
    #
    #  Downloads files from Dropbox (assumes that both
    #  local_target and remote_target have been set).
    #  @return Void
    #  ----------------------------------------------------
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

    #  ----------------------------------------------------
    #  upload method
    #
    #  Uploads files tro Dropbox (assumes that both
    #  local_target and remote_target have been set).
    #  @return Void
    #  ----------------------------------------------------
    def upload
      if !@local_target.nil? && !@remote_target.nil?
        if @verbose
          system "#{ @dbu } upload #{ @local_target } #{ @remote_target }"
        else
          exec = `#{ @dbu } upload #{ @local_target }" "#{ @remote_target }`
        end
      else
        error_msg = 'Local and remote targets cannot be nil'
        @logger.error(error_msg) if @logger
        fail StandardError, error_msg
      end
    end
  end
end