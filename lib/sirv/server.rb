require 'socket'

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
      @socket.close unless @socket.nil?
    end
    
    def with_client_connection
      Socket.tcp_server_loop(@port) do |client, addrinfo|
        begin
          yield client
        ensure
          client.close
        end
      end
    end
  end
  
  class HelloWorldServer < Server
    def run(env)
      super
      with_client_connection do |client|
        hello_world = Response.new(200, {}, ["hello, world!\n"])
        Thread.new { client.print hello_world }.join
      end
    end
  end
  
  class RackServer < Server
    def run(env)
      super
      app = check_env_for_app(env)
      with_client_connection do |client|
        fork { client.print Response.new(*app.call({})) }
        Process.wait
      end
    end
    
    private
    
    def check_env_for_app(env)
      raise 'No rack application found.' unless env[:application] &&
                                                env[:application].respond_to?(:call)
      env[:application]
    end
  end
end
