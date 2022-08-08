module Node.Event.Internal

export
on0 : HasIO io => (a -> PrimIO () -> PrimIO ()) -> a -> IO () -> io ()
on0 fn a cb = primIO $ fn a $ toPrim cb

export
on1 : HasIO io => (a -> (e -> PrimIO ()) -> PrimIO ()) -> a -> (e -> IO ()) -> io ()
on1 fn a cb = primIO $ fn a $ \e => toPrim $ cb e

export
on2 : HasIO io => (a -> (b -> c -> PrimIO ()) -> PrimIO ()) -> a -> (b -> c -> IO ()) -> io ()
on2 fn a cb = primIO $ fn a $ \b, c => toPrim $ cb b c

public export
nodeOn0 : String -> String
nodeOn0 event = "node:lambda: (tya, a, callback) => a.on('\{event}', callback)"

public export
nodeOn1 : String -> String
nodeOn1 event = "node:lambda: (tya, tyb, a, callback) => a.on('\{event}', b => callback(b)())"

public export
nodeOn2 : String -> String
nodeOn2 event = "node:lambda: (tya, tyb, tyc, a, callback) => a.on('\{event}', (b, c) => callback(b)(c)())"

