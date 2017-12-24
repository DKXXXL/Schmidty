module TypeInfer where

    type_infer :: Tm -> Maybe Tm 
    

    -- Type Equation
    data TyEqu = 
        | EqTy Ty Ty
        | OfEqTy Tm Tm
        | OfSubTy Tm Tm
        | OfSupTy Tm Tm
        | TmOfTy Tm Ty
        | SubTy Ty Ty
        | TmOfSubTy Tm Ty
        | TmOfSupTy Tm Ty
    
    known_cond :: TyEqu -> Bool

    type SysTyEqu = [TyEqu]

    accC :: Counter -> IO Integer
    accC x = do {
        ret <- readIORef ct;
        atomicModifyIORef' ct (\x -> (x-1, x-1));
        return ret
    }

    type_constraint :: Counter -> Tm -> [TyEqu]
    type_constraint ct (MIf crit bA bB) =
        [TmOfTy crit TBool,
        OfEqTy bA bB,
        OfSupTy (MIf crit bA bB) bB] 
        ++ type_constraint ct crit
        ++ type_constraint ct bA
        ++ type_constraint ct bB

    type_constraint ct (MSuc x) =
        [TmOfTy x TNat,
         TmOfTy (MSuc x) TNat] ++
        type_constraint ct x
    
    type_constraint ct (MNGT a b) =
        [TmOfTy a TNat,
        TmOfTy b TNat,
        TmOfTy (MNGT a b) TBool] ++
        type_constraint ct a ++
        type_constraint ct b
    
    type_constraint ct (MNEQ a b) =
        [TmOfTy a TNat,
        TmOfTy b TNat,
        TmOfTy (MNEQ a b) TBool] ++
        type_constraint ct a ++
        type_constraint ct b

    type_constraint ct (MNLT a b) =
        [TmOfTy a TNat,
        TmOfTy b TNat,
        TmOfTy (MNLT a b) TBool] ++
        type_constraint ct a ++
        type_constraint ct b

    type_constraint ct (MCEQ a b) =
        [TmOfTy a TChr,
        TmOfTy b TChr,
        TmOfTy (MCEQ a b) TBool] ++
        type_constraint ct a ++
        type_constraint ct b

    -- lexical scoped, so type constraint not that trivial
    type_constraint ct (MFun i T TO body) =
        [TmOfSupTy (TVar i) T,
         TmOfSubTy body TO,
         TmOfTy (MFun i T TO body) (TFun T TO)] ++
         type_constraint ct body
    
    type_constraint ct (MApp f x) = 
        let typeOfArg = TInfer . unsafePerformIO $ accC ct
        in let typeOfO = TInfer . unsafePerformIO $ accC ct
        in [TmOfTy f (TFun (typeOfArg) ( typeOfO)),
            TmOfSubTy x ( typeOfArg),
            TmOfSupTy (MApp f x) typeOfO] ++
            type_constraint ct f ++
            type_constraint ct x
    
    type_constraint ct (MLet i bind body) =
        let typeOfBind = TInfer . unsafePerformIO $ accC ct
        in [TmOfTy (TVar i) typeOfBind,
            TmOfTy bind typeOfBind,
            OfSupTy (MLet i bind body) body] ++
            type_constraint ct bind ++
            type_constraint ct body
    
    type_constraint ct (BEQ a b) =
        [TmOfTy a TBool,
         TmOfTy b TBool,
         TmOfTy (BEQ a b) TBool] ++
         type_constraint ct a ++
         type_constraint ct b
    
    type_constraint ct (MLeft l RT) =
        let typeOfUnk =TInfer . unsafePerformIO $ accC ct
        in [TmOfTy l (typeOfUnk),
            TmOfSupTy (MLeft l RT) (TSum (typeOfUnk) RT)] ++
            type_constraint ct l

    type_constraint ct (MRight LT r) =
        let typeOfUnk = TInfer . unsafePerformIO $ accC ct
        in [TmOfTy r (typeOfUnk),
            TmOfSupTy (MRight LT r) (TSum LT (typeOfUnk))] ++
            type_constraint ct r

    type_constraint ct (MCase x lb rb) =
        let typeOfL = TInfer . unsafePerformIO $ accC ct
        in let typeOfR = TInfer . unsafePerformIO $ accC ct
        in let typeOfret = TInfer . unsafePerformIO $ accC ct 
        in [TmOfTy x (TSum ( typeOfL) ( typeOfR)),
            TmOfTy lb (TFun (typeOfL) (typeOfret)),
            TmOfTy rb (TFun (typeOfR) (typeOfret)),
            TmOfSupTy (MCase x lb rb) typeOfret
            ] ++
            type_constraint ct x ++
            type_constraint ct lb ++
            type_constraint ct rb 
    
    

    type_constraint ct (MLetRcd ci tyid supty rcd body) =
        [TmOfTy ct ]
        

    type_constraint ct (MSeq pre post) =
        [OfSupTy (MSeq pre post) post] ++
        type_constraint ct pre ++
        type_constraint ct post