module Node.TLS.CreateServer

import Data.Buffer.Ext

public export
record Options where
  constructor MkOptions
  -- ALPNProtocols: TODO
  clientCertEngine: Maybe String
  enableTrace: Bool
  handshakeTimeout: Int
  rejectUnauthorized: Bool
  requestCert: Bool
  sessionTimeout: Int
  -- SNICallback(servername, callback): TODO
  ticketKeys: Maybe Buffer
  -- pskCallback: TODO
  pskIdentityHint: Maybe String

export
defaultOptions : Options
defaultOptions = MkOptions
  { clientCertEngine = Nothing
  , enableTrace = False
  , handshakeTimeout = 120000
  , rejectUnauthorized = True
  , requestCert = False
  , sessionTimeout = 300
  , ticketKeys = Nothing
  , pskIdentityHint = Nothing
  }

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( clientCertEngine
  , enableTrace
  , handshakeTimeout
  , rejectUnauthorized
  , requestCert
  , sessionTimeout
  , ticketKeys
  , pskIdentityHint
  ) => {
    const maybe = ({h, a1}) => h === undefined ? a1 : undefined
    const bool = (b) => b != 0
    const opts = {
      clientCertEngine: maybe(clientCertEngine),
      enableTrace: bool(enableTrace),
      handshakeTimeout,
      rejectUnauthorized: bool(rejectUnauthorized),
      requestCert: bool(requestCert),
      sessionTimeout,
      ticketKeys: maybe(ticketKeys),
      pskIdentityHint: maybe(pskIdentityHint)
    }
    Object.keys(opts).forEach(key => opts[key] === undefined && delete opts[key])
    return opts
  }
  """
ffi_convertOptions : 
  (clientCertEngine: Maybe String) ->
  (enableTrace: Bool) ->
  (handshakeTimeout: Int) ->
  (rejectUnauthorized: Bool) ->
  (requestCert: Bool) ->
  (sessionTimeout: Int) ->
  (ticketKeys: Maybe Buffer) ->
  (pskIdentityHint: Maybe String) ->
  NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions o = ffi_convertOptions
  o.clientCertEngine
  o.enableTrace
  o.handshakeTimeout
  o.rejectUnauthorized
  o.requestCert
  o.sessionTimeout
  o.ticketKeys
  o.pskIdentityHint
