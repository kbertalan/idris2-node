module Node.HTTP2.Http2Server

import Node
import Node.Event.Internal
import Node.HTTP2.Headers
import Node.HTTP2.ServerHttp2Stream
import public Node.Net.Server

export
data Http2Server : Type where [external]

export
implementation ServerClass Http2Server where

%foreign nodeOn2 "stream"
ffi_onStream : a -> (b -> c -> PrimIO ()) -> PrimIO ()

export
(.onStream) : HasIO io => Http2Server -> (ServerHttp2Stream -> Headers -> IO()) -> io ()
(.onStream) = on2 ffi_onStream

