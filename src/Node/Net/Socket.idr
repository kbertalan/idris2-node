module Node.Net.Socket

import Node
import public Node.Error
import Node.Event.Internal
import Node.Internal.Elab
import Node.Internal.Support
import public Node.Net.Socket.Address
import public Node.Net.Socket.Connect
import public Node.Net.Socket.Type
import public Node.Stream

%language ElabReflection

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

%foreign """
  node:lambda:
  (tys, s) => {
    const a = s.address()
    if (a === undefined || a.port === undefined || a.family === undefined || a.address === undefined) {
      return _nothing()
    }
    return _just(a)
  }
  """
ffi_address : s -> PrimIO $ Maybe $ Node Address

export
socketAddress : HasIO io => s -> io $ Maybe Address
socketAddress s = map fromNode <$> primIO (ffi_address s)

%runElab mkNodeFieldIO (basic "socketBytesRead") "bytesRead" `(Int)
%runElab mkNodeFieldIO (basic "socketBytesWritten") "bytesWritten" `(Int)

%foreign "node:lambda: (tys, s, opts) => s.connect(opts)"
ffi_connect : s -> AnyPtr -> PrimIO s

export
socketConnect : HasIO io => s -> {auto t : SocketType} -> Connect.options t -> io s
socketConnect s {t} opts = primIO $ ffi_connect s $ believe_me $ convertOptions t opts

%runElab mkNodeFieldIO (basic "socketConnecting") "connecting" `(Bool)

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

%runElab mkNodeFieldIO (basic "socketDestroyed") "destroyed" `(Bool)
%runElab mkNodeFieldIO (basic "socketLocalAddress") "localAddress" `(Maybe String)
%runElab mkNodeFieldIO (basic "socketLocalPort") "localPort" `(Maybe Int)
%runElab mkNodeFieldIO (basic "socketPending") "pending" `(Bool)

%foreign "node:lambda: (tys, s) => s.ref()"
ffi_ref : s -> PrimIO s

export
socketRef : HasIO io => s -> io s
socketRef s = primIO $ ffi_ref s

%runElab mkNodeFieldIO (basic "socketRemoteAddress") "remoteAddress" `(Maybe String)
%runElab mkNodeFieldIO (basic "socketRemoteFamily") "remoteFamily" `(Maybe String)
%runElab mkNodeFieldIO (basic "socketRemotePort") "remotePort" `(Maybe Int)

%foreign "node:lambda: (tys, s) => s.resetAndDestroy()"
ffi_resetAndDestroy : s -> PrimIO s

export
socketResetAndDestroy : HasIO io => s -> io s
socketResetAndDestroy s = primIO $ ffi_resetAndDestroy s

%foreign """
  node:lambda:
  (tys, s, initialDelay) => {
    const d = _maybe(initialDelay)
    if (d) {
       return s.setKeepAlive(true, d)
    }
    return s.setKeepAlive(false)
  }
  """
ffi_setKeepAlive : s -> Maybe Int -> PrimIO s

export
socketSetKeepAlive : HasIO io => s -> Maybe Int -> io s
socketSetKeepAlive s initialDelay = primIO $ ffi_setKeepAlive s initialDelay

%foreign "node:lambda: (tys, s, b) => s.setNoDelay(_bool(b))"
ffi_setNoDelay : s -> Bool -> PrimIO s

export
socketSetNoDelay : HasIO io => s -> Bool -> io s
socketSetNoDelay s b = primIO $ ffi_setNoDelay s b

%foreign """
  node:lambda:
  (tys, s, timeout) => {
    const t = _maybe(timeout)
    if (t) {
      return s.setTimeout(t)
    }
    return s.setTimeout(0)
  }
  """
ffi_setTimeout : s -> Maybe Int -> PrimIO s

export
socketSetTimeout : HasIO io => s -> Maybe Int -> io s
socketSetTimeout s timeout = primIO $ ffi_setTimeout s timeout

%foreign """
  node:lambda: (tys, s) => {
    const t = s.timeout
    if (t === undefined || t === null) {
      return _nothing()
    }
    return _just(t)
  }
  """
ffi_timeout : s -> PrimIO $ Maybe Int

export
socketTimeout : HasIO io => s -> io $ Maybe Int
socketTimeout s = primIO $ ffi_timeout s

%foreign "node:lambda: (tys, s) => s.unref()"
ffi_unref : s -> PrimIO s

export
socketUnref : HasIO io => s -> io s
socketUnref s = primIO $ ffi_unref s

%runElab mkNodeFieldIO (basic "socketReadyState") "readyState" `(String)

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
  (.address) : HasIO io => s -> io $ Maybe Address
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
  (.localAddress) : HasIO io => s -> io $ Maybe String
  (.localAddress) = socketLocalAddress
  (.localPort) : HasIO io => s -> io $ Maybe Int
  (.localPort) = socketLocalPort
  -- -- pause from ReadableClass
  (.pending) : HasIO io => s -> io Bool
  (.pending) = socketPending
  (.ref) : HasIO io => s -> io s
  (.ref) = socketRef
  (.remoteAddress) : HasIO io => s -> io $ Maybe String
  (.remoteAddress) = socketRemoteAddress
  (.remoteFamily) : HasIO io => s -> io $ Maybe String
  (.remoteFamily) = socketRemoteFamily
  (.remotePort) : HasIO io => s -> io $ Maybe Int
  (.remotePort) = socketRemotePort
  (.resetAndDestroy) : HasIO io => s -> io s
  (.resetAndDestroy) = socketResetAndDestroy
  -- -- resume from ReadableClass
  -- -- setEncoding -- skipped, don't switch data type
  (.setKeepAlive) : HasIO io => s -> Maybe Int -> io s
  (.setKeepAlive) = socketSetKeepAlive
  (.setNoDelay) : HasIO io => s -> Bool -> io s
  (.setNoDelay) = socketSetNoDelay
  (.setTimeout) : HasIO io => s -> Maybe Int -> io s
  (.setTimeout) = socketSetTimeout
  (.timeout) : HasIO io => s -> io $ Maybe Int
  (.timeout) = socketTimeout
  (.unref) : HasIO io => s -> io s
  (.unref) = socketUnref
  -- -- write from WriteableClass
  (.readyState) : HasIO io => s -> io String
  (.readyState) = socketReadyState

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

