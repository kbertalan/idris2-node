module Node.TLS.Connect

import Node
import Data.Buffer
import Node.Internal.Support

public export
record Options where
  constructor MkOptions
  enableTrace: Maybe Bool
  host: Maybe String
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
  , host = Nothing
  , port = Nothing
  , path = Nothing
  , allowHalfOpen = False
  , rejectUnauthorized = True
  , servername = Nothing
  , session = Nothing
  , minDHSize = Nothing
  , highWaterMark = Nothing
  }

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
  ) => _keepDefined({
    enableTrace: _maybe(enableTrace),
    host: _maybe(host),
    port: _maybe(port),
    path: _maybe(path),
    allowHalfOpen: _bool(allowHalfOpen),
    rejectUnauthorized: _bool(rejectUnauthorized),
    servername: _maybe(servername),
    session: _maybe(session),
    minDHSize: _maybe(minDHSize),
    highWaterMark: _maybe(highWaterMark)
  })
  """
ffi_convertOptions:
  (enableTrace: Maybe Bool)
  -> (host: Maybe String)
  -> (port: Maybe Int)
  -> (path: Maybe String)
  -> (allowHalfOpen: Bool)
  -> (rejectUnauthorized: Bool)
  -> (servername: Maybe String)
  -> (session: Maybe Buffer)
  -> (minDHSize: Maybe Int)
  -> (highWaterMark: Maybe Int)
  -> Node Options

export
convertOptions : Options -> Node Options
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

