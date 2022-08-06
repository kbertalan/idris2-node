module Node.Stream.FFI

export
on0 : HasIO io => (a -> PrimIO () -> PrimIO ()) -> a -> IO () -> io ()
on0 fn a cb = primIO $ fn a $ toPrim cb

export
on1 : HasIO io => (a -> (e -> PrimIO ()) -> PrimIO ()) -> a -> (e -> IO ()) -> io ()
on1 fn a cb = primIO $ fn a $ \e => toPrim $ cb e

nodeOn0 : String -> String
nodeOn0 event = "node:lambda: (tya, a, callback) => a.on('\{event}', callback)"

nodeOn1 : String -> String
nodeOn1 event = "node:lambda: (tya, tyb, a, callback) => a.on('\{event}', b => callback(b)())"

export
%foreign nodeOn0 "close"
ffi_onClose : a -> PrimIO () -> PrimIO ()

export
%foreign nodeOn1 "error"
ffi_onError : a -> (e -> PrimIO ()) -> PrimIO ()

namespace Writeable
  export
  %foreign nodeOn0 "drain"
  ffi_onDrain : a -> PrimIO () -> PrimIO ()

  export
  %foreign nodeOn0 "finish"
  ffi_onFinish : a -> PrimIO () -> PrimIO ()

  export
  %foreign nodeOn1 "pipe"
  ffi_onPipe : a -> (r -> PrimIO ()) -> PrimIO ()

  export
  %foreign nodeOn1 "unpipe"
  ffi_onUnpipe : a -> (r -> PrimIO ()) -> PrimIO ()

  export
  %foreign "node:lambda: (tya, writeable) => writeable.cork()"
  ffi_cork : a -> PrimIO ()

  export
  %foreign "node:lambda: (tya, writeable, callback) => writeable.end(callback)"
  ffi_end : a -> PrimIO () -> PrimIO ()

  export
  %foreign "node:lambda: (tya, tyb, writeable, data, callback) => writeable.end(data, callback)"
  ffi_endData : a -> b -> PrimIO () -> PrimIO ()

  export
  %foreign "node:lambda: (tya, tyb, writeable, data, callback) => writeable.write(data, callback)"
  ffi_write : a -> b -> PrimIO () -> PrimIO ()

  export
  %foreign "node:lambda: (tya, writeable) => writeable.uncork()"
  ffi_uncork : a -> PrimIO ()

namespace Readable

  export
  %foreign "node:lambda: (tya, tyd, reader, callback) => reader.on('data', chunk => callback(chunk)())"
  ffi_onData : a -> (d -> PrimIO ()) -> PrimIO ()

  export
  %foreign "node:lambda: (tya, reader, callback) => reader.on('end', callback)"
  ffi_onEnd : a -> PrimIO () -> PrimIO ()

  export
  %foreign "node:lambda: (tya, reader, callback) => reader.on('pause', callback)"
  ffi_onPause : a -> PrimIO () -> PrimIO ()

  export
  %foreign "node:lambda: (tya, reader, callback) => reader.on('resume', callback)"
  ffi_onResume : a -> PrimIO () -> PrimIO ()

  export
  %foreign "node:lambda: (tya, reader) => reader.pause()"
  ffi_pause : a -> PrimIO ()

  export
  %foreign "node:lambda: (tya, reader) => reader.resume()"
  ffi_resume : a -> PrimIO ()

