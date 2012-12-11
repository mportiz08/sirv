require 'socket'

require 'sirv/response'

module Sirv
  class Server
    def initialize(port)
      @port = port
      Thread.abort_on_exception = true
    end
    
    def run(env)
      raise 'Implement me.'
    end
    
    def with_tcp_socket
      puts "sirv is running at http://localhost:#{@port}..."
      trap('SIGINT') do
        puts "sirv shutting down..."
        exit
      end
      
      socket = TCPServer.new(@port)
      loop do
        yield socket
      end
    end
  end
  
  class HelloWorldServer < Server
    def run(env)
      with_tcp_socket do |socket|
        Thread.start(socket.accept) do |client|
          client.print Response.new(200, {}, ["hello, world!\n"])
          client.close
        end
      end
    end
  end
  
  class RackServer < Server
    def run(env)
      check_env_for_app(env)
      with_tcp_socket do |socket|
        Thread.start(socket.accept) do |client|
          client.print Response.new(*client.call({}))
          client.close
        end
      end
    end
    
    private
    
    def check_env_for_app(env)
      raise 'No rack application found.' unless env[:application] &&
                                                env[:application].respond_to?(:call)
    end
  end
end
