module NameEli where
    data UniId = NId Id | CId Id deriving (Show, Eq)
    type UniLexi = Dict UniId Integer


    nameEli' :: UniLexi -> EForm -> EForm
    nameEli' c (EVar i) = dictLoc' c (NId i)
    nameEli' c (ECVar i) = dictLoc' c (CId i)
    nameEli' c (EFunC i (Cont j) T body) =
        let c' = addDict (addDict c (CId j) 0) (NId i) 0
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
        
