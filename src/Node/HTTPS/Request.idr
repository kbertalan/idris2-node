module Node.HTTPS.Request

import Node
import public Node.HTTP.Headers
import public Node.HTTP.Request
import public Node.Net.Socket.Connect
import public Node.Net.Socket.Type
import public Node.TLS.Connect
import public Node.TLS.CreateSecureContext

namespace Command

  public export
  record Options (t : SocketType) where
    constructor MkOptions
    request: Node.HTTP.Request.Options Headers
    tls: Node.TLS.Connect.Options
    context: Node.TLS.CreateSecureContext.Options
    socket: Maybe $ Node.Net.Socket.Connect.options t

  export
  defaultOptions : {auto t : SocketType} -> HTTPS.Request.Command.Options t
  defaultOptions = MkOptions
    { request = { protocol := "https:" } defaultOptions
    , tls  = defaultOptions
    , context = defaultOptions
    , socket = Nothing
    }

  %foreign """
    node:lambda:
    ( ty
    , request
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
    -> (socket: Maybe AnyPtr)
    -> Node $ Node.HTTPS.Request.Command.Options t

  export
  convertOptions : (t : SocketType) -> Node.HTTPS.Request.Command.Options t -> Node $ Node.HTTPS.Request.Command.Options t
  convertOptions t o = ffi_convertOptions
    (convertOptions o.request)
    (convertOptions o.tls)
    (convertOptions o.context)
    (believe_me $ convertOptions t <$> o.socket)

