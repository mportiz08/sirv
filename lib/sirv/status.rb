module Sirv
  class Status
    attr_reader :code, :msg
    
    def initialize(code, msg)
      @code, @msg = code, msg
    end
    
    def to_s
      [@code, @msg].join(' ')
    end
  end
end
