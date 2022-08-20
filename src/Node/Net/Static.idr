module Node.Net.Static

import Node
import Node.Net.Type
import Node.Net.Socket

%foreign "node:lambda: (ty, net, opts) => new net.Socket(opts)"
ffi_newSocket : NetModule -> Node Socket.Options -> PrimIO $ Socket t

export
(.newSocket) : HasIO io => NetModule -> Socket.Options -> io $ Socket t
(.newSocket) net opts = primIO $ ffi_newSocket net $ convertOptions opts

