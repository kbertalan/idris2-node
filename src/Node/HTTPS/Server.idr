module Node.HTTPS.Server

import Node.Error
import Node.HTTP
import public Node.Net.Server.Listen

%hide Node.HTTP.Server.Server

export
data Server : Type where [external]

%foreign "node:lambda: (server, handler) => server.on('request', (req, res) => handler(req)(res)())"
ffi_onRequest : Server -> (IncomingMessage -> ServerResponse -> PrimIO ()) -> PrimIO ()

export
(.onRequest) : HasIO io => Server -> (IncomingMessage -> ServerResponse -> IO()) -> io ()
(.onRequest) server callback = 
  let primCallback = \req => \res => toPrim $ callback req res
  in primIO $ ffi_onRequest server primCallback


%foreign "node:lambda: (server, options) => server.listen(options)"
ffi_listen : Server -> Listen.NodeOptions -> PrimIO ()

export
(.listen) : HasIO io => Server -> Listen.Options -> io ()
(.listen) server options = primIO $ ffi_listen server $ convertOptions options

%foreign "node:lambda: server => server.close()"
ffi_close : Server -> PrimIO ()

export
(.close) : HasIO io => Server -> io ()
(.close) server = primIO $ ffi_close server

