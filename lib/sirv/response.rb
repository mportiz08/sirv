require 'sirv/status'

module Sirv
  class Response
    EOL = "\r\n"
    
    DEFAULT_HEADERS = {
      "Server" => "Sirv"
    }
    
    def initialize(status, headers, body)
      @status  = Status.from_code(status)
      @headers = DEFAULT_HEADERS.merge(headers)
      @body    = body
    end
    
    def version
      'HTTP/1.1'
    end
    
    def status
      [version, @status].join(' ')
    end
    
    def headers
      @headers.map { |k,v| "#{k}: #{v}" }
              .join(EOL)
    end
    
    def body
      @body
    end
    
    def body?
      !@body.empty?
    end
    
    def to_s
      resp = ''
      resp << [status, headers, EOL].join(EOL)
      resp << body.join("\n") if body?
    end
  end
end
