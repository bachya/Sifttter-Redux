require 'readline'
require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'lib/sifttter_redux/cli_message.rb')

class CLIMessageTest < Test::Unit::TestCase
  def setup
    SifttterRedux::CLIMessage::deactivate_logging
  end
  
  def test_error_message
    assert_output('# test'.red + "\n") { SifttterRedux::CLIMessage::error('test') }
  end

  def test_info_message
    assert_output('# test'.blue + "\n") { SifttterRedux::CLIMessage::info('test') }
  end

  def test_info_block_single_line
    assert_output("# start".blue + "body\n" + 'end'.blue + "\n") do
      SifttterRedux::CLIMessage::info_block('start', 'end') { puts 'body' }
    end
  end

  def test_info_block_multiline
    assert_output("# start".blue + "\nbody\n" + '# end'.blue + "\n") do
      SifttterRedux::CLIMessage::info_block('start', 'end', true) { puts 'body' }
    end
  end
  
  def test_info_block_no_block
    assert_raise ArgumentError do
      SifttterRedux::CLIMessage::info_block('start', 'end', true)
    end
  end

  def test_section_message
    assert_output('---> test'.purple + "\n") { SifttterRedux::CLIMessage::section('test') }
  end

  def test_section_block_single_line
    assert_output("---> section".purple + "\nbody\n") do
      SifttterRedux::CLIMessage::section_block('section', true) { puts 'body' }
    end
  end

  def test_success_message
    assert_output('# test'.green + "\n") { SifttterRedux::CLIMessage::success('test') }
  end

  def test_warning_message
    assert_output('# test'.yellow + "\n") { SifttterRedux::CLIMessage::warning('test') }
  end
  
  # def test_prompt
  #   with_stdin do |answer|
  #     answer.puts 'default'
  #     assert_equal(SifttterRedux::CLIMessage::prompt('Hit enter to give the default response', 'default'), 'default')
  #   end
  # end
  # 
  # def with_stdin
  #   stdin = $stdin             # remember $stdin
  #   $stdin, write = IO.pipe    # create pipe assigning its "read end" to $stdin
  #   yield write                # pass pipe's "write end" to block
  # ensure
  #   write.close                # close pipe
  #   $stdin = stdin             # restore $stdin
  # end
end
