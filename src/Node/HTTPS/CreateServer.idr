module Node.HTTPS.CreateServer

import Node
import Node.HTTP.CreateServer as HTTP
import Node.Internal.Support
import Node.Net.CreateServer as Net
import Node.TLS.CreateServer as TLS
import Node.TLS.CreateSecureContext as SecureContext

public export
ServerOptions : Type
ServerOptions = HTTP.Options

public export
defaultServerOptions : HTTPS.CreateServer.ServerOptions
defaultServerOptions = HTTP.defaultOptions

public export
record Options where
  constructor MkOptions
  server: ServerOptions
  context: SecureContext.Options
  tls: TLS.Options
  net: Net.Options

export
defaultOptions : HTTPS.CreateServer.Options
defaultOptions = MkOptions
  { server = defaultServerOptions
  , context = defaultOptions
  , tls = defaultOptions
  , net = defaultOptions
  }

%foreign """
  node:lambda:
  ( server
  , secure
  , tls
  , net
  ) => ({
    ...net,
    ...tls,
    ...secure,
    ...server
  })
  """
ffi_convertOptions :
  Node ServerOptions
  -> Node SecureContext.Options
  -> Node TLS.Options
  -> Node Net.Options
  -> Node HTTPS.CreateServer.Options

export
convertOptions : HTTPS.CreateServer.Options -> Node HTTPS.CreateServer.Options
convertOptions o = ffi_convertOptions
  (convertOptions o.server)
  (convertOptions o.context)
  (convertOptions o.tls)
  (convertOptions o.net)

