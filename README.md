# ruby-sockets

## Installing

### Recommended

```
gem install sockets
```

### Edge

```
git clone https://github.com/samuelkadolph/ruby-sockets
cd ruby-sockets && rake install
```

## Usage

### Environment Variables & Executable Wrappers

sockets provides two executables: `pruby` and `pirb`. They are simple wrappers
for your current `ruby` and `irb` executables that `require "sockets/env"`
which installs hooks to `TCPSocket` which will use your proxy environment
variables whenever a `TCPSocket` is created. sockets will use the
`proxy`, `PROXY`, `socks_proxy` and `http_proxy` environment variables (in that
order) to determine what proxy to use.

### Ruby

```ruby
require "sockets/proxy"

proxy = Sockets::Proxy("socks://localhost")
socket = proxy.open("www.google.com", 80)
socket << "GET / HTTP/1.1\r\nHost: www.google.com\r\n\r\n"
socket.gets # => "HTTP/1.1 200 OK\r\n"
```

## Supported Proxies

<table>
  <tr>
    <th>Protocol</th>
    <th>Formats</th>
    <th>Notes</th>
  </tr>
  <tr>
    <td>HTTP</td>
    <td><pre>http://[username[:password]@]host[:port][?tunnel=false]</pre></td>
    <td>
      The port defaults to 80. This is currently a limitation that may be solved in the future.<br>
      Appending <code>?tunnel=false</code> forces the proxy to not use <code>CONNECT</code>.</td>
  </tr>
  <tr>
    <td>SOCKS5</td>
    <td><pre>socks://[username[:password]@]host[:port]
socks5://[username[:password]@]host[:port]</pre></td>
    <td>
      Port defaults to 1080.
    </td>
  </tr>
  <tr>
    <td>SOCKS4</td>
    <td><pre>socks4://[username@]ip1.ip2.ip3.ip4[:port]</pre></td>
    <td>Currently hangs. Not sure if the problem is with code or server.</td>
  </tr>
  <tr>
    <td>SOCKS4A</td>
    <td><pre>socks4a://[username@]host[:port]</pre></td>
    <td>Not yet implemented.</td>
  </tr>
</table>
