module Node.HTTPS.Static

import Node
import public Node.HTTP.ClientRequest
import Node.HTTPS.CreateServer
import public Node.HTTPS.Request
import Node.HTTPS.Server as HTTPS
import Node.HTTPS.Type

%foreign "node:lambda: (https, opts) => https.createServer(opts)"
ffi_createServer : HTTPS -> Node HTTPS.CreateServer.Command.Options -> PrimIO HTTPS.Server

export
(.createServer) : HasIO io => HTTPS -> HTTPS.CreateServer.Command.Options -> io HTTPS.Server
(.createServer) https opts = primIO $ ffi_createServer https $ convertOptions opts

%foreign "node:lambda: (https, url, t, opts, cb) => https.get(url, opts, (res) => { cb(res)() })"
ffi_get : HTTPS -> String -> (t : SocketType) -> Node (Node.HTTPS.Request.Command.Options t) -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.get) : HasIO io => HTTPS -> String -> { auto t : SocketType } -> Node.HTTPS.Request.Command.Options t -> (IncomingMessage -> IO ()) -> io ClientRequest
(.get) https url {t} opts cb = primIO $ ffi_get https url t (convertOptions t opts) $ \res => toPrim $ cb res

%foreign "node:lambda: (https, url, t, opts, cb) => https.request(url, opts, (res) => { cb(res)() })"
ffi_request : HTTPS -> String -> (t : SocketType) -> Node (Node.HTTPS.Request.Command.Options t) -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.request) : HasIO io => HTTPS -> String -> { auto t : SocketType } -> Node.HTTPS.Request.Command.Options t -> (IncomingMessage -> IO ()) -> io ClientRequest
(.request) https url {t} opts cb = primIO $ ffi_request https url t (convertOptions t opts) $ \res => toPrim $ cb res

export
(.post) : HasIO io => HTTPS -> String -> {auto t : SocketType} -> (Node.HTTPS.Request.Command.Options t) -> (IncomingMessage -> IO ()) -> io ClientRequest
(.post) https url opts cb = https.request url ({ request.method := "POST" } opts) cb

