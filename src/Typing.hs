module Typing where

type Dict k v = [(k, v)]

checkDict :: Dict k v -> k -> Maybe v 
checkDict ((a, b): dict') k = if (a == k) then Just b else (checkDict dict' k)
checkDict [] _ = Nothing

addDict :: Dict k v -> k -> v -> Dict k v 
addDict h a b = (a, b) : h

type CustomedTypeDict = Dict TyId Ty 
type VarTypeDict = Dict Id Ty 


has_type :: Tm -> Maybe Ty

has_type' :: CustomedTypeDict ->
             VarTypeDict ->
             Tm -> Maybe Ty

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
has_type' tyd vd (MFun i tyI tm) =
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


        
    