module ToAST where
    import Parsing2 as P
    import Macro
    import AST

    toType :: P.SStruc -> Ty
    toType (P.SAtom "Int") = TNat
    toType (P.SAtom "Char") = TChr
    toType (P.SAtom "Bool") = TBool
    toType (P.SAtom "None") = TNone
    toType (P.SAtom "_") = TInfer 0
    toType (P.SAtom x) = TVar . varNameToid $ x
    toType (P.SList ((P.SAtom "->"):a:b:[])) =
        TFun (toType a) (toType b)
    toType (P.SList ((P.SAtom "TSum"):a:b:[])) =
        TSum (toType a) (toType b)
    


    toAst :: P.SStruc -> Tm
    toAst (P.SChar s) = MChr s
    toAst (P.SBool t) = if t then MTrue else MFalse
    toAst (P.SNum i) = MInt $ fromIntegral i
    toAst (P.SAtom x) = MVar (varNameToid x)
    toAst (P.SList ((P.SAtom "left"):tm:ty:[])) =
        MLeft (toAst tm) (toType ty) 
    toAst (P.SList ((P.SAtom "right"):ty:tm:[])) =
        MRight (toType ty) (toAst tm)
    toAst (P.SList ((P.SAtom "Field"):ty:(SAtom id):[])) =
        MField (toType ty) (varNameToid id)
    toAst (P.SList ((P.SAtom "lambda"):(P.SList ((P.SList ((P.SAtom x):ty:[])):[])):body:[])) =
        MFun (varNameToid x) (toType ty)  (toAst body)
    toAst (P.SList ((P.SAtom "let"):(P.SAtom x):ty:bind:body:[])) =
        MLet (varNameToid x) (toType ty) (toAst bind) (toAst body)
    toAst (P.SList ((P.SAtom "letrcd"):(P.SAtom cons):(P.SAtom tyid):suty:(P.SList ((P.SAtom "Record"):rcd)):body:[])) =
        MLetRcd (varNameToid cons) (varNameToid tyid) (toType suty) (toRcd rcd) (toAst body)
        where toRcd :: [P.SStruc] -> [(Id, Ty)]
              toRcd = map toRcd'
              toRcd' :: P.SStruc -> (Id, Ty)
              toRcd' (P.SList ((P.SAtom i):ty:[])) = ((varNameToid i), (toType ty))
    toAst (P.SList ((P.SAtom "letext"):(P.SAtom x):ty:body:[])) =
        MLetExt (varNameToid x) (toType ty) (toAst body)
    toAst (P.SList (dec:oprands)) =
        let operands' = map toAst oprands
        in if(carefulOperator dec)
            then case dec of (P.SAtom "suc") -> case operands' of a:[] -> MSuc a
                             (P.SAtom "dec") -> case operands' of a:[] -> MDec a
                             (P.SAtom ">") -> case operands' of a:b:[] -> MNGT a b
                             (P.SAtom "=") -> case operands' of a:b:[] -> MNEQ a b
                             (P.SAtom "<") -> case operands' of a:b:[] -> MNLT a b
                             (P.SAtom "ceq") -> case operands' of a:b:[] -> MCEQ a b
                             (P.SAtom "case") -> case operands' of a:b:c:[] -> MCase a b c 
                             (P.SAtom "beq") -> case operands' of a:b:[] -> MBEQ a b
                             (P.SAtom "begin") -> case operands' of a:b:[] -> MSeq a b
                             (P.SAtom "if") -> case operands' of a:b:c:[] -> MIf a b c
            else case operands' of a:[] -> MApp (toAst dec) a