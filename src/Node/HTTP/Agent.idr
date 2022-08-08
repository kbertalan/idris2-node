module Node.HTTP.Agent

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

data NodeAgentOptions : Type where [external]

%foreign """
  node:lambda:
  (
    keepAlive
    keepAliveMsecs
    maxSockets
    maxTotalSockets
    maxFreeSockets
    scheduling
  ) => ({
    keepAlive: keepAlive != 0,
    keepAliveMsecs,
    maxSockets,
    maxTotalSockets,
    maxFreeSockets,
    scheduling
  })
  """
ffi_nodeAgentOptions :
  (keepAlive : Int) ->
  (keepAliveMsecs : Int) ->
  (maxSockets : Int) ->
  (maxTotalSockets : Int) ->
  (maxFreeSockets : Int) ->
  (scheduling : String) ->
  NodeAgentOptions

%foreign "node:lambda: (options) => new Agent(options)"
ffi_newAgent : NodeAgentOptions -> Agent

export
newAgent : AgentOptions -> Agent
newAgent opts = ffi_newAgent $ ffi_nodeAgentOptions
  (if opts.keepAlive then 1 else 0)
  opts.keepAliveMsecs
  opts.maxSockets
  opts.maxTotalSockets
  opts.maxFreeSockets
  (show opts.scheduling)

