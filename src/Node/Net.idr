module Node.Net

import public Node.Net.CreateServer
import public Node.Net.Server
import public Node.Net.Socket
import public Node.Net.Static
import public Node.Net.Type

%foreign "node:lambda: () => require('net')"
ffi_require : PrimIO NetModule

export
require : HasIO io => io NetModule
require = primIO $ ffi_require

