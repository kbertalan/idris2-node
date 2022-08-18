module Node.Internal.Support

%export "javascript:_maybe"
%foreign """
  javascript:lambda:
  ({h, a1}) => h === undefined ? a1 : undefined
  """
maybe : Maybe a -> AnyPtr

%export "javascript:_just"
%foreign """
  javascript:lambda:
  (a) => ({a1:a})
  """
just : a -> Maybe a

%export "javascript:_nothing"
%foreign """
  javascript:lambda:
  () => ({h:0})
  """
nothing : () -> Maybe a

%export "javascript:_bool"
%foreign """
  javascript:lambda:
  (b) => b != 0
  """
bool : Bool -> AnyPtr

%export "javascript:_maybeBool"
%foreign """
  javascript:lambda:
  (b) => b !== undefined ? b != 0 : undefined
  """
maybeBool : AnyPtr -> AnyPtr

%export "javascript:_true"
%foreign """
  javascript:lambda:
  () => 1
  """
true : () -> Bool

%export "javascript:_false"
%foreign """
  javascript:lambda:
  () => 0
  """
false : () -> Bool

%export "javascript:_left"
%foreign """
  javascript:lambda:
  (a) => ({h:0,a1:a})
  """
left : a -> Either a b

%export "javascript:_right"
%foreign """
  javascript:lambda:
  (a) => ({h:1,a1:a})
  """
right : a -> Either b a

%export "javascript:_keepDefined"
%foreign """
  javascript:lambda:
  (o) => {
    const obj = {...o}
    Object.keys(obj).forEach(key => obj[key] === undefined && delete obj[key])
    return obj
  }
  """
keepDefined : AnyPtr -> AnyPtr

