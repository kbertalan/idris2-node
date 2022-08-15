module Node.TLS.CreateSecureContext

import Data.Buffer.Ext

public export
record Options where
  constructor MkOptions
  ca: List String
  cert: List String
  sigalgs: List String
  ciphers: Maybe String
  clientCertEngine: Maybe String
  crl: List String
  dhparam: Maybe String
  ecdhCurve: Maybe String
  honorCipherOrder: Maybe Bool
  key: List String
  privateKeyEngine: Maybe String
  privateKeyIdentifier: Maybe String
  maxVersion: Maybe String
  minVersion: Maybe String
  passphrase: Maybe String
  pfx: List String
  secureOptions: Maybe Int
  secureProtocol: Maybe String
  sessionIdContext: Maybe String
  ticketKeys: Maybe Buffer
  sessionTimeout: Int

export
defaultOptions : Options
defaultOptions = MkOptions
  { ca = []
  , cert = []
  , sigalgs = []
  , ciphers = Nothing
  , clientCertEngine = Nothing
  , crl = []
  , dhparam = Nothing
  , ecdhCurve = Nothing
  , honorCipherOrder = Nothing
  , key = []
  , privateKeyEngine = Nothing
  , privateKeyIdentifier = Nothing
  , maxVersion = Nothing
  , minVersion = Nothing
  , passphrase = Nothing
  , pfx = []
  , secureOptions = Nothing
  , secureProtocol = Nothing
  , sessionIdContext = Nothing
  , ticketKeys = Nothing
  , sessionTimeout = 300
  }

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( ca
  , cert
  , sigalgs
  , ciphers
  , clientCertEngine
  , crl
  , dhparam
  , ecdhCurve
  , honorCipherOrder
  , key
  , privateKeyEngine
  , privateKeyIdentifier
  , maxVersion
  , minVersion
  , passphrase
  , pfx
  , secureOptions
  , secureProtocol
  , sessionIdContext
  , ticketKeys
  , sessionTimeout
  ) => {
    const maybe = ({h, a1}) => h === undefined ? a1 : undefined
    const bool = (b) => b === undefined ? undefined : b != 0
    const opts = {
      ca: __prim_idris2js_array(ca),
      cert: __prim_idris2js_array(cert),
      sigalgs: sigalgs.length > 0 ? __prim_idris2js_array(sigalgs).join(',') : undefined,
      ciphers: maybe(ciphers),
      clientCertEngine: maybe(clientCertEngine),
      crl: __prim_idris2js_array(crl),
      dhparam: maybe(dhparam),
      ecdhCurve: maybe(ecdhCurve),
      honorCipherOrder: bool(maybe(honorCipherOrder)),
      key: __prim_idris2js_array(key),
      privateKeyEngine: maybe(privateKeyEngine),
      privateKeyIdentifier: maybe(privateKeyIdentifier),
      maxVersion: maybe(maxVersion),
      minVersion: maybe(minVersion),
      passphrase: maybe(passphrase),
      pfx: __prim_idris2js_array(pfx),
      secureOptions: maybe(secureOptions),
      secureProtocol: maybe(secureProtocol),
      sessionIdContext: maybe(sessionIdContext),
      ticketKeys: maybe(ticketKeys),
      sessionTimeout
    }
    Object.keys(opts).forEach(key => opts[key] === undefined && delete opts[key])
    return opts
  }
  """
ffi_convertOptions:
  (ca: List String) ->
  (cert: List String) ->
  (sigalgs: List String) ->
  (ciphers: Maybe String) ->
  (clientCertEngine: Maybe String) ->
  (crl: List String) ->
  (dhparam: Maybe String) ->
  (ecdhCurve: Maybe String) ->
  (honorCipherOrder: Maybe Bool) ->
  (key: List String) ->
  (privateKeyEngine: Maybe String) ->
  (privateKeyIdentifier: Maybe String) ->
  (maxVersion: Maybe String) ->
  (minVersion: Maybe String) ->
  (passphrase: Maybe String) ->
  (pfx: List String) ->
  (secureOptions: Maybe Int) ->
  (secureProtocol: Maybe String) ->
  (sessionIdContext: Maybe String) ->
  (ticketKeys: Maybe Buffer) ->
  (sessionTimeout: Int) ->
  NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions o = ffi_convertOptions
  o.ca
  o.cert
  o.sigalgs
  o.ciphers
  o.clientCertEngine
  o.crl
  o.dhparam
  o.ecdhCurve
  o.honorCipherOrder
  o.key
  o.privateKeyEngine
  o.privateKeyIdentifier
  o.maxVersion
  o.minVersion
  o.passphrase
  o.pfx
  o.secureOptions
  o.secureProtocol
  o.sessionIdContext
  o.ticketKeys
  o.sessionTimeout

