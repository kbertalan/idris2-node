module Node.HTTP2.ClientHttp2Stream

import public Data.Buffer
import public Node.Error
import Node.Event.Internal
import Node.HTTP2.Headers
import public Node.Stream

export
data ClientHttp2Stream : Type where [external]

export
implementation ReadableClass Buffer Error ClientHttp2Stream where

export
implementation WriteableClass Buffer Error ClientHttp2Stream where

%foreign nodeOn1 "response"
ffi_onResponse : a -> (b -> PrimIO ()) -> PrimIO ()

export
(.onResponse) : HasIO io => ClientHttp2Stream -> (Headers -> IO ()) -> io ()
(.onResponse) = on1 ffi_onResponse

%foreign nodeOn1 "push"
ffi_onPush : a -> (b -> PrimIO ()) -> PrimIO ()

export
(.onPush) : HasIO io => ClientHttp2Stream -> (Headers -> IO ()) -> io ()
(.onPush) = on1 ffi_onPush

