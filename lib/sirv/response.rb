require 'sirv/status'

module Sirv
  class Response
    LINE_ENDING = "\r\n"
    
    DEFAULT_HEADERS = {
      "Server" => "Sirv"
    }
    
    def initialize(body, headers={})
      @status  = Status.new(200, "OK")
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
      @headers
    end
    
    def body
      @body
    end
    
    def body?
      !@body.nil?
    end
    
    def to_s
      resp = ''
      
      resp << (status + LINE_ENDING)
      headers.each { |k,v| resp << "#{k}: #{v}#{LINE_ENDING}"}
      resp << LINE_ENDING
      resp << body
    end
  end
end
