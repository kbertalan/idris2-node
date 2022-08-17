module Node.HTTPS.Static

import Node
import public Node.HTTP.ClientRequest
import Node.HTTPS.CreateServer
import public Node.HTTPS.Request
import Node.HTTPS.Server
import Node.HTTPS.Type

%foreign "node:lambda: (https, opts) => https.createServer(opts)"
ffi_createServer : HTTPS -> Node HTTPS.CreateServer.Options -> PrimIO Server

export
(.createServer) : HasIO io => HTTPS -> HTTPS.CreateServer.Options -> io Server
(.createServer) https opts = primIO $ ffi_createServer https $ convertOptions opts

%foreign "node:lambda: (https, url, opts, cb) => https.get(url, opts, (res) => { cb(res)() })"
ffi_get : HTTPS -> String -> Node Node.HTTPS.Request.Command.Options -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.get) : HasIO io => HTTPS -> String -> Node.HTTPS.Request.Command.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.get) https url opts cb = primIO $ ffi_get https url (convertOptions opts) $ \res => toPrim $ cb res

%foreign "node:lambda: (https, url, opts, cb) => https.request(url, opts, (res) => { cb(res)() })"
ffi_request : HTTPS -> String -> Node Node.HTTPS.Request.Command.Options -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.request) : HasIO io => HTTPS -> String -> Node.HTTPS.Request.Command.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.request) https url opts cb = primIO $ ffi_request https url (convertOptions opts) $ \res => toPrim $ cb res

export
(.post) : HasIO io => HTTPS -> String -> Node.HTTPS.Request.Command.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.post) https url opts cb = https.request url ({ request.method := "POST" } opts) cb

