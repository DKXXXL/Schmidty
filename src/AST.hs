module AST where

type Id = Integer
type TyId = Id

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
    | TInfer
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
    | MFun Id Ty Tm 
    | MApp Tm Tm 
    | MLet Id Tm Tm
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

