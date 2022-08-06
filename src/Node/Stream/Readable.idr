module Node.Stream.Readable

import public Data.Maybe
import Node.Stream.FFI

export
readableOnClose : HasIO io => a -> IO () -> io ()
readableOnClose = on0 ffi_onClose

export
readableOnData : HasIO io => a -> (d -> IO ()) -> io ()
readableOnData = on1 ffi_onData

export
readableOnEnd : HasIO io => a -> IO () -> io ()
readableOnEnd = on0 ffi_onEnd

export
readableOnError : HasIO io => a -> (e -> IO ()) -> io ()
readableOnError = on1 ffi_onError

export
readableOnPause : HasIO io => a -> IO () -> io ()
readableOnPause = on0 ffi_onPause

export
readableOnResume : HasIO io => a -> IO () -> io ()
readableOnResume = on0 ffi_onResume

export
readablePause : HasIO io => a -> io ()
readablePause a = primIO $ ffi_pause a

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

