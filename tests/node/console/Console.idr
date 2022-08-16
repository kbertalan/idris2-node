module Console

import Data.Buffer.Ext
import Data.String
import Node.Console

%foreign "node:lambda: () => ({ a: 1, b: 2 })"
ffi_object : AnyPtr

%foreign "node:lambda: () => [1, '2', 3.4]"
ffi_array : AnyPtr

main : IO ()
main = do
  console.log "something"
  console.log ffi_object
  console.log ffi_array

