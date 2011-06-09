require "sockets/proxy"

module Sockets
  module Proxify
    def self.included(klass)
      klass.class_eval do
        alias_method :initialize_without_proxy, :initialize
        alias_method :initialize, :initialize_with_proxy
      end
    end

    def initialize_with_proxy(host, port, options_or_local_host = {}, local_port = nil, options_if_local_host = {})
      if options_or_local_host.is_a?(Hash)
        local_host = nil
        options = options_or_local_host
      else
        local_host = options_or_local_host
        options = options_if_local_host
      end

      if options[:proxy] && (proxy = Sockets::Proxy(options.delete(:proxy), options)) && proxy.proxify?(host)
        initialize_without_proxy(proxy.host, proxy.port, local_host, local_port)
        begin
          proxy.proxify(self, host, port)
        rescue Exception
          close
          raise
        end
      else
        initialize_without_proxy(host, port, local_host, local_port)
      end
    end
  end
end

module Sockets
  module EnvironmentProxify
    def self.included(klass)
      klass.class_eval do
        extend ClassMethods
        alias_method :initialize_without_environment_proxy, :initialize
        alias_method :initialize, :initialize_with_environment_proxy
      end
    end

    def initialize_with_environment_proxy(host, port, options_or_local_host = {}, local_port = nil, options_if_local_host = {})
      if options_or_local_host.is_a?(Hash)
        local_host = nil
        options = options_or_local_host
      else
        local_host = options_or_local_host
        options = options_if_local_host
      end

      options = { :proxy => environment_proxy, :no_proxy => environment_no_proxy }.merge(options)
      initialize_without_environment_proxy(host, port, local_host, local_port, options)
    end

    def environment_proxy
      self.class.environment_proxy
    end

    def environment_no_proxy
      self.class.environment_no_proxy
    end

    module ClassMethods
      def environment_proxy
        ENV["proxy"] || ENV["PROXY"] || ENV["socks_proxy"] || ENV["http_proxy"]
      end

      def environment_no_proxy
        ENV["no_proxy"]
      end
    end
  end
end
