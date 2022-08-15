module Node.HTTP.Request

import Data.Maybe
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
  ) => {
    const maybe = ({h, a1}) => h === undefined ? a1 : undefined
    const opts = {
      agent: maybe(agent),
      auth: maybe(auth),
      defaultPort: maybe(defaultPort),
      family,
      headers: maybe(headers),
      hostname: maybe(hostname),
      insecureHTTPParser: insecureHTTPParser != 0,
      localAddress: maybe(localAddress),
      localPort: maybe(localPort),
      maxHeaderSize: maybe(maxHeaderSize),
      method,
      path: maybe(path),
      port: maybe(port),
      protocol,
      setHost: setHost != 0,
      socketPath: maybe(socketPath),
      timeout: maybe(timeout)
    }
    Object.keys(opts).forEach(key => opts[key] === undefined && delete opts[key])
    return opts
  }
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
  ) => {
    const maybe = ({h, a1}) => h === undefined ? a1 : undefined
    return {
      ...maybe(socketOpts),
      ...opts
    }
  }
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

