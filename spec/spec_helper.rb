$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../fixtures', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../support', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'flexidb'
require 'spec'
require 'spec/autorun'

require 'fixtures'
require 'fake_adapter'

Spec::Runner.configure do |config|
end
