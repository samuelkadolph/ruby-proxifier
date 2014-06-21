require 'spec_helper'
require 'proxifier/proxies/socks'

describe Proxifier do

  it 'should have a version number' do
    Proxifier::VERSION.wont_be_nil
  end

  it 'should create Proxy from URL String' do
    proxy = Proxifier::Proxy('socks://joe:sekret@myproxy:60123')

    proxy.must_be_instance_of Proxifier::SOCKSProxy
    proxy.user.must_equal 'joe'
    proxy.password.must_equal 'sekret'
    proxy.host.must_equal 'myproxy'
    proxy.port.must_equal 60123
  end

end
