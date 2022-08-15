module Node.FS.Static

import Node.Error
import Node.FS.ReadStream
import Node.FS.Stats
import Node.FS.Type
import Node.Internal.Support

%foreign "node:lambda: (fs,path)=>fs.createReadStream(path)"
ffi_createReadStream : FS -> String -> PrimIO ReadStream

export
(.createReadStream) : HasIO io => (fs : FS) -> String -> io ReadStream
(.createReadStream) fs path = primIO $ ffi_createReadStream fs path

%foreign """
  node:lambda:
  (fs,rty,bigint,path) => {
    try {
      const result = fs.statSync(path, {
        bigint,
        throwIfNoEntry: true
      });

      return _right(result);
    } catch(e) {
      return _left(e);
    }
  }
  """
ffi_statSync : FS -> {r: StatsReturnType} -> (bigint : Bool) -> String -> PrimIO (Either NodeError $ Stats r)

export
(.statSync) : HasIO io => (fs : FS) -> (r : StatsReturnType) -> String -> io (Either NodeError $ Stats r)
(.statSync) fs r path = primIO $ ffi_statSync fs (isBigInt r) path

%foreign """
  node:lambda:
  (fs,rty,bigint,path,cb) => {
    fs.stat(
      path,
      { bigint },
      (err, value) => cb()(err ? _left(err) : _right(value))
    )
  }
  """
ffi_stat : FS -> {r: StatsReturnType} -> (bigint : Bool) -> String -> (Either NodeError (Stats r) -> PrimIO()) -> PrimIO ()

export
(.stat) : HasIO io => (fs : FS) -> (r: StatsReturnType) -> String -> (Either NodeError (Stats r) -> IO ()) -> io ()
(.stat) fs r path cb = primIO $ ffi_stat fs (isBigInt r) path $ \either => toPrim $ cb either

