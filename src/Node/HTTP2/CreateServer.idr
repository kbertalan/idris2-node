module Node.HTTP2.CreateServer

import Node.HTTP2.Type

public export
data PaddingStrategy
  = None
  | Max
  | Aligned

export
data NodePaddingStrategy : Type where [external]

%foreign "node:lambda: (http2) => http2.constants.PADDING_STRATEGY_NONE"
ffi_paddingStrategy_None : {auto http2 : HTTP2} -> NodePaddingStrategy

%foreign "node:lambda: (http2) => http2.constants.PADDING_STRATEGY_MAX"
ffi_paddingStrategy_Max : {auto http2 : HTTP2} -> NodePaddingStrategy

%foreign "node:lambda: (http2) => http2.constants.PADDING_STRATEGY_ALIGNED"
ffi_paddingStrategy_Aligned : {auto http2 : HTTP2} -> NodePaddingStrategy

export
convertPaddingStrategy : {auto http2 : HTTP2} -> PaddingStrategy -> NodePaddingStrategy
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

export
data NodeSettings : Type where [external]

%foreign """
  node:lambda:
  ( headerTableSize
  , enablePush
  , initialWindowSize
  , maxFrameSize
  , maxConcurrentStreams
  , maxHeaderListSize
  , enableConnectProtocol
  ) => {
    const bool = (b) => b != 0
    const settings = {
      headerTableSize,
      enablePush: bool(enablePush) && undefined, // -- TODO check why value true not accepted and causing HTTP2 session errrors?
      initialWindowSize,
      maxFrameSize,
      maxConcurrentStreams,
      maxHeaderListSize,
      enableConnectProtocol: bool(enableConnectProtocol)
    }
    return settings
  }
  """
ffi_convertSettings :
  (headerTableSize: Int) ->
  (enablePush: Bool) ->
  (initialWindowSize: Int) ->
  (maxFrameSize: Int) ->
  (maxConcurrentStreams: Double) ->
  (maxHeaderListSize: Int) ->
  (enableConnectProtocol: Bool) ->
  NodeSettings

export
convertSettings : Settings -> NodeSettings
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
defaultOptions : Options
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

export
data NodeOptions : Type where [external]

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
  ) => {
    const maybe = ({h, a1}) => h === undefined ? a1 : undefined
    const opts = {
      maxDeflateDynamicTableSize,
      maxSettings,
      maxSessionMemory,
      maxHeaderListPairs,
      maxOutstandingPings,
      maxSendHeaderBlockLength: maybe(maxSendHeaderBlockLength),
      paddingStrategy,
      peerMaxConcurrentStreams,
      maxSessionInvalidFrames,
      maxSessionRejectedStreams,
      settings,
      unknownProtocolTimeout
    }
    return opts
  }
  """
ffi_convertOptions :
  (maxDeflateDynamicTableSize: Int) ->
  (maxSettings: Int) ->
  (maxSessionMemory: Int) ->
  (maxHeaderListPairs: Int) ->
  (maxOutstandingPings: Int) ->
  (maxSendHeaderBlockLength: Maybe Int) ->
  (paddingStrategy: NodePaddingStrategy) ->
  (peerMaxConcurrentStreams: Int) ->
  (maxSessionInvalidFrames: Int ) ->
  (maxSessionRejectedStreams: Int) ->
  (settings: NodeSettings) ->
  (unknownProtocolTimeout: Int) ->
  NodeOptions

export
convertOptions : {auto http2 : HTTP2} -> Options -> NodeOptions
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

