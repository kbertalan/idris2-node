module Node.FS.ReadStream

import Data.Buffer
import Node.Stream

export
data ReadStream : Type where [external]

export
implementation Readable Buffer ReadStream where

