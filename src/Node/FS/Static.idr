module Node.FS.Static

import Node.Error
import Node.FS.ReadStream
import Node.FS.Stats
import Node.FS.Type

%foreign "node:lambda: (fs,path)=>fs.createReadStream(path)"
ffi_createReadStream : FS -> String -> PrimIO ReadStream

export
createReadStream : HasIO io => { auto fs : FS } -> String -> io ReadStream
createReadStream path = primIO $ ffi_createReadStream fs path

%foreign """
  node:lambda:
  (fs,rty,path) => {
    try {
      const result = fs.statSync(path, {
        bigint: rty.h == 0,
        throwIfNoEntry: true
      });

      return {
        h: 1, // Right
        a1: result
      };
    } catch(e) {
      return {
        h: 0, // Left
        a1: e
      };
    }
  }
  """
ffi_stat_sync : FS -> (r: StatsReturnType) -> String -> PrimIO (Either NodeError $ Stats r)

export
stat_sync : HasIO io => {auto fs : FS} -> (r : StatsReturnType) -> String -> io (Either NodeError $ Stats r)
stat_sync r path = primIO $ ffi_stat_sync fs r path

%foreign """
  node:lambda:
  (fs,rty,path,cb) => {
    fs.stat(path, {
      bigint: rty.h == 0
    }, function(err, value) {
      cb() (
        err
        ? {
            h: 0, // Left
            a1: err
          }
        : {
            h: 1, // Right
            a1: value
          }
      ) 
    })
  }
  """
ffi_stat : FS -> (r: StatsReturnType) -> String -> (Either NodeError (Stats r) -> PrimIO()) -> PrimIO ()

export
stat : HasIO io => {auto fs : FS} -> (r: StatsReturnType) -> String -> (Either NodeError (Stats r) -> IO ()) -> io ()
stat r path cb = primIO $ ffi_stat fs r path $ \either => toPrim $ cb either

