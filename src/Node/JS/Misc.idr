module Node.JS.Misc

import Node.Internal.Support

export
%foreign "node:lambda: (ty, o) => o ? _true() : _false()"
truthy : a -> Bool

