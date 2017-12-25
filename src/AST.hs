module AST where

type Id = Integer
type TyId = Id
type InferId = Id

data Ty = 
    | TNat
    | TChr
    | TFun Ty Ty 
    | TBool
    | TSum Ty Ty 
    | TNone
    --- Root of subtyping
    --- | TRcd Ty [(Id, Ty)] 
    --- Nominal Type, Not exposed 
    | TVar TyId
--  | TAlias TyId
    | TInfer InferId
    deriving (Show, Eq)

-- Terms

data Tm =
    | MNone
    | MIf Tm Tm Tm
    | MVar Id
    | MZero
    | MSuc Tm 
    | MNGT Tm Tm 
    | MNEQ Tm Tm
    | MNLT Tm Tm
    | MChr Integer
    | MCEQ Tm Tm 
    | MFun Id Ty Ty Tm 
    | MApp Tm Tm 
    | MLet Id Ty Tm Tm
    | MTrue 
    | MFalse
    | MBEQ Tm Tm 
    | MLeft Tm Ty 
    | MRight Ty Tm 
    | MCase Tm Tm Tm 
    | MLetRcd Id TyId Ty [(Id, Ty)] Tm 
    --- Width Subtyping
    --- letrcd (constructorName 
    ---         TypeName 
    ---            SuperType ((FieldName FieldType) (FieldName FieldType)))
    --- Depth Subtyping
    | MField Ty Id
    | MSeq Tm Tm 
    deriving (Show, Eq)

type Dict k v = [(k, v)]

checkDict :: Dict k v -> k -> Maybe v 
checkDict ((a, b): dict') k = if (a == k) then Just b else (checkDict dict' k)
checkDict [] _ = Nothing

addDict :: Dict k v -> k -> v -> Dict k v 
addDict h a b = (a, b) : h

