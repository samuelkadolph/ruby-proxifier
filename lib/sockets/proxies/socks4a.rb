module Sockets
  module Proxies
    class SOCKS4A < Proxy
      def do_proxify(*)
        raise NotImplementedError, "SOCKS4A is not yet implemented"
      end
    end
  end
end
