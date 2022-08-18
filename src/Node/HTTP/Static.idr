module Node.HTTP.Static

import Node
import Node.HTTP.CreateServer
import Node.HTTP.ClientRequest
import Node.HTTP.IncomingMessage
import public Node.HTTP.Request
import Node.HTTP.Server as HTTP
import Node.HTTP.Type

%foreign "node:lambda: (http, url, opts, cb) => http.get(url, opts, (res) => { cb(res)() })"
ffi_get : HTTP -> String -> Node Request.Command.Options -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.get) : HasIO io => HTTP -> String -> Request.Command.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.get) http url opts cb = primIO $ ffi_get http url (convertOptions opts) $ \res => toPrim $ cb res

%foreign "node:lambda: (http, url, opts, cb) => http.request(url, opts, (res) => { cb(res)() })"
ffi_request : HTTP -> String -> Node Request.Command.Options -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.request) : HasIO io => HTTP -> String -> Request.Command.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.request) http url opts cb = primIO $ ffi_request http url (convertOptions opts) $ \res => toPrim $ cb res

export
(.post) : HasIO io => HTTP -> String -> Request.Command.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.post) http url opts cb = http.request url ({ request.method := "POST" } opts) cb

%foreign "node:lambda: (http, options) => http.createServer(options)"
ffi_createServer : HTTP -> Node CreateServer.Options -> PrimIO HTTP.Server

export
(.createServer) : HasIO io => HTTP -> CreateServer.Options -> io HTTP.Server
(.createServer) http options = primIO $ ffi_createServer http $ convertOptions options

