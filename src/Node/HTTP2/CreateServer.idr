module Node.HTTP2.CreateServer

import Node
import Node.HTTP2.Module
import Node.Internal.Support
import public Node.Net.CreateServer

public export
data PaddingStrategy
  = None
  | Max
  | Aligned

%foreign "node:lambda: (http2) => http2.constants.PADDING_STRATEGY_NONE"
ffi_paddingStrategy_None : {auto http : HTTP2Module} -> Node PaddingStrategy

%foreign "node:lambda: (http2) => http2.constants.PADDING_STRATEGY_MAX"
ffi_paddingStrategy_Max : {auto http : HTTP2Module} -> Node PaddingStrategy

%foreign "node:lambda: (http2) => http2.constants.PADDING_STRATEGY_ALIGNED"
ffi_paddingStrategy_Aligned : {auto http : HTTP2Module} -> Node PaddingStrategy

export
convertPaddingStrategy : {auto http : HTTP2Module} -> PaddingStrategy -> Node PaddingStrategy
convertPaddingStrategy = \case
  None => ffi_paddingStrategy_None
  Max => ffi_paddingStrategy_Max
  Aligned => ffi_paddingStrategy_Aligned

public export
record Settings where
  constructor MkSettings
  headerTableSize: Int
  enablePush: Bool
  initialWindowSize: Int
  maxFrameSize: Int
  maxConcurrentStreams: Double
  maxHeaderListSize: Int
  enableConnectProtocol: Bool

export
defaultSettings : Settings
defaultSettings = MkSettings
  { headerTableSize = 4096
  , enablePush = True
  , initialWindowSize = 65535
  , maxFrameSize = 16384
  , maxConcurrentStreams = 4294967295.0
  , maxHeaderListSize = 65535
  , enableConnectProtocol = False
  }

%foreign """
  node:lambda:
  ( headerTableSize
  , enablePush
  , initialWindowSize
  , maxFrameSize
  , maxConcurrentStreams
  , maxHeaderListSize
  , enableConnectProtocol
  ) => _keepDefined({
    headerTableSize,
    enablePush: _bool(enablePush) && undefined, // -- TODO check why value true not accepted and causing HTTP2 session errrors?
    initialWindowSize,
    maxFrameSize,
    maxConcurrentStreams,
    maxHeaderListSize,
    enableConnectProtocol: _bool(enableConnectProtocol)
  })
  """
ffi_convertSettings :
  (headerTableSize: Int) ->
  (enablePush: Bool) ->
  (initialWindowSize: Int) ->
  (maxFrameSize: Int) ->
  (maxConcurrentStreams: Double) ->
  (maxHeaderListSize: Int) ->
  (enableConnectProtocol: Bool) ->
  Node Settings

export
convertSettings : Settings -> Node Settings
convertSettings s = ffi_convertSettings
  s.headerTableSize
  s.enablePush
  s.initialWindowSize
  s.maxFrameSize
  s.maxConcurrentStreams
  s.maxHeaderListSize
  s.enableConnectProtocol

public export
record Options where
  constructor MkOptions
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
  unknownProtocolTimeout: Int

export
defaultOptions : HTTP2.CreateServer.Options
defaultOptions = MkOptions
  { maxDeflateDynamicTableSize = 4096
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
  , unknownProtocolTimeout = 10000
  }

%foreign """
  node:lambda:
  ( maxDeflateDynamicTableSize
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
  , unknownProtocolTimeout
  ) => _keepDefined({
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
    unknownProtocolTimeout
  })
  """
ffi_convertOptions :
  (maxDeflateDynamicTableSize: Int) ->
  (maxSettings: Int) ->
  (maxSessionMemory: Int) ->
  (maxHeaderListPairs: Int) ->
  (maxOutstandingPings: Int) ->
  (maxSendHeaderBlockLength: Maybe Int) ->
  (paddingStrategy: Node PaddingStrategy) ->
  (peerMaxConcurrentStreams: Int) ->
  (maxSessionInvalidFrames: Int ) ->
  (maxSessionRejectedStreams: Int) ->
  (settings: Node Settings) ->
  (unknownProtocolTimeout: Int) ->
  Node HTTP2.CreateServer.Options

export
convertOptions : {auto http : HTTP2Module} -> HTTP2.CreateServer.Options -> Node HTTP2.CreateServer.Options
convertOptions o = ffi_convertOptions
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
  o.unknownProtocolTimeout

namespace Command

  public export
  record Options where
    constructor MkOptions
    server: Node.HTTP2.CreateServer.Options
    net: Node.Net.CreateServer.Options

  export
  defaultOptions : Command.Options
  defaultOptions = MkOptions
    { server = defaultOptions
    , net = defaultOptions
    }

  %foreign "node:lambda: (server, net) => ({...net, ...server})"
  ffi_convertOptions :
    (server : Node HTTP2.CreateServer.Options)
    -> (net : Node Net.CreateServer.Options)
    -> Node Command.Options

  export
  convertOptions : {auto http : HTTP2Module} -> Command.Options -> Node Command.Options
  convertOptions o = Command.ffi_convertOptions
    (convertOptions o.server)
    (convertOptions o.net)

