require "socket"
require "uri"
require "uri/socks"

module Sockets
  class Proxy
    attr_reader :url, :options

    def initialize(url, options = {})
      url = URI.parse(uri) unless url.is_a?(URI::Generic)
      @url, @options = url, options
    end

    def open(host, port, local_host = nil, local_port = nil)
      if proxify?(host)
        socket = TCPSocket.new(proxy.host, proxy.port, local_host, local_port)
        begin
          proxify(socket, host, port)
        rescue Exception
          socket.close
          raise
        end
        socket
      else
        TCPSocket.new(host, port, local_host, local_port)
      end
    end

    def proxify?(host)
      return true unless options[:no_proxy]

      dont_proxy = options[:no_proxy].split(",")
      dont_proxy.none? { |h| host =~ /#{h}\Z/ }
    end

    def proxify(socket, host, port)
      do_proxify(socket, host, port)
    end

    %w(host port user password query version).each do |attr|
      class_eval "def #{attr}; url.#{attr} end", __FILE__, __LINE__
    end

    def query_options
      @query ||= query ? Hash[query.split("&").map { |q| q.split("=") }] : {}
    end

    %w(no_proxy).each do |option|
      class_eval "def #{option}; options[:#{option}] end", __FILE__, __LINE__
    end

    protected
      def do_proxify(socket, host, port)
        raise NotImplementedError, "#{self} must implement do_proxify"
      end
  end

  def self.Proxy(url, options = {})
    url = URI.parse(url)

    raise(ArgumentError, "proxy has no scheme") unless url.scheme
    begin
      klass = Proxies.const_get(url.scheme.upcase)
    rescue NameError
      begin
        require "sockets/proxies/#{url.scheme}"
        klass = Proxies.const_get(url.scheme.upcase)
      rescue LoadError, NameError
        raise(ArgumentError, "unknown proxy scheme `#{url.scheme}'")
      end
    end

    klass.new(url, options)
  end
end
