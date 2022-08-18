module Node.Console.Static

import Data.Buffer
import Node
import Node.Error
import Node.Console.Console
import Node.Console.Type
import Node.Stream.Writeable

%foreign "node:lambda: (tyout, tyerr, console, opts) => new console.Console(opts)"
ffi_newConsole : ConsoleModule -> Node (Options out err) -> PrimIO Console

export
(.newConsole) : WriteableClass Buffer Error out
  => WriteableClass Buffer Error err
  => HasIO io
  => ConsoleModule
  -> Console.Options out err
  -> io Console
(.newConsole) mod opts = primIO $ ffi_newConsole mod $ convertOptions opts

