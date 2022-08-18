module Node.Net.Socket

import Node
import public Node.Error
import Node.Event.Internal
import Node.Internal.Support
import public Node.Net.Socket.Address
import public Node.Net.Socket.Connect
import public Node.Net.Socket.Type
import public Node.Stream

%foreign "node:lambda: (tys, s, cb) => s.on('close', (b) => cb(b ? _true() : _false())())"
ffi_onClose : s -> (Bool -> PrimIO ()) -> PrimIO ()

export
socketOnClose : HasIO io => s -> (Bool -> IO ()) -> io ()
socketOnClose s cb = primIO $ ffi_onClose s $ \b => toPrim $ cb b

%foreign nodeOn0 "connect"
ffi_onConnect : s -> PrimIO () -> PrimIO ()

export
socketOnConnect : HasIO io => s -> IO () -> io ()
socketOnConnect = on0 ffi_onConnect

%foreign nodeOn1 "error"
ffi_onError : s -> (e -> PrimIO ()) -> PrimIO ()

export
socketOnError : HasIO io => s -> (Error -> IO ()) -> io ()
socketOnError = on1 ffi_onError

%foreign """
  node:lambda:
  ( tys
  , s
  , cb) => s.on(
    'lookup',
    (err, addr, family, host) =>
      cb(err ? _just(err) : _nothing()
        , addr
        , family ? _just(family) : _nothing()
        , host)()
  )
  """
ffi_onLookup : s -> (Maybe Error -> (address : String) -> (family : Maybe String) -> (host : String) -> PrimIO ()) -> PrimIO ()

export
socketOnLookup : HasIO io => s -> (Maybe Error -> (address : String) -> (family : Maybe String) -> (host : String) -> IO ()) -> io ()
socketOnLookup s cb = primIO $ ffi_onLookup s $ \err, addr, family, host => toPrim $ cb err addr family host

%foreign nodeOn0 "ready"
ffi_onReady : s -> PrimIO () -> PrimIO ()

export
socketOnReady : HasIO io => s -> IO () -> io ()
socketOnReady = on0 ffi_onReady

%foreign nodeOn0 "timeout"
ffi_onTimeout : s -> PrimIO () -> PrimIO ()

export
socketOnTimeout : HasIO io => s -> IO () -> io ()
socketOnTimeout = on0 ffi_onTimeout

%foreign "node:lambda: (tys, s) => s.address()"
ffi_address : s -> PrimIO $ Node Address

export
socketAddress : HasIO io => s -> io Address
socketAddress s = fromNode <$> primIO (ffi_address s)

%foreign "node:lambda: (tys, s) => s.bytesRead"
ffi_bytesRead : s -> PrimIO Int

export
socketBytesRead : HasIO io => s -> io Int
socketBytesRead s = primIO $ ffi_bytesRead s

%foreign "node:lambda: (tys, s) => s.bytesWritten"
ffi_bytesWritten : s -> PrimIO Int

export
socketBytesWritten : HasIO io => s -> io Int
socketBytesWritten s = primIO $ ffi_bytesWritten s

%foreign "node:lambda: (tys, s, opts) => s.connect(opts)"
ffi_connect : s -> AnyPtr -> PrimIO s

export
socketConnect : HasIO io => s -> {auto t : SocketType} -> Connect.options t -> io s
socketConnect s opts = primIO $ ffi_connect s $ believe_me opts

%foreign "node:lambda: (tys, s) => s.connecting ? _true() : _false()"
ffi_connecting : s -> PrimIO Bool

export
socketConnecting : HasIO io => s -> io Bool
socketConnecting s = primIO $ ffi_connecting s

%foreign """
  node:lambda:
  (tys, s, e) => {
    const err = _maybe(e)
    return err ? s.destroy(err) : s.destroy()
  }
  """
ffi_destroy : s -> Maybe Error -> PrimIO s

export
socketDestroy : HasIO io => s -> Maybe Error -> io s
socketDestroy s e = primIO $ ffi_destroy s e

%foreign "node:lambda: (tys, s) => s.destroyed ? _true() : _false()"
ffi_destroyed : s -> PrimIO Bool

export
socketDestroyed : HasIO io => s -> io Bool
socketDestroyed s = primIO $ ffi_destroyed s

public export
interface
  ReadableClass d Error s =>
  WriteableClass d Error s =>
  SocketClass (t : SocketType) s | s
  where
  -- onClose is different from the onClose in ReadableClass and WriteableClass
  (.onClose) : HasIO io => s -> (Bool -> IO ()) -> io ()
  (.onClose) = socketOnClose
  (.onConnect) : HasIO io => s -> IO () -> io ()
  (.onConnect) = socketOnConnect
  -- onData from ReadableClass
  -- onDrain from WriteableClass
  -- onEnd  from ReadableClass
  (.onError) : HasIO io => s -> (Error -> IO ()) -> io ()
  (.onError) = socketOnError
  (.onLookup) : HasIO io => s -> (Maybe Error -> (address : String) -> (family : Maybe String) -> (host : String) -> IO ()) -> io ()
  (.onLookup) = socketOnLookup
  (.onReady) : HasIO io => s -> IO () -> io ()
  (.onReady) = socketOnReady
  (.onTimeout) : HasIO io => s -> IO () -> io ()
  (.onTimeout) = socketOnTimeout
  (.address) : HasIO io => s -> io Address
  (.address) = socketAddress
  (.bytesRead) : HasIO io => s -> io Int
  (.bytesRead) = socketBytesRead
  (.bytesWritten) : HasIO io => s -> io Int
  (.bytesWritten) = socketBytesWritten
  (.connect) : HasIO io => s -> Connect.options t -> io s
  (.connect) s opts = socketConnect s opts { t = t }
  (.connecting) : HasIO io => s -> io Bool
  (.connecting) = socketConnecting
  (.destroy) : HasIO io => s -> Maybe Error -> io s
  (.destroy) = socketDestroy
  (.destroyed) : HasIO io => s -> io Bool
  (.destroyed) = socketDestroyed
  -- end from WriteableClass
  -- localAddress
  -- localPort
  -- -- pause from ReadableClass
  -- pending
  -- ref
  -- remoteAddress
  -- remoteFamily
  -- remotePort
  -- resetAndDestroy
  -- -- resume from ReadableClass
  -- -- setEncoding -- skipped, don't switch data type
  -- setKeepAlive
  -- setNoDelay
  -- setTimeout
  -- timeout
  -- unref
  -- -- write from WriteableClass
  -- readyState

export
data Socket : (t : SocketType) -> Type where [external]

export
implementation ReadableClass d Error (Socket t) where

export
implementation WriteableClass d Error (Socket t) where

export
implementation SocketClass TCP (Socket TCP) where

export
implementation SocketClass IPC (Socket IPC) where

public export
record Options where
  constructor MkOptions
  fd: Maybe Int
  allowHalfOpen: Maybe Bool
  readable: Maybe Bool
  writeable: Maybe Bool
  -- TODO: signal

export
defaultOptions : Options
defaultOptions = MkOptions
  { fd = Nothing
  , allowHalfOpen = Nothing
  , readable = Nothing
  , writeable = Nothing
  }

%foreign """
  node:lambda:
  ( fd
  , allowHalfOpen
  , readable
  , writeable
  ) => _keepDefined({
    fd: _maybe(fd),
    allowHalfOpen: _maybeBool(_maybe(allowHalfOpen)),
    readable: _maybeBool(_maybe(readable)),
    writeable: _maybeBool(_maybe(writeable))
  })
  """
ffi_convertOptions :
  ( fd : Maybe Int )
  -> ( allowHalfOpen : Maybe Bool )
  -> ( readable : Maybe Bool )
  -> ( writeable : Maybe Bool )
  -> Node Options

export
convertOptions : Options -> Node Options
convertOptions o = ffi_convertOptions
  o.fd
  o.allowHalfOpen
  o.readable
  o.writeable

