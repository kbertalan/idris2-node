module Node.HTTP.Request

import Node.Internal.Support
import Node.HTTP.Agent
import public Node.HTTP.Headers
import Node.Net.Socket.Connect

public export
record RequestOptions h where
  constructor MkRequestOptions
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
defaultRequestOptions : RequestOptions h
defaultRequestOptions = MkRequestOptions
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

export
data NodeRequestOptions : Type where [external]

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
ffi_convertRequestOptions :
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
  -> Request.NodeRequestOptions

export
convertRequestOptions : RequestOptions h -> Request.NodeRequestOptions
convertRequestOptions o = ffi_convertRequestOptions
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

public export
record Options where
  constructor MkOptions
  requestOptions: RequestOptions Headers
  socketConnectOptions: Maybe Connect.Options

export
defaultOptions : Request.Options
defaultOptions = MkOptions
  { requestOptions = defaultRequestOptions
  , socketConnectOptions = Nothing
  }

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( opts
  , socketOpts
  ) => ({
    ..._maybe(socketOpts),
    ...opts
  })
  """
ffi_convertOptions :
  (requestOptions : Request.NodeRequestOptions)
  -> (socketConnectOptions : Maybe Connect.NodeOptions)
  -> Request.NodeOptions

export
convertOptions : Request.Options -> Request.NodeOptions
convertOptions o = ffi_convertOptions
  (convertRequestOptions o.requestOptions)
  (convertOptions <$> o.socketConnectOptions)

