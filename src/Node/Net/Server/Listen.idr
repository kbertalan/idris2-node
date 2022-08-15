module Node.Net.Server.Listen

import Node.Internal.Support

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
  ) => _keepDefined({
    port: _maybe(port),
    host: _maybe(host),
    path: _maybe(path),
    backlog: _maybe(backlog),
    exclusive: _bool(exclusive),
    readableAll: _bool(readableAll),
    writableAll: _bool(writableAll),
    ipv6Only: _bool(ipv6Only),
  })
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

