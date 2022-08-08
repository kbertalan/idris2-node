module Node.HTTP2.CreateSecureServer

import Data.Maybe
import Node.HTTP2.CreateServer
import Node.HTTP2.Type

%hide Node.HTTP2.CreateServer.Options
%hide Node.HTTP2.CreateServer.NodeOptions

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
defaultOptions : Options
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

export
data NodeOptions : Type where [external]

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
  ) => ({
    allowHTTP1: allowHTTP1 != 0,
    maxDeflateDynamicTableSize,
    maxSettings,
    maxSessionMemory,
    maxHeaderListPairs,
    maxOutstandingPings,
    maxSendHeaderBlockLength: maxSendHeaderBlockLength != -1 ? maxSendHeaderBlockLength : undefined,
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
  (allowHTTP1: Int) ->
  (maxDeflateDynamicTableSize: Int) ->
  (maxSettings: Int) ->
  (maxSessionMemory: Int) ->
  (maxHeaderListPairs: Int) ->
  (maxOutstandingPings: Int) ->
  (maxSendHeaderBlockLength: Int) ->
  (paddingStrategy: NodePaddingStrategy) ->
  (peerMaxConcurrentStreams: Int) ->
  (maxSessionInvalidFrames: Int) ->
  (maxSessionRejectedStreams: Int) ->
  (settings: NodeSettings) ->
  (origins: List String) ->
  (unknownProtocolTimeout: Int) ->
  NodeOptions

export
convertOptions : {auto http2 : HTTP2} -> Options -> NodeOptions
convertOptions o = ffi_convertOptions
  (if o.allowHTTP1 then 1 else 0)
  o.maxDeflateDynamicTableSize
  o.maxSettings
  o.maxSessionMemory
  o.maxHeaderListPairs
  o.maxOutstandingPings
  (fromMaybe (-1) o.maxSendHeaderBlockLength)
  (convertPaddingStrategy o.paddingStrategy)
  o.peerMaxConcurrentStreams
  o.maxSessionInvalidFrames
  o.maxSessionRejectedStreams
  (convertSettings o.settings)
  o.origins
  o.unknownProtocolTimeout

