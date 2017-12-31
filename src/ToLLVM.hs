module ToLLVM where

    import LLVM.AST

    ---- Reference : Implementing a JIT 
    ------ Compiled Language with Haskell and LLVM

    newtype LLVM a = LLVM (State AST.Module a)
        deriving (Functor, Applicative, Monad, MonadState AST.Module )

    newtype Codegen a = Codegen { runCodegen :: State CodegenState a }
        deriving (Functor, Applicative, Monad, MonadState CodegenState )

    

    toLLVMAsm :: [MLabel] -> IO ByteString
    toLLVMAsm labels =
        withContext $ \context ->
            liftError $ withModuleFromAST context asts $ \m -> do
              llstr <- moduleLLVMAssembly m
              return llstr
        where asts = toLLVMModule labels

    toLLVMModule :: [MLabel] -> (AST.Module)
    toLLVMModule labels = allAst
        where labels' = reverse $ sort labels
              --- tollvm :: LLVM ()
              tollvm' = (mapM toFun labels') 
              allAst :: AST.Module
              allAst = 
                let (LLVM tollvm) = tollvm'
                in execState tollvm emptyASTModule
              emptyASTModule = defaultModule { moduleName = "entrance"}



    toFun :: MLabel -> LLVM ()
    toFun (MLabel labelNo absMinss) =
        defFun ("LABEL" ++ (show labelno)) [llvmInssInBlock]
        where llvmInss :: Codegen [()]
              (Codegen llvmInss) = 
                mapM cgenStatement absMinss
              llvmInssInBlock :: BasicBlock
              llvmInssInBlock = 
                BasicBlock labelName codeInblock (Just (Ret Nothing))
                where labelName :: Name
                      labelName = mkName "entry"
                      codeInblock :: [Named Instruction]
                      codeInblock = reverse . stack .block $ generatedCode
                      generatedCode :: CodegenState
                      generatedCode = execState (runCodegen llvmInss) emptyCode
                      emptyCode :: CodegenState
                      emptyCode = CodegenState (BlockState []) 1


    type SymbolTable = [(String, Operand)]

    data CodegenState
    = CodegenState {
    block        :: BlockState  -- Blocks for function
    , count        :: Word                     -- Count of unnamed instructions
    } deriving Show

    data BlockState
    = BlockState {
    stack :: [Named Instruction]            -- Stack of instructions
    } deriving Show

    retType :: Type
    retType = VoidType

    pType :: Type -> Type
    pType = flip PointerType (AddrSpace 0)

    generalObjType :: Type
    generalObjType = 
        StructureType False [(IntegerType machinebit), 
                             (pType (IntegerType machinebit))]

    goTy = generalObjType

    regType :: Type
    regType = goTy

    machinebit :: Word32

    regPt :: Integer -> Operand
    regPt x = 
        ConstantOperand . 
        GlobalDefinition (pType regType) . 
        mkName . ("regPt" ++) $ show i

    constantReg :: Value -> Operand
    constantReg =
        ConstantOperand .
        GlobalDefinition (regType) .
        mkName . show

    envptpt :: Operand
    envptpt =
        ConstantOperand . 
        GlobalDefinition (pType goTy) . 
        mkName . ("envPtPt") 

    

    addDefn :: Definition -> LLVM ()
    addDefn d = do {
        defs <- gets moduleDefinition
        modify $ \s -> s {moduleDefinition defs ++ [d]}
    }



    defFun :: String -> [BasicBlock] -> LLVM ()
    defFun name blks = addDefn $ 
        GlobalDefinition $ functionDefaults {
            name = Name name
            , parameters = []
            , returnType = retType
            , basicBlocks = blks
        }

    external ::  Type -> String -> [(Type, Name)] -> LLVM ()
    external retty label argtys = addDefn $
        GlobalDefinition $ functionDefaults {
        name        = Name label
        , linkage     = L.External
        , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
        , returnType  = retty
        , basicBlocks = []
        }

    fresh :: Codegen Word
    fresh = do {
        i <- gets count
        modify $ \s -> s {count = i + 1}
        return i
    }

    instr :: Instruction -> Codegen (Operand)
    instr ins = do {
      n <- fresh
      let ref = (UnName n)
      blk <- gets block
      let i = stack blk
      modifyBlock (blk { stack = (ref := ins) : i } )
      return $ local ref
      }
    
    callinternalFunWithArg :: Type -> String -> [Operand] -> Codegen Operand
    callinternalFunWithArg ty x args =
        instr $ Call (Just Tail) CC.C [] (Right fn) args' [] []
        where fn :: Operand
              fn = ConstantOperand . 
                    GlobalReference ty . 
                    mkName $ x
              args' = map (\x -> (x, [])) args
    
    callinternalFun :: String -> Codegen Operand
    callinternalFun x = 
        instr $ Call Nothing CC.C [] (Right fn) [] [] []
        where fn :: Operand
              fn = ConstantOperand . 
                    GlobalReference retType . 
                    mkName $ x
    
    internalFunNames :: [String]
    internalFunNames = 
        ["prevEnvpt", 
         "addEnv",
         "SUC",
         "NGT",
         "NEQ",
         "NLT",
         "CEQ",
         "CEQ",
         "BEQ",
         "LEFT",
         "RIGHT",
         "APP",
         "IFJUMP",
         "CASEJUMP",
         "JUMPBACKCONT",
         "GOTOEVALBIND",
         "ADDCONTSTACKIFEXIST",
         "fieldExtract",
         "constructorOfRecord",
         "closureCons"]

    
    store :: Operand -> Operand -> Codegen Operand
    store ptr val = instr $ Store False ptr val Nothing 0 []
    
    load :: Operand -> Codegen Operand
    load ptr = instr $ Load False ptr Nothing 0 []

    addEnv :: Integer -> Codegen Operand
    addEnv 1 = callinternalFun "addEnv"
    addEnv n = 
        callinternalFun "addEnv" >> addEnv (n - 1)
    

    getPtToEnvloc :: Envloc -> Codegen Operand
    getPtToEnvloc 0 = load envptpt
    getPtToEnvloc n = do {
        spt <- getPtToEnvloc (n - 1)
        callinternalFunWithArg (pType goTy) "prevEnvpt" [spt]
        }

    setEnvContentToPt :: Operand -> Operand -> Codegen Operand
    setEnvContentToPt content ptr =
        callinternalFunWithArg VoidType "setEnvContentToPt" [content, ptr]

    extractEnvContentFromPt :: Operand -> Codegen Operand
    extractEnvContentFromPt x = 
        callinternalFunWithArg (goTy) "extractEnvContentFromPt" [x]

    getEnvContentFromEnvloc x = 
        getPtToEnvloc x >>= extractEnvContentFromPt
    
    setEnvContentToEnvloc content x =
        getPtToEnvloc x >>= (setEnvContentToPt content)


    cint :: Integer -> Operand
    cint = ConstantOperand . Int machinebit

    cgenValue :: Value -> Codegen (Operand)
    cgenValue (VVar i) = do
        envContent <- getEnvContentFromEnvloc i
        
    cgenValue (VField (TVar tyid) id) = 
        callinternalFunWithArg (goTy) "fieldExtract" [cint tyid, cint id]
    cgenValue (VConstructor tyid) =
        callinternalFunWithArg (goTy) "constructorOfRecord" [cint tyid]
    cgenValue (VClosure labelno envloc) =
        callinternalFunWithArg (goTy) "closureCons" [labelnof, cint envloc]
        where labelnof = 
            ConstantOperand .
            GlobalReference (FunctionType retType [] False) .
            mkName . ("LABEL" ++ ) $ labelno
    cgenValue (VContStack regnum entry out _) = do
        out' <- cgenValue out
        callinternalFunWithArg goTy "initContStack" [regnum', labelOfEntry, out']
        where labelOfEntry = 
            ConstantOperand .
            GlobalReference (FunctionType retType [] False) .
            mkName . ("LABEL" ++ ) $ entry
              regnum' = 
                ConstantOperand . 
                Int machinebit regnum

    cgenValue x = return . constantReg $ x

    tcall :: Integer -> String -> Codegen ()
    tcall n x = 
        init n >>= \args -> instr $ Call (Just Tail) CC.C [] (Right x') args [] []
        where init 0 = return []
              init n = do 
                l <- init (n - 1)
                t <- load $ regPt n
                return (l ++ [t])
              argsTys = map snd . zip [1..n] . repeat $ goTy
              x' = ConstantOperand . 
                   GlobalReference (FunctionType retType argsTys False) .
                   mkName . show $ x

    cgenStatement :: MachL -> Codegen ()
    cgenStatement (SetRegReg r1 r2) = do {
        i <- load (regPt 2)
        j <- store (regPt 1) i
    }

    cgenStatement (SetRegEnv r1 envloc) = do {
        envContent <- getEnvContentFromEnvloc envloc
        store (regPt r1) envContent
    }

    cgenStatement (SetEnvReg envloc r1) = do {
        i <- load (regPt r1)
        setEnvContentToEnvloc i envloc
    }

    cgenStatement (SetEnvEnv a b) = do {
        envContent <- getEnvContentFromEnvloc b
        setEnvContentToEnvloc envContent a
    }

    cgenStatement (SetReg r1 v) = do {
        got <- cgenValue v
        store (regPt r1) got
    }

    cgenStatement (SetEnv envloc v) = do {
        got <- cgenValue v
        setEnvContentToEnvloc got envloc
    }

    cgenStatement (SetEnvPt envloc) = do {
        newPtPtEnv <- getPtToEnvloc envloc
        newPtEnv <- load newPtPtEnv
        store envptpt newPtEnv
    }

    cgenStatement (EnvptToReg r1) = do {
        ptEnv <- load envptpt
        store (regPt r1) ptEnv
    }

    cgenStatement (RegToEnvpt r1) = do {
        ptEnv <- load (regPt r1)
        store envptpt ptEnv
    }

    cgenStatement (AddEnv i) = addEnv i
    
    cgenStatement APP = 
        load (regPt 0) >>= 
            \f -> callinternalFunWithArg retType "APP" [f]

    cgenStatement (JUMPBACKCONT i) = do {
        envContent <- getEnvContentFromEnvloc i
        callinternalFunWithArg retType "JUMPBACKCONT" [envContent]
    }

    cgenStatement (GOTOEVALBIND i r1) = do {
        envContent <- getEnvContentFromEnvloc i
        rct <- load $ regPt r1
        callinternalFunWithArg retType "GOTOEVALBIND" [envContent, rct]
    }

    cgenStatement (ADDCONTSTACKIFEXIST i r1) = do {
        envContent <- getEnvContentFromEnvloc i
        rct <- load $ regPt r1
        callinternalFunWithArg retType "ADDCONTSTACKIFEXIST" [envContent, rct]
    }

    cgenStatement x = 
        tcall nx x
        where nx = snd . head . filter (== x) $ internalFlist
              internalFlist = 
                [(SUC, 2),
                 (NGT, 3),
                 (NEQ, 3),
                 (NLT, 3),
                 (CEQ, 3),
                 (BEQ, 3),
                 (LEFT, 2),
                 (RIGHT, 2)
                 (IFJUMP, 3),
                 (CASEJUMP, 4)
                ]