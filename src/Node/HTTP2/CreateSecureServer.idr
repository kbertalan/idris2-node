module Node.HTTP2.CreateSecureServer

import Node
import Node.HTTP2.CreateServer
import Node.HTTP2.Module
import Node.Internal.Support
import public Node.Net.CreateServer
import public Node.TLS.CreateServer
import public Node.TLS.CreateSecureContext

public export
record Options where
  constructor MkOptions
  allowHTTP1: Bool
  maxDeflateDynamicTableSize: Int
  maxSettings: Int
  maxSessionMemory: Int
  maxHeaderListPairs: Int
  maxOutstandingPings: Int
  maxSendHeaderBlockLength: Maybe Int
  paddingStrategy: PaddingStrategy
  peerMaxConcurrentStreams: Int
  maxSessionInvalidFrames: Int
  maxSessionRejectedStreams: Int
  settings: Settings
  origins: List String
  unknownProtocolTimeout: Int

export
defaultOptions : CreateSecureServer.Options
defaultOptions = MkOptions
  { allowHTTP1 = False
  , maxDeflateDynamicTableSize = 4096
  , maxSettings = 32
  , maxSessionMemory = 10
  , maxHeaderListPairs = 128
  , maxOutstandingPings = 10
  , maxSendHeaderBlockLength = Nothing
  , paddingStrategy = None
  , peerMaxConcurrentStreams = 100
  , maxSessionInvalidFrames = 1000
  , maxSessionRejectedStreams = 100
  , settings = defaultSettings
  , origins = []
  , unknownProtocolTimeout = 10000
  }

%foreign """
  node:lambda:
  ( allowHTTP1
  , maxDeflateDynamicTableSize
  , maxSettings
  , maxSessionMemory
  , maxHeaderListPairs
  , maxOutstandingPings
  , maxSendHeaderBlockLength
  , paddingStrategy
  , peerMaxConcurrentStreams
  , maxSessionInvalidFrames
  , maxSessionRejectedStreams
  , settings
  , origins
  , unknownProtocolTimeout
  ) => _keepDefined({
    allowHTTP1: _bool(allowHTTP1),
    maxDeflateDynamicTableSize,
    maxSettings,
    maxSessionMemory,
    maxHeaderListPairs,
    maxOutstandingPings,
    maxSendHeaderBlockLength: _maybe(maxSendHeaderBlockLength),
    paddingStrategy,
    peerMaxConcurrentStreams,
    maxSessionInvalidFrames,
    maxSessionRejectedStreams,
    settings,
    origins: __prim_idris2js_array(origins),
    unknownProtocolTimeout
  })
  """
ffi_convertOptions :
  (allowHTTP1: Bool) ->
  (maxDeflateDynamicTableSize: Int) ->
  (maxSettings: Int) ->
  (maxSessionMemory: Int) ->
  (maxHeaderListPairs: Int) ->
  (maxOutstandingPings: Int) ->
  (maxSendHeaderBlockLength: Maybe Int) ->
  (paddingStrategy: Node PaddingStrategy) ->
  (peerMaxConcurrentStreams: Int) ->
  (maxSessionInvalidFrames: Int) ->
  (maxSessionRejectedStreams: Int) ->
  (settings: Node Settings) ->
  (origins: List String) ->
  (unknownProtocolTimeout: Int) ->
  Node CreateSecureServer.Options

export
convertOptions : {auto http : HTTP2Module} -> CreateSecureServer.Options -> Node CreateSecureServer.Options
convertOptions o = ffi_convertOptions
  o.allowHTTP1
  o.maxDeflateDynamicTableSize
  o.maxSettings
  o.maxSessionMemory
  o.maxHeaderListPairs
  o.maxOutstandingPings
  o.maxSendHeaderBlockLength
  (convertPaddingStrategy o.paddingStrategy)
  o.peerMaxConcurrentStreams
  o.maxSessionInvalidFrames
  o.maxSessionRejectedStreams
  (convertSettings o.settings)
  o.origins
  o.unknownProtocolTimeout

namespace Command

  public export
  record Options where
    constructor MkOptions
    server: HTTP2.CreateSecureServer.Options
    context: TLS.CreateSecureContext.Options
    tls: TLS.CreateServer.Options
    net: Net.CreateServer.Options

  export
  defaultOptions : HTTP2.CreateSecureServer.Command.Options
  defaultOptions = MkOptions
    { server = defaultOptions
    , context = defaultOptions
    , tls = defaultOptions
    , net = defaultOptions
    }

  %foreign """
    node:lambda:
    ( server
    , context
    , tls
    , net
    ) => ({
      ...net,
      ...tls,
      ...context,
      ...server
    })
    """
  ffi_convertOptions :
    (server : Node HTTP2.CreateSecureServer.Options)
    -> (context : Node TLS.CreateSecureContext.Options)
    -> (tls : Node TLS.CreateServer.Options)
    -> (net : Node Net.CreateServer.Options)
    -> Node CreateSecureServer.Command.Options

  export
  convertOptions : {auto http : HTTP2Module} -> HTTP2.CreateSecureServer.Command.Options -> Node HTTP2.CreateSecureServer.Command.Options
  convertOptions o = ffi_convertOptions
    (convertOptions o.server)
    (convertOptions o.context)
    (convertOptions o.tls)
    (convertOptions o.net)

