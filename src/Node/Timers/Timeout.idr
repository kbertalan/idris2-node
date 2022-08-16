module Node.Timers.Timeout

import Node.Internal.Support

export
data Timeout : Type where [external]

export
%foreign "node:lambda: (t) => t.hasRef() ? _true() : _false()"
(.hasRef) : Timeout -> Bool

%foreign "node:lambda: (t) => t.ref()"
ffi_ref : Timeout -> PrimIO Timeout

export
(.ref) : HasIO io => Timeout -> io Timeout
(.ref) timeout = primIO $ ffi_ref timeout


%foreign "node:lambda: (t) => t.unref()"
ffi_unref : Timeout -> PrimIO Timeout

export
(.unref) : HasIO io => Timeout -> io Timeout
(.unref) timeout = primIO $ ffi_unref timeout

%foreign "node:lambda: (t) => t.refresh()"
ffi_refresh : Timeout -> PrimIO Timeout

export
(.refresh) : HasIO io => Timeout -> io Timeout
(.refresh) timeout = primIO $ ffi_refresh timeout

