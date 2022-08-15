module Node.HTTPS.Request

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

export
data NodeOptions : Type where [external]

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
  (requestOptions: NodeRequestOptions)
  -> (tlsConnectOptions: Node.TLS.Connect.NodeOptions)
  -> (tlsCreateSecureContextOptions: Node.TLS.CreateSecureContext.NodeOptions)
  -> (socketConnectOptions: Maybe Node.Net.Socket.Connect.NodeOptions)
  -> Node.HTTPS.Request.NodeOptions

export
convertOptions : Node.HTTPS.Request.Options -> Node.HTTPS.Request.NodeOptions
convertOptions o = ffi_convertOptions
  (convertRequestOptions o.requestOptions)
  (convertOptions o.tlsConnectOptions)
  (convertOptions o.tlsCreateSecureContextOptions)
  (convertOptions <$> o.socketConnectOptions)

