module Node.HTTP2.Static

import Node
import Node.HTTP2.Connect
import Node.HTTP2.ClientHttp2Session
import Node.HTTP2.CreateSecureServer
import Node.HTTP2.CreateServer
import Node.HTTP2.Http2Server
import Node.HTTP2.Type

%foreign "node:lambda: (http2, opts) => http2.createServer(opts)"
ffi_createServer : HTTP2 -> Node HTTP2.CreateServer.Command.Options -> PrimIO Http2Server

export
(.createServer) : HasIO io => HTTP2 -> HTTP2.CreateServer.Command.Options -> io Http2Server
(.createServer) http2 opts = primIO $ ffi_createServer http2 (convertOptions opts)

%foreign "node:lambda: (http2, opts) => http2.createSecureServer(opts)"
ffi_createSecureServer : HTTP2 -> Node HTTP2.CreateSecureServer.Command.Options -> PrimIO Http2Server

export
(.createSecureServer) : HasIO io => HTTP2 -> HTTP2.CreateSecureServer.Command.Options -> io Http2Server
(.createSecureServer) http2 opts = primIO $ ffi_createSecureServer http2 (convertOptions opts)

%foreign "node:lambda: (http2, authority, connectOptions) => http2.connect(authority, connectOptions)"
ffi_connect : HTTP2 -> String -> Node Connect.Options -> PrimIO ClientHttp2Session

export
(.connect) : HasIO io => HTTP2 -> String -> Connect.Options -> io ClientHttp2Session
(.connect) http2 authority connectOptions = primIO $ ffi_connect http2 authority $ convertOptions connectOptions

