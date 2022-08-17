module HTTPS

import Data.Buffer.Ext
import Node.HTTPS
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
  https <- HTTPS.require
  let opts = { context.key := [key]
             , context.cert := [cert]
             } defaultOptions
  server <- https.createServer opts
  server.listen $ { port := Just port } Listen.defaultOptions
  server.onRequest $ \req, res => do
    putStrLn "server processing request"
    headers <- empty
    res.writeHead 200 headers
    res.write (fromString "\{req.url}\n") Nothing
    req.onData $ \d => res.write d Nothing
    req.onClose $ res.end Nothing

  let allowInsecure = { tls.rejectUnauthorized := False } defaultOptions

  req <- https.post "https://localhost:\{show port}/something" allowInsecure $ \res => do
    putStrLn "HTTPS POST:"
    res.onData $ putStrLn . show
    res.onClose server.close

  req.write "this is the body from the client side request" Nothing
  req.end Nothing

  pure ()
