module Node.Net.Socket.Address

import Node

public export
record Address where
  constructor MkAddress
  port: Int
  family: String
  address: String

%foreign """
  node:lambda:
  (addr, ctor) => {
     const {port, family, address} = addr
     return _just(ctor(port, family, address))
  }
  """
ffi_fromNode : Node Address -> (Int -> String -> String -> Address) -> Address

export
fromNode : Node Address -> Address
fromNode a = ffi_fromNode a MkAddress

