require 'socket'

require 'sirv/response'

module Sirv
  class Server
    def initialize(port)
      @port = port
      Thread.abort_on_exception = true
    end
    
    def start
      puts "sirv is running at http://localhost:#{@port}..."
      handle_interrupt
      
      socket = TCPServer.new(@port)
      loop do
        Thread.start(socket.accept) do |client|
          resp = Response.new("hello, world!\n")
          client.print resp
          client.close
        end
      end
    end
    
    def stop
      puts "sirv shutting down..."
      exit
    end
    
    private
    
    def handle_interrupt
      trap('SIGINT') { stop }
    end
  end
end
