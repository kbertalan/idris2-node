module Node.TLS.Connect

import Data.Buffer

public export
record Options where
  constructor MkOptions
  enableTrace: Maybe Bool
  host: String
  port: Maybe Int
  path: Maybe String
  -- TODO: socket
  allowHalfOpen: Bool
  rejectUnauthorized: Bool
  -- TODO: pskCallback
  -- TODO: ALPNProtocols
  servername: Maybe String
  -- TODO: checkServerIdentity(servername, cert)
  session: Maybe Buffer
  minDHSize: Maybe Int
  highWaterMark: Maybe Int
  -- TODO: secureContext
  -- TODO: onread

export
defaultOptions : Options
defaultOptions = MkOptions
  { enableTrace = Nothing
  , host = "localhost"
  , port = Nothing
  , path = Nothing
  , allowHalfOpen = False
  , rejectUnauthorized = True
  , servername = Nothing
  , session = Nothing
  , minDHSize = Nothing
  , highWaterMark = Nothing
  }

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( enableTrace
  , host
  , port
  , path
  , allowHalfOpen
  , rejectUnauthorized
  , servername
  , session
  , minDHSize
  , highWaterMark
  ) => {
    const maybe = ({h, a1}) => h === undefined ? a1 : undefined
    const opts = {
      enableTrace: maybe(enableTrace),
      host,
      port: maybe(port),
      path: maybe(path),
      allowHalfOpen: allowHalfOpen != 0,
      rejectUnauthorized: rejectUnauthorized != 0,
      servername: maybe(servername),
      session: maybe(session),
      minDHSize: maybe(minDHSize),
      highWaterMark: maybe(highWaterMark)
    }
    Object.keys(opts).forEach(key => opts[key] === undefined && delete opts[key])
    return opts
  }
  """
ffi_convertOptions:
  (enableTrace: Maybe Bool)
  -> (host: String)
  -> (port: Maybe Int)
  -> (path: Maybe String)
  -> (allowHalfOpen: Bool)
  -> (rejectUnauthorized: Bool)
  -> (servername: Maybe String)
  -> (session: Maybe Buffer)
  -> (minDHSize: Maybe Int)
  -> (highWaterMark: Maybe Int)
  -> NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions o = ffi_convertOptions
  o.enableTrace
  o.host
  o.port
  o.path
  o.allowHalfOpen
  o.rejectUnauthorized
  o.servername
  o.session
  o.minDHSize
  o.highWaterMark

