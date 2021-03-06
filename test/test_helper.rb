require 'rubygems'
require 'simplecov'
require 'minitest/autorun'
require 'shoulda'
require 'rack'
require 'timecop'

SimpleCov.start do
  add_filter 'specs/ruby/1.9.1/gems/'
  add_filter '/test/'
  add_filter '/config/'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'imprint'

class Minitest::Test
  def before_setup
    # Remove any existing trace id before each test
    Imprint::Tracer.set_trace_id nil
  end
end
