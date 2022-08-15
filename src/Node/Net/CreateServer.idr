module Node.Net.CreateServer

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
  ) => {
    const bool = (b) => b != 0
    return {
      allowHalfOpen: bool(allowHalfOpen),
      pauseOnConnect: bool(pauseOnConnect),
      noDelay: bool(noDelay),
      keepAlive: bool(keepAlive),
      keepAliveInitialDelay
    }
  }
  """
ffi_convertOptions :
  (allowHalfOpen : Bool) ->
  (pauseOnConnect : Bool) ->
  (noDelay : Bool) ->
  (keepAlive : Bool) ->
  (keepAliveInitialDelay : Int) ->
  CreateServer.NodeOptions

export
convertOptions : CreateServer.Options -> CreateServer.NodeOptions
convertOptions o = ffi_convertOptions
  o.allowHalfOpen
  o.pauseOnConnect
  o.noDelay
  o.keepAlive
  o.keepAliveInitialDelay

