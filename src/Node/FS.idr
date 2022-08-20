module Node.FS

import public Node.FS.ReadStream
import public Node.FS.Static
import public Node.FS.Stats
import public Node.FS.Module

%foreign "node:lambda: () => require('fs')"
ffi_require : PrimIO FSModule

export
require : HasIO io => io FSModule
require = primIO ffi_require

