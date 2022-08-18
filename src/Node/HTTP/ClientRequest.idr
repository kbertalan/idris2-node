module Node.HTTP.ClientRequest

import public Data.Buffer
import public Node.Error
import public Node.Stream

export
data ClientRequest : Type where [external]

export
implementation WriteableClass Buffer NodeError ClientRequest where

