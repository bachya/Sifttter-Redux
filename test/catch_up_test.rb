require 'date'
require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'lib/sifttter-redux/date-range-maker.rb')

class DefaultTest < Test::Unit::TestCase

  def setup
    $drm = DateRangeMaker.new
  end

  def test_today
    assert_equal($drm.today, (Date.today..Date.today))
  end
  
  def test_yesterday
    assert_equal($drm.yesterday, (Date.today - 1..Date.today - 1))
  end
  
  def test_last_5_days
    assert_equal($drm.last_n_days(5), (Date.today - 5...Date.today))
  end
  
  def test_last_5_days_include_today
    assert_equal($drm.last_n_days(5, {:include_today => true}), (Date.today - 5..Date.today))
  end
  
  def test_last_12_days
    assert_equal($drm.last_n_days(12), (Date.today - 12...Date.today))
  end
  
  def test_last_12_days_include_today
    assert_equal($drm.last_n_days(12, {:include_today => true}), (Date.today - 12..Date.today))
  end
  
  def test_current_week
    end_date = Date.today - Date.today.wday + 7
    if end_date > Date.today
      end_date = Date.today
    end
      
    assert_equal($drm.last_n_weeks, (Date.today - Date.today.wday + 1...end_date))
  end
  
  def test_current_week_include_today
    end_date = Date.today - Date.today.wday + 7
    if end_date > Date.today
      end_date = Date.today
    end
      
    assert_equal($drm.last_n_weeks(0, {:include_today => true}), (Date.today - Date.today.wday + 1..end_date))
  end
  
  def test_last_2_weeks
    end_date = Date.today - Date.today.wday + 7
    if end_date > Date.today
      end_date = Date.today
    end
      
    assert_equal($drm.last_n_weeks(2), (Date.today - Date.today.wday - 13...end_date))
  end
  
  def test_last_2_weeks_include_today
    end_date = Date.today - Date.today.wday + 7
    if end_date > Date.today
      end_date = Date.today
    end
      
    assert_equal($drm.last_n_weeks(2, {:include_today => true}), (Date.today - Date.today.wday - 13..end_date))
  end
  
  def test_range_only_start_date
    assert_equal($drm.range("2014-02-01", nil), (Date.parse("2014-02-01")...Date.today))
  end
  
  def test_range_only_start_date_include_today
    assert_equal($drm.range("2014-02-01", nil, {:include_today => true}), (Date.parse("2014-02-01")..Date.today))
  end
  
  def test_range_start_date_and_end_date
    assert_equal($drm.range("2014-02-01", "2014-02-05"), (Date.parse("2014-02-01")..Date.parse("2014-02-05")))
  end
  
  def test_range_bad_dates
    assert_raise BadChronicDateError do
      $drm.range("Bad Start Date", "Bad End Date")
    end
  end
  
  def test_range_end_date_with_no_start_date
    assert_raise InvalidFlagsError do
      $drm.range(nil, Date.today)
    end
  end
  
  def test_range_end_date_before_start_date
    assert_raise BadDateOrderError do
      $drm.range(Date.today, Date.today - 1)
    end
  end
  
  def test_range_negative_look_back
    assert_raise NegativeDaysError do
      $drm.last_n_days(-5)
    end
  end
end
