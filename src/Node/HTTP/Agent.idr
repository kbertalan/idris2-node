module Node.HTTP.Agent

import Node
import Node.Internal.Support

export
data Agent : Type where [external]

public export
data Scheduling
  = FIFO
  | LIFO

export
implementation Show Scheduling where
  show = \case
    FIFO => "fifo"
    LIFO => "lifo"

public export
record Options where
  constructor MkOptions
  keepAlive : Bool
  keepAliveMsecs : Int
  maxSockets : Int
  maxTotalSockets : Int
  maxFreeSockets : Int
  scheduling : Scheduling
--  timeout : Int

export
defaultOptions : Options
defaultOptions = MkOptions
  { keepAlive = False
  , keepAliveMsecs = 1000
  , maxSockets = 65535
  , maxTotalSockets = 65535
  , maxFreeSockets = 256
  , scheduling = LIFO
  }

%foreign """
  node:lambda:
  (
    keepAlive
    keepAliveMsecs
    maxSockets
    maxTotalSockets
    maxFreeSockets
    scheduling
  ) => _keepDefined({
    keepAlive: _bool(keepAlive),
    keepAliveMsecs,
    maxSockets,
    maxTotalSockets,
    maxFreeSockets,
    scheduling
  })
  """
ffi_convertOptions :
  (keepAlive : Bool) ->
  (keepAliveMsecs : Int) ->
  (maxSockets : Int) ->
  (maxTotalSockets : Int) ->
  (maxFreeSockets : Int) ->
  (scheduling : String) ->
  Node Options

%foreign "node:lambda: (options) => new Agent(options)"
ffi_newAgent : Node Options -> Agent

export
newAgent : Options -> Agent
newAgent o = ffi_newAgent $ ffi_convertOptions
  o.keepAlive
  o.keepAliveMsecs
  o.maxSockets
  o.maxTotalSockets
  o.maxFreeSockets
  (show o.scheduling)

