module NameReassign where

    -- Resolve Name Confliction (Shadowing)
    
    type LexDict = Dict Id Id
    type LexTypeDict = Dict TyId TyId

    nameConflictResolution :: Tm -> Tm
    nameConflictResolution = nameReassign accum 0
        where accum ct = do {
            ret <- readIORef ct;
            atomicModifyIORef' ct (\x -> (x+1, x+1));
            return ret
        }

    tynameConflictResolution :: Tm -> Tm
    nameConflictResolution = 
        typenameRes accum (unsafePerformIO $ newIORef 0) []
        where accum = do {
            ret <- readIORef ct;
            atomicModifyIORef' ct (\x -> (x+1, x+1));
            return ret
        }

    nameReassign :: AccCounter -> Integer -> Tm -> Tm
    
    nameReassign acc init tm =
        nameRes acc (unsafePerformIO $ newIORef init) [] tm
    
    nameRes :: AccCounter ->  Counter ->
                LexDict ->
                Tm -> Tm
    nameRes acc ct d MNone = MNone
    nameRes acc ct d (MIf a b c) =
        MIf (nameRes acc ct d a)
            (nameRes acc ct d b)
            (nameRes acc ct d c)
    nameRes acc ct d (MVar id) =
        MVar (checkDict d id)
    
    nameRes acc ct d (MZero) =
        MZero
    
    nameRes acc ct d (MSuc x) =
        MSuc (nameRes acc ct d x)
    
    nameRes acc ct d (MNGT a b) =
        MNGT (nameRes acc ct d a) (nameRes acc ct d b)
    
    nameRes acc ct d (MNEQ a b) =
        MNEQ (nameRes acc ce d a) (nameRes acc ct d b)
    nameRes acc ct d (MNLT a b) =
        MNLT (nameRes acc ce d a) (nameRes acc ct d b)
       
    nameRes acc ct d (MChr i) =
        MChr i
    
    nameRes acc ct d (MCEQ a b) =
        MCEQ (nameRes acc ct d a) (nameRes acc ct d b)
    
    nameRes acc ct d (MFun i T body) =
        let ni = unsafePerformIO $ acc ct
        in let nd = addDict d i ni
            in MFun ni T (nameRes acc ct nd body)
    
    nameRes acc ct d (MApp f x) =
        MApp (nameRes acc ct d f) (nameRes acc ct x)
    
    nameRes acc ct d (MLet i bind body) =
        let ni = unsafePerformIO $ acc ct
        in MLet ni (nameRes acc ct bind) (nameRes acc ct (addDict d i ni) body)
    
    nameRes acc ct d (MTrue) = MTrue 
    nameRes acc ct d (MFalse) = MFalse

    nameRes acc ct d (MBEQ a b) =
        MBEQ (nameRes acc ct d a) (nameRes acc ct d b)
    
    nameRes acc ct d (MLeft l RT) = 
        MLeft (nameRes acc ct d l) RT

    nameRes acc ct d (MRight LT r) =
        MRight LT (nameRes acc ct d r)
    
    nameRes acc ct d (MCase x lb rb) =
        MCase (nameRes acc ct d x) 
              (nameRes acc ct d lb)
              (nameRes acc ct d rb)
    
    nameRes acc ct d (MLetRcd id tyid suty record body) =
        let ni = unsafePerformIO $ acc ct 
        in MLet ni tyid suty record (nameRes acc ct (addDict d id ni) body)
    
    nameRes acc ct d (MField ty id) =
        MField ty (checkDict d id)

    nameRes acc ct d (MSeq pre past) =
        MSeq (nameRes acc ct d pre) (nameRes acc ct d post)

        
    typeIdSubst :: LexTypeDict -> Ty -> Ty
    typeIdSubst d (TVar tyid) = TVar (checkDict d tyid)
    typeIdSubst d x = x
        
    typenameRes :: AccCounter -> Counter -> LexTypeDict ->Tm -> Tm 
    typenameRes acc ct d MNone = MNone
    typenameRes acc ct d (MIf a b c) =
        MIf (typenameRes acc ct d a)
            (typenameRes acc ct d b)
            (typenameRes acc ct d c)
    typenameRes acc ct d (MVar id) =
        MVar id

    typenameRes acc ct d (MZero) =
        MZero

    typenameRes acc ct d (MSuc x) =
        MSuc (typenameRes acc ct d x)

    typenameRes acc ct d (MNGT a b) =
        MNGT (typenameRes acc ct d a) (typenameRes acc ct d b)

    typenameRes acc ct d (MNEQ a b) =
        MNEQ (typenameRes acc ce d a) (typenameRes acc ct d b)
    typenameRes acc ct d (MNLT a b) =
        MNLT (typenameRes acc ce d a) (typenameRes acc ct d b)
    
    typenameRes acc ct d (MChr i) =
        MChr i

    typenameRes acc ct d (MCEQ a b) =
        MCEQ (typenameRes acc ct d a) (typenameRes acc ct d b)

    typenameRes acc ct d (MFun i T body) =
        MFun i (typeIdSubst d T)
            (typenameRes acc ct d body)

    typenameRes acc ct d (MApp f x) =
        MApp (typenameRes acc ct d f) (typenameRes acc ct x)

    typenameRes acc ct d (MLet i bind body) =
        MLet i (typenameRes acc ct d bind) (typenameRes acc ct d body)

    typenameRes acc ct d (MTrue) = MTrue 
    typenameRes acc ct d (MFalse) = MFalse

    typenameRes acc ct d (MBEQ a b) =
        MBEQ (typenameRes acc ct d a) (typenameRes acc ct d b)

    typenameRes acc ct d (MLeft l RT) = 
        MLeft (typenameRes acc ct d l) (typeIdSubst d RT)

    typenameRes acc ct d (MRight LT r) =
        MRight (typeIdSubst d LT) (typenameRes acc ct d r)

    typenameRes acc ct d (MCase x lb rb) =
        MCase (typenameRes acc ct d x) 
            (typenameRes acc ct d lb)
            (typenameRes acc ct d rb)

    typenameRes acc ct d (MLetRcd id tyid suty record body) =
        let ntyid = unsafePerformIO $ acc ct 
        in let newd = addDict d tyid ntyid
        in MLetRcd id ntyid suty record (typenameRes acc ct (addDict newd tyid ntyid) body)

    typenameRes acc ct d (MField ty id) =
        MField (typeIdSubst d ty) id

    typenameRes acc ct d (MSeq pre past) =
        MSeq (typenameRes acc ct d pre) (typenameRes acc ct d post)



