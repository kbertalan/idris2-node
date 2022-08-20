module Node.HTTP.Server

import Node
import Node.Event.Internal
import Node.HTTP.IncomingMessage
import Node.HTTP.ServerResponse
import Node.HTTP.Module
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

