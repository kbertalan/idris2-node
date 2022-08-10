module FS

import Data.Buffer.Ext
import Data.String
import Node.FS
import Promise

printStream : Readable Buffer NodeError r => String -> r -> Promise () IO ()
printStream name stream = promise $ \resolve', reject' => do
  stream.onPause $ putStrLn "\{name} paused"
  stream.onResume $ putStrLn "\{name} resumed"
  stream.onClose $ do
    putStrLn "\{name} closed"
    resolve' ()
  stream.onData $ putStrLn . unlines . map ("\{name} data: " <+>) . lines . show
  stream.onEnd $ putStrLn "\{name} ended"
  stream.onError $ \err => do
    putStrLn "\{name} error: \{message err}"
    reject' ()
  stream.pause
  stream.resume

main : IO ()
main = do
  fs <- FS.require
  runPromise ignoreIt ignoreIt $ do
    fs.createReadStream "run" >>= printStream "run"
    fs.createReadStream "not-exists" >>= printStream "not-exists"
  where
    ignoreIt : a -> IO ()
    ignoreIt = const $ pure ()
