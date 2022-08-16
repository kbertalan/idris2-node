module Node.JS.Std.JSON

export
%foreign "node:lambda: (ty, a, space) => JSON.stringify(a, null, space)"
stringify : a -> Int -> String

