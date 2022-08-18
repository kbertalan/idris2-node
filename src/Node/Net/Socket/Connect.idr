module Node.Net.Socket.Connect

import Node
import Node.Internal.Support
import Node.Net.Socket.Type

public export
data IpAddressFamily
  = IPv4
  | IPv6
  | Both

export
familyAsInt : IpAddressFamily -> Int
familyAsInt = \case
  IPv4 => 4
  IPv6 => 6
  Both => 0

public export
record TCPOptions where
  constructor MkTCPOptons
  port: Int
  host: Maybe String
  localAddress: Maybe String
  localPort: Maybe Int
  family: IpAddressFamily
  -- TODO: hints
  -- TODO: lookup
  noDelay: Bool
  keepAlive: Bool
  keepAliveInitialDelay: Int

public export
record IPCOptions where
  constructor MkIPCOptions
  path: String

public export
options : SocketType -> Type
options TCP = TCPOptions
options IPC = IPCOptions

export
defaultTCPOptions : (port : Int) -> options TCP
defaultTCPOptions port = MkTCPOptons
  { port = port
  , host = Nothing
  , localAddress = Nothing
  , localPort = Nothing
  , family = Both
  , noDelay = False
  , keepAlive = False
  , keepAliveInitialDelay = 0
  }

export
defaultIPCOptions : (path : String) -> options IPC
defaultIPCOptions path = MkIPCOptions
  { path = path }

%foreign """
  node:lambda:
  ( port
  , host
  , localAddress
  , localPort
  , family
  , noDelay
  , keepAlive
  , keepAliveInitialDelay
  ) => _keepDefined({
    port,
    host: _maybe(host),
    localAddress: _maybe(localAddress),
    localPort: _maybe(localPort),
    family,
    noDelay,
    keepAlive,
    keepAliveInitialDelay
  })
  """
ffi_convertTCPOptions :
  (port: Int)
  -> (host: Maybe String)
  -> (localAddress: Maybe String)
  -> (localPort: Maybe Int)
  -> (family: Int)
  -> (noDelay: Bool)
  -> (keepAlive: Bool)
  -> (keepAliveInitialDelay: Int)
  -> Node $ options TCP

%foreign """
  node:lambda:
  ( path
  ) => ({
    path
  })
  """
ffi_convertIPCOptions :
  (path: String)
  -> Node $ options IPC

export
convertOptions : (t : SocketType) -> options t -> Node $ options t
convertOptions TCP o = ffi_convertTCPOptions
    o.port
    o.host
    o.localAddress
    o.localPort
    (familyAsInt o.family)
    o.noDelay
    o.keepAlive
    o.keepAliveInitialDelay
convertOptions IPC o = ffi_convertIPCOptions o.path

