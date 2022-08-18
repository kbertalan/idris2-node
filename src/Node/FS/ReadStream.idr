module Node.FS.ReadStream

import Data.Buffer
import public Node.Error
import public Node.Stream

export
data ReadStream : Type where [external]

export
implementation ReadableClass Buffer NodeError ReadStream where

