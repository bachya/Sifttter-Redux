require 'chronic'

module SifttterRedux
  #  ======================================================
  #  Configuration Module
  #
  #  Manages any configuration values and the flat file
  #  into which they get stored.
  #  ======================================================
  module DateRangeMaker

    #  ------------------------------------------------------
    #  last_n_days method
    #
    #  Returns a date range for the last N days (including
    #  today's date if specified).
    #  @param num_days The number of days to look back
    #  @param include_today Should today be included?
    #  @return Range
    #  ------------------------------------------------------
    def self.last_n_days(num_days, include_today = false)
      fail ArgumentError, 'Cannot specify a negative number of days' if num_days < 0

      if include_today
        (Date.today - num_days..Date.today)
      else
        (Date.today - num_days...Date.today)
      end
    end
    
    #  ------------------------------------------------------
    #  last_n_weeks method
    #
    #  Returns a date range for the last N weeks (including
    #  today's date if specified).
    #  @param num_days The number of weeks to look back
    #  @param include_today Should today be included?
    #  @return Range
    #  ------------------------------------------------------
    def self.last_n_weeks(num_weeks = 0, include_today = false)
      fail ArgumentError, 'Cannot specify a negative number of weeks' if num_weeks < 0
    
      beginning_date = Date.today - Date.today.wday + 1
      end_date = Date.today - Date.today.wday + 7
    
      # We coerce the end date to be today if a date
      # greater than today has been specified.
      end_date = Date.today if end_date > Date.today
    
      if include_today
        (beginning_date - num_weeks * 7..end_date)
      else
        (beginning_date - num_weeks * 7...end_date)
      end
    end
    
    #  ------------------------------------------------------
    #  range method
    #
    #  Returns a date range for specified start dates and
    #  end dates. Note that specifying an end date greater
    #  than today's date will force today to be the end date.
    #  @param start_date The start date
    #  @param end_date The end date
    #  @param options Miscellaneous options hash
    #  @return Range
    #  ------------------------------------------------------
    def self.range(start_date, end_date, include_today = false)
      fail ArgumentError, "You can't specify -t without specifying -f" if start_date.nil? && !end_date.nil?

      begin
        chronic_start_date = Chronic.parse(start_date).to_date
      rescue 
        fail ArgumentError, "Invalid date provided to Chronic: #{ start_date }" unless start_date.nil?
        nil
      end
    
      begin
        chronic_end_date = Chronic.parse(end_date).to_date
      rescue  
        fail ArgumentError, "Invalid date provided to Chronic: #{ end_date }" unless end_date.nil?
        nil
      end

      fail ArgumentError, 'The start date must be before or equal to the end date' if chronic_end_date && chronic_start_date > chronic_end_date
    
      if !chronic_start_date.nil?
        if chronic_end_date.nil?
          if include_today
            (chronic_start_date..Date.today)
          else
            (chronic_start_date...Date.today)
          end
        else
          (chronic_start_date..chronic_end_date)
        end
      end
    end
    
    #  ------------------------------------------------------
    #  today method
    #
    #  Returns a date range for today
    #  @return Range
    #  ------------------------------------------------------
    def self.today
      (Date.today..Date.today)
    end
    
    #  ------------------------------------------------------
    #  yesterday method
    #
    #  Returns a date range for yesterday
    #  @return Range
    #  ------------------------------------------------------
    def self.yesterday
      (Date.today - 1..Date.today - 1)
    end
    
  end
end