module Node.Net.Static

import Node
import Node.Net.Type
import Node.Net.Socket

%foreign "node:lambda: (ty, net, opts) => new net.Socket(opts)"
ffi_newSocket : Node Socket.Options -> PrimIO $ Socket t

export
newSocket : HasIO io => Socket.Options -> io $ Socket t
newSocket opts = primIO $ ffi_newSocket $ convertOptions opts

