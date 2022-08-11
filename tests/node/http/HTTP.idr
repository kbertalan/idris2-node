module HTTP

import Data.Buffer.Ext
import Node.HTTP
import Node.Net.Server.Listen
import Promise

main : IO ()
main = do
  let port = 3000
  http <- HTTP.require
  server <- http.createServer defaultOptions
  server.listen $ { port := Just port } Listen.defaultOptions
  server.onRequest $ \req, res => do
    putStrLn "server processing request"
    headers <- empty
    res.writeHead 200 headers
    req.onData $ \d => res.write d Nothing
    req.onClose $ res.end Nothing

  req <- http.post "http://localhost:\{show port}/something" $ \res => do
    putStrLn "HTTP POST:"
    res.onData $ putStrLn . show
    res.onClose server.close

  req.write "this is the body from the client side request" Nothing
  req.end Nothing

  pure ()
