module AST where

type Id = Integer
type TyId = Id

data Ty = 
    | TNat
    | TChr
    | TFun Ty Ty 
    | TBool
    | TSum Ty Ty 
    | TRoot
    --- Root of subtyping
    | TRcd Ty [(Id, Ty)] 
    --- Nominal Type, Not exposed 
    | TVar TyId
--    | TInfer
    deriving (Show, Eq)

-- Terms

data Tm =
    | MIf Tm Tm Tm
    | MVar Id
    | MZero
    | MSuc Tm 
    | MNGT Tm Tm 
    | MNEQ Tm Tm
    | MNLT Tm Tm
    | MChr Integer
    | MCEQ Tm Tm 
    | MFun Id Ty Tm 
    | MApp Tm Tm 
    | MLet Id Tm Tm
    | MTrue 
    | MFalse
    | MBEQ Tm Tm 
    | MLeft Tm Ty 
    | MRight Ty Tm 
    | MCase Tm Tm Tm 
    | MLetRcdW Id TyId Ty [(Id, Ty)] Tm 
    --- Width Subtyping
    --- letrcd (constructorName 
    ---         TypeName 
    ---            SuperType ((FieldName FieldType) (FieldName FieldType)))
    | MLetRcdD Id TyId Ty [(Id, Ty)] Tm 
    --- Depth Subtyping
    | MField Ty Id Tm
    | MSeq Tm Tm 
    deriving (Show, Eq)

