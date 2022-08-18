module Node.HTTP2.ClientHttp2Session

import Node.Error
import Node.Event.Internal
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

%foreign nodeOn2 "stream"
ffi_onStream : a -> (b -> c -> PrimIO ()) -> PrimIO ()

export
(.onStream) : HasIO io => ClientHttp2Session -> (ClientHttp2Stream -> Headers -> IO ()) -> io ()
(.onStream) = on2 ffi_onStream

%foreign nodeOn1 "error"
ffi_onError : a -> (b -> PrimIO ()) -> PrimIO ()

export
(.onError) : HasIO io => ClientHttp2Session -> (Error -> IO ()) -> io ()
(.onError) = on1 ffi_onError

