module Node.Timers.Static

import Node.Timers.Immediate
import Node.Timers.Timeout

%foreign "node:lambda: (cb) => setImmediate(cb)"
ffi_setImmediate : PrimIO () -> PrimIO Immediate

export
setImmediate : HasIO io => IO () -> io Immediate
setImmediate cb = primIO $ ffi_setImmediate $ toPrim cb

%foreign "node:lambda: (cb, delay) => setInterval(cb, delay)"
ffi_setInterval : PrimIO () -> Int -> PrimIO Timeout

export
setInterval : HasIO io => IO () -> Int -> io Timeout
setInterval cb delay = primIO $ ffi_setInterval (toPrim cb) delay

%foreign "node:lambda: (cb, delay) => setTimeout(cb, delay)"
ffi_setTimeout : PrimIO () -> Int -> PrimIO Timeout

export
setTimeout : HasIO io => IO () -> Int -> io Timeout
setTimeout cb delay = primIO $ ffi_setTimeout (toPrim cb) delay

%foreign "node:lambda: (immediate) => clearImmediate(immediate)"
ffi_clearImmediate : Immediate -> PrimIO ()

export
clearImmediate : HasIO io => Immediate -> io ()
clearImmediate immediate = primIO $ ffi_clearImmediate immediate

%foreign "node:lambda: (timeout) => clearInterval(timeout)"
ffi_clearInterval : Timeout -> PrimIO ()

export
clearInterval : HasIO io => Timeout -> io ()
clearInterval timeout = primIO $ ffi_clearInterval timeout

%foreign "node:lambda: (timeout) => clearTimeout(timeout)"
ffi_clearTimeout : Timeout -> PrimIO ()

export
clearTimeout : HasIO io => Timeout -> io ()
clearTimeout timeout = primIO $ ffi_clearTimeout timeout

