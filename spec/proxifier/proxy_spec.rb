require 'spec_helper'
require 'uri'
require 'proxifier/proxy'

describe Proxifier::Proxy do

  it 'should create proxy from URL String' do
    proxy = Proxifier::Proxy.new('socks://joe:sekret@myproxy:60123')

    proxy.url.scheme.must_equal 'socks'
    proxy.user.must_equal 'joe'
    proxy.password.must_equal 'sekret'
    proxy.host.must_equal 'myproxy'
    proxy.port.must_equal 60123
  end

  it 'should create proxy from generic URI' do
    uri   = URI::Generic.new('socks', 'joe:sekret', 'myproxy', 60123, nil, nil, nil, nil, nil)
    proxy = Proxifier::Proxy.new(uri)

    proxy.url.scheme.must_equal 'socks'
    proxy.user.must_equal 'joe'
    proxy.password.must_equal 'sekret'
    proxy.host.must_equal 'myproxy'
    proxy.port.must_equal 60123
  end

end
