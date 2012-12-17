require 'net/http'

require 'rspec'
require 'sirv'

module Helpers
  def test_port
    3000
  end
  
  def localhost
    URI "http://localhost:#{test_port}"
  end
  
  def get(uri)
    Net::HTTP.get_response(uri)
  end
  
  def basic_rack_app
    ->(env) { [200, {'Content-Type' => 'text/plain'}, ['foobar']] }
  end
end
