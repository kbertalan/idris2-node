module Node.Console.Static

import Node.Console.Console
import Node.Console.Type
import Node.Stream.Writeable

%foreign "node:lambda: (console, opts) => new console.Console(opts)"
ffi_newConsole : ConsoleModule -> Console.NodeOptions -> PrimIO Console

(.newConsole) : Writeable d e out
  => Writeable d e err
  => HasIO io
  => ConsoleModule
  -> Console.Options out err
  -> io Console
(.newConsole) mod opts = primIO $ ffi_newConsole mod $ convertOptions opts

