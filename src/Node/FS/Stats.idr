module Node.FS.Stats

import Node.FS.Type
import Node.Error

public export
data StatsReturnType
  = StatsBigInt
  | StatsInt

public export
statsReturnType : StatsReturnType -> Type
statsReturnType StatsBigInt = Integer
statsReturnType StatsInt = Int

export
data Stats : StatsReturnType -> Type where [external]

%foreign "node:lambda: (ty, s)=>s.isBlockDevice()"
ffi_isBlockDevice : Stats r -> Int

export
(.isBlockDevice) : Stats r -> Bool
(.isBlockDevice) stats = 0 /= ffi_isBlockDevice stats

%foreign "node:lambda: (ty,s)=>s.isCharacterDevice() ? 1 : 0"
ffi_isCharacterDevice : Stats r -> Int

export
(.isCharacterDevice) : Stats r -> Bool
(.isCharacterDevice) stats = 0 /= ffi_isCharacterDevice stats

%foreign "node:lambda: (ty,s)=>s.isDirectory() ? 1 : 0"
ffi_isDirectory : Stats r -> Int

export
(.isDirectory) : Stats r -> Bool
(.isDirectory) stats = 0 /= ffi_isDirectory stats

%foreign "node:lambda: (ty,s)=>s.isFIFO() ? 1 : 0"
ffi_isFIFO : Stats r -> Int

export
(.isFIFO) : Stats r -> Bool
(.isFIFO) stats = 0 /= ffi_isFIFO stats

%foreign "node:lambda: (ty,s)=>s.isFile() ? 1 : 0"
ffi_isFile : Stats r -> Int

export
(.isFile) : Stats r -> Bool
(.isFile) stats = 0 /= ffi_isFile stats

%foreign "node:lambda: (ty,s)=>s.isSocket() ? 1 : 0"
ffi_isSocket : Stats r -> Int

export
(.isSocket) : Stats r -> Bool
(.isSocket) stats = 0 /= ffi_isSocket stats

%foreign "node:lambda: (ty,s)=>s.isSymbolicLink() ? 1 : 0"
ffi_isSymbolicLink : Stats r -> Int

export
(.isSymbolicLink) : Stats r -> Bool
(.isSymbolicLink) stats = 0 /= ffi_isSymbolicLink stats

%foreign "node:lambda: (rty,aty,s)=>s.size"
ffi_size : Stats r -> a

export
size : Stats r -> statsReturnType r
size stats = ffi_size stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.dev"
ffi_dev : Stats r -> a

export
dev : Stats r -> statsReturnType r
dev stats = ffi_dev stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.ino"
ffi_ino : Stats r -> a

export
ino : Stats r -> statsReturnType r
ino stats = ffi_ino stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.mode"
ffi_mode : Stats r -> a

export
mode : Stats r -> statsReturnType r
mode stats = ffi_mode stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.nlink"
ffi_nlink : Stats r -> a

export
nlink : Stats r -> statsReturnType r
nlink stats = ffi_nlink stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.uid"
ffi_uid : Stats r -> a

export
uid : Stats r -> statsReturnType r
uid stats = ffi_uid stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.gid"
ffi_gid : Stats r -> a

export
gid : Stats r -> statsReturnType r
gid stats = ffi_gid stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.rdev"
ffi_rdev : Stats r -> a

export
rdev : Stats r -> statsReturnType r
rdev stats = ffi_rdev stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.blksize"
ffi_blksize : Stats r -> a

export
blksize : Stats r -> statsReturnType r
blksize stats = ffi_blksize stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.blocks"
ffi_blocks : Stats r -> a

export
blocks : Stats r -> statsReturnType r
blocks stats = ffi_blocks stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.atimeMs"
ffi_atimeMs : Stats r -> a

export
atimeMs : Stats r -> statsReturnType r
atimeMs stats = ffi_atimeMs stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.ctimeMs"
ffi_ctimeMs : Stats r -> a

%foreign "node:lambda: (rty,aty,s)=>s.mtimeMs"
ffi_mtimeMs : Stats r -> a

export
mtimeMs : Stats r -> statsReturnType r
mtimeMs stats = ffi_mtimeMs stats { a = statsReturnType r }

export
ctimeMs : Stats r -> statsReturnType r
ctimeMs stats = ffi_ctimeMs stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.birthtimeMs"
ffi_birthtimeMs : Stats r -> a

export
birthtimeMs : Stats r -> statsReturnType r
birthtimeMs stats = ffi_birthtimeMs stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.atimeNs"
ffi_atimeNs : Stats r -> a

export
atimeNs : Stats r -> statsReturnType r
atimeNs stats = ffi_atimeNs stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.mtimeNs"
ffi_mtimeNs : Stats r -> a

export
mtimeNs : Stats r -> statsReturnType r
mtimeNs stats = ffi_mtimeNs stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.ctimeNs"
ffi_ctimeNs : Stats r -> a

export
ctimeNs : Stats r -> statsReturnType r
ctimeNs stats = ffi_ctimeNs stats { a = statsReturnType r }

%foreign "node:lambda: (rty,aty,s)=>s.birthtimeNs"
ffi_birthtimeNs : Stats r -> a

export
birthtimeNs : Stats r -> statsReturnType r
birthtimeNs stats = ffi_birthtimeNs stats { a = statsReturnType r }

{-
Missing implementations for:
- atime
- mtime
- ctime
- birthtime
-}
