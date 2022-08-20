module Node.HTTP.Static

import Node
import Node.HTTP.CreateServer
import Node.HTTP.ClientRequest
import Node.HTTP.IncomingMessage
import public Node.HTTP.Request
import Node.HTTP.Server as HTTP
import Node.HTTP.Module
import Node.Net.Socket.Type
import Node.Net.Socket.Connect

%foreign "node:lambda: (http, url, t, opts, cb) => http.get(url, opts, (res) => { cb(res)() })"
ffi_get : HTTPModule -> String -> (t : SocketType) -> Node (Request.Command.Options t) -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.get) : HasIO io => HTTPModule -> String -> {auto t : SocketType } -> Request.Command.Options t -> (IncomingMessage -> IO ()) -> io ClientRequest
(.get) http url {t} opts cb = primIO $ ffi_get http url t (convertOptions t opts) $ \res => toPrim $ cb res

%foreign "node:lambda: (http, url, t, opts, cb) => http.request(url, opts, (res) => { cb(res)() })"
ffi_request : HTTPModule -> String -> (t : SocketType) -> Node (Request.Command.Options t) -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.request) : HasIO io => HTTPModule -> String -> {auto t : SocketType} -> Request.Command.Options t -> (IncomingMessage -> IO ()) -> io ClientRequest
(.request) http url {t} opts cb = primIO $ ffi_request http url t (convertOptions t opts) $ \res => toPrim $ cb res

export
(.post) : HasIO io => HTTPModule -> String -> {auto t : SocketType} -> Request.Command.Options t -> (IncomingMessage -> IO ()) -> io ClientRequest
(.post) http url opts cb = http.request url ({ request.method := "POST" } opts) cb

%foreign "node:lambda: (http, options) => http.createServer(options)"
ffi_createServer : HTTPModule -> Node CreateServer.Options -> PrimIO HTTP.Server

export
(.createServer) : HasIO io => HTTPModule -> CreateServer.Options -> io HTTP.Server
(.createServer) http options = primIO $ ffi_createServer http $ convertOptions options

