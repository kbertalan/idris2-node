module Node.HTTPS.Request

import public Node.HTTP.Headers
import public Node.HTTP.Request
import public Node.Net.Socket.Connect
import public Node.TLS.Connect
import public Node.TLS.CreateSecureContext

public export
record Options where
  constructor MkOptions
  requestOptions: Node.HTTP.Request.Options Headers
  tlsConnectOptions: Node.TLS.Connect.Options
  tlsCreateSecureContextOptions: Node.TLS.CreateSecureContext.Options
  socketConnectOptions: Maybe Node.Net.Socket.Connect.Options

export
defaultOptions : HTTPS.Request.Options
defaultOptions = MkOptions
  { requestOptions = { protocol := "https:" } defaultOptions
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
  ) => {
    const maybe = ({h, a1}) => h === undefined || undefined
    const opts = {
      ...maybe(socketConnectOptions),
      ...tlsCreateSecureContextOptions,
      ...tlsConnectOptions,
      ...requestOptions
    }
    return opts
  }
  """
ffi_convertOptions:
  (requestOptions: Node.HTTP.Request.NodeOptions)
  -> (tlsConnectOptions: Node.TLS.Connect.NodeOptions)
  -> (tlsCreateSecureContextOptions: Node.TLS.CreateSecureContext.NodeOptions)
  -> (socketConnectOptions: Maybe Node.Net.Socket.Connect.NodeOptions)
  -> Node.HTTPS.Request.NodeOptions

export
convertOptions : Node.HTTPS.Request.Options -> Node.HTTPS.Request.NodeOptions
convertOptions o = ffi_convertOptions
  (convertOptions o.requestOptions)
  (convertOptions o.tlsConnectOptions)
  (convertOptions o.tlsCreateSecureContextOptions)
  (convertOptions <$> o.socketConnectOptions)

