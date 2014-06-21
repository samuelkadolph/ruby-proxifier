require 'spec_helper'
require 'uri'
require 'proxifier/proxies/socks'

describe Proxifier::SOCKSProxy do

  before do
    @socket = MiniTest::Mock.new
  end

  it 'should comply with SOCKS5 authentication specification' do
    proxy = Proxifier::Proxy('socks://joe:sekret@myproxy:60123')

    proxy.must_be_instance_of Proxifier::SOCKSProxy

    TCPSocket.stub :new, @socket do
      @socket.expect :<<, nil, ["\x05\x02\x00\x02"]
      @socket.expect :read, "\x05\x02", [2]
      @socket.expect :<<, nil, ["\x01\x03joe\x06sekret"]
      @socket.expect :read, "\x01\x00", [2]
      @socket.expect :<<, nil, ["\x05\x01\x00\x03\tlocalhost\x048"]
      @socket.expect :read, "\x05\x00\x00\x01", [4]
      @socket.expect :read, "\x7F\x00\x00\x01", [4]
      @socket.expect :read, "\x08", [2]

      proxy.open('localhost', 1080)
    end
  end

end
