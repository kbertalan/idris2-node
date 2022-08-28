module Socket

import Data.Buffer.Ext
import Data.String
import Node.HTTP
import Node.Net
import Node.Timers
import Promise

showAddress : Address -> String
showAddress a = "\{a.family} \{a.address}"

socketWithError : NetModule -> Promise () IO ()
socketWithError net = promise $ \resolve', reject' => do
  putStrLn "\n---socket with error:"
  socket <- net.newSocket defaultOptions { t = TCP }
  socket.timeout >>= putStrLn . show
  ignore $ socket.setTimeout $ Just 100
  socket.timeout >>= putStrLn . show
  socket.address >>= putStrLn . show . map showAddress
  socket.onClose $ \b => do
    putStrLn "socket closed: \{show b}"
    resolve' ()
  Socket.(.onError) socket $ \err => putStrLn err.message
  ignore $ socket.connect $ defaultTCPOptions 3000

socketWithSuccess : NetModule -> Promise () IO ()
socketWithSuccess net = promise $ \resolve', reject' => do
  putStrLn "\n---socket with success:"
  http <- HTTP.require
  server <- http.createServer defaultOptions
  let doListen = server.listen $ { port := Just 3000 } defaultOptions
  doListen
  server.onError $ \err => do
    if err.code == SystemError EADDRINUSE
      then ignore $ setTimeout (server.close >> doListen) 500
      else do
        putStrLn "could not start server: \{err.message}"
        reject' ()
  server.onRequest $ \req, res => do
    res.writeHead 200 =<< empty
    res.write "response" Nothing
    res.end Nothing

  server.onListening $ do
    socket <- net.newSocket defaultOptions { t = TCP }
    socket <- socket.connect $ defaultTCPOptions 3000
    socket.readyState >>= putStrLn . ("ready state: " <+>)
    socket.pending >>= putStrLn . ("pending: " <+>) . show
    socket.connecting >>= putStrLn . ("connecting: " <+>) . show
    socket.destroyed >>= putStrLn . ("destroyed: " <+>) . show
    socket.timeout >>= putStrLn . ("timeout: " <+>) . show
    socket.address >>= putStrLn . ("address: " <+>) . show . map showAddress
    socket.localAddress >>= putStrLn . ("local address: " <+>) . show
    socket.localPort >>= putStrLn . ("local port: " <+>) . show
    -- it seems if querying remote details, then it is memoized by nodejs and values will remain undefined forever
    -- socket.remoteAddress >>= putStrLn . ("remote address: " <+>) . show
    -- socket.remoteFamily >>= putStrLn . ("remote family: " <+>) . show
    -- socket.remotePort >>= putStrLn . ("remote port: " <+>) . show
    socket <- socket.setTimeout $ Just 100
    socket.onConnect $ do
      socket.readyState >>= putStrLn . ("ready state: " <+>)
      socket.pending >>= putStrLn . ("pending: " <+>) . show
      socket.connecting >>= putStrLn . ("connecting: " <+>) . show
      socket.destroyed >>= putStrLn . ("destroyed: " <+>) . show
      socket.timeout >>= putStrLn . ("timeout: " <+>) . show
      socket.address >>= putStrLn . ("address: " <+>) . show . map showAddress
      socket.remoteAddress >>= putStrLn . ("remote address: " <+>) . show
      socket.remoteFamily >>= putStrLn . ("remote family: " <+>) . show
      socket.remotePort >>= putStrLn . ("remote port: " <+>) . show
      socket.localAddress >>= putStrLn . ("local address: " <+>) . show
      -- socket.localPort >>= putStrLn . ("local port: " <+>) . show
      socket.write "GET / HTTP/1.1\n\n" Nothing
      socket.end Nothing { e = Error, d = Buffer }
      socket.bytesRead >>= putStrLn . ("bytes read: " <+>) . show
      socket.bytesWritten >>= putStrLn . ("bytes written: " <+>) . show
    socket.onData { e = Error, d = Buffer } $ \d =>
      let filtered = unlines $ map ("> " <+>) $ filter (not . isPrefixOf "Date: ") $ lines $ show d
      in putStrLn "data: \n\{filtered}"
    socket.onEnd { e = Error, d = Buffer } $ do
      putStrLn "end"
      socket.bytesRead >>= putStrLn . ("bytes read: " <+>) . show
      socket.bytesWritten >>= putStrLn . ("bytes written: " <+>) . show
    socket.onError $ \err => putStrLn "socket error: \{err.message}"
    socket.onClose $ \b => do
      putStrLn "socket closed: \{show b}"
      socket.readyState >>= putStrLn . ("ready state: " <+>)
      socket.destroyed >>= putStrLn . ("destroyed: " <+>) . show
      server.close

  server.onClose $ resolve' ()

  pure ()

main : IO ()
main = do
  net <- Net.require
  runPromise (const $ pure ()) (const $ pure ()) $ do
    socketWithError net
    socketWithSuccess net
