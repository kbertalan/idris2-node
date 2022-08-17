module Node.TLS.CreateServer

import Node
import Data.Buffer.Ext
import Node.Internal.Support

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
  ) => _keepDefined({
    clientCertEngine: _maybe(clientCertEngine),
    enableTrace: _bool(enableTrace),
    handshakeTimeout,
    rejectUnauthorized: _bool(rejectUnauthorized),
    requestCert: _bool(requestCert),
    sessionTimeout,
    ticketKeys: _maybe(ticketKeys),
    pskIdentityHint: _maybe(pskIdentityHint)
  })
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
  Node Options

export
convertOptions : Options -> Node Options
convertOptions o = ffi_convertOptions
  o.clientCertEngine
  o.enableTrace
  o.handshakeTimeout
  o.rejectUnauthorized
  o.requestCert
  o.sessionTimeout
  o.ticketKeys
  o.pskIdentityHint
