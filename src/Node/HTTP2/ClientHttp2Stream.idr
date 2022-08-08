module Node.HTTP2.ClientHttp2Stream

import Node.Error
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

%foreign "node:lambda: (ty, stream, data) => stream.on('data', a => data(a)())"
ffi_onData : ClientHttp2Stream -> (a -> PrimIO ()) -> PrimIO ()

export
onData : HasIO io => ClientHttp2Stream -> (a -> IO ()) -> io ()
onData stream cb = primIO $ ffi_onData stream $ \a => toPrim $ cb a

%foreign "node:lambda: (stream, error) => stream.on('error', e => error(e)())"
ffi_onError : ClientHttp2Stream -> (NodeError -> PrimIO ()) -> PrimIO ()

export
onError : HasIO io => ClientHttp2Stream -> (NodeError -> IO ()) -> io ()
onError stream cb = primIO $ ffi_onError stream $ \e => toPrim $ cb e

%foreign "node:lambda: (stream, end) => stream.on('end', end)"
ffi_onEnd : ClientHttp2Stream -> PrimIO () -> PrimIO ()

export
onEnd : HasIO io => ClientHttp2Stream -> IO () -> io ()
onEnd stream cb = primIO $ ffi_onEnd stream $ toPrim $ cb

%foreign "node:lambda: (stream, response) => stream.on('response', headers => response(headers)())"
ffi_onResponse : ClientHttp2Stream -> (Headers -> PrimIO ()) -> PrimIO ()

export
(.onResponse) : HasIO io => ClientHttp2Stream -> (Headers -> IO ()) -> io ()
(.onResponse) stream cb = primIO $ ffi_onResponse stream $ \h => toPrim $ cb h

%foreign "node:lambda: (stream, handler) => stream.on('push', headers => handler(headers)())"
ffi_onPush : ClientHttp2Stream -> (Headers -> PrimIO ()) -> PrimIO ()

export
(.onPush) : HasIO io => ClientHttp2Stream -> (Headers -> IO ()) -> io ()
(.onPush) stream cb = primIO $ ffi_onPush stream $ \h => toPrim $ cb h

