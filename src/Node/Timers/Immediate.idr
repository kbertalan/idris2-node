module Node.Timers.Immediate

import Node.Internal.Support

export
data Immediate : Type where [external]

export
%foreign "node:lambda: (i) => i.hasRef() ? _true() : _false()"
(.hasRef) : Immediate -> Bool

%foreign "node:lambda: (i) => i.ref()"
ffi_ref : Immediate -> PrimIO Immediate

export
(.ref) : HasIO io => Immediate -> io Immediate
(.ref) immediate = primIO $ ffi_ref immediate

%foreign "node:lambda: (i) => i.unref()"
ffi_unref : Immediate -> PrimIO Immediate

export
(.unref) : HasIO io => Immediate -> io Immediate
(.unref) immediate = primIO $ ffi_unref immediate

