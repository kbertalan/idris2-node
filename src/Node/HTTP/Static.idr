module Node.HTTP.Static

import Node.HTTP.CreateServer
import Node.HTTP.ClientRequest
import Node.HTTP.IncomingMessage
import Node.HTTP.Server
import Node.HTTP.Type

%foreign "node:lambda: (http, url, cb) => http.get(url, (res) => { cb(res)() })"
ffi_get : HTTP -> String -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.get) : HasIO io => HTTP -> String -> (IncomingMessage -> IO ()) -> io ClientRequest
(.get) http url cb = primIO $ ffi_get http url $ \res => toPrim $ cb res

%foreign "node:lambda: (http, url, cb) => http.request(url, {method: 'POST'}, (res) => { cb(res)() })"
ffi_post : HTTP -> String -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.post) : HasIO io => HTTP -> String -> (IncomingMessage -> IO ()) -> io ClientRequest
(.post) http url cb = primIO $ ffi_post http url $ \res => toPrim $ cb res

%foreign "node:lambda: (http, options) => http.createServer(options)"
ffi_createServer : HTTP -> NodeOptions -> PrimIO Server

export
(.createServer) : HasIO io => HTTP -> Options -> io Server
(.createServer) http options = primIO $ ffi_createServer http $ convertOptions options

