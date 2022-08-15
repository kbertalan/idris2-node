module Node.HTTP.CreateServer

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

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( insecureHTTPParser
  , maxHeaderSize
  , noDelay
  , keepAlive
  , keepAliveInitialDelay
  ) => {
    const bool = (b) => b != 0
    const opts = {
      insecureHTTPParser: bool(insecureHTTPParser),
      maxHeaderSize,
      noDelay: bool(noDelay),
      keepAlive: bool(keepAlive),
      keepAliveInitialDelay
    }
    return opts
  }
  """
ffi_convertOptions :
  (insecureHTTPParser: Bool) ->
  (maxHeaderSize: Int) ->
  (noDelay: Bool) ->
  (keepAlive: Bool) ->
  (keepAliveInitialDelay: Int) ->
  NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions o = ffi_convertOptions
  o.insecureHTTPParser
  o.maxHeaderSize
  o.noDelay
  o.keepAlive
  o.keepAliveInitialDelay

