module Node.Net.Server.Listen

public export
record Options where
  constructor MkOptions
  port : Maybe Int
  host : Maybe String
  path : Maybe String
  backlog : Maybe Int
  exclusive : Bool
  readableAll : Bool
  writableAll : Bool
  ipv6Only : Bool
  -- TODO signal <AbortSignal> An AbortSignal that may be used to close a listening server.

export
defaultOptions : Options
defaultOptions = MkOptions
  { port = Nothing
  , host = Nothing
  , path = Nothing
  , backlog = Nothing
  , exclusive = False
  , readableAll = False
  , writableAll = False
  , ipv6Only = False
  }

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( port
  , host
  , path
  , backlog
  , exclusive
  , readableAll
  , writableAll
  , ipv6Only
  ) => {
    const maybe = ({h, a1}) => h === undefined ? a1 : undefined
    const bool = (b) => b != 0
    const opts = {
      port: maybe(port),
      host: maybe(host),
      path: maybe(path),
      backlog: maybe(backlog),
      exclusive: bool(exclusive),
      readableAll: bool(readableAll),
      writableAll: bool(writableAll),
      ipv6Only: bool(ipv6Only),
    }
    Object.keys(opts).forEach(key => opts[key] === undefined && delete opts[key])
    return opts
  }
  """
ffi_convertOptions :
  (port : Maybe Int) ->
  (host : Maybe String) ->
  (path : Maybe String) ->
  (backlog : Maybe Int) ->
  (exclusive : Bool) ->
  (readableAll : Bool) ->
  (writableAll : Bool) ->
  (ipv6Only : Bool) ->
  NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions o = ffi_convertOptions
  o.port
  o.host
  o.path
  o.backlog
  o.exclusive
  o.readableAll
  o.writableAll
  o.ipv6Only

