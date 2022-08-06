module Node.HTTP.Server

import Data.Buffer
import public Node.HTTP
import public Node.Headers
import public Node.Net.Server
import public Node.Stream

export
data IncomingMessage : Type where [external]

export
data ServerResponse : Type where [external]

namespace Request

  export
  %foreign "node:lambda: req => req.headers"
  (.headers) : IncomingMessage -> Headers

  export
  %foreign "node:lambda: req => req.httpVersion"
  (.httpVersion) : IncomingMessage -> String

  export
  %foreign "node:lambda: req => req.method"
  (.method) : IncomingMessage -> String

  export
  %foreign "node:lambda: req => req.url"
  (.url) : IncomingMessage -> String

  public export
  implementation Readable Buffer IncomingMessage where

namespace Response

  %foreign "node:lambda: (res, status, headers) => res.writeHead(status, headers)"
  ffi_writeHead : ServerResponse -> Int -> Headers -> PrimIO ()

  export
  (.writeHead) : HasIO io => ServerResponse -> Int -> Headers -> io ()
  (.writeHead) res status headers = primIO $ ffi_writeHead res status headers

  public export
  implementation Writeable Buffer ServerResponse where

public export
record Options where
  constructor MkOptions
  insecureHTTPParser: Bool
  maxHeaderSize: Int
  noDelay: Bool
  keepAlive: Bool
  keepAliveInitialDelay: Int

export
defaultOptions : HTTP.Server.Options
defaultOptions = MkOptions
  { insecureHTTPParser = False
  , maxHeaderSize = 16384
  , noDelay = False
  , keepAlive = False
  , keepAliveInitialDelay = 0
  }

export
data NodeHTTPServerOptions : Type where [external]

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
  NodeHTTPServerOptions

export
convertOptions : HTTP.Server.Options -> NodeHTTPServerOptions
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

export
data Server : Type where [external]

%foreign "node:lambda: (http, options) => http.createServer(options)"
ffi_createServer : HTTP -> NodeHTTPServerOptions -> PrimIO Server

export
(.createServer) : HasIO io => HTTP -> HTTP.Server.Options -> io Server
(.createServer) http options = primIO $ ffi_createServer http $ convertOptions options

%foreign "node:lambda: (server, handler) => server.on('request', (req, res) => handler(req)(res)())"
ffi_onRequest : Server -> (IncomingMessage -> ServerResponse -> PrimIO ()) -> PrimIO ()

export
(.onRequest) : HasIO io => Server -> (IncomingMessage -> ServerResponse -> IO()) -> io ()
(.onRequest) server callback = 
  let primCallback = \req => \res => toPrim $ callback req res
  in primIO $ ffi_onRequest server primCallback


%foreign "node:lambda: (server, options) => server.listen(options)"
ffi_listen : Server -> NodeListenOptions -> PrimIO ()

export
(.listen) : HasIO io => Server -> Listen.Options -> io ()
(.listen) server options = primIO $ ffi_listen server $ convertOptions options

%foreign "node:lambda: server => server.close()"
ffi_close : Server -> PrimIO ()

export
(.close) : HasIO io => Server -> io ()
(.close) server = primIO $ ffi_close server

