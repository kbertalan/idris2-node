module Node.HTTPS.Server

import Node
import Node.Error
import Node.Event.Internal
import public Node.HTTP.IncomingMessage
import public Node.HTTP.ServerResponse
import public Node.Net.Server.Listen

export
data Server : Type where [external]

%foreign nodeOn2 "request"
ffi_onRequest : a -> (b -> c -> PrimIO ()) -> PrimIO ()

export
(.onRequest) : HasIO io => Server -> (IncomingMessage -> ServerResponse -> IO()) -> io ()
(.onRequest) = on2 ffi_onRequest

%foreign "node:lambda: (server, options) => server.listen(options)"
ffi_listen : Server -> Node Listen.Options -> PrimIO ()

export
(.listen) : HasIO io => Server -> Listen.Options -> io ()
(.listen) server options = primIO $ ffi_listen server $ convertOptions options

%foreign "node:lambda: server => server.close()"
ffi_close : Server -> PrimIO ()

export
(.close) : HasIO io => Server -> io ()
(.close) server = primIO $ ffi_close server

