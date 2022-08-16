module Node.Console.Console

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
defaultOptions : Writeable d e out => Writeable d e err => out -> err -> Options out err
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
  -> (colorMode: ColorMode)
  -> (groupIndentation: Int)
  -> NodeOptions

export
convertOptions : Options out err -> NodeOptions
convertOptions o = ffi_convertOptions
  o.stdout
  o.stderr
  o.ignoreErrors
  o.colorMode
  o.groupIndentation

%foreign """
  node:lambda:
  (tya, c, a) => c.log(a)
  """
ffi_log : Console -> a -> PrimIO ()

export
(.log) : HasIO io => Console -> a -> io ()
(.log) c a = primIO $ ffi_log c a

