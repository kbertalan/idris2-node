module Node.Net.Server.Listen

import Data.Maybe

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
  ) => ({
    port: port != -1 ? port : undefined,
    host: host || undefined,
    path: path || undefined,
  })
  """
ffi_convertOptions :
  (port : Int) ->
  (host : String) ->
  (path : String) ->
  (backlog : Int) ->
  (exclusive : Int) ->
  (readableAll : Int) ->
  (writableAll : Int) ->
  (ipv6Only : Int) ->
  NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions o = ffi_convertOptions
  (fromMaybe (-1) o.port)
  (fromMaybe "" o.host)
  (fromMaybe "" o.path)
  (fromMaybe (-1) o.backlog)
  (if o.exclusive then 1 else 0)
  (if o.readableAll then 1 else 0)
  (if o.writableAll then 1 else 0)
  (if o.ipv6Only then 1 else 0)

