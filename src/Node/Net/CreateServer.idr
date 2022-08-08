module Node.Net.CreateServer

import Data.Maybe

public export
record Options where
  constructor MkOptions
  allowHalfOpen : Bool
  pauseOnConnect : Bool
  noDelay : Bool
  keepAlive : Bool
  keepAliveInitialDelay : Int

export
defaultOptions : CreateServer.Options
defaultOptions = MkOptions
  { allowHalfOpen = False
  , pauseOnConnect = False
  , noDelay = False
  , keepAlive = False
  , keepAliveInitialDelay = 0
  }

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( allowHalfOpen
  , pauseOnConnect
  , noDelay
  , keepAlive
  , keepAliveInitialDelay
  ) => ({
    allowHalfOpen: allowHalfOpen != 0,
    pauseOnConnect: pauseOnConnect != 0,
    noDelay: noDelay != 0,
    keepAlive: keepAlive != 0,
    keepAliveInitialDelay
  })
  """
ffi_convertOptions :
  (allowHalfOpen : Int) ->
  (pauseOnConnect : Int) ->
  (noDelay : Int) ->
  (keepAlive : Int) ->
  (keepAliveInitialDelay : Int) ->
  CreateServer.NodeOptions

export
convertOptions : CreateServer.Options -> CreateServer.NodeOptions
convertOptions o = ffi_convertOptions
  (if o.allowHalfOpen then 1 else 0)
  (if o.pauseOnConnect then 1 else 0)
  (if o.noDelay then 1 else 0)
  (if o.keepAlive then 1 else 0)
  o.keepAliveInitialDelay

