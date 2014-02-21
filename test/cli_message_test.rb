require "test_helper"
require File.join(File.dirname(__FILE__), "..", "lib/sifttter_redux/cli_message.rb")

class CliMessageTest < Test::Unit::TestCase
  def test_error_message
    assert_output('---> ERROR: test'.red + "\n") { SifttterRedux::CliMessage.error('test') }
  end

  def test_info_message
    assert_output('---> INFO: test'.blue + "\n") { SifttterRedux::CliMessage.info('test') }
  end

  def test_info_block_single_line
    assert_output("---> INFO: start".blue + "body\n" + 'end'.blue + "\n") do
      SifttterRedux::CliMessage.info_block('start', 'end') { puts 'body' }
    end
  end

  def test_info_block_multiline
    assert_output("---> INFO: start".blue + "\nbody\n" + '---> INFO: end'.blue + "\n") do
      SifttterRedux::CliMessage.info_block('start', 'end', true) { puts 'body' }
    end
  end
  
  def test_info_block_no_block
    assert_raise ArgumentError do
      SifttterRedux::CliMessage.info_block('start', 'end', true)
    end
  end

  def test_prompt
    assert_equal(SifttterRedux::CliMessage.prompt('Pick the default option', 'default'), 'default')
  end

  def test_section_message
    assert_output('#### test'.purple + "\n") { SifttterRedux::CliMessage.section('test') }
  end

  def test_section_block_single_line
    assert_output("#### section".purple + "\nbody\n") do
      SifttterRedux::CliMessage.section_block('section', true) { puts 'body' }
    end
  end

  def test_success_message
    assert_output('---> SUCCESS: test'.green + "\n") { SifttterRedux::CliMessage.success('test') }
  end

  def test_warning_message
    assert_output('---> WARNING: test'.yellow + "\n") { SifttterRedux::CliMessage.warning('test') }
  end
end
