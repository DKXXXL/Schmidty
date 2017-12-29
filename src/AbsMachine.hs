module AbsMachine where
    
    data ABSS = ABSS {
        LABELNO :: Integer,
        FUNS :: [MLabel]
    } deriving (Show, Eq) 
    type ABSM = State ABSS


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

    mapValueToReg :: [Value] -> [Integer] -> [MachL]
    mapValueToReg (a : as) (b:bs) =
        (SetReg (reg b) a) : (mapValueToReg as bs)

    

    machl :: TForm -> ABSM [MachL]
    machl (TFIf crit tb fb) =
        do {
        crit' <- machl' crit;
        tb' <- machl tb;
        fb' <- machl fb;
        labeltrue <- addnewfun tb';
        labelfalse <- addnewfun fb';
        return $
        (mapValueToReg [crit', VClosure labeltrue 0, VClosure labelfalse 0]
                       [1, 2, 3]) ++
        [IFJUMP (reg 1) (reg 2) (reg 3)]
        }
    machl (TFSuc x cont) =
        do {
            x' <- machl' x;
            cont' <- machl' 
        }



    machl' :: EForm -> ABSM Value
    machl' ENone = return VNone
    machl' (EVar i) = return VVar i
    machl' (ECVar _) = error "Not Supposed to find ECVAR"
    machl' EZero = return VZero
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

    machl' (EField )
    

    

    

    
    