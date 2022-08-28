module Node.Stream.Readable

import public Data.Maybe
import Node.Event.Internal

%foreign nodeOn0 "close"
ffi_onClose : a -> PrimIO () -> PrimIO ()

export
unsafeReadableOnClose : HasIO io => a -> IO () -> io ()
unsafeReadableOnClose = on0 ffi_onClose

%foreign nodeOn1 "data"
ffi_onData : a -> (b -> PrimIO ()) -> PrimIO ()

export
unsafeReadableOnData : HasIO io => a -> (d -> IO ()) -> io ()
unsafeReadableOnData = on1 ffi_onData

%foreign nodeOn0 "end"
ffi_onEnd : a -> PrimIO () -> PrimIO ()

export
unsafeReadableOnEnd : HasIO io => a -> IO () -> io ()
unsafeReadableOnEnd = on0 ffi_onEnd

%foreign nodeOn1 "error"
ffi_onError : a -> (e -> PrimIO ()) -> PrimIO ()

export
unsafeReadableOnError : HasIO io => a -> (e -> IO ()) -> io ()
unsafeReadableOnError = on1 ffi_onError

%foreign nodeOn0 "pause"
ffi_onPause : a -> PrimIO () -> PrimIO ()

export
unsafeReadableOnPause : HasIO io => a -> IO () -> io ()
unsafeReadableOnPause = on0 ffi_onPause

%foreign nodeOn0 "resume"
ffi_onResume : a -> PrimIO () -> PrimIO ()

export
unsafeReadableOnResume : HasIO io => a -> IO () -> io ()
unsafeReadableOnResume = on0 ffi_onResume

%foreign "node:lambda: (tya, reader) => reader.pause()"
ffi_pause : a -> PrimIO ()

export
unsafeReadablePause : HasIO io => a -> io ()
unsafeReadablePause a = primIO $ ffi_pause a

%foreign "node:lambda: (tya, reader) => reader.resume()"
ffi_resume : a -> PrimIO ()

export
unsafeReadableResume : HasIO io => a -> io ()
unsafeReadableResume a = primIO $ ffi_resume a

||| Readable stream in flowing mode
public export
interface ReadableClass d e r | r where
  (.onClose) : HasIO io => r -> IO () -> io ()
  (.onClose) = unsafeReadableOnClose
  (.onData) : HasIO io => r -> (d -> IO ()) -> io ()
  (.onData) = unsafeReadableOnData
  (.onEnd) : HasIO io => r -> IO () -> io ()
  (.onEnd) = unsafeReadableOnEnd
  (.onError) : HasIO io => r -> (e -> IO ()) -> io ()
  (.onError) = unsafeReadableOnError
  (.onPause) : HasIO io => r -> IO () -> io ()
  (.onPause) = unsafeReadableOnPause
  (.onResume) : HasIO io => r -> IO () -> io ()
  (.onResume) = unsafeReadableOnResume
  (.pause) : HasIO io => r -> io ()
  (.pause) = unsafeReadablePause
  (.resume) : HasIO io => r -> io ()
  (.resume) = unsafeReadableResume

