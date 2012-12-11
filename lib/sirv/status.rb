module Sirv
  class Status
    def initialize(code, msg)
      @code, @msg = code, msg
    end
    
    def to_s
      [@code, @msg].join(' ')
    end
  end
end
