module Node.HTTP2.ClientHttp2Session

import Node.Error
import Node.HTTP2.ClientHttp2Stream
import Node.HTTP2.Headers

export
data ClientHttp2Session : Type where [external]

%foreign """
  node:lambda:
  (session, method, path, headers) =>
    session.request({
      ...headers,
      ':method': method,
      ':path': path
    })
  """
ffi_request : ClientHttp2Session -> String -> String -> Headers -> PrimIO ClientHttp2Stream

export
(.get) : HasIO io => ClientHttp2Session -> String -> Headers -> io ClientHttp2Stream
(.get) session path headers = primIO $ ffi_request session "GET" path headers

export
(.post) : HasIO io => ClientHttp2Session -> String -> Headers -> io ClientHttp2Stream
(.post) session path headers = primIO $ ffi_request session "POST" path headers

%foreign "node:lambda: (session) => session.close()"
ffi_close : ClientHttp2Session -> PrimIO ()

export
(.close) : HasIO io => ClientHttp2Session -> io ()
(.close) session = primIO $ ffi_close session

%foreign """
  node:lambda:
  (session, handler) =>
    session.on('stream', (pushedStream, requestHeaders) => handler(pushedStream)(requestHeaders)())
  """
ffi_onStream : ClientHttp2Session -> (ClientHttp2Stream -> Headers -> PrimIO ()) -> PrimIO ()

export
(.onStream) : HasIO io => ClientHttp2Session -> (ClientHttp2Stream -> Headers -> IO ()) -> io ()
(.onStream) session handler = primIO $ ffi_onStream session $ \stream, headers => toPrim $ handler stream headers

%foreign "node:lambda: (session, error) => session.on('error', e => error(e)())"
ffi_onError : ClientHttp2Session -> (NodeError -> PrimIO ()) -> PrimIO ()

export
(.onError) : HasIO io => ClientHttp2Session -> (NodeError -> IO ()) -> io ()
(.onError) session cb = primIO $ ffi_onError session $ \e => toPrim $ cb e

