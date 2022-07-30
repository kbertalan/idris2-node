module Node

import Data.Buffer

%foreign "node:lambda: (ty, a) => JSON.stringify(a, null, 2)"
ffi_toJsonString : a -> String

export
toJsonString : a -> String
toJsonString a = ffi_toJsonString a


%foreign "node:lambda: (ty, a) => console.log(a)"
ffi_debugJsValue : a -> PrimIO ()

export
debugJsValue : HasIO io => a -> io ()
debugJsValue a = primIO $ ffi_debugJsValue a

%foreign "node:lambda: cb => setTimeout(() => cb(), 0)"
ffi_defer : PrimIO () -> PrimIO ()

export
defer : HasIO io => IO () -> io ()
defer action = primIO $ ffi_defer $ toPrim action

%foreign "node:lambda: (ty, o) => !!o ? 1 : 0"
ffi_exists : a -> Int

export
exists : a -> Bool
exists a = 0 /= ffi_exists a

