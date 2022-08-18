module Node.HTTP2.ServerHttp2Stream

import Data.Buffer
import public Node.Error
import public Node.HTTP2.Headers
import public Node.Stream

export
data ServerHttp2Stream : Type where [external]

public export
implementation ReadableClass Buffer NodeError ServerHttp2Stream where

public export
implementation WriteableClass Buffer NodeError ServerHttp2Stream where

%foreign "node:lambda: (stream, headers) => stream.respond(headers)"
ffi_respond : ServerHttp2Stream -> Headers -> PrimIO ()

export
(.respond) : HasIO io => ServerHttp2Stream -> Headers -> io ()
(.respond) stream headers = primIO $ ffi_respond stream headers

%foreign "node:lambda: (stream) => stream.pushAllowed ? 1 : 0"
ffi_pushAllowed : ServerHttp2Stream -> Int

export
(.pushAllowed) : ServerHttp2Stream -> Bool
(.pushAllowed) stream = 0 /= ffi_pushAllowed stream

%foreign """
  node:lambda:
  (stream, headers, callback) => stream.pushStream(headers, (err, str, hs) => callback(err)(str)(hs)())
  """
ffi_pushStream : ServerHttp2Stream -> Headers -> (NodeError -> ServerHttp2Stream -> Headers -> PrimIO ()) -> PrimIO ()

export
(.pushStream) : HasIO io => ServerHttp2Stream -> Headers -> (NodeError -> ServerHttp2Stream -> Headers -> IO ()) -> io ()
(.pushStream) stream headers callback = primIO $ ffi_pushStream stream headers $ \err, str, hs => toPrim $ callback err str hs

