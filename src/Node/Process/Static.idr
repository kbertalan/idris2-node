module Node.Process.Static

import Node.Error
import Node.Process.Type
import public Node.Stream

export
data StdErr : Type where [external]

public export
implementation Writeable d NodeError StdErr where

export
%foreign "node:lambda: (process) => process.stderr"
(.stderr) : Process -> StdErr

export
data StdIn : Type where [external]

public export
implementation Readable d NodeError StdIn where

export
%foreign "node:lambda: (process) => process.stdin"
(.stdin) : Process -> StdIn

export
data StdOut : Type where [external]

public export
implementation Writeable d NodeError StdOut where

export
%foreign "node:lambda: (process) => process.stdout"
(.stdout) : Process -> StdOut

