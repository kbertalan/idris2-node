module Node.HTTP2.Static

import Node
import Node.HTTP2.Connect
import Node.HTTP2.ClientHttp2Session
import Node.HTTP2.CreateSecureServer
import Node.HTTP2.CreateServer
import Node.HTTP2.Http2Server
import Node.HTTP2.Type
import public Node.Net.CreateServer
import public Node.TLS.CreateServer
import public Node.TLS.CreateSecureContext

%foreign "node:lambda: (http2, netServerOptions, serverOptions) => http2.createServer({...netServerOptions, ...serverOptions})"
ffi_createServer : HTTP2 -> Node Net.CreateServer.Options -> Node HTTP2.CreateServer.Options -> PrimIO Http2Server

export
(.createServer) : HasIO io => HTTP2 -> Net.CreateServer.Options -> HTTP2.CreateServer.Options -> io Http2Server
(.createServer) http2 netServerOptions serverOptions = primIO $ ffi_createServer http2 (convertOptions netServerOptions) (convertOptions serverOptions)

%foreign """
  node:lambda:
  (http2, netServerOptions, tlsServerOptions, tlsContextOptions, secureServerOptions) =>
    http2.createSecureServer({
      ...netServerOptions,
      ...tlsServerOptions,
      ...tlsContextOptions,
      ...secureServerOptions
    })
  """
ffi_createSecureServer : HTTP2 -> Node Net.CreateServer.Options -> Node TLS.CreateServer.Options -> Node TLS.CreateSecureContext.Options -> Node HTTP2.CreateSecureServer.Options -> PrimIO Http2Server

export
(.createSecureServer) : HasIO io => HTTP2 -> Net.CreateServer.Options -> TLS.CreateServer.Options -> TLS.CreateSecureContext.Options -> HTTP2.CreateSecureServer.Options -> io Http2Server
(.createSecureServer) http2 netServerOptions tlsServerOptions tlsContextOptions secureServerOptions = primIO $ ffi_createSecureServer http2 (convertOptions netServerOptions) (convertOptions tlsServerOptions) (convertOptions tlsContextOptions) (convertOptions secureServerOptions)

%foreign "node:lambda: (http2, authority, connectOptions) => http2.connect(authority, connectOptions)"
ffi_connect : HTTP2 -> String -> Node Connect.Options -> PrimIO ClientHttp2Session

export
(.connect) : HTTP2 -> String -> Connect.Options -> IO ClientHttp2Session
(.connect) http2 authority connectOptions = primIO $ ffi_connect http2 authority $ convertOptions connectOptions

