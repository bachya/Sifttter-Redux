require 'chronic'

class DateRangeMakerError < StandardError
  def initialize(msg = "You've triggered a DateRangeMakerError")
    super
  end
end

class BadChronicDateError < DateRangeMakerError
  def initialize(msg = "Invalid date provided to Chronic...")
    super
  end
end

class BadDateOrderError < DateRangeMakerError
  def initialize(msg = "The start date must be before or equal to the end date...")
    super
  end
end

class InvalidFlagsError < DateRangeMakerError
  def initialize(msg = "You can't specify -t without specifying -f...")
    super
  end
end

#|  ======================================================
#|  DateRangeMaker Class
#|
#|  Singleton to manage the YAML config file
#|  for this script
#|  ======================================================
class DateRangeMaker 
  
  def initialize

  end
  
  def last_seven_days(include_today = false)
    if (include_today)
      _r = (Date.today - 7..Date.today)
    else
      _r = (Date.today - 7...Date.today)
    end
    
    return _r
  end
  
  def range(options = {})
    
    opts = {
      :start_date => Date.today,
      :end_date => nil,
      :include_today => false
    }
    
    options.each do |k, v|
      k = k.to_sym
      raise ArgumentError, "Unknown property: #{k}" unless opts.key?(k)
      opts[k] = v
    end
    
    begin
      chronic_start_date = Chronic.parse(opts[:start_date]).to_date
    rescue 
      raise BadChronicDateError.new("Invalid date provided to Chronic: #{opts[:start_date]}") if !opts[:start_date].nil?
      nil
    end
    
    begin
      chronic_end_date = Chronic.parse(opts[:end_date]).to_date
    rescue  
      raise BadChronicDateError.new("Invalid date provided to Chronic: #{opts[:end_date]}") if !opts[:end_date].nil?
      nil
    end
    
    raise InvalidFlagsError.new if (opts[:start_date].nil? && !opts[:end_date].nil?)
    raise BadDateOrderError.new if (chronic_end_date && chronic_start_date > chronic_end_date)
    
    if (!chronic_start_date.nil?)
      if (chronic_end_date.nil?)
        if (opts[:include_today])
          dates = (chronic_start_date..Date.today)
        else
          dates = (chronic_start_date...Date.today)
        end
      else
        dates = (chronic_start_date..chronic_end_date)
      end
    end
    
    return dates
  end
  
  def today
    return (Date.today..Date.today)
  end
  
  def yesterday
    return (Date.today - 1..Date.today - 1)
  end
end