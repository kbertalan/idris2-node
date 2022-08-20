module Node.HTTPS

import public Node.HTTPS.CreateServer
import public Node.HTTPS.Server
import public Node.HTTPS.Static
import public Node.HTTPS.Module

%foreign "node:lambda: () => require('https')"
ffi_require : () -> PrimIO HTTPSModule

export
require : HasIO io => io HTTPSModule
require = primIO $ ffi_require ()

