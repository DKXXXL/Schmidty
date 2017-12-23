module NameReassign where

    -- Resolve Name Confliction (Shadowing)
    type Counter = IORef Integer
    type AccCounter = IORef Integer -> IO Integer
    type LexDict = Dict Id Id

    nameReassign :: AccCounter -> Integer -> Tm -> Tm
    
    nameReassign acc rct init tm =
        nameRes acc rct (unsafePerformIO $ newIORef init) tm
    
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
    
    nameRes acc ct 
