module Node.Stream.Writeable

import Data.Maybe
import Node.Event.Internal
import Node.Stream.Readable

%foreign nodeOn0 "close"
ffi_onClose : a -> PrimIO () -> PrimIO ()

export
unsafeWriteableOnClose : HasIO io => a -> IO () -> io ()
unsafeWriteableOnClose = on0 ffi_onClose

%foreign nodeOn0 "drain"
ffi_onDrain : a -> PrimIO () -> PrimIO ()

export
unsafeWriteableOnDrain : HasIO io => a -> IO () -> io ()
unsafeWriteableOnDrain = on0 ffi_onDrain

%foreign nodeOn1 "error"
ffi_onError : a -> (e -> PrimIO ()) -> PrimIO ()

export
unsafeWriteableOnError : HasIO io => a -> (e -> IO ()) -> io ()
unsafeWriteableOnError = on1 ffi_onError

%foreign nodeOn0 "finish"
ffi_onFinish : a -> PrimIO () -> PrimIO ()

export
unsafeWriteableOnFinish : HasIO io => a -> IO () -> io ()
unsafeWriteableOnFinish = on0 ffi_onFinish

%foreign nodeOn1 "pipe"
ffi_onPipe : a -> (r -> PrimIO ()) -> PrimIO ()

export
unsafeWriteableOnPipe : HasIO io => ReadableClass d e r => a -> (r -> IO ()) -> io ()
unsafeWriteableOnPipe = on1 ffi_onPipe

%foreign nodeOn1 "unpipe"
ffi_onUnpipe : a -> (r -> PrimIO ()) -> PrimIO ()

export
unsafeWriteableOnUnpipe : HasIO io => ReadableClass d e r => a -> (r -> IO ()) -> io ()
unsafeWriteableOnUnpipe = on1 ffi_onUnpipe

%foreign "node:lambda: (tya, writeable) => writeable.cork()"
ffi_cork : a -> PrimIO ()

export
unsafeWriteableCork : HasIO io => a -> io ()
unsafeWriteableCork a = primIO $ ffi_cork a

%foreign "node:lambda: (tya, writeable, callback) => writeable.end(callback)"
ffi_end : a -> PrimIO () -> PrimIO ()

export
unsafeWriteableEnd : HasIO io => a -> IO () -> io ()
unsafeWriteableEnd = on0 ffi_end

%foreign "node:lambda: (tya, tyb, writeable, data, callback) => writeable.write(data, callback)"
ffi_write : a -> b -> PrimIO () -> PrimIO ()

export
unsafeWriteableWrite : HasIO io => a -> b -> IO () -> io ()
unsafeWriteableWrite a b cb = primIO $ ffi_write a b $ toPrim cb

%foreign "node:lambda: (tya, writeable) => writeable.uncork()"
ffi_uncork : a -> PrimIO ()

export
unsafeWriteableUncork : HasIO io => a -> io ()
unsafeWriteableUncork a = primIO $ ffi_uncork a

||| Writable stream
public export
interface WriteableClass d e w | w where
  (.onClose) : HasIO io => w -> IO () -> io ()
  (.onClose) = unsafeWriteableOnClose
  (.onDrain) : HasIO io => w -> IO () -> io ()
  (.onDrain) = unsafeWriteableOnDrain
  (.onError) : HasIO io => w -> (e -> IO ()) -> io ()
  (.onError) = unsafeWriteableOnError
  (.onFinish) : HasIO io => w -> IO () -> io ()
  (.onFinish) = unsafeWriteableOnFinish
  (.onPipe) : HasIO io => ReadableClass d e r => w -> (r -> IO ()) -> io ()
  (.onPipe) = unsafeWriteableOnPipe
  (.onUnpipe) : HasIO io => ReadableClass d e r => w -> (r -> IO ()) -> io ()
  (.onUnpipe) = unsafeWriteableOnUnpipe
  (.cork) : HasIO io => w -> io ()
  (.cork) = unsafeWriteableCork
  (.end) : HasIO io => w -> Maybe (IO ()) -> io ()
  (.end) w cb = unsafeWriteableEnd w $ fromMaybe (pure ()) cb
  (.write) : HasIO io => w -> d -> Maybe (IO ()) -> io ()
  (.write) w d cb = unsafeWriteableWrite w d $ fromMaybe (pure ()) cb
  (.uncork) : HasIO io => w -> io ()
  (.uncork) = unsafeWriteableUncork

