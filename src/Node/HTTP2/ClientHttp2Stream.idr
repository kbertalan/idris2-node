module Node.HTTP2.ClientHttp2Stream

import Node.Error
import Node.Event.Internal
import Node.HTTP2.Headers

export
data ClientHttp2Stream : Type where [external]

%foreign "node:lambda: stream => stream.end()"
ffi_end : ClientHttp2Stream -> PrimIO ()

export
(.end) : HasIO io => ClientHttp2Stream -> io ()
(.end) stream = primIO $ ffi_end stream

%foreign "node:lambda: (ty, stream, data) => stream.write(data)"
ffi_write : { 0 a : _ } -> ClientHttp2Stream -> a -> PrimIO ()

export
(.write) : HasIO io => ClientHttp2Stream -> a -> io ()
(.write) stream a = primIO $ ffi_write stream a

%foreign nodeOn1 "data"
ffi_onData : a -> (b -> PrimIO ()) -> PrimIO ()

export
onData : HasIO io => ClientHttp2Stream -> (a -> IO ()) -> io ()
onData = on1 ffi_onData

%foreign nodeOn1 "error"
ffi_onError : a -> (e -> PrimIO ()) -> PrimIO ()

export
onError : HasIO io => ClientHttp2Stream -> (NodeError -> IO ()) -> io ()
onError = on1 ffi_onError

%foreign nodeOn0 "end"
ffi_onEnd : a -> PrimIO () -> PrimIO ()

export
onEnd : HasIO io => ClientHttp2Stream -> IO () -> io ()
onEnd = on0 ffi_onEnd

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

