module Node.Console.Static

import Data.Buffer
import Node.Error
import Node.Console.Console
import Node.Console.Type
import Node.Stream.Writeable

%foreign "node:lambda: (console, opts) => new console.Console(opts)"
ffi_newConsole : ConsoleModule -> Console.NodeOptions -> PrimIO Console

export
(.newConsole) : Writeable Buffer NodeError out
  => Writeable Buffer NodeError err
  => HasIO io
  => ConsoleModule
  -> Console.Options out err
  -> io Console
(.newConsole) mod opts = primIO $ ffi_newConsole mod $ convertOptions opts

