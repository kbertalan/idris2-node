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
  ) => ({
    insecureHTTPParser: insecureHTTPParser != 0,
    maxHeaderSize,
    noDelay: noDelay != 0,
    keepAlive: keepAlive != 0,
    keepAliveInitialDelay
  })
  """
ffi_convertOptions :
  (insecureHTTPParser: Int) ->
  (maxHeaderSize: Int ) ->
  (noDelay: Int) ->
  (keepAlive: Int) ->
  (keepAliveInitialDelay: Int) ->
  NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions o = ffi_convertOptions
  (boolToInt o.insecureHTTPParser)
  o.maxHeaderSize
  (boolToInt o.noDelay)
  (boolToInt o.keepAlive)
  o.keepAliveInitialDelay
  where
    boolToInt : Bool -> Int
    boolToInt = \case
      True => 1
      False => 0

