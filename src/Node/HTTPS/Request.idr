module Node.HTTPS.Request

import Node
import public Node.HTTP.Headers
import public Node.HTTP.Request
import public Node.Net.Socket.Connect
import public Node.TLS.Connect
import public Node.TLS.CreateSecureContext

namespace Command

  public export
  record Options where
    constructor MkOptions
    request: Node.HTTP.Request.Options Headers
    tls: Node.TLS.Connect.Options
    context: Node.TLS.CreateSecureContext.Options
    socket: Maybe Node.Net.Socket.Connect.Options

  export
  defaultOptions : HTTPS.Request.Command.Options
  defaultOptions = MkOptions
    { request = { protocol := "https:" } defaultOptions
    , tls  = defaultOptions
    , context = defaultOptions
    , socket = Nothing
    }

  %foreign """
    node:lambda:
    ( request
    , tls
    , context
    , socket
    ) => _keepDefined({
      ..._maybe(socket),
      ...context,
      ...tls,
      ...request
    })
    """
  ffi_convertOptions:
    (request: Node $ Node.HTTP.Request.Options Headers)
    -> (tls: Node Node.TLS.Connect.Options)
    -> (context: Node Node.TLS.CreateSecureContext.Options)
    -> (socket: Maybe (Node Node.Net.Socket.Connect.Options))
    -> Node Node.HTTPS.Request.Command.Options

  export
  convertOptions : Node.HTTPS.Request.Command.Options -> Node Node.HTTPS.Request.Command.Options
  convertOptions o = ffi_convertOptions
    (convertOptions o.request)
    (convertOptions o.tls)
    (convertOptions o.context)
    (convertOptions <$> o.socket)

