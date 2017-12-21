type Id = Integer
type TyId = Id

data Ty = 
    | TNat
    | TChr
    | TFun Ty Ty 
    | TBool
    | TSum Ty Ty 
    | TRcd Ty [(Id, Ty)] 
    --- Nominal Type, Not exposed 
    | TVar TyId
--    | TInfer

-- Terms

data Tm =
    | MIf Tm Tm Tm
    | MVar Id
    | MSuc Tm 
    | MChr Integer
    | MFun Id Ty Tm 
    | MLet Id Tm 
    | MTrue 
    | MFalse
    | MLeft Tm Ty 
    | MRight Ty Tm 
    | MCase Tm Tm Tm 
    | MLetRcd Id TyId Ty [(Id, Ty)] Tm 
    --- letrcd (constructorName 
    ---         TypeName 
    ---            SuperType ((FieldName FieldType) (FieldName FieldType)))
    | MField Ty Id Tm
    | MSeq Tm Tm 


type Dict k v = [(k, v)]

checkDict :: Dict k v -> k -> Maybe v 
checkDict ((a, b): dict') k = if (a == k) then Just b else (checkDict dict' k)
checkDict [] _ = Nothing

addDict :: Dict k v -> k -> v -> Dict k v 
addDict h a b = (a, b) : h

type CustomedTypeInfo = Dict TyId Ty 
type VarTypes = Dict Id Ty 


has_type :: Tm -> Maybe Ty

has_type' :: [(TyId, Ty)] -> 