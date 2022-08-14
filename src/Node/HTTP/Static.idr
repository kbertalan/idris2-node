module Node.HTTP.Static

import Node.HTTP.CreateServer
import Node.HTTP.ClientRequest
import Node.HTTP.IncomingMessage
import public Node.HTTP.Request
import Node.HTTP.Server
import Node.HTTP.Type

%foreign "node:lambda: (http, url, opts, cb) => http.get(url, opts, (res) => { cb(res)() })"
ffi_get : HTTP -> String -> Request.NodeRequestOptions -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.get) : HasIO io => HTTP -> String -> Request.RequestOptions -> (IncomingMessage -> IO ()) -> io ClientRequest
(.get) http url opts cb = primIO $ ffi_get http url (convertRequestOptions opts) $ \res => toPrim $ cb res

%foreign "node:lambda: (http, url, opts, cb) => http.request(url, opts, (res) => { cb(res)() })"
ffi_request : HTTP -> String -> Request.NodeRequestOptions -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.request) : HasIO io => HTTP -> String -> Request.RequestOptions -> (IncomingMessage -> IO ()) -> io ClientRequest
(.request) http url opts cb = primIO $ ffi_request http url (convertRequestOptions opts) $ \res => toPrim $ cb res

export
(.post) : HasIO io => HTTP -> String -> Request.RequestOptions -> (IncomingMessage -> IO ()) -> io ClientRequest
(.post) http url opts cb = http.request url ({ requestOptions.method := "POST" } opts) cb

%foreign "node:lambda: (http, options) => http.createServer(options)"
ffi_createServer : HTTP -> CreateServer.NodeOptions -> PrimIO Server

export
(.createServer) : HasIO io => HTTP -> Options -> io Server
(.createServer) http options = primIO $ ffi_createServer http $ convertOptions options

