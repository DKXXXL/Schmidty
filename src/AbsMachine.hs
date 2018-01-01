module AbsMachine where
    import AST
    

    data ABSS = ABSS {
        LABELNO :: Integer,
        FUNS :: [MLabel],
        DECLARE :: Dict Id Id
    } deriving (Show, Eq) 
    type ABSM = State ABSS

    initialState :: Dict Id Id -> ABSS
    initialState predecl = ABSS 2 [] predecl

    toAbsMachL :: Dict Id Id -> TForm -> [MLabel]
    toAbsMachL predecl tf = (MLabel 0 mainRunning):fs
        where (mainRunning, fs) = runState (machl tf) (initialState predecl)


    accLabel :: Integer -> ABSM ()
    accLabel x = modify $ \absm -> absm {LABELNO = labelno + x}

    addnewfun :: [MachL] -> ABSM Integer
    addnewfun f = do {
        labelnow <- gets LABELNO;
        funs <- gets FUNS;
        modify $ \absm -> absm {
            LABELNO = labelnow + 1,
            FUNS = (MLabel labelnow f):funs
            };
        return labelnow
    }

    
    mapEFormToRegs :: [EForm] -> [Integer] -> ABSM [MachL]
    mapEFormToRegs eforms regs = 
        (flip mapValueToRegs regs). mapM machl' $ eforms
     {-  where connectState :: [ABSM EForm] -> ABSM [EForm]
              connectState [] = return []
              connectState (x:xs) = 
                x >>= (\x' -> connectState xs >>= \xs' -> return (x':xs'))
              states :: [ABSM EForm]
              states = map machl' eforms -}
    mapValueToRegs :: [Value] -> [Integer] -> [MachL]
    mapValueToRegs = (map (\(x,y) -> mapValueToReg)) . zip

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
        (mapValueToReg [crit', 
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

    machl (TFixApp i outevalbind bind cont) =
        do {
            eventualKont <- machl' cont
            evalBind <- machl bind
            labelOfevalBind <- addnewfun evalBind
            let endEvalBind = [JUMPBACKCONT 1] 
            labelOfendEvalBind <- addnewfun endEvalBind
            return $
            [AddEnv 2,
             EnvptToReg (reg 1)
             SetEnv 1 (VContStack (reg 1) labelOfevalBind eventualKont []),
             SetEnv 0 (VClosure labelOfendEvalBind 0),
             GOTOEVALBIND 1
            ]
        }

    machl (TFFixC (EVar i) cont) =
        do {
            closureOfCont <- machl' cont
            return $ 
            [SetReg (reg 2) closureOfCont,
             ADDCONTSTACKIFEXIST i (reg 2),
             GOTOEVALBIND i (reg 2)
            ]
        }
    
    machl (TFLet i ty bind body) =
        do {
            bind' <- machl' bind
            body' <- machl body
            return $ 
            [AddEnv 1,
             SetEnv 0 bind',
             ] ++ body'
        }

    machl (TFLetExt i ty body) =
        do {
            dict <- gets DECLARE
            body' <- machl body
            let extName = checkDict dict i
            return $ 
            [AddEnv 1,
             SetEnv 0 (VDeclare extName ty)] ++
             body'
        }
    machl (TFBEQ a b cont) =
        do {
            init <- mapEFormToRegs [a, b, cont] [1, 2, 3];
            return (init ++ [BEQ])
        }

    machl (TFLeft x cont) =
        do {
            init <- mapEFormToRegs [x, cont] [1, 2];
            return (init ++ [LEFT])
        }

    machl (TFRight x cont) =
        do {
            init <- mapEFormToRegs [x, cont] [1, 2];
            return (init ++ [Right])
        }

    machl (TFCase x lf rf cont) =
        do {
            init <- mapEFormToRegs [x, lf, rf, cont] [1, 2, 3, 4];
            return (init ++ [CASEJUMP])
        }

    machl (TFLetRcd cons ty suty rcd body) =
        do {
            body' <- machl body
            return $ 
            [AddEnv 1,
             SetEnv 0 (VConstructor ty)] ++
             body'
        }
    machl (TFSeq pre post) =
        do {
            pre' <- machl pre
            post' <- machl post
            return $ pre' ++ post'
        }

    machl' :: EForm -> ABSM Value
    machl' ENone = return VNone
    machl' (EVar i) = return VVar i
    machl' (ECVar _) = error "Not Supposed to find ECVAR"
    machl' EZero = return VZero
    machl' (EInt i) = return $ VInt i
    machl' ETrue = return VTrue
    machl' EFalse = return VFalse
    machl' (EFunc i cont ty body) =
        do {
            funbody <- machl body
            let bodywithInit = 
                [AddEnv 2,
                 SetEnvReg 0 2,
                 SetEnvReg 1 1] 
                ++ funbody
            labelnow <- addnewfun bodywithInit
            return $ VClosure labelnow 0
        }

    machl' (ECont cont body) = 
        do {
            funbody <- machl body
            let bodywithInit = 
                [AddEnv 1,
                 SetEnvReg 0 1] 
                ++ funbody
            labelnow <- addnewfun bodywithInit
            return $ VClosure labelnow 0
        }

    machl' (EField ty i) = do {
        let body = [
            ExtractEnvptfromclsToReg (reg 1) (reg 1),
            RegToEnvpt (reg 1),
            SetRegEnv (reg 1) i,
            SetRegReg (reg 0) (reg 2),
            APP
        ]
        labelnow <- addnewfun body
        return $ VClosure labelnow 0
    }
    

    

    

    
    