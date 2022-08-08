module Node.HTTPS.Static

import Node.HTTP.CreateServer
import Node.HTTPS.CreateServer
import Node.HTTPS.Server
import Node.HTTPS.Type
import public Node.Net.CreateServer
import public Node.TLS.CreateSecureContext
import public Node.TLS.CreateServer

%foreign """
  node:lambda:
  (https, netServerOptions, tlsServerOptions, tlsContextOptions, secureServerOptions) =>
    https.createServer({
      ...netServerOptions,
      ...tlsServerOptions,
      ...tlsContextOptions,
      ...secureServerOptions
    })
  """
ffi_createServer : HTTPS -> Net.CreateServer.NodeOptions -> TLS.CreateServer.NodeOptions -> TLS.CreateSecureContext.NodeOptions -> Node.HTTP.CreateServer.NodeOptions -> PrimIO Server

export
(.createServer) : HasIO io => HTTPS -> Net.CreateServer.Options -> TLS.CreateServer.Options -> TLS.CreateSecureContext.Options -> HTTPS.CreateServer.Options -> io Server
(.createServer) https netServerOptions tlsServerOptions tlsContextOptions httpsOptions = primIO $ ffi_createServer https (convertOptions netServerOptions) (convertOptions tlsServerOptions) (convertOptions tlsContextOptions) (convertOptions httpsOptions)

