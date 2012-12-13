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
    Net::HTTP.get(localhost).should eq ('foobar')
  end
  
  it 'should handle multiple client connections' do
    num_clients = 10
    responses = num_clients.times.map do
      Thread.new { Net::HTTP.get(localhost) }.value
    end
    responses.should eq(['foobar'] * num_clients)
  end
end
