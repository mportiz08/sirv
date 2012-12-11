module Sirv
  class Status
    attr_reader :code, :msg
    
    def self.from_code(code)
      msgs = {
        200 => "OK"
      }
      self.new(200, msgs[code])
    end
    
    def initialize(code, msg)
      @code, @msg = code, msg
    end
    
    def to_s
      [@code, @msg].join(' ')
    end
  end
end
