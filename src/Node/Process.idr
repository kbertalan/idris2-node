module Node.Process

import public Node.Process.Static
import public Node.Process.Module

%foreign "node:lambda: () => require('process')"
ffi_require : PrimIO ProcessModule

export
require : HasIO io => io ProcessModule
require = primIO ffi_require

