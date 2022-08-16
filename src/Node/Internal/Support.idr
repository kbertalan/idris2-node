module Node.Internal.Support

%nomangle "javascript:_maybe"
%foreign """
  javascript:lambda:
  ({h, a1}) => h === undefined ? a1 : undefined
  """
maybe : Maybe a -> AnyPtr

%nomangle "javascript:_just"
%foreign """
  javascript:lambda:
  (a) => ({a1:a})
  """
just : a -> Maybe a

%nomangle "javascript:_nothing"
%foreign """
  javascript:lambda:
  () => ({h:0})
  """
nothing : () -> Maybe a

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

%nomangle "javascript:_true"
%foreign """
  javascript:lambda:
  () => 1
  """
true : () -> Bool

%nomangle "javascript:_false"
%foreign """
  javascript:lambda:
  () => 0
  """
false : () -> Bool

%nomangle "javascript:_left"
%foreign """
  javascript:lambda:
  (a) => ({h:0,a1:a})
  """
left : a -> Either a b

%nomangle "javascript:_right"
%foreign """
  javascript:lambda:
  (a) => ({h:1,a1:a})
  """
right : a -> Either b a

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

