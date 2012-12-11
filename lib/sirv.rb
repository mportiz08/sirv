require 'sirv/server'

module Sirv
  def self.listen(port)
    Sirv::Server.new(port).start
  end
end
