module Node.Stream.Readable

import public Data.Maybe
import Node.Event.Internal

%foreign nodeOn0 "close"
ffi_onClose : a -> PrimIO () -> PrimIO ()

export
readableOnClose : HasIO io => a -> IO () -> io ()
readableOnClose = on0 ffi_onClose

%foreign nodeOn1 "data"
ffi_onData : a -> (b -> PrimIO ()) -> PrimIO ()

export
readableOnData : HasIO io => a -> (d -> IO ()) -> io ()
readableOnData = on1 ffi_onData

%foreign nodeOn0 "end"
ffi_onEnd : a -> PrimIO () -> PrimIO ()

export
readableOnEnd : HasIO io => a -> IO () -> io ()
readableOnEnd = on0 ffi_onEnd

%foreign nodeOn1 "error"
ffi_onError : a -> (e -> PrimIO ()) -> PrimIO ()

export
readableOnError : HasIO io => a -> (e -> IO ()) -> io ()
readableOnError = on1 ffi_onError

%foreign nodeOn0 "pause"
ffi_onPause : a -> PrimIO () -> PrimIO ()

export
readableOnPause : HasIO io => a -> IO () -> io ()
readableOnPause = on0 ffi_onPause

%foreign nodeOn0 "resume"
ffi_onResume : a -> PrimIO () -> PrimIO ()

export
readableOnResume : HasIO io => a -> IO () -> io ()
readableOnResume = on0 ffi_onResume

%foreign "node:lambda: (tya, reader) => reader.pause()"
ffi_pause : a -> PrimIO ()

export
readablePause : HasIO io => a -> io ()
readablePause a = primIO $ ffi_pause a

%foreign "node:lambda: (tya, reader) => reader.resume()"
ffi_resume : a -> PrimIO ()

export
readableResume : HasIO io => a -> io ()
readableResume a = primIO $ ffi_resume a

||| Readable stream in flowing mode
public export
interface Readable d r | r where
  (.onClose) : HasIO io => r -> IO () -> io ()
  (.onClose) = readableOnClose
  (.onData) : HasIO io => r -> (d -> IO ()) -> io ()
  (.onData) = readableOnData
  (.onEnd) : HasIO io => r -> IO () -> io ()
  (.onEnd) = readableOnEnd
  (.onError) : HasIO io => r -> (e -> IO ()) -> io ()
  (.onError) = readableOnError
  (.onPause) : HasIO io => r -> IO () -> io ()
  (.onPause) = readableOnPause
  (.onResume) : HasIO io => r -> IO () -> io ()
  (.onResume) = readableOnResume
  (.pause) : HasIO io => r -> io ()
  (.pause) = readablePause
  (.resume) : HasIO io => r -> io ()
  (.resume) = readableResume

