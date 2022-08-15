module Node.Internal.Support

%nomangle "javascript:_maybe"
%foreign """
  javascript:lambda:
  ({h, a1}) => h === undefined ? a1 : undefined
  """
maybe : Maybe a -> AnyPtr

%nomangle "javascript:_bool"
%foreign """
  javascript:lambda:
  (b) => b != 0
  """
bool : Bool -> AnyPtr

%nomangle "javascript:_maybeBool"
%foreign """
  javascript:lambda:
  (b) => b !== undefined ? b != 0 : undefined
  """
maybeBool : AnyPtr -> AnyPtr

%nomangle "javascript:_keepDefined"
%foreign """
  javascript:lambda:
  (o) => {
    const obj = {...o}
    Object.keys(obj).forEach(key => obj[key] === undefined && delete obj[key])
    return obj
  }
  """
keepDefined : AnyPtr -> AnyPtr

