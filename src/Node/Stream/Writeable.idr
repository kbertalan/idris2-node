module Node.Stream.Writeable

import Data.Maybe
import Node.Stream.FFI
import Node.Stream.Readable

export
writeableOnClose : HasIO io => a -> IO () -> io ()
writeableOnClose = on0 ffi_onClose

export
writeableOnDrain : HasIO io => a -> IO () -> io ()
writeableOnDrain = on0 ffi_onDrain

export
writeableOnError : HasIO io => a -> (e -> IO ()) -> io ()
writeableOnError = on1 ffi_onError

export
writeableOnFinish : HasIO io => a -> IO () -> io ()
writeableOnFinish = on0 ffi_onFinish

export
writeableOnPipe : HasIO io => Readable d r => a -> (r -> IO ()) -> io ()
writeableOnPipe = on1 ffi_onPipe

export
writeableOnUnpipe : HasIO io => Readable d r => a -> (r -> IO ()) -> io ()
writeableOnUnpipe = on1 ffi_onUnpipe

export
writeableCork : HasIO io => a -> io ()
writeableCork a = primIO $ ffi_cork a

export
writeableEnd : HasIO io => a -> IO () -> io ()
writeableEnd = on0 ffi_end

export
writeableWrite : HasIO io => a -> b -> IO () -> io ()
writeableWrite a b cb = primIO $ ffi_write a b $ toPrim cb

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

