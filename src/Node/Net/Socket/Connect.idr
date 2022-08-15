module Node.Net.Socket.Connect

import Node.Internal.Support

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
data Options
  = TCP TCPOptions
  | IPC IPCOptions

export
defaultTCPOptions : (port : Int) -> Options
defaultTCPOptions port = TCP $ MkTCPOptons
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
defaultIPCOptions : (path : String) -> Options
defaultIPCOptions path = IPC $ MkIPCOptions
  { path = path }

export
data NodeOptions : Type where [external]

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
  -> NodeOptions

%foreign """
  node:lambda:
  ( path
  ) => ({
    path
  })
  """
ffi_convertIPCOptions :
  (path: String)
  -> NodeOptions

export
convertOptions : Options -> NodeOptions
convertOptions = \case
  TCP o => ffi_convertTCPOptions
    o.port
    o.host
    o.localAddress
    o.localPort
    (familyAsInt o.family)
    o.noDelay
    o.keepAlive
    o.keepAliveInitialDelay
  IPC o => ffi_convertIPCOptions
    o.path

