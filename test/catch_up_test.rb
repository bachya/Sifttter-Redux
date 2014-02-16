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
  
  def test_last_7_days
    assert_equal($drm.last_seven_days, (Date.today - 7...Date.today))
  end
  
  def test_last_7_days_include_today
    assert_equal($drm.last_seven_days(true), (Date.today - 7..Date.today))
  end
  
  def test_range_only_start_date
    assert_equal($drm.range({:start_date => "2014-02-01"}), (Date.parse("2014-02-01")...Date.today))
  end
  
  def test_range_only_start_date_include_today
    assert_equal($drm.range({:start_date => "2014-02-01", :include_today => true}), (Date.parse("2014-02-01")..Date.today))
  end
  
  def test_range_start_date_and_end_date
    assert_equal($drm.range({:start_date => "2014-02-01", :end_date => "2014-02-05"}), (Date.parse("2014-02-01")..Date.parse("2014-02-05")))
  end
  
  def test_range_bad_dates
    assert_raise BadChronicDateError do
      $drm.range({:start_date => "Bad Start Date", :end_date => "Bad End Date"})
    end
  end
  
  def test_range_end_date_with_no_start_date
    assert_raise InvalidFlagsError do
      $drm.range({:start_date => nil, :end_date => Date.today})
    end
  end
  
  def test_range_end_date_before_start_date
    assert_raise BadDateOrderError do
      $drm.range({:start_date => Date.today, :end_date => Date.today - 1})
    end
  end
end
