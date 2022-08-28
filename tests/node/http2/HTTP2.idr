module HTTP2

import Data.Buffer.Ext
import Node.HTTP2
import Node.JS.IO
import Node.Timers
import System.File

main : IO ()
main = do
  Right key <- readFile "./build/certs/key.pem"
    | Left e => putStrLn "could not read key file: \{show e}"

  Right cert <- readFile "./build/certs/cert.pem"
    | Left e => putStrLn "could not read cert file: \{show e}"

  Right _ <- runJSIO $ catchIO $ do
      let port = 3443
      http2 <- HTTP2.require
      let opts = { context.key := [key]
                 , context.cert := [cert]
                 } defaultOptions
      server <- http2.createSecureServer opts
      server.onStream $ \stream, headers => do
        putStrLn "server processing request"
        h <- empty
        h <- h.setHeader { io = IO } ":status" "200"
        stream.respond h
        stream.write (fromString "\{show $ headers.getHeader ":path"}\n") Nothing
        stream.onData $ \d => stream.write d Nothing
        (Readable.(.onEnd)) stream $ stream.end Nothing
      let listen' = server.listen $ { port := Just port } Listen.defaultOptions
      listen'
      server.onError $ \err =>
        if err.code == SystemError EADDRINUSE
          then ignore $ setTimeout (server.close >> listen') 500
          else putStrLn "could not start server: \{err.message}"

      server.onListening $ do
        let allowInsecure = { rejectUnauthorized := False } defaultOptions

        session <- http2.connect "https://localhost:\{show port}" allowInsecure
        stream <- session.post "/something" =<< empty
        stream.onResponse $ \headers => do
          putStrLn "HTTP2 POST:"
          onData stream $ putStrLn
          session.close
          server.close

        stream.write "this is the body from the client side request"
        stream.end
    | Left err => putStrLn "could not create server: \{err.message}"
  pure ()

