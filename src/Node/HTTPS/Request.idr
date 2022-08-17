module Node.HTTPS.Request

import Node
import public Node.HTTP.Headers
import public Node.HTTP.Request
import public Node.Net.Socket.Connect
import public Node.TLS.Connect
import public Node.TLS.CreateSecureContext

public export
record Options where
  constructor MkOptions
  requestOptions: RequestOptions Headers
  tlsConnectOptions: Node.TLS.Connect.Options
  tlsCreateSecureContextOptions: Node.TLS.CreateSecureContext.Options
  socketConnectOptions: Maybe Node.Net.Socket.Connect.Options

export
defaultOptions : HTTPS.Request.Options
defaultOptions = MkOptions
  { requestOptions = { protocol := "https:" } defaultRequestOptions
  , tlsConnectOptions = defaultOptions
  , tlsCreateSecureContextOptions = defaultOptions
  , socketConnectOptions = Nothing
  }

%foreign """
  node:lambda:
  ( requestOptions
  , tlsConnectOptions
  , tlsCreateSecureContextOptions
  , socketConnectOptions
  ) => _keepDefined({
    ..._maybe(socketConnectOptions),
    ...tlsCreateSecureContextOptions,
    ...tlsConnectOptions,
    ...requestOptions
  })
  """
ffi_convertOptions:
  (requestOptions: Node $ RequestOptions Headers)
  -> (tlsConnectOptions: Node Node.TLS.Connect.Options)
  -> (tlsCreateSecureContextOptions: Node Node.TLS.CreateSecureContext.Options)
  -> (socketConnectOptions: Maybe (Node Node.Net.Socket.Connect.Options))
  -> Node Node.HTTPS.Request.Options

export
convertOptions : Node.HTTPS.Request.Options -> Node Node.HTTPS.Request.Options
convertOptions o = ffi_convertOptions
  (convertRequestOptions o.requestOptions)
  (convertOptions o.tlsConnectOptions)
  (convertOptions o.tlsCreateSecureContextOptions)
  (convertOptions <$> o.socketConnectOptions)

