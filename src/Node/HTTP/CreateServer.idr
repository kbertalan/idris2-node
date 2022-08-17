module Node.HTTP.CreateServer

import Node
import Node.Internal.Support

public export
record Options where
  constructor MkOptions
  insecureHTTPParser: Bool
  maxHeaderSize: Int
  noDelay: Bool
  keepAlive: Bool
  keepAliveInitialDelay: Int

export
defaultOptions : Options
defaultOptions = MkOptions
  { insecureHTTPParser = False
  , maxHeaderSize = 16384
  , noDelay = False
  , keepAlive = False
  , keepAliveInitialDelay = 0
  }

%foreign """
  node:lambda:
  ( insecureHTTPParser
  , maxHeaderSize
  , noDelay
  , keepAlive
  , keepAliveInitialDelay
  ) => _keepDefined({
    insecureHTTPParser: _bool(insecureHTTPParser),
    maxHeaderSize,
    noDelay: _bool(noDelay),
    keepAlive: _bool(keepAlive),
    keepAliveInitialDelay
  })
  """
ffi_convertOptions :
  (insecureHTTPParser: Bool) ->
  (maxHeaderSize: Int) ->
  (noDelay: Bool) ->
  (keepAlive: Bool) ->
  (keepAliveInitialDelay: Int) ->
  Node Options

export
convertOptions : Options -> Node Options
convertOptions o = ffi_convertOptions
  o.insecureHTTPParser
  o.maxHeaderSize
  o.noDelay
  o.keepAlive
  o.keepAliveInitialDelay

