module NameEli where
    data UniId = NId Id | CId Id deriving (Show, Eq)
    type UniLexi = Dict UniId Integer


    nameEli' :: UniLexi -> EForm -> EForm
    nameEli' c (EVar i) = EVar $ dictLoc' c (NId i)
    nameEli' c (ECVar i) = EVar $ dictLoc' c (CId i)
    nameEli' c (EFunC i (Cont j) T body) =
        let c' = addDict (addDict c (NId i) 0) (CId j) 0
        in EFunC 1 (Cont 0) T (nameEli c' body)

    nameEli' c (ECont (Cont i) body) =
        let c' = addDict c (CId i) 0
        in ECont (Cont 0) (nameEli c' body)
    
    nameEli' c x = x    

    nameEli :: UniLexi -> TForm -> TForm 
    nameEli c (TFIf crit ba bb) =
        TFIf (nameEli' c crit) (nameEli c ba) (nameEli c bb)
    
    nameEli c (TFSuc x cont) =
        TFSuc (nameEli' c x) (nameEli' c cont)
    
    nameEli c (TFNGT a b cont) =
        TFNGT (nameEli' c a) (nameEli' c b) (nameEli' c cont)

    nameEli c (TFNEQ a b cont) =
        TFNEQ (nameEli' c a) (nameEli' c b) (nameEli' c cont)

    nameEli c (TFNLT a b cont) =
        TFNLT (nameEli' c a) (nameEli' c b) (nameEli' c cont)

    nameEli c (TFCEQ a b cont) =
        TFCEQ (nameEli' c a) (nameEli' c b) (nameEli' c cont)
    
    nameEli c (TFApp f x) =
        TFApp (nameEli' c f) (nameEli' c x)

    nameEli c (TFAppc f x cont) =
        TFApp (nameEli' c f) (nameEli' c x) (nameEli' c cont)

    nameEli c (TFixApp itself retCall evBind cont) =
        let c' = addDict (addDict c (NId itself) 0) (CId retCall) 0 
        in TFixApp i ret (nameEli c' evBind) (nameEli' c cont)

    nameEli c (TFFixC i cont) =
        TFFixC (nameEli' c i) (nameEli' c cont)

    nameEli c (TFLet i ty bind body) =
        let c' = addDict c (NId i) 0
        in TFLet i T (nameEli' c bind) (nameEli c' body)
    
    nameEli c (TFBEQ a b cont) =
        TFBEQ (nameEli' c a) (nameEli' c b) (nameEli' c cont)

    nameEli c (TFLeft x cont) =
        TFLeft (nameEli' c x) (nameEli' c cont)

    nameEli c (TFRight x cont) =
        TFRight (nameEli' c x) (nameEli' c cont)

    nameEli c (TFCase x lb rb cont) =
        TFCase (nameEli' c x) (nameEli' c lb) (nameEli' c rb) (nameEli' c cont)

    nameEli c (TFLetRcd cons ty suty rcd body) =
        let c' = addDict c (NId cons) 0
        in TFLetRcd cons ty suty rcd (nameEli c' body)

    nameEli c (TFSeq pre post) =
        TFSeq (nameEli c pre) (nameEli c post)

    
