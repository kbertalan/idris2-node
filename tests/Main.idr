module Main

import Test.Golden

node : TestPool
node = MkTestPool "Node tests" [] (Just Node)
  [ "node/console"
  , "node/fs"
  , "node/http"
  , "node/http2"
  , "node/https"
  , "node/net/socket"
  ]

js : TestPool
js = MkTestPool "JS tests" [] (Just Node)
  [ "node/js/uri" ]

ext : TestPool
ext = MkTestPool "Extensions" [] Nothing [ "ext/buffer" ]

main : IO ()
main = runner [ node, js, ext ]
