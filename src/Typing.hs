module Typing where

type RecordInfo = (Ty* [(Id* Ty)])
type CustomedTypeDict = Dict TyId RecordInfo 
-- type TypeAliases = Dict TyId Ty
type VarTypeDict = Dict Id Ty 

subtyOf :: CustomedTypeDict -> Ty -> Ty -> Bool
subtyOf d h1 h2 = if (h1 == h2) 
                    then true 
                    else (subtypeOf' d h1 h2)

subtypeOf' :: CustomedTypeDict -> Ty -> Ty -> Bool
subtypeOf' d (TFun i o) (TFun i' o') =
    (subtyOf d i' i) && (subtyOf d o o')
subtypeOf' d (TSum a b) (TSum a' b') =
    (subtyOf a a') && (subtyOf b b')
subtypeOf' d (TVar sub) super =
    let supOfSub, _ = checkDict d sub
    in subtyOf d supOfSub super
subtypeOf' _ _ _ = False


has_type :: Tm -> Maybe Ty
has_type = has_type' [] [] 

has_type' :: CustomedTypeDict ->
             VarTypeDict ->
             Tm -> Maybe Ty

has_type' _ _ MNone = TNone

has_type' tyd vd (MIf crit bA bB) =
        case (has_type' tyd vd crit) 
            of Just TBool -> 
                    let tyinCtx = has_type' tyd vd
                        tbA = (tyinCtx bA)
                    in if (tbA == (tyinCtx bB))
                        then tbA 
                        else Nothing
               Nothing -> Nothing

has_type' tyd vd (MVar id) = checkDict vd id 
has_type' _ _ MZero = Just TNat
has_type' tyd vd (MSuc n) = 
    if (has_type' tyd vd n == Just TNat)
    then Just TNat 
    else Nothing

has_type' tyd vd (MNGT a b) = 
    let tyInCtx = has_type' tyd vd
    in do {
        a' <- tyInCtx a;
        b' <- tyInCtx b;
        if ((a' == TNat) && (b' == TNat))
            then Just TBool
            else Nothing
    }
has_type' tyd vd (MNLT a b) = 
    let tyInCtx = has_type' tyd vd
    in do {
        a' <- tyInCtx a;
        b' <- tyInCtx b;
        if ((a' == TNat) && (b' == TNat))
            then Just TBool
            else Nothing
        }

has_type' tyd vd (MNEQ a b) = 
    let tyInCtx = has_type' tyd vd
    in do {
        a' <- tyInCtx a;
        b' <- tyInCtx b;
        if ((a' == TNat) && (b' == TNat))
            then Just TBool
            else Nothing
        }
has_type' _ _ (MChr intg) = Just TChr
has_type' tyd vd (MCEQ a b) = 
    let tyInCtx = has_type' tyd vd
    in do {
        a' <- tyInCtx a;
        b' <- tyInCtx b;
        if ((a' == TChr) && (b' == TChr))
            then Just TBool
            else Nothing
        }
has_type' tyd vd (MFun i tyI tyO tm) =
    (has_type' tyd (addDict vd i tyI) tm) 
        >>= (\tyO -> return (TFun tyI tyO))
has_type' tyd vd (MApp f x) = 
    let tyInCtx = has_type' tyd vd
    in do {
        fT <- tyInCtx f;
        xT <- tyInCtx x;
        case fT of (TFun tyI tyO) ->
            if (tyI == xT) then Just tyO else Nothing
    }

has_type' tyd vd (MLet i bind body) =
    (has_type' tyd vd bind) 
        >>= (\bindty -> has_type' tyd (addDict vd i bindty) body)

has_type' _ _ MTrue =
    Just TBool

has_type' _ _ MFalse =
    Just TBool

has_type' tyd vd (MBEQ a b) =
    let tyInCtx = has_type' tyd vd
    in do {
        a' <- tyInCtx a;
        b' <- tyInCtx b;
        if ((a' == TBool) && (b' == TBool))
            then Just TBool
            else Nothing
        }

has_type' tyd vd (MLeft l RT) =
    (has_type' tyd vd l) 
    >>= (\LT -> return (TSum LT RT))

has_type' tyd vd (MRight LT r) =
    (has_type' tyd vd r) 
    >>= (\RT -> return (TSum LT RT))

has_type' tyd vd (MCase crit bA bB) =
    let tyInCtx = has_type' tyd vd
    in do {
        critia <- tyInCtx crit;
        tybA <- tyInCtx bA;
        tybB <- tyInCtx bB;
        case critia of (TSum LT RT) ->
            case tybA of (TFun IT OT) ->
                case tybB of (TFun IT' OT') ->
                  if((LT == IT) && (RT == IT') && (OT == OT'))
                    then Just OT 
                    else Nothing
                            _ -> Nothing
                         _ -> Nothing
                       _ -> Nothing
    }

has_type' tyd vd (MLetRcd cName tyName suTy record body) =
    let consTy = tyListToProd $ ((map fst record)++ (TVar tyName))
        _, suprecord = checkDict tyd suTy
    in  if ((suTy == TNone) 
        || (checkSubtyping tyd record suprecord))
        then has_type (addDict tyd tyName (suTy, record)) (addDict vd cName consTy) body
        else Nothing

has_type' tyd vd (MField (TVar tyid) fieldId) =
    do {
        rcdInf <- checkDict tyd tyid;
        fieldType <- checkDict rcdInf fieldId;
        return (TFun (TVar tyid) fieldType)
    }

has_type' tyd vd (MField _ _) = Nothing

has_type' tyd vd (MSeq pre post) =
    (has_type' tyd vd pre)
    >> has_type' tyd vd post


tyListToProd :: [Ty] -> Ty
tyListToProd (a : []) = a
tyListToProd (a : l) = TFun a (tyListToProd l)


checkSubtyping :: CustomedTypeDict -> [(Id, Ty)] -> [(Id, Ty)] -> Bool 
checkSubtyping _ subty [] = True 
checkSubtyping typesInfo (a:b) (a':b') =
    subtyOf a a' 
    && checkSubtyping b b'








        
    