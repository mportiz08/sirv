require 'sirv/server'

module Sirv
  def self.hello_world(port)
    Sirv::HelloWorldServer.new(port).run({})
  end
  
  def self.run_rack_app(app, port)
    Sirv::RackServer.new(port).run(:application => app)
  end
end
