module Node.HTTP.ServerResponse

import Data.Buffer
import public Node.Error
import public Node.HTTP.Headers
import public Node.Stream

export
data ServerResponse : Type where [external]

public export
implementation Writeable Buffer NodeError ServerResponse where

%foreign "node:lambda: (res, status, headers) => res.writeHead(status, headers)"
ffi_writeHead : ServerResponse -> Int -> Headers -> PrimIO ()

export
(.writeHead) : HasIO io => ServerResponse -> Int -> Headers -> io ()
(.writeHead) res status headers = primIO $ ffi_writeHead res status headers

