module HTTP2

import Data.Buffer.Ext
import Node.HTTP2
import Node.Net.Server.Listen
import Promise
import System.File

main : IO ()
main = do
  Right key <- readFile "./build/certs/key.pem"
    | Left e => putStrLn "could not read key file: \{show e}"

  Right cert <- readFile "./build/certs/cert.pem"
    | Left e => putStrLn "could not read cert file: \{show e}"

  let port = 3443
  http2 <- HTTP2.require
  let tls = { key := [key]
            , cert := [cert]
            } defaultOptions
  server <- http2.createSecureServer defaultOptions defaultOptions tls defaultOptions
  server.onStream $ \stream, headers => do
    putStrLn "server processing request"
    h <- empty
    h <- h.setHeader { io = IO } ":status" "200"
    stream.respond h
    stream.write (fromString "\{show $ headers.getHeader ":path"}\n") Nothing
    stream.onData $ \d => stream.write d Nothing
    (Readable.(.onEnd)) stream $ stream.end Nothing
  server.listen $ { port := Just port } Listen.defaultOptions

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

