module Node.Process

import public Node.Process.Static
import public Node.Process.Type

%foreign "node:lambda: () => require('process')"
ffi_require : PrimIO Process

export
require : HasIO io => io Process
require = primIO ffi_require

