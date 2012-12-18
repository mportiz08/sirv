require 'helper'
require 'net/http'

describe Sirv::RackServer do
  include Helpers
  
  before do
    server = Sirv::RackServer.new(test_port)
    @app = Thread.new { server.run(:application => basic_rack_app) }
  end
  
  after do
    @app.terminate
  end
  
  it 'should server a basic rack application' do
    get('/').should be_an_http_response(200, 'foobar')
  end
  
  it 'should handle multiple client connections' do
    num_clients = 8
    threads = num_clients.times.map do
      Thread.new { get('/') }
    end
    responses = threads.map(&:value)
    responses.each { |resp| resp.should be_an_http_response(200, 'foobar') }
  end
end
