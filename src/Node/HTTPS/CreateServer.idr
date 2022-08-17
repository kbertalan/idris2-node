module Node.HTTPS.CreateServer

import Node
import Node.HTTP.CreateServer as HTTP
import Node.Internal.Support
import public Node.Net.CreateServer as Net
import public Node.TLS.CreateServer as TLS
import public Node.TLS.CreateSecureContext as SecureContext

public export
Options : Type
Options = HTTP.Options

public export
defaultOptions : HTTPS.CreateServer.Options
defaultOptions = HTTP.defaultOptions

namespace Command

  public export
  record Options where
    constructor MkOptions
    server: HTTPS.CreateServer.Options
    context: SecureContext.Options
    tls: TLS.Options
    net: Net.Options

  export
  defaultOptions : HTTPS.CreateServer.Command.Options
  defaultOptions = MkOptions
    { server = HTTPS.CreateServer.defaultOptions
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
    Node HTTPS.CreateServer.Options
    -> Node SecureContext.Options
    -> Node TLS.Options
    -> Node Net.Options
    -> Node HTTPS.CreateServer.Command.Options

  export
  convertOptions : HTTPS.CreateServer.Command.Options -> Node HTTPS.CreateServer.Command.Options
  convertOptions o = ffi_convertOptions
    (convertOptions o.server)
    (convertOptions o.context)
    (convertOptions o.tls)
    (convertOptions o.net)

