require "socket"

require "sockets"
require "sockets/proxify"

module Sockets
  class Proxy
    def open(host, port, local_host = nil, local_port = nil)
      if proxify?(host)
        socket = TCPSocket.new(proxy.host, proxy.port, local_host, local_port, :proxy => nil)
        begin
          proxify(socket, host, port)
        rescue Exception
          socket.close
          raise
        end
        socket
      else
        TCPSocket.new(host, port, local_host, local_port, :proxy => nil)
      end
    end
  end
end

class TCPSocket
  include Sockets::Proxify
  include Sockets::EnvironmentProxify
end
