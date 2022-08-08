module Node.HTTPS.CreateServer

import Node.HTTP.CreateServer as HTTP

public export
Options : Type
Options = HTTP.Options

public export
defaultOptions : HTTPS.CreateServer.Options
defaultOptions = HTTP.defaultOptions

