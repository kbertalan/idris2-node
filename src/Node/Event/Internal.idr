module Node.Event.Internal

export
on0 : HasIO io => (a -> PrimIO () -> PrimIO ()) -> a -> IO () -> io ()
on0 fn a cb = primIO $ fn a $ toPrim cb

export
on1 : HasIO io => (a -> (e -> PrimIO ()) -> PrimIO ()) -> a -> (e -> IO ()) -> io ()
on1 fn a cb = primIO $ fn a $ \e => toPrim $ cb e

public export
nodeOn0 : String -> String
nodeOn0 event = "node:lambda: (tya, a, callback) => a.on('\{event}', callback)"

public export
nodeOn1 : String -> String
nodeOn1 event = "node:lambda: (tya, tyb, a, callback) => a.on('\{event}', b => callback(b)())"

