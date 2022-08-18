||| JSIO based on idris2-dom JSIO utilities, which is adjusted to this library.
module Node.JS.IO

import public Control.Monad.Either
import Node.Error
import Node.Internal.Support

public export
JSIO : Type -> Type
JSIO = EitherT Error IO

export %inline
runJSIO : JSIO a -> IO $ Either Error a
runJSIO = runEitherT

%foreign """
  javascript:lambda:
  (tya, cb) => {
    try {
      const result = cb()
      return _right(result)
    } catch(e) {
      if (e instanceof Error) {
        return _left(e)
      }
      return _left(new Error(e))
    }
  }
  """
ffi_catchIO : PrimIO a -> PrimIO $ Either Error a

export
catchIO : IO a -> JSIO a
catchIO cb = MkEitherT $ primIO $ ffi_catchIO $ toPrim cb

||| Support Javascript exception handling when lifting IO to JSIO
export
implementation [JS] HasIO JSIO where
  liftIO = catchIO

