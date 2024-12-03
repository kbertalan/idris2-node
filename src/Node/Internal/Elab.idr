module Node.Internal.Elab

import public Language.Reflection
import Node.Internal.Support

%language ElabReflection
%default total

export
field : String -> Name
field = UN . Field

export
basic : String -> Name
basic = UN . Basic

isVar : String -> TTImp -> Bool
isVar expected (IVar _ name) = hasName name
  where
    hasName : Name -> Bool
    hasName (UN $ Basic n) = n == expected
    hasName (UN $ Field n) = n == expected
    hasName (NS ns name) = hasName name
    hasName _ = False
isVar _ _ = False

isMaybe : TTImp -> (Bool, TTImp)
isMaybe (IApp _ name expr) = (isVar "Maybe" name, expr)
isMaybe x = (False, x)

fieldConvert : TTImp -> String -> String
fieldConvert tti var with (isMaybe tti)
  _ | (True, inner) with (isVar "Bool" inner)
    _ | True = """
      {
        const v = \{var}
        if (v === undefined || v === null) {
          return _nothing()
        }
        return _just(v ? _true() : _false())
      }
      """
    _ | False = """
      {
        const v = \{var}
        if (v === undefined || v === null) {
          return _nothing()
        }
        return _just(v)
      }
      """
  _ | (False, inner) with (isVar "Bool" inner)
    _ | True = "\{var} ? _true() : _false()"
    _ | False = var

export
nodeFieldDecl : (fnName : Name) -> (fieldName : String) -> (fieldType : TTImp) -> List Decl
nodeFieldDecl fnName fieldName fieldType = [ foreignDecl, fnDecl, fnDef ]
  where
    nodeCode : String
    nodeCode = "node:lambda: (tyx, x) => \{fieldConvert fieldType $ "x." <+> fieldName}"

    foreignFnOpt : FnOpt
    foreignFnOpt = ForeignFn [ IApp EmptyFC (IVar EmptyFC (UN $ Basic "fromString")) (IPrimVal EmptyFC $ Str nodeCode) ]

    foreignName : Name
    foreignName = basic "ffi_\{fieldName}"

    foreignDecl : Decl
    foreignDecl = IClaim $ NoFC $ MkIClaimData MW Private [foreignFnOpt]
                    $ MkTy EmptyFC (NoFC foreignName)
                    $ IPi EmptyFC MW ExplicitArg Nothing (IBindVar EmptyFC "a") fieldType

    fnDecl : Decl
    fnDecl = IClaim $ NoFC $ MkIClaimData MW Export []
               $ MkTy EmptyFC (NoFC fnName)
               $ IPi EmptyFC MW ExplicitArg Nothing (IBindVar EmptyFC "a") fieldType

    fnDef : Decl
    fnDef = IDef EmptyFC fnName
              [ PatClause EmptyFC
                  (IApp EmptyFC (IVar EmptyFC fnName) (IBindVar EmptyFC "a"))
                  (IApp EmptyFC (IVar EmptyFC foreignName) (IVar EmptyFC (basic "a")))
              ]

export
mkNodeField : (fnName : Name) -> (fieldName : String) -> (fieldType: TTImp) -> Elab ()
mkNodeField fnName fName fType = declare $ nodeFieldDecl fnName fName fType

export
nodeFieldIODecl : (fnName : Name) -> (fieldName : String) -> (fieldType : TTImp) -> List Decl
nodeFieldIODecl fnName fieldName fieldType = [ foreignDecl, fnDecl, fnDef ]
  where
    nodeCode : String
    nodeCode = "node:lambda: (tyx, x) => \{fieldConvert fieldType $ "x." <+> fieldName}"

    foreignFnOpt : FnOpt
    foreignFnOpt = ForeignFn [ IApp EmptyFC (IVar EmptyFC (UN $ Basic "fromString")) (IPrimVal EmptyFC $ Str nodeCode) ]

    foreignName : Name
    foreignName = basic "ffi_\{fieldName}"

    foreignDecl : Decl
    foreignDecl = IClaim $ NoFC $ MkIClaimData MW Private [foreignFnOpt]
                    $ MkTy EmptyFC (NoFC foreignName)
                    $ IPi EmptyFC MW ExplicitArg Nothing (IBindVar EmptyFC "a")
                      $ IApp EmptyFC (IVar EmptyFC $ basic "PrimIO") fieldType

    fnDecl : Decl
    fnDecl = IClaim $ NoFC $ MkIClaimData MW Export []
               $ MkTy EmptyFC (NoFC fnName)
               $ IPi EmptyFC MW AutoImplicit Nothing (IApp EmptyFC (IVar EmptyFC $ basic "HasIO") (IBindVar EmptyFC "io"))
                 $ IPi EmptyFC MW ExplicitArg Nothing (IBindVar EmptyFC "a")
                   $ IApp EmptyFC (IBindVar EmptyFC "io") fieldType

    fnDef : Decl
    fnDef = IDef EmptyFC fnName
              [ PatClause EmptyFC
                  (IApp EmptyFC (IVar EmptyFC fnName) (IBindVar EmptyFC "a"))
                  (IApp EmptyFC (IVar EmptyFC $ basic "primIO") $ IApp EmptyFC (IVar EmptyFC foreignName) (IVar EmptyFC (basic "a")))
              ]

export
mkNodeFieldIO : (fnName : Name) -> (fieldName : String) -> (fieldType : TTImp) -> Elab ()
mkNodeFieldIO fnName fieldName fieldType = declare $ nodeFieldIODecl fnName fieldName fieldType

