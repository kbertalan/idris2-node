module Node.HTTPS.Static

import Node.HTTP.CreateServer
import public Node.HTTP.ClientRequest
import Node.HTTPS.CreateServer
import public Node.HTTPS.Request
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

%foreign "node:lambda: (https, url, opts, cb) => https.get(url, opts, (res) => { cb(res)() })"
ffi_get : HTTPS -> String -> Node.HTTPS.Request.NodeOptions -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.get) : HasIO io => HTTPS -> String -> Node.HTTPS.Request.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.get) https url opts cb = primIO $ ffi_get https url (convertOptions opts) $ \res => toPrim $ cb res

%foreign "node:lambda: (https, url, opts, cb) => https.request(url, opts, (res) => { cb(res)() })"
ffi_request : HTTPS -> String -> Node.HTTPS.Request.NodeOptions -> (IncomingMessage -> PrimIO ()) -> PrimIO ClientRequest

export
(.request) : HasIO io => HTTPS -> String -> Node.HTTPS.Request.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.request) https url opts cb = primIO $ ffi_request https url (convertOptions opts) $ \res => toPrim $ cb res

export
(.post) : HasIO io => HTTPS -> String -> Node.HTTPS.Request.Options -> (IncomingMessage -> IO ()) -> io ClientRequest
(.post) https url opts cb = https.request url ({ requestOptions.method := "POST" } opts) cb

