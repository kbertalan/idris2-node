module Node.HTTP2.Connect

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

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  (ca, rejectUnauthorized) => ({
    ca: ca || undefined,
    rejectUnauthorized: rejectUnauthorized != 0
  })
  """
ffi_nodeConnectOptions : String -> Bool -> NodeOptions

export
convertOptions : Connect.Options -> NodeOptions
convertOptions (MkOptions ca rejectUnauthorized)
  = ffi_nodeConnectOptions ca rejectUnauthorized

