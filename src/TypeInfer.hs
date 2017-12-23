module TypeInfer where

    type_infer :: Tm -> Maybe Tm 
    

    -- Type Equation
    data TyEqu = 
        | EqTy Ty Ty
        | OfEqTy Tm Tm
        | TmOfTy Tm Ty
        | SubTy Ty Ty
        | OfSubTy Tm Tm
        | TmOfSubTy Tm Ty
    
    known_cond :: TyEqu -> Bool

    type SysTyEqu = [TyEqu]

    type_constraint :: Tm -> [SysTyEqu]
    type_constraint (MIf crit bA bB) =
        [TmOfTy crit TBool,
        OfEqTy bA bB] 
        ++ type_constraint crit
        ++ type_constraint bA
        ++ type_constraint bB

    type_constraint (MSuc x) =
        [TmOfTy x TNat] ++
        type_constraint x
    
    type_constraint (MNGT a b) =
        [TmOfTy a TNat,
        TmOfTy b TNat] ++
        type_constraint a ++
        type_constraint b
    
    type_constraint (MNEQ a b) =
        [TmOfTy a TNat,
        TmOfTy b TNat] ++
        type_constraint a ++
        type_constraint b

    type_constraint (MNLT a b) =
        [TmOfTy a TNat,
        TmOfTy b TNat] ++
        type_constraint a ++
        type_constraint b

    type_constraint (MCEQ a b) =
        [TmOfTy a TChr,
        TmOfTy b TChr] ++
        type_constraint a ++
        type_constraint b

    -- lexical scoped, so type constraint not that trivial
    type_constraint (MFun i T body) =
        [TmOfTy (TVar) TNat,
        TmOfTy b TNat] ++
        type_constraint a ++
        type_constraint b