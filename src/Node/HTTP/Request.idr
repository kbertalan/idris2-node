module Node.HTTP.Request

import Node
import Node.Internal.Support
import Node.HTTP.Agent
import public Node.HTTP.Headers
import Node.Net.Socket.Connect

public export
record Options h where
  constructor MkOptions
  agent: Maybe Agent
  auth: Maybe String
  -- TODO: createConnection
  defaultPort: Maybe Int
  family: IpAddressFamily
  headers: Maybe h
  -- TODO: hints
  -- host: use `hostname` instead
  hostname: Maybe String
  insecureHTTPParser: Bool
  localAddress: Maybe String
  localPort: Maybe Int
  -- TODO: lookup
  maxHeaderSize: Maybe Int
  method: String
  path: Maybe String
  port: Maybe Int
  protocol: String
  setHost: Bool
  socketPath: Maybe String
  timeout: Maybe Int
  -- TODO: signal

export
defaultOptions : Options h
defaultOptions = MkOptions
  { agent = Nothing
  , auth = Nothing
  , defaultPort = Nothing
  , family = Both
  , headers = Nothing
  , hostname = Nothing
  , insecureHTTPParser = False
  , localAddress = Nothing
  , localPort = Nothing
  , maxHeaderSize = Nothing
  , method = "GET"
  , path = Nothing
  , port = Nothing
  , protocol = "http:"
  , setHost = True
  , socketPath = Nothing
  , timeout = Nothing
  }

%foreign """
  node:lambda:
  ( headersType
  , agent
  , auth
  , defaultPort
  , family
  , headers
  , hostname
  , insecureHTTPParser
  , localAddress
  , localPort
  , maxHeaderSize
  , method
  , path
  , port
  , protocol
  , setHost
  , socketPath
  , timeout
  ) => _keepDefined({
    agent: _maybe(agent),
    auth: _maybe(auth),
    defaultPort: _maybe(defaultPort),
    family,
    headers: _maybe(headers),
    hostname: _maybe(hostname),
    insecureHTTPParser: _bool(insecureHTTPParser),
    localAddress: _maybe(localAddress),
    localPort: _maybe(localPort),
    maxHeaderSize: _maybe(maxHeaderSize),
    method,
    path: _maybe(path),
    port: _maybe(port),
    protocol,
    setHost: _bool(setHost),
    socketPath: _maybe(socketPath),
    timeout: _maybe(timeout)
  })
  """
ffi_convertOptions :
  (agent: Maybe Agent)
  -> (auth: Maybe String)
  -> (defaultPort: Maybe Int)
  -> (family: Int)
  -> (headers: Maybe h)
  -> (hostname: Maybe String)
  -> (insecureHTTPParser: Bool)
  -> (localAddress: Maybe String)
  -> (localPort: Maybe Int)
  -> (maxHeaderSize: Maybe Int)
  -> (method: String)
  -> (path: Maybe String)
  -> (port: Maybe Int)
  -> (protocol: String)
  -> (setHost: Bool)
  -> (socketPath: Maybe String)
  -> (timeout: Maybe Int)
  -> Node $ Request.Options h

export
convertOptions : Options h -> Node $ Options h
convertOptions o = ffi_convertOptions
  o.agent
  o.auth
  o.defaultPort
  (familyAsInt o.family)
  o.headers
  o.hostname
  o.insecureHTTPParser
  o.localAddress
  o.localPort
  o.maxHeaderSize
  o.method
  o.path
  o.port
  o.protocol
  o.setHost
  o.socketPath
  o.timeout

namespace Command

  public export
  record Options where
    constructor MkOptions
    request: Request.Options Headers
    socket: Maybe Connect.Options

  export
  defaultOptions : Command.Options
  defaultOptions = MkOptions
    { request = defaultOptions
    , socket = Nothing
    }

  %foreign """
    node:lambda:
    ( request
    , socket
    ) => ({
      ..._maybe(socket),
      ...request
    })
    """
  ffi_convertOptions :
    (request : Node $ Request.Options Headers)
    -> (socket : Maybe (Node Connect.Options))
    -> Node Command.Options

  export
  convertOptions : Command.Options -> Node Command.Options
  convertOptions o = ffi_convertOptions
    (convertOptions o.request)
    (convertOptions <$> o.socket)

