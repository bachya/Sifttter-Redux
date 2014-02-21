require "test_helper"
require File.join(File.dirname(__FILE__), "..", "lib/sifttter_redux/configuration.rb")

class ConfigurationTest < Test::Unit::TestCase
  
  def setup
    SifttterRedux::Configuration.load('/tmp/srd_config')
  end

  def teardown
    File.delete('/tmp/srd_config') if File.exists?('/tmp/srd_config')
  end
  
  def test_add_data
    SifttterRedux::Configuration.add_section('section1')
    SifttterRedux::Configuration['section1'] = { 'a' => 'test', 'b' => 'test' }
    assert_equal(SifttterRedux::Configuration.dump, { 'section1' => { 'a' => 'test', 'b' => 'test' } })
    
    SifttterRedux::Configuration['section1']['a'] = 'bigger test'
    SifttterRedux::Configuration['section1']['c'] = 'little test'
    assert_equal(SifttterRedux::Configuration.dump, { 'section1' => { 'a' => 'bigger test', 'b' => 'test', 'c' => 'little test' } })
  end
  
  def test_add_section
    SifttterRedux::Configuration.add_section('section1')
    SifttterRedux::Configuration.add_section('section2')
    assert_equal(SifttterRedux::Configuration.dump, { 'section1' => {}, 'section2' => {} })
  end
  
  def test_add_section_duplicate
    SifttterRedux::Configuration.add_section('section1')
    SifttterRedux::Configuration.add_section('section2')
    SifttterRedux::Configuration.add_section('section2')
    assert_equal(SifttterRedux::Configuration.dump, { 'section1' => {}, 'section2' => {} })
  end
  
  def test_config_path
    assert_equal(SifttterRedux::Configuration.config_path, '/tmp/srd_config')
  end
  
  def test_delete_section
    SifttterRedux::Configuration.add_section('section1')
    SifttterRedux::Configuration.add_section('section2')
    SifttterRedux::Configuration.delete_section('section2')
    assert_equal(SifttterRedux::Configuration.dump, { 'section1' => {} })
  end
  
  def test_delete_section_nonexistant
    SifttterRedux::Configuration.add_section('section1')
    SifttterRedux::Configuration.delete_section('section12723762323')
    assert_equal(SifttterRedux::Configuration.dump, { 'section1' => {} })
  end
  
  def test_reset
    SifttterRedux::Configuration.add_section('section1')
    SifttterRedux::Configuration.add_section('section2')
    SifttterRedux::Configuration.add_section('section3')
    SifttterRedux::Configuration.reset
    assert_equal(SifttterRedux::Configuration.dump, {})
  end
  
  def test_save
    SifttterRedux::Configuration.add_section('section1')
    SifttterRedux::Configuration['section1'] = { 'a' => 'test', 'b' => 'test' }
    SifttterRedux::Configuration.save
    
    File.open('/tmp/srd_config', 'r') do |f|
      assert_output("---\nsection1:\n  a: test\n  b: test\n") { puts f.read }
    end
  end
  
  def test_section_exists
    SifttterRedux::Configuration.add_section('section1')
    assert_equal(SifttterRedux::Configuration.section_exists?('section1'), true)
  end
end
