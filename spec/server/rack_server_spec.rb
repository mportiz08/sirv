require 'helper'
require 'net/http'

describe Sirv::RackServer do
  include Helpers
  
  before do
    @server = Sirv::RackServer.new(test_port)
  end
  
  it 'should serve a basic rack application' do
    begin
      sthread = Thread.new { @server.run(:application => basic_rack_app) }
      Net::HTTP.get(localhost).should eq('foobar')
    ensure
      sthread.terminate
    end
  end
  
  it 'should handle multiple client connections' do
    begin
      sthread = Thread.new { @server.run(:application => basic_rack_app) }
      clients = 5.times.map do
        Thread.new { Net::HTTP.get(localhost).should eq('foobar') }
      end
    ensure
      clients.each(&:join)
      sthread.terminate
    end
  end
end
