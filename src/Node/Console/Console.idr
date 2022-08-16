module Node.Console.Console

import Data.Buffer
import Node.Error
import Node.Console.Type
import Node.Stream.Writeable

export
data Console : Type where [external]

public export
data ColorMode
  = True
  | False
  | Auto

data NodeColorMode : Type where [external]

%foreign "node:lambda: () => true"
ffi_colorMode_true : NodeColorMode

%foreign "node:lambda: () => false"
ffi_colorMode_false : NodeColorMode

%foreign "node:lambda: () => 'auto'"
ffi_colorMode_auto : NodeColorMode

convertColorMode : ColorMode -> NodeColorMode
convertColorMode = \case
  True => ffi_colorMode_true
  False => ffi_colorMode_false
  Auto => ffi_colorMode_auto

public export
record Options (out : Type) (err : Type) where
  constructor MkOptions
  stdout: out
  stderr: err
  ignoreErrors: Bool
  colorMode: ColorMode
  -- TODO: inspectOptions
  groupIndentation: Int

export
defaultOptions : Writeable Buffer NodeError out => Writeable Buffer NodeError err => out -> err -> Options out err
defaultOptions stdout stderr = MkOptions
  { stdout = stdout
  , stderr = stderr
  , ignoreErrors = True
  , colorMode = Auto
  , groupIndentation = 2
  }

export
data NodeOptions : Type where [external]

%foreign """
  node:lambda:
  ( tyo
  , tye
  , stdout
  , stderr
  , ignoreErrors
  , colorMode
  , groupIndentation
  ) => ({
    stdout,
    stderr,
    ignoreErrors,
    colorMode,
    groupIndentation
  })
  """
ffi_convertOptions :
  (stdout: out)
  -> (stderr: err)
  -> (ignoreErrors: Bool)
  -> (colorMode: NodeColorMode)
  -> (groupIndentation: Int)
  -> NodeOptions

export
convertOptions : Options out err -> NodeOptions
convertOptions o = ffi_convertOptions
  o.stdout
  o.stderr
  o.ignoreErrors
  (convertColorMode o.colorMode)
  o.groupIndentation

%foreign "node:lambda: (tya, c, a) => c.log(a)"
ffi_log : Console -> a -> PrimIO ()

export
(.log) : HasIO io => Console -> a -> io ()
(.log) c a = primIO $ ffi_log c a

%foreign "node:lambda: (tya, c, a) => c.debug(a)"
ffi_debug : Console -> a -> PrimIO ()

export
(.debug) : HasIO io => Console -> a -> io ()
(.debug) c a = primIO $ ffi_debug c a

%foreign "node:lambda: (tya, c, a) => c.error(a)"
ffi_error : Console -> a -> PrimIO ()

export
(.error) : HasIO io => Console -> a -> io ()
(.error) c a = primIO $ ffi_error c a

%foreign "node:lambda: (tya, c, a) => c.info(a)"
ffi_info : Console -> a -> PrimIO ()

export
(.info) : HasIO io => Console -> a -> io ()
(.info) c a = primIO $ ffi_info c a

%foreign "node:lambda: (tya, c, a) => c.trace(a)"
ffi_trace : Console -> a -> PrimIO ()

export
(.trace) : HasIO io => Console -> a -> io ()
(.trace) c a = primIO $ ffi_trace c a

%foreign "node:lambda: (tya, c, a) => c.warn(a)"
ffi_warn : Console -> a -> PrimIO ()

export
(.warn) : HasIO io => Console -> a -> io ()
(.warn) c a = primIO $ ffi_warn c a

