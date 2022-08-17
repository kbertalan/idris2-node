module Node.HTTP.Agent

import Node
import Node.Internal.Support

export
data Agent : Type where [external]

public export
data AgentScheduling
  = FIFO
  | LIFO

export
implementation Show AgentScheduling where
  show = \case
    FIFO => "fifo"
    LIFO => "lifo"

public export
record AgentOptions where
  constructor MkAgentOptions
  keepAlive : Bool
  keepAliveMsecs : Int
  maxSockets : Int
  maxTotalSockets : Int
  maxFreeSockets : Int
  scheduling : AgentScheduling
--  timeout : Int

export
defaultAgentOptions : AgentOptions
defaultAgentOptions = MkAgentOptions
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
ffi_nodeAgentOptions :
  (keepAlive : Bool) ->
  (keepAliveMsecs : Int) ->
  (maxSockets : Int) ->
  (maxTotalSockets : Int) ->
  (maxFreeSockets : Int) ->
  (scheduling : String) ->
  Node AgentOptions

%foreign "node:lambda: (options) => new Agent(options)"
ffi_newAgent : Node AgentOptions -> Agent

export
newAgent : AgentOptions -> Agent
newAgent o = ffi_newAgent $ ffi_nodeAgentOptions
  o.keepAlive
  o.keepAliveMsecs
  o.maxSockets
  o.maxTotalSockets
  o.maxFreeSockets
  (show o.scheduling)

