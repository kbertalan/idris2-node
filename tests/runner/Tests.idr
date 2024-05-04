module Tests

import Test.Golden.RunnerHelper

main : IO ()
main = do
 goldenRunner
  [ "node" `atDir` "node"
  , "node/net" `atDir` "node/net"
  , "node/js" `atDir` "node/js"
  , "ext" `atDir` "ext"
  ]
