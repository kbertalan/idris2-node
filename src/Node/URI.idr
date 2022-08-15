module Node.URI

import Node.Internal.Support

public export
data URIError = MkURIError String

export
%foreign """
  node:lambda:
  s => {
    try {
      const result = decodeURI(s);
      return _right(result)
    } catch(e) {
      return _left(e.message)
    }
  }
  """
decodeURI : String -> Either URIError String

export
%foreign """
  node:lambda:
  s => {
    try {
      const result = decodeURIComponent(s);
      return _right(result)
    } catch(e) {
      return _left(e.message)
    }
  }
  """
decodeURIComponent : String -> Either URIError String

export
%foreign """
  node:lambda:
  s => {
    try {
      const result = encodeURI(s);
      return _right(result)
    } catch(e) {
      return _left(e.message)
    }
  }
  """
encodeURI : String -> Either URIError String

export
%foreign """
  node:lambda:
  s => {
    try {
      const result = encodeURIComponent(s);
      return _right(result)
    } catch(e) {
      return _left(e.message)
    }
  }
  """
encodeURIComponent : String -> Either URIError String
