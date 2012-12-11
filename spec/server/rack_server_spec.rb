require 'helper'
require 'net/http'

describe Sirv::RackServer do
  before do
    @server = Sirv::RackServer.new(3000)
  end
  
  it 'should serve a basic rack application' do
    app = ->(env) { [200, {'Content-Type' => 'text/plain'}, ['hello, world!']] }
    begin
      sthread = Thread.new { @server.run(:application => app) }
      Net::HTTP.get(URI('http://localhost:3000')).should eq('hello, world!')
    ensure
      sthread.terminate
    end
  end
end
