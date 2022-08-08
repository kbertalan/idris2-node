module Node.HTTPS

import public Node.HTTPS.CreateServer
import public Node.HTTPS.Server
import public Node.HTTPS.Static
import public Node.HTTPS.Type

%foreign "node:lambda: () => require('https')"
ffi_require : () -> PrimIO HTTPS

export
require : HasIO io => io HTTPS
require = primIO $ ffi_require ()

