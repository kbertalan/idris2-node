module Node.Console

import public Node.Console.Console
import public Node.Console.Static
import public Node.Console.Type

%foreign "node:lambda: () => require('console')"
ffi_require : PrimIO ConsoleModule

export
require : HasIO io => io ConsoleModule
require = primIO $ ffi_require

export
%foreign "node:lambda: () => console"
console : Console

