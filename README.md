# ruby-proxifier

## Installing

### Recommended

```
gem install proxifier
```

### Edge

```
git clone https://github.com/samuelkadolph/ruby-proxifier
cd ruby-proxifier && rake install
```

## Rationale

This gem was created for 2 purposes.

First is to enable ruby programmers to use HTTP or SOCKS proxies
interchangeably when using TCPSockets. Either manually with
`Proxifier::Proxy#open` or by `require "proxifier/env"`.

The second purpose is to use ruby code that doesn't user proxies for users that
have to use proxies.<br>The pruby and pirb executables are simple wrappers for
their respective ruby executables that support proxies from environment
variables.

## Usage

### Executable Wrappers & Environment Variables

proxifier provides two executables: `pruby` and `pirb`. They are simple
wrappers for your current `ruby` and `irb` executables that requires the
`"proxifier/env"` script which installs hooks into `TCPSocket` which will use
the proxy environment variables to proxy any `TCPSocket`.

The environment variables that proxifier will check are (in order of descending
precedence):

<table>
  <tr>
    <th>Variable Name</th>
    <th>Alternatives</th>
    <th>Notes</th>
  </tr>
  <tr>
    <td>proxy</td>
    <td>PROXY</td>
    <td>Requires the proxy scheme to be present.</td>
  </tr>
  <tr>
    <td>socks_proxy</td>
    <td>SOCKS_PROXY<br>socks5_proxy<br>SOCKS5_PROXY</td>
    <td>Implies the SOCKS5 proxy scheme.</td>
  </tr>
  <tr>
    <td>socks4a_proxy</td>
    <td>SOCKS4A_PROXY</td>
    <td>Implies the SOCKS4A proxy scheme.</td>
  </tr>
  <tr>
    <td>socks4_proxy</td>
    <td>PROXY</td>
    <td>Implies the SOCKS4 proxy scheme.</td>
  </tr>
  <tr>
    <td>http_proxy</td>
    <td>HTTP_PROXY</td>
    <td>Implies the HTTP proxy scheme.</td>
  </tr>
</table>

### Ruby

```ruby
require "proxifier/proxy"

proxy = Proxifier::Proxy("socks://localhost")
socket = proxy.open("www.google.com", 80)
socket << "GET / HTTP/1.1\r\nHost: www.google.com\r\n\r\n"
socket.gets # => "HTTP/1.1 200 OK\r\n"
```

### Environment - patching TCPSocket

```ruby
require 'proxifier/env'
ENV['PROXY'] = 'http://10.0.0.44:8888' # How to find the proxy
ENV['PROXY_FILTER_REGEX'] = '(10\..*|localhost)' # Do not use proxy for connections inside internal net or localhost
ENV['PROXY_FILTER_LIST'] = '66.211.168.123,207.97.227.239'
```

Afterwards, any new TCPSocket connections will use the proxy, unless they're excluded either by the specific PROXY_FILTER_LIST or the PROXY_FILTER_REGEX.

PROXY_FILTER_LIST specifies a comma separated list of hostnames or IP addresses (whichever the client code is going to use).

PROXY_FILTER_REGEX is a regular expression, where if the connection hostname (or IP address) matches the regex, connections will be made directly and not through the proxy.

Both PROXY_FILTER_LIST and PROXY_FILTER_REGEX are optional, but only one will be used.

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
    <td>SOCKS4A</td>
    <td><pre>socks4a://[username@]host[:port]</pre></td>
    <td>Not yet implemented.</td>
  </tr>
  <tr>
    <td>SOCKS4</td>
    <td><pre>socks4://[username@]host[:port]</pre></td>
    <td>Currently hangs. Not sure if the problem is with code or server.</td>
  </tr>
</table>
