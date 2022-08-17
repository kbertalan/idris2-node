module Node.HTTP2.Connect

import Node

public export
record Options where
  constructor MkOptions
  ca : String
  rejectUnauthorized : Bool

export
defaultOptions : Options
defaultOptions = MkOptions
  { ca = ""
  , rejectUnauthorized = True
  }

%foreign """
  node:lambda:
  (ca, rejectUnauthorized) => ({
    ca: ca || undefined,
    rejectUnauthorized: rejectUnauthorized != 0
  })
  """
ffi_nodeConnectOptions : String -> Bool -> Node Options

export
convertOptions : Connect.Options -> Node Options
convertOptions (MkOptions ca rejectUnauthorized)
  = ffi_nodeConnectOptions ca rejectUnauthorized

