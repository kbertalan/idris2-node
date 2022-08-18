module Node.HTTPS.Server

import Node
import Node.Error
import Node.Event.Internal
import public Node.HTTP.IncomingMessage
import public Node.HTTP.ServerResponse
import public Node.Net.Server

%hide Node.Net.Server.Server

export
data Server : Type where [external]

export
implementation ServerClass Server where

%foreign nodeOn2 "request"
ffi_onRequest : a -> (b -> c -> PrimIO ()) -> PrimIO ()

export
(.onRequest) : HasIO io => Server -> (IncomingMessage -> ServerResponse -> IO()) -> io ()
(.onRequest) = on2 ffi_onRequest

