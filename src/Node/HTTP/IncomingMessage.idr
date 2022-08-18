module Node.HTTP.IncomingMessage

import public Data.Buffer
import public Node.Error
import Node.HTTP.Headers
import public Node.Stream

export
data IncomingMessage : Type where [external]

public export
implementation ReadableClass Buffer Error IncomingMessage where

export
%foreign "node:lambda: req => req.headers"
(.headers) : IncomingMessage -> Headers

export
%foreign "node:lambda: req => req.httpVersion"
(.httpVersion) : IncomingMessage -> String

export
%foreign "node:lambda: req => req.method"
(.method) : IncomingMessage -> String

export
%foreign "node:lambda: req => req.url"
(.url) : IncomingMessage -> String

export
%foreign "node:lambda: res => res.statusCode"
(.statusCode) : IncomingMessage -> Int

