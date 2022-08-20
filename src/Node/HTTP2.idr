module Node.HTTP2

import public Node.HTTP2.Connect
import public Node.HTTP2.ClientHttp2Session
import public Node.HTTP2.ClientHttp2Stream
import public Node.HTTP2.CreateSecureServer
import public Node.HTTP2.CreateServer
import public Node.HTTP2.Http2Server
import public Node.HTTP2.ServerHttp2Stream
import public Node.HTTP2.Static
import public Node.HTTP2.Module

%foreign "node:lambda: () => require('http2')"
ffi_require : PrimIO HTTP2Module

export
require : HasIO io => io HTTP2Module
require = primIO $ ffi_require

