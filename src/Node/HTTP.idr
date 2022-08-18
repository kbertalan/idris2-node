module Node.HTTP

import public Node.HTTP.Agent
import public Node.HTTP.ClientRequest
import public Node.HTTP.CreateServer
import public Node.HTTP.Headers
import public Node.HTTP.IncomingMessage
import public Node.HTTP.Request
import public Node.HTTP.Server
import public Node.HTTP.ServerResponse
import public Node.HTTP.Static
import public Node.HTTP.Type

%foreign "node:lambda: () => require('http')"
ffi_require : PrimIO HTTP

export
require : HasIO io => io HTTP
require = primIO $ ffi_require

