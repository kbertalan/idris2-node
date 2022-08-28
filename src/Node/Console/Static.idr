module Node.Console.Static

import public Data.Buffer
import Node
import public Node.Error
import Node.Console.Console
import Node.Console.Module
import public Node.Stream.Writeable

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

