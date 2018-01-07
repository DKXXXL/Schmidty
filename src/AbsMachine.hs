module AbsMachine where
    import Control.Monad.State.Lazy
    import AST
    import IRep
    

    data ABSS = ABSS {
        labelNO :: Integer,
        functions :: [MLabel],
        declare :: Dict Id Id
    } deriving (Show, Eq) 
    type ABSM = State ABSS

    initialState :: Dict Id Id -> ABSS
    initialState predecl = ABSS 2 [] predecl

    toAbsMachL :: Dict Id Id -> TForm -> [MLabel]
    toAbsMachL predecl tf = (MLabel 0 mainRunning):fs
        where (mainRunning, ABSS _ fs _) = runState (machl tf) (initialState predecl)


    addnewfun :: [MachL] -> ABSM Integer
    addnewfun f = do {
        labelnow <- gets labelNO;
        funs <- gets functions;
        modify $ \absm -> absm {
            labelNO = labelnow + 1,
            functions = (MLabel labelnow f):funs
            };
        return labelnow
    }

    
    mapEFormToRegs :: [EForm] -> [Integer] -> ABSM [MachL]
    mapEFormToRegs eforms regs = 
        ( >>= (return . (flip mapValueToRegs regs))). 
        (mapM machl') $ eforms
        -- (mapM machl') :: [EForm] -> ABSM [Value]
     {-  where connectState :: [ABSM EForm] -> ABSM [EForm]
              connectState [] = return []
              connectState (x:xs) = 
                x >>= (\x' -> connectState xs >>= \xs' -> return (x':xs'))
              states :: [ABSM EForm]
              states = map machl' eforms -}
    mapValueToRegs :: [Value] -> [Integer] -> [MachL]
    mapValueToRegs a b = (map (\(x,y) -> mapValueToReg x y)) $ zip a b

    mapValueToReg :: Value -> Integer -> MachL
    mapValueToReg a b = (SetReg (reg b) a)

    

    machl :: TForm -> ABSM [MachL]
    machl (TFIf crit tb fb) =
        do {
        crit' <- machl' crit;
        tb' <- machl tb;
        fb' <- machl fb;
        labeltrue <- addnewfun tb';
        labelfalse <- addnewfun fb';
        return $
        (mapValueToRegs [crit', 
                        VClosure labeltrue 0, 
                        VClosure labelfalse 0]
                        [1, 2, 3]) ++
        [IFJUMP]
        }
    
    machl (TFSuc x cont) =
        do {
            init <- mapEFormToRegs [x, cont] [1, 2];
            return (init ++ [SUC])
        }

    machl (TFDec x cont) =
        do {
            init <- mapEFormToRegs [x, cont] [1, 2];
            return (init ++ [DEC])
        }

    machl (TFNGT a b cont) =
        do {
            init <- mapEFormToRegs [a, b, cont] [1, 2, 3];
            return (init ++ [NGT])
        }


    machl (TFNEQ a b cont) =
        do {
            init <- mapEFormToRegs [a, b, cont] [1, 2, 3];
            return (init ++ [NEQ])
        }

    machl (TFNLT a b cont) =
        do {
            init <- mapEFormToRegs [a, b, cont] [1, 2, 3];
            return (init ++ [NLT])
        }

    machl (TFCEQ a b cont) =
        do {
            init <- mapEFormToRegs [a, b, cont] [1, 2, 3];
            return (init ++ [CEQ])
        }

    machl (TFApp f x) =
        do {
            init <- mapEFormToRegs [f, x] [0, 1];
            return (init ++ [APP])
        }

    machl (TFAppc f x y) =
        do {
            init <- mapEFormToRegs [f, x, y] [0, 1, 2];
            return (init ++ [APP])
        }

    machl (TFixApp i outevalbind bind cont) = do 
            eventualKont <- machl' cont
            evalBind <- machl bind
            labelOfevalBind <- addnewfun evalBind
            let endEvalBind = 
                    [SetRegEnv (reg 4) 1,
                    CHECKFIXNODENECESSARY 1,
                    JUMPBACKCONT 1 (reg 4)] 
            labelOfendEvalBind <- addnewfun endEvalBind
            return $
                [AddEnv 2,
                 SetEnv 1 (VContStack 0 labelOfevalBind eventualKont []),
                 SetEnv 0 (VClosure labelOfendEvalBind 0),
                 GOTOEVALBIND 1 (reg 1)
                ]
        

    machl (TFFixC (EVar i) cont) = do
            closureOfCont <- machl' cont
            return $ 
                [SetReg (reg 3) closureOfCont,
                ADDCONTSTACKIFEXIST i (reg 3),
                SetRegEnv (reg 1) i,
                GOTOEVALBIND i (reg 3)
                ]
    
     

    machl (TFLetExt i ty body) =do 
            dict <- gets declare
            body' <- machl body
            let extName = case checkDict dict i of Just x -> x
            return $ 
                [AddEnv 1,
                SetEnv 0 (VDeclare extName ty)] ++
                body'
        
    machl (TFBEQ a b cont) =do 
            init <- mapEFormToRegs [a, b, cont] [1, 2, 3];
            return (init ++ [BEQ])
        

    machl (TFLeft x cont) =
        do {
            init <- mapEFormToRegs [x, cont] [1, 2];
            return (init ++ [LEFT])
        }

    machl (TFRight x cont) =
        do {
            init <- mapEFormToRegs [x, cont] [1, 2];
            return (init ++ [RIGHT])
        }

    machl (TFCase x lf rf cont) =
        do {
            init <- mapEFormToRegs [x, lf, rf, cont] [1, 2, 3, 4];
            return (init ++ [CASEJUMP])
        }

        
    machl (TFSeq pre post) = do 
            pre' <- machl pre
            post' <- machl post
            return $ pre' ++ post'

    machl' :: EForm -> ABSM Value
    machl' ENone = return VNone
    machl' (EVar i) = return $ VVar i
    machl' (ECVar _) = error "Not Supposed to find ECVAR"
    machl' (EChr i) = return $ VChr i
    machl' EZero = return VZero
    machl' (EInt i) = return $ VInt i
    machl' ETrue = return VTrue
    machl' EFalse = return VFalse
    machl' (EFunC i cont ty body) =do 
            funbody <- machl body
            let bodywithInit = 
                    [AddEnv 2,
                    SetEnvReg 0 2,
                    SetEnvReg 1 1] 
                    ++ funbody
            labelnow <- addnewfun bodywithInit
            return $ VClosure labelnow 0
        

    machl' (ECont cont body) = do 
            funbody <- machl body
            let bodywithInit = 
                    [AddEnv 1,
                    SetEnvReg 0 1] 
                    ++ funbody
            labelnow <- addnewfun bodywithInit
            return $ VClosure labelnow 0
        
    machl' EndCont = do
            let bodywithInit =
                    [AddEnv 1,
                     SetEnvReg 0 1,
                     ENDPROGRAM]
            labelnow <- addnewfun bodywithInit
            return $ VClosure labelnow 0

    machl' (EField ty i) = do 
        let body = [
                ExtractEnvptfromclsToReg (reg 1) (reg 1),
                RegToEnvpt (reg 1),
                SetRegEnv (reg 1) i,
                SetRegReg (reg 0) (reg 2),
                APP
                ]
        labelnow <- addnewfun body
        return $ VClosure labelnow 0

    
    
    

    

    

    
    