require 'chronic'
require 'singleton'

#  ======================================================
#  DateRangeMakerError Class
#  ======================================================
class DateRangeMakerError < StandardError
  def initialize(msg = "You've triggered a DateRangeMakerError")
    super
  end
end

#  ======================================================
#  BadChronicDateError Class
#  ======================================================
class BadChronicDateError < DateRangeMakerError
  def initialize(msg = "Invalid date provided to Chronic...")
    super
  end
end

#  ======================================================
#  BadDateOrderError Class
#  ======================================================
class BadDateOrderError < DateRangeMakerError
  def initialize(msg = "The start date must be before or equal to the end date...")
    super
  end
end

#  ======================================================
#  InvalidFlagsError Class
#  ======================================================
class InvalidFlagsError < DateRangeMakerError
  def initialize(msg = "You can't specify -t without specifying -f...")
    super
  end
end

#  ======================================================
#  NegativeDaysError Class
#  ======================================================
class NegativeDaysError < DateRangeMakerError
  def initialize(msg = "You must specify a positive number of days to look back...")
    super
  end
end

#  ======================================================
#  DateRangeMaker Class
#
#  Singleton to manage the YAML config file
#  for this script
#  ======================================================
class DateRangeMaker 
  include Singleton
  
  #  ------------------------------------------------------
  #  last_n_days method
  #
  #  Returns a date range for the last N days (including
  #  today's date if specified).
  #  @param num_days The number of days to look back
  #  @param options Miscellaneous options hash
  #  @return Range
  #  ------------------------------------------------------
  def last_n_days(num_days, options = {})
    fail NegativeDaysError if num_days < 0
    
    opts = { :include_today => false }    
    options.each do |k, v|
      k = k.to_sym
      fail ArgumentError, "Unknown property: #{ k }" unless opts.key?(k)
      opts[k] = v
    end
    
    if opts[:include_today]
      _r = (Date.today - num_days..Date.today)
    else
      _r = (Date.today - num_days...Date.today)
    end
    
    _r
  end
  
  #  ------------------------------------------------------
  #  last_n_weeks method
  #
  #  Returns a date range for the last N weeks (including
  #  today's date if specified).
  #  @param num_days The number of weeks to look back
  #  @param options Miscellaneous options hash
  #  @return Range
  #  ------------------------------------------------------
  def last_n_weeks(num_weeks = 0, options = {})
    fail NegativeDaysError if num_weeks < 0
    
    opts = { :include_today => false }    
    options.each do |k, v|
      k = k.to_sym
      fail ArgumentError, "Unknown property: #{ key }" unless opts.key?(k)
      opts[k] = v
    end
    
    beginning_date = Date.today - Date.today.wday + 1
    end_date = Date.today - Date.today.wday + 7
    
    # We're currently before the end of the week, so
    # reset the new ending date to today.
    if end_date > Date.today
      end_date = Date.today
    end
    
    if opts[:include_today]
      _r = (beginning_date - num_weeks * 7..end_date)
    else
      _r = (beginning_date - num_weeks * 7...end_date)
    end
    
    _r
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
  def range(start_date, end_date, options = {})
    fail InvalidFlagsError.new if start_date.nil? && !end_date.nil?
    
    opts = { :include_today => false }    
    options.each do |k, v|
      k = k.to_sym
      raise ArgumentError, "Unknown property: #{ key }" unless opts.key?(k)
      opts[k] = v
    end
    
    begin
      chronic_start_date = Chronic.parse(start_date).to_date
    rescue 
      fail BadChronicDateError.new("Invalid date provided to Chronic: #{ start_date }") unless start_date.nil?
      nil
    end
    
    begin
      chronic_end_date = Chronic.parse(end_date).to_date
    rescue  
      fail BadChronicDateError.new("Invalid date provided to Chronic: #{ end_date }") unless end_date.nil?
      nil
    end

    fail BadDateOrderError.new if chronic_end_date && chronic_start_date > chronic_end_date
    
    if !chronic_start_date.nil?
      if chronic_end_date.nil?
        if opts[:include_today]
          dates = (chronic_start_date..Date.today)
        else
          dates = (chronic_start_date...Date.today)
        end
      else
        dates = (chronic_start_date..chronic_end_date)
      end
    end
    
    dates
  end
  
  #  ------------------------------------------------------
  #  today method
  #
  #  Returns a date range for today
  #  @return Range
  #  ------------------------------------------------------
  def today
    (Date.today..Date.today)
  end
  
  #  ------------------------------------------------------
  #  yesterday method
  #
  #  Returns a date range for yesterday
  #  @return Range
  #  ------------------------------------------------------
  def yesterday
    (Date.today - 1..Date.today - 1)
  end
end