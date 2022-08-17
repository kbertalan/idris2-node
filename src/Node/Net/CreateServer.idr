module Node.Net.CreateServer

import Node
import Node.Internal.Support

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

%foreign """
  node:lambda:
  ( allowHalfOpen
  , pauseOnConnect
  , noDelay
  , keepAlive
  , keepAliveInitialDelay
  ) => _keepDefined({
    allowHalfOpen: _bool(allowHalfOpen),
    pauseOnConnect: _bool(pauseOnConnect),
    noDelay: _bool(noDelay),
    keepAlive: _bool(keepAlive),
    keepAliveInitialDelay
  })
  """
ffi_convertOptions :
  (allowHalfOpen : Bool) ->
  (pauseOnConnect : Bool) ->
  (noDelay : Bool) ->
  (keepAlive : Bool) ->
  (keepAliveInitialDelay : Int) ->
  Node CreateServer.Options

export
convertOptions : CreateServer.Options -> Node CreateServer.Options
convertOptions o = ffi_convertOptions
  o.allowHalfOpen
  o.pauseOnConnect
  o.noDelay
  o.keepAlive
  o.keepAliveInitialDelay

