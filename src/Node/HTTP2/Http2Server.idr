module Node.HTTP2.Http2Server

import Node.Event.Internal
import Node.HTTP2.Headers
import Node.HTTP2.ServerHttp2Stream
import Node.Net.Server.Listen

export
data Http2Server : Type where [external]

%foreign nodeOn2 "stream"
ffi_onStream : a -> (b -> c -> PrimIO ()) -> PrimIO ()

export
(.onStream) : HasIO io => Http2Server -> (ServerHttp2Stream -> Headers -> IO()) -> io ()
(.onStream) = on2 ffi_onStream

%foreign "node:lambda: (server, options) => server.listen(options)"
ffi_listen : Http2Server -> Listen.NodeOptions -> PrimIO ()

export
(.listen) : HasIO io => Http2Server -> Listen.Options -> io ()
(.listen) server options = primIO $ ffi_listen server $ convertOptions options

%foreign "node:lambda: server => server.close()"
ffi_close : Http2Server -> PrimIO ()

export
(.close) : HasIO io => Http2Server -> io ()
(.close) server = primIO $ ffi_close server

