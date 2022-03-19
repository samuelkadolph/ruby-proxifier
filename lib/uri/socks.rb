require 'uri/generic'

module URI
  class Socks < Generic
    DEFAULT_PORT = 1080
    COMPONENT = [:scheme, :userinfo, :host, :port, :query].freeze

    def self.build(args)
      tmp = Util.make_components_hash(self, args)
      super(tmp)
    end
  end

  class Socks4 < Socks
  end

  class Socks4A < Socks
  end

  mapping = {
    'SOCKS' => Socks,
    'SOCKS5' => Socks,
    'SOCKS4' => Socks4,
    'SOCKS4A' => Socks4A
  }
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1.0')
    mapping.each { |scheme, class_name| register_scheme scheme, class_name }
  else
    mapping.each { |scheme, class_name| @@schemes[scheme] = class_name }
  end
end

