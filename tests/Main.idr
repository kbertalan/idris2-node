module Main

import Test.Golden

node : TestPool
node = MkTestPool "Node tests" [] (Just Node)
  [ "node/uri"
  , "node/fs"
  , "node/http"
  , "node/https"
  ]

ext : TestPool
ext = MkTestPool "Extensions" [] Nothing [ "ext/buffer" ]

main : IO ()
main = runner [ node, ext ]
