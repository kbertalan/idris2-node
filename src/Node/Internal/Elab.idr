module Node.Internal.Elab

import Language.Reflection

%language ElabReflection

export
field : String -> Name
field = UN . Field

export
basic : String -> Name
basic = UN . Basic

export
nodeFieldDecl : (fnName : Name) -> (fieldName : String) -> (fieldType : TTImp) -> List Decl
nodeFieldDecl fnName fieldName fieldType = [ foreignDecl, fnDecl, fnDef ]
  where
    nodeCode : String
    nodeCode = "node:lambda: (tyx, x) => x.\{fieldName}"

    foreignFnOpt : FnOpt
    foreignFnOpt = ForeignFn [ IApp EmptyFC (IVar EmptyFC (UN $ Basic "fromString")) (IPrimVal EmptyFC $ Str nodeCode) ]

    foreignName : Name
    foreignName = UN $ Basic "ffi_\{fieldName}"

    foreignDecl : Decl
    foreignDecl = IClaim EmptyFC MW Private [foreignFnOpt]
                    $ MkTy EmptyFC EmptyFC foreignName 
                    $ IPi EmptyFC MW ExplicitArg Nothing (IBindVar EmptyFC "a") fieldType

    fnDecl : Decl
    fnDecl = IClaim EmptyFC MW Export []
               $ MkTy EmptyFC EmptyFC fnName
               $ IPi EmptyFC MW ExplicitArg Nothing (IBindVar EmptyFC "a") fieldType

    fnDef : Decl
    fnDef = IDef EmptyFC fnName
              [ PatClause EmptyFC
                  (IApp EmptyFC (IVar EmptyFC fnName) (IBindVar EmptyFC "a"))
                  (IApp EmptyFC (IVar EmptyFC foreignName) (IVar EmptyFC (UN $ Basic "a")))
              ]

export
mkNodeField : (fnName : Name) -> (fieldName : String) -> (fieldType: TTImp) -> Elab ()
mkNodeField fnName fName fType = declare $ nodeFieldDecl fnName fName fType

