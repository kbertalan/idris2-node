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
import public Node.HTTP.Module

%foreign "node:lambda: () => require('http')"
ffi_require : PrimIO HTTPModule

export
require : HasIO io => io HTTPModule
require = primIO $ ffi_require

