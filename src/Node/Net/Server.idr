module Node.Net.Server

import public Node
import public Node.Error
import public Node.Net.Server.Listen
import Node.Event.Internal

%foreign nodeOn0 "close"
ffi_onClose : s -> PrimIO () -> PrimIO ()

export
serverOnClose : HasIO io => s -> IO () -> io ()
serverOnClose = on0 ffi_onClose

%foreign nodeOn1 "connection"
ffi_onConnection : s -> (socket -> PrimIO ()) -> PrimIO ()

export
serverOnConnection : HasIO io => s -> (socket -> IO ()) -> io ()
serverOnConnection = on1 ffi_onConnection

%foreign nodeOn1 "error"
ffi_onError : s -> (e -> PrimIO ()) -> PrimIO ()

export
serverOnError : HasIO io => s -> (Error -> IO ()) -> io ()
serverOnError = on1 ffi_onError

%foreign nodeOn0 "listening"
ffi_onListening : s -> PrimIO () -> PrimIO ()

export
serverOnListening : HasIO io => s -> IO () -> io ()
serverOnListening = on0 ffi_onListening

%foreign nodeOn1 "drop"
ffi_onDrop : s -> (drop -> PrimIO ()) -> PrimIO ()

export
serverOnDrop : HasIO io => s -> (drop -> IO ()) -> io ()
serverOnDrop = on1 ffi_onDrop

%foreign "node:lambda: (ty, server, options) => server.listen(options)"
ffi_listen : s -> Node Listen.Options -> PrimIO ()

export
serverListen : HasIO io => s -> Listen.Options -> io ()
serverListen server options = primIO $ ffi_listen server $ convertOptions options

%foreign "node:lambda: (ty, server) => server.close()"
ffi_close : s -> PrimIO ()

export
serverClose : HasIO io => s -> io ()
serverClose server = primIO $ ffi_close server

public export
interface ServerClass s where
  (.onClose) : HasIO io => s -> IO () -> io ()
  (.onClose) = serverOnClose
  (.onConnection) : HasIO io => s -> (socket -> IO ()) -> io ()
  (.onConnection) = serverOnConnection
  (.onError) : HasIO io => s -> (Error -> IO ()) -> io ()
  (.onError) = serverOnError
  (.onListening) : HasIO io => s -> IO () -> io ()
  (.onListening) = serverOnListening
  (.onDrop) : HasIO io => s -> (drop -> IO ()) -> io ()
  (.onDrop) = serverOnDrop
  (.listen) : HasIO io => s -> Listen.Options -> io ()
  (.listen) = serverListen
  (.close) : HasIO io => s -> io ()
  (.close) = serverClose

export
data Server : Type where [external]

public export
implementation ServerClass Server where

