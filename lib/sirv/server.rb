require 'socket'
require 'stringio'

require 'sirv/response'

module Sirv
  class Server
    def initialize(port)
      @port = port
      
      at_exit        { stop }
      trap('SIGINT') { exit }
      
      Thread.abort_on_exception = true
    end
    
    def run(env)
      puts "sirv is running at http://localhost:#{@port}..."
    end
    
    def stop
      puts 'sirv shutting down...'
    end
    
    def on_client
      server = TCPServer.new(@port)
      loop do
        Thread.start(server.accept) do |client|
          begin
           yield client 
          ensure
            client.close
          end
        end
      end
    end
  end
  
  class HelloWorldServer < Server
    def run(env)
      super
      on_client do |client|
        status  = 200
        body    = ["hello, world!\n"]
        headers = {'Content-Type' => 'text/plain'}
        
        response = Response.new(status, headers, body)
        IO.copy_stream(response.as_io, client)
      end
    end
  end
  
  class RackServer < Server
    def run(env)
      super
      app = find_app(env)
      on_client do |client|
        response = Response.new(*app.call({}))
        IO.copy_stream(response.as_io, client)
      end
    end
    
    private
    
    def find_app(env)
      raise 'No rack application found.' unless env[:application] &&
                                                env[:application].respond_to?(:call)
      env[:application]
    end
  end
end
