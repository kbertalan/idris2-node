module Node.Net.Server

import public Node
import public Node.Error
import public Node.Net.Server.Listen
import Node.Event.Internal

%foreign nodeOn0 "close"
ffi_onClose : s -> PrimIO () -> PrimIO ()

export
unsafeServerOnClose : HasIO io => s -> IO () -> io ()
unsafeServerOnClose = on0 ffi_onClose

%foreign nodeOn1 "connection"
ffi_onConnection : s -> (socket -> PrimIO ()) -> PrimIO ()

export
unsafeServerOnConnection : HasIO io => s -> (socket -> IO ()) -> io ()
unsafeServerOnConnection = on1 ffi_onConnection

%foreign nodeOn1 "error"
ffi_onError : s -> (e -> PrimIO ()) -> PrimIO ()

export
unsafeServerOnError : HasIO io => s -> (Error -> IO ()) -> io ()
unsafeServerOnError = on1 ffi_onError

%foreign nodeOn0 "listening"
ffi_onListening : s -> PrimIO () -> PrimIO ()

export
unsafeServerOnListening : HasIO io => s -> IO () -> io ()
unsafeServerOnListening = on0 ffi_onListening

%foreign nodeOn1 "drop"
ffi_onDrop : s -> (drop -> PrimIO ()) -> PrimIO ()

export
unsafeServerOnDrop : HasIO io => s -> (drop -> IO ()) -> io ()
unsafeServerOnDrop = on1 ffi_onDrop

%foreign "node:lambda: (ty, server, options) => server.listen(options)"
ffi_listen : s -> Node Listen.Options -> PrimIO ()

export
unsafeServerListen : HasIO io => s -> Listen.Options -> io ()
unsafeServerListen server options = primIO $ ffi_listen server $ convertOptions options

%foreign "node:lambda: (ty, server) => server.close()"
ffi_close : s -> PrimIO ()

export
unsafeServerClose : HasIO io => s -> io ()
unsafeServerClose server = primIO $ ffi_close server

public export
interface ServerClass s where
  (.onClose) : HasIO io => s -> IO () -> io ()
  (.onClose) = unsafeServerOnClose
  (.onConnection) : HasIO io => s -> (socket -> IO ()) -> io ()
  (.onConnection) = unsafeServerOnConnection
  (.onError) : HasIO io => s -> (Error -> IO ()) -> io ()
  (.onError) = unsafeServerOnError
  (.onListening) : HasIO io => s -> IO () -> io ()
  (.onListening) = unsafeServerOnListening
  (.onDrop) : HasIO io => s -> (drop -> IO ()) -> io ()
  (.onDrop) = unsafeServerOnDrop
  (.listen) : HasIO io => s -> Listen.Options -> io ()
  (.listen) = unsafeServerListen
  (.close) : HasIO io => s -> io ()
  (.close) = unsafeServerClose

export
data Server : Type where [external]

public export
implementation ServerClass Server where

