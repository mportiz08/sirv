require 'net/http'

require 'rspec'
require 'sirv'

# RSpec::Matchers.define :be_an_http_response do |expected_code|
#   match do |actual_response|
#     actual_response.code == expected_code
#   end
# end


module Helpers
  extend RSpec::Matchers::DSL
  
  matcher :be_an_http_response do |expected_code, expected_body|
    match do |actual_response|
      actual_response.code.to_i == expected_code &&
      actual_response.body      == expected_body
    end
    
    failure_message_for_should do |actual_response|
      "expected #{actual_response} to be an HTTP response with " +
      "status code <#{expected_code}> and " +
      "body <#{expected_body}>"
    end
  end
  
  def test_port
    3000
  end
  
  def localhost
    "http://localhost:#{test_port}"
  end
  
  def get(path)
    Net::HTTP.get_response(URI(localhost + path))
  end
  
  def basic_rack_app
    ->(env) { [200, {'Content-Type' => 'text/plain'}, ['foobar']] }
  end
end
