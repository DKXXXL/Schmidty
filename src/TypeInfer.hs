module TypeInfer where

    type_infer :: Tm -> Maybe Tm 
    
    -- Type Equation
    data TyEqu = 
        | EqTy Ty Ty
        | SubTy Ty Ty
        | SupTy Ty Ty
        | TmOfTy Tm Ty
        | TmOfSubTy Tm Ty
        | TmOfSupTy Tm Ty
        deriving (Show, Eq)
    
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
        let typeOfRet = TInfer . unsafePerformIO $ accC ct
        in [TmOfTy crit TBool,
            TmOfTy bA typeOfRet,
            TmOfTy bB typeOfRet,
            TmOfSupTy (MIf crit bA bB) typeOfRet] 
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
    type_constraint ct (MFun i T body) =
        let TO = TInfer . unsafePerformIO $ accC ct
        in [TmOfSupTy (TVar i) T,
            TmOfSubTy body TO,
            TmOfTy (MFun i T body) (TFun T TO)] ++
            type_constraint ct body
    
    type_constraint ct (MApp f x) = 
        let typeOfArg = TInfer . unsafePerformIO $ accC ct
        in let typeOfO = TInfer . unsafePerformIO $ accC ct
        in [TmOfTy f (TFun (typeOfArg) ( typeOfO)),
            TmOfSubTy x ( typeOfArg),
            TmOfSupTy (MApp f x) typeOfO] ++
            type_constraint ct f ++
            type_constraint ct x
    
    type_constraint ct (MLet i typeOfBind bind body) =
    let typeOfBody = TInfer . unsafePerformIO $ accC ct
        in [TmOfTy (TVar i) typeOfBind,
            TmOfTy bind typeOfBind,
            TmOfTy body typeOfBody
            TmOfSupTy (MLet i T bind body) typeOfBody] ++
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
        let typeOfRet = unsafePerformIO $ accC ct
        in [TmOfTy post typeOfRet,
            TmOfSupTy (MSeq pre post) typeOfRet] ++
        type_constraint ct pre ++
        type_constraint ct post

    repeat :: Integer -> (a -> a) -> (a -> a)
    repeat 0 f = \x -> x
    repeat n f = f . (rep (n-1) f)

    simpl_constraint :: [TyEqu] -> [TyEqu]
    simpl_constraint [] = []
    simpl_constraint ((TmOfTy tm ty):sys) = 
        (TmOfTy tm ty) : (simpl_constraint (substTmTy tm ty sys))
        where substTmTy :: Tm -> Ty -> [TyEqu] -> [TyEqu]
              substTmTy tm ty = repeat 4 (map (substTmTy' tm ty))
              where substTmTy' :: Tm -> Ty -> TyEqu -> TyEqu
                    substTmTy' tm ty (TmOfTy tm' ty') =
                      if (tm == tm') then EqTy ty ty' else TmOfTy tm' ty'
                    substTmTy' tm ty (TmOfSubTy tm1 ty1) =
                        if (tm == tm1)
                            then (SubTy ty ty1)
                            else (TmOfSubTy tm1 ty1)
                    substTmTy' tm ty (TmOfSupTy tm1 ty1) =
                        if (tm == tm1)
                            then (SupTy ty ty1)
                            else (TmOfSupTy tm1 ty1)
                    substTmTy' tm ty x = x

    check_consistent :: [TyEqu] -> Bool


                    