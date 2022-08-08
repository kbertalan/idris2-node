module Node.Stream.Writeable

import Data.Maybe
import Node.Event.Internal
import Node.Stream.Readable

%foreign nodeOn0 "close"
ffi_onClose : a -> PrimIO () -> PrimIO ()

export
writeableOnClose : HasIO io => a -> IO () -> io ()
writeableOnClose = on0 ffi_onClose

%foreign nodeOn0 "drain"
ffi_onDrain : a -> PrimIO () -> PrimIO ()

export
writeableOnDrain : HasIO io => a -> IO () -> io ()
writeableOnDrain = on0 ffi_onDrain

%foreign nodeOn1 "error"
ffi_onError : a -> (e -> PrimIO ()) -> PrimIO ()

export
writeableOnError : HasIO io => a -> (e -> IO ()) -> io ()
writeableOnError = on1 ffi_onError

%foreign nodeOn0 "finish"
ffi_onFinish : a -> PrimIO () -> PrimIO ()

export
writeableOnFinish : HasIO io => a -> IO () -> io ()
writeableOnFinish = on0 ffi_onFinish

%foreign nodeOn1 "pipe"
ffi_onPipe : a -> (r -> PrimIO ()) -> PrimIO ()

export
writeableOnPipe : HasIO io => Readable d r => a -> (r -> IO ()) -> io ()
writeableOnPipe = on1 ffi_onPipe

%foreign nodeOn1 "unpipe"
ffi_onUnpipe : a -> (r -> PrimIO ()) -> PrimIO ()

export
writeableOnUnpipe : HasIO io => Readable d r => a -> (r -> IO ()) -> io ()
writeableOnUnpipe = on1 ffi_onUnpipe

%foreign "node:lambda: (tya, writeable) => writeable.cork()"
ffi_cork : a -> PrimIO ()

export
writeableCork : HasIO io => a -> io ()
writeableCork a = primIO $ ffi_cork a

%foreign "node:lambda: (tya, writeable, callback) => writeable.end(callback)"
ffi_end : a -> PrimIO () -> PrimIO ()

export
writeableEnd : HasIO io => a -> IO () -> io ()
writeableEnd = on0 ffi_end

%foreign "node:lambda: (tya, tyb, writeable, data, callback) => writeable.write(data, callback)"
ffi_write : a -> b -> PrimIO () -> PrimIO ()

export
writeableWrite : HasIO io => a -> b -> IO () -> io ()
writeableWrite a b cb = primIO $ ffi_write a b $ toPrim cb

%foreign "node:lambda: (tya, writeable) => writeable.uncork()"
ffi_uncork : a -> PrimIO ()

export
writeableUncork : HasIO io => a -> io ()
writeableUncork a = primIO $ ffi_uncork a

||| Writable stream
public export
interface Writeable d w | w where
  (.onClose) : HasIO io => w -> IO () -> io ()
  (.onClose) = writeableOnClose
  (.onDrain) : HasIO io => w -> IO () -> io ()
  (.onDrain) = writeableOnDrain
  (.onError) : HasIO io => w -> (e -> IO ()) -> io ()
  (.onError) = writeableOnError
  (.onFinish) : HasIO io => w -> IO () -> io ()
  (.onFinish) = writeableOnFinish
  (.onPipe) : HasIO io => Readable d r => w -> (r -> IO ()) -> io ()
  (.onPipe) = writeableOnPipe
  (.onUnpipe) : HasIO io => Readable d r => w -> (r -> IO ()) -> io ()
  (.onUnpipe) = writeableOnUnpipe
  (.cork) : HasIO io => w -> io ()
  (.cork) = writeableCork
  (.end) : HasIO io => w -> Maybe (IO ()) -> io ()
  (.end) w cb = writeableEnd w $ fromMaybe (pure ()) cb
  (.write) : HasIO io => w -> d -> Maybe (IO ()) -> io ()
  (.write) w d cb = writeableWrite w d $ fromMaybe (pure ()) cb
  (.uncork) : HasIO io => w -> io ()
  (.uncork) = writeableUncork

