module Node.FS

import public Node.FS.ReadStream
import public Node.FS.Static
import public Node.FS.Stats
import public Node.FS.Type

%foreign "node:lambda: () => require('fs')"
ffi_require : PrimIO FS

export
require : HasIO io => io FS
require = primIO ffi_require

