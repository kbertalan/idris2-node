module Node.Process.Static

import Node.Error
import Node.Internal.Elab
import Node.Process.Module
import public Node.Stream

%language ElabReflection

export
data StdErr : Type where [external]

public export
implementation WriteableClass d Error StdErr where

%runElab mkNodeField (field "stderr") "stderr" `(StdErr)

export
data StdIn : Type where [external]

public export
implementation ReadableClass d Error StdIn where

%runElab mkNodeField (field "stdin") "stdin" `(StdIn)

export
data StdOut : Type where [external]

public export
implementation WriteableClass d Error StdOut where

%runElab mkNodeField (field "stdout") "stdout" `(StdOut)

