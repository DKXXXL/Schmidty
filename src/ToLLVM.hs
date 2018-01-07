{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module ToLLVM where
    


    import Data.Word
    import Data.ByteString (ByteString, pack)
    import Data.ByteString.Char8 (unpack)
    import Data.String
    import Data.List
    
    import AST
    import IRep
    import Control.Monad.State
    import Control.Monad.Except
    import LLVM.AST.Constant (Constant(..))
    import qualified LLVM.AST as AST
    import LLVM.AST
    import LLVM.AST.Global
    import LLVM.AST.AddrSpace
    import LLVM.Module
    import LLVM.Context
    import qualified LLVM.AST.Linkage as L
    import qualified LLVM.AST.CallingConvention as CC

    ---- Reference : Implementing a JIT 
    ------ Compiled Language with Haskell and LLVM

    newtype LLVM a = LLVM (State AST.Module a)
        deriving (Functor, Applicative, Monad, MonadState AST.Module )

    newtype Codegen a = Codegen { runCodegen :: State CodegenState a }
        deriving (Functor, Applicative, Monad, MonadState CodegenState )

    toLLVMAsm' :: AST.Module -> IO String
    toLLVMAsm' = liftM unpack . toLLVMAsm

    toLLVMAsm :: AST.Module -> IO ByteString
    toLLVMAsm asts =
        withContext $ \context ->
              withModuleFromAST context asts $ \m -> do
              llstr <- moduleLLVMAssembly m
              return llstr

    toLLVMModule :: [MLabel] -> (AST.Module)
    toLLVMModule labels = allAst
        where labels' = reverse $ sort labels
              --- tollvm :: LLVM ()
              tollvm' = 
                defAllExternFun
                >> defAllRegs 
                >> (mapM toFun labels') 
                >> externFunCont
              allAst :: AST.Module
              allAst = 
                let (LLVM tollvm) = tollvm'
                in execState tollvm emptyASTModule
              emptyASTModule = defaultModule { moduleName = "entrance" }



    toFun :: MLabel -> LLVM ()
    toFun (MLabel labelNo absMinss) =
        decextrefs >> 
        defFun ("LABEL" ++ (show labelNo)) [llvmInssInBlock]
        where llvmInss :: Codegen [()]
              llvmInss = 
                mapM cgenStatement absMinss
              decextrefs :: LLVM [()]
              decextrefs = 
                mapM (\x -> external goTy x []) extrefs
              extrefs :: [String]
              extrefs = extfuns generatedCode
              llvmInssInBlock :: BasicBlock
              llvmInssInBlock = 
                BasicBlock labelName codeInblock (Do (Ret Nothing []))
              labelName :: Name
              labelName = mkName "entry"
              codeInblock :: [Named Instruction]
              codeInblock = reverse . stack .block $ generatedCode
              generatedCode :: CodegenState
              generatedCode = execState (runCodegen llvmInss) emptyCode
              emptyCode :: CodegenState
              emptyCode = CodegenState (BlockState []) 1 []


    

    type SymbolTable = [(String, Operand)]

    data CodegenState
        = CodegenState {
        block        :: BlockState  -- Blocks for function
        , count      :: Word                     -- Count of unnamed instructions
        , extfuns    :: [String]
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
                             (pType (IntegerType 8))]
                             --- i8* is a pointer to union?

    goTy = generalObjType

    regType :: Type
    regType = goTy

    machinebit :: Word32
    machinebit = 64

    regPt :: Integer -> Operand
    regPt x = 
        ConstantOperand . 
        GlobalReference (pType regType) . 
        mkName . ("regPt" ++) $ show x
{-}
    constantReg :: Value -> Operand
    constantReg =
        ConstantOperand .
        GlobalReference (regType) .
        mkName . show
-}
    envPt :: Operand
    envPt =
        ConstantOperand . 
        GlobalReference (pType regType) . 
        mkName $ ("envPt") 


    defReg :: Type -> String -> LLVM ()
    defReg ty vName = addDefn $
        GlobalDefinition $ globalVariableDefaults {
            name = mkName vName
            , linkage = L.Common
            , initializer = Just initial
            , LLVM.AST.Global.type' = ty
        }
        where initial = Struct Nothing False [Int machinebit 0, Null (IntegerType 8)]
    
    
    defAllRegs = mapM (defReg goTy) . allRegs $ registerNum

    defAllExternFun =
        mapM f' internalFunNames
        where f' (fName, ret, argL) =
                external ret fName argL'
                where argL' = map (\(x, y)->(x, mkName y)) argL

    registerNum = 6
    allRegs x = 
        ["envPt"] ++
        (map (("regPt" ++).show) [0..x])
    


    addDefn :: Definition -> LLVM ()
    addDefn d = do
        defs <- gets moduleDefinitions
        modify $ \s -> s {moduleDefinitions = defs ++ [d]}


--- Responsible for FFI
    externFunCont :: LLVM ()
    externFunCont =
        addDefn $ 
        GlobalDefinition $ functionDefaults {
            name = mkName "externFuncGiveCont"
            , parameters = ([Parameter goTy (mkName"cont") [], Parameter goTy (mkName "ret") []], False)
            , returnType = retType
            , basicBlocks = [llvmInssInBlock]
        }
        where local = LocalReference goTy
              cont = local (mkName "cont")
              result = local (mkName "ret")
              labelName = mkName "entry"
              llvmInssInBlock :: BasicBlock
              llvmInssInBlock = 
                BasicBlock labelName codeInblock (Do (Ret Nothing []))
              codeInblock :: [Named Instruction]
              codeInblock = reverse . stack .block $ generatedCode
              generatedCode :: CodegenState
              generatedCode = execState (runCodegen codegenbody) emptyCode
              emptyCode :: CodegenState
              emptyCode = CodegenState (BlockState []) 1 []
              codegenbody :: Codegen ()
              codegenbody = do
                        store (regPt 0) cont
                        store (regPt 1) result
                    >> (cgenStatement APP)
              


    defFun :: String -> [BasicBlock] -> LLVM ()
    defFun name' blks = addDefn $ 
        GlobalDefinition $ functionDefaults {
            name = mkName name'
            , parameters = ([], False)
            , returnType = retType
            , basicBlocks = blks
        }

    external ::  Type -> String -> [(Type, Name)] -> LLVM ()
    external retty label argtys = addDefn $
        GlobalDefinition $ functionDefaults {
        name        = mkName label
        , linkage     = L.External
        , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
        , returnType  = retty
        , basicBlocks = []
        }


    fresh :: Codegen Word
    fresh = do 
        i <- gets count
        modify $ \s -> s {count = i + 1}
        return i
    

    modifyBlock :: BlockState -> Codegen ()
    modifyBlock x = do
            modify $ \s -> s {block = x}

    instr :: Type -> Instruction -> Codegen (Operand)
    instr VoidType ins = do 
            blk <- gets block
            let i = stack blk
            modifyBlock (blk { stack = (Do ins) : i } )
            return $ cint $ 0
    instr ty ins = do 
            n <- fresh
            let ref = (UnName n)
            blk <- gets block
            let i = stack blk
            modifyBlock (blk { stack = (ref := ins) : i } )
            return $ local ref
      where local = LocalReference ty
    
    getexternSchmidty :: Id -> Ty -> Codegen Operand
    getexternSchmidty i ty = do
        extrefs <- gets extfuns
        modify $ \s -> s {extfuns = callingname: extrefs} 
        callexternalFun callingname
        where fname = idToVarName i
              callingname = "getExt" ++ fname

    callinternalFunWithArg :: Type -> String -> [Operand] -> Codegen Operand
    callinternalFunWithArg ty x args =
        instr ty $ Call (Just Tail) CC.C [] (Right fn) args' [] []
        where fn :: Operand
              fn = ConstantOperand . 
                    GlobalReference (pType (FunctionType ty argTys False)) . 
                    mkName $ x
              args' = map (\x -> (x, [])) args
              argTys = (map fst) . (\(x,y,z) -> z) $ signature
              signature = head  . filter ((== x). (\(x,y,z)->x)) $ internalFunNames
    


    callexternalFun :: String -> Codegen Operand
    callexternalFun fname =
        instr goTy $ Call (Just Tail) CC.C [] (Right fn) [] [] []
        where fn :: Operand
              fn = ConstantOperand . 
                    GlobalReference (pType (FunctionType goTy [] False)) . 
                    mkName $ fname
    gft = pType (FunctionType retType [] False)

    internalFunNames :: [(String, Type, [(Type, String)])]
    internalFunNames = 
        [("prevEnvshellByEnvshell", (goTy), [((goTy), "envshell")]),
         ("addEnv", goTy, [((goTy), "env")]),
         ("SUC", goTy, [((goTy), "x")]),
         ("DEC", goTy, [((goTy), "x")]),
         ("NGT", goTy, [((goTy), "x"),(goTy, "y")]),
         ("NEQ", goTy, [((goTy), "x"),(goTy, "y")]),
         ("NLT", goTy, [((goTy), "x"),(goTy, "y")]),
         ("CEQ", goTy, [((goTy), "x"),(goTy, "y")]),
         ("BEQ", goTy, [((goTy), "x"),(goTy, "y")]),
         ("LEFT", goTy, [((goTy), "x")]),
         ("RIGHT", goTy, [((goTy), "x")]),
         ("APP", VoidType, [((goTy), "x")]),
         ("IFJUMP", goTy, [((goTy), "crit"),(goTy, "tb"),(goTy, "fb")]),
         ("CASEJUMP", goTy, [((goTy), "crit"),(goTy, "lb"),(goTy, "rb"), (goTy, "cont")]),
         ("JUMPBACKCONT", goTy, [((goTy), "fixinfo")]),
         ("GOTOEVALBIND", goTy, [((goTy), "fixinfo"), ((goTy), "maybeCont")]),
         ("ADDCONTSTACKIFEXIST", VoidType, [((goTy), "fixinfo"), ((goTy), "cont")]),
         ("constInteger", goTy, [((IntegerType machinebit), "x")]),
         ("closureCons", goTy, [(gft, "f"), ((goTy), "env")]),
         ("initContStack", goTy, [(goTy, "entrance"), (goTy, "exit")]),
         ("setEnvContentToPt", VoidType, [(goTy, "envContent"), (goTy, "envPt")]),
         ("extractEnvContentFromPt", goTy, [(goTy, "envPt")]),
         ("ExtractEnvshellfromcls", goTy, [(goTy, "cls")]),
         ("extractSumType", goTy, [(goTy, "sum")]),
         ("ENDPROGRAM", VoidType, [(goTy, "res")]),
         ("CHECKFIXNODENECESSARY", goTy, [(goTy, "fixnode"), (goTy, "maybe")])]

    
    store :: Operand -> Operand -> Codegen Operand
    store ptr val = instr VoidType $ Store False ptr val Nothing 0 []
    
    load :: Operand -> Codegen Operand
    load ptr = instr goTy $ Load False ptr Nothing 0 []

    addEnv :: Integer -> Operand -> Codegen Operand
    addEnv 1 x = callinternalFunWithArg (goTy) "addEnv" [x]
    addEnv n x = 
        callinternalFunWithArg (goTy) "addEnv" [x] >>= addEnv (n - 1)
    

    getEnvshellatEnvloc :: Envloc -> Codegen Operand
    getEnvshellatEnvloc 0 = load envPt
    getEnvshellatEnvloc n = do 
        spt <- getEnvshellatEnvloc (n - 1)
        callinternalFunWithArg (goTy) "prevEnvshellByEnvshell" [spt]
        

    setEnvContentToPt :: Operand -> Operand -> Codegen Operand
    setEnvContentToPt content ptr =
        callinternalFunWithArg VoidType "setEnvContentToPt" [content, ptr]

    extractEnvContentFromPt :: Operand -> Codegen Operand
    extractEnvContentFromPt x = 
        callinternalFunWithArg (goTy) "extractEnvContentFromPt" [x]

    getEnvContentFromEnvloc x = do
        pt <- getEnvshellatEnvloc x
        extractEnvContentFromPt pt

    setEnvContentToEnvloc content x = do
        pt <- getEnvshellatEnvloc x
        setEnvContentToPt content pt


    cint :: Integer -> Operand
    cint = ConstantOperand . Int machinebit

    cgenValue :: Value -> Codegen (Operand)
    cgenValue (VVar i) =  getEnvContentFromEnvloc i
    cgenValue (VInt i) =
        callinternalFunWithArg (goTy) "constInteger" [cint i]
    cgenValue (VDeclare i ty) = do
        getexternSchmidty i ty
    cgenValue (VClosure labelno envloc) = do
        envShell <- getEnvshellatEnvloc envloc
        callinternalFunWithArg (goTy) "closureCons" [labelnof, envShell]
        where labelnof = 
                    ConstantOperand .
                    GlobalReference gft .
                    mkName . ("LABEL" ++ ) $ show labelno
    cgenValue (VContStack envloc entry out _) = do
                entrance <- cgenValue (VClosure entry envloc)
                out' <- cgenValue out
                callinternalFunWithArg goTy "initContStack" [entrance, out']
{-        where labelOfEntry = 
                    ConstantOperand .
                    GlobalReference (FunctionType retType [] False) .
                    mkName . ("LABEL" ++ ) $ show entry -}

    cgenValue VTrue = 
        callinternalFunWithArg (goTy) "constInteger" [cint 1]

    cgenValue VFalse = 
        callinternalFunWithArg (goTy) "constInteger" [cint 0]

    cgenValue (VChr i) = 
        callinternalFunWithArg (goTy) "constInteger" [cint i]

    cgenValue VNone = 
        callinternalFunWithArg (goTy) "constInteger" [cint 0]
    tcall :: Integer -> String -> Codegen ()
    tcall n x = do
                    args <- init n 
                    let args' = zip args (repeat [])
                    result <- instr goTy $ Call Nothing CC.C [] (Right x') args' [] []
                    cont <- load $ regPt (n + 1)
                    store (regPt 0) cont
                    store (regPt 1) result
            >> (cgenStatement APP)
        where init 0 = return []
              init n = do 
                l <- init (n - 1)
                t <- load $ regPt n
                return (l ++ [t])
              argsTys = map snd . zip [1..n] . repeat $ goTy
              x' = ConstantOperand . 
                   GlobalReference (pType (FunctionType goTy argsTys False)) .
                   mkName  $ x

    cgenStatement :: MachL -> Codegen ()
    cgenStatement (SetRegReg r1 r2) = do 
                i <- load (regPt 2)
                store (regPt 1) i
                return ()
    

    cgenStatement (SetRegEnv r1 envloc) = do 
                envContent <- getEnvContentFromEnvloc envloc
                store (regPt r1) envContent
                return ()
    

    cgenStatement (SetEnvReg envloc r1) = do
        i <- load (regPt r1)
        setEnvContentToEnvloc i envloc
        return ()


    cgenStatement (SetEnvEnv a b) = do
            envContent <- getEnvContentFromEnvloc b
            setEnvContentToEnvloc envContent a
            return ()


    cgenStatement (SetReg r1 v) = do
            got <- cgenValue v
            store (regPt r1) got
            return ()


    cgenStatement (SetEnv envloc v) = do
            got <- cgenValue v
            setEnvContentToEnvloc got envloc
            return ()

    cgenStatement (SetEnvPt envloc) = do 
        newEnvshell <- getEnvshellatEnvloc envloc
        store envPt newEnvshell
        return ()

    cgenStatement (ExtractEnvptfromclsToReg r1 r2) = do 
        cls <- load (regPt r1)
        clsenvpt <- callinternalFunWithArg (goTy) "ExtractEnvshellfromcls" [cls]
        store (regPt r2) clsenvpt
        return ()
    

    cgenStatement (EnvptToReg r1) = do
            envShell <- load envPt
            store (regPt r1) envShell
            return ()

    cgenStatement (RegToEnvpt r1) = do
            envShell <- load (regPt r1)
            store envPt envShell
            return ()


    cgenStatement (AddEnv i) = do 
            envShell <- load envPt
            newShell <- addEnv i envShell
            store envPt newShell
            return ()
            
    
    
    cgenStatement APP = do 
        cls <- load $ regPt 0
        clsenvpt <- callinternalFunWithArg (goTy) "ExtractEnvshellfromcls" [cls]
        store envPt clsenvpt
        callinternalFunWithArg retType "APP" [cls]
        return ()

    cgenStatement (JUMPBACKCONT i) = do 
        envContent <- getEnvContentFromEnvloc i
        cont <- callinternalFunWithArg goTy "JUMPBACKCONT" [envContent]
        store (regPt 0) cont
        >> (cgenStatement APP)

    cgenStatement (CHECKFIXNODENECESSARY i) = do
        fixnodeContent <- getEnvContentFromEnvloc i
        maysubst <- load $ regPt 1
        shouldbe <- callinternalFunWithArg goTy "CHECKFIXNODENECESSARY" [fixnodeContent, maysubst]
        setEnvContentToEnvloc shouldbe i
        return ()

    cgenStatement (GOTOEVALBIND i r1) = do 
        envContent <- getEnvContentFromEnvloc i
        maybecont <- load $ (regPt r1)
        cont <- callinternalFunWithArg goTy "GOTOEVALBIND" [envContent, maybecont]
        store (regPt 0) cont
        >> (cgenStatement APP)

    cgenStatement (ADDCONTSTACKIFEXIST i r1) = do 
        envContent <- getEnvContentFromEnvloc i
        rct <- load $ regPt r1
        callinternalFunWithArg retType "ADDCONTSTACKIFEXIST" [envContent, rct]
        return ()

    cgenStatement (ENDPROGRAM) = do 
        res <- load $ regPt 1
        callinternalFunWithArg VoidType "ENDPROGRAM" [res]
        return ()
    
    cgenStatement (IFJUMP) = do
        crit <- load $ regPt 1
        tb <- load $ regPt 2
        fb <- load $ regPt 3
        cb <- callinternalFunWithArg goTy "IFJUMP" [crit, tb, fb]
        store (regPt 0) cb
        >> (cgenStatement APP)

    cgenStatement (CASEJUMP) = do 
                crit <- load $ regPt 1
                lb <- load $ regPt 2
                rb <- load $ regPt 3
                cont <- load $ regPt 4
                x <- callinternalFunWithArg goTy "extractSumType" [crit]
                cb <- callinternalFunWithArg goTy "CASEJUMP" [crit, lb, rb]
                store (regPt 0) cb
                store (regPt 1) x
                store (regPt 2) cont
            
            >> (cgenStatement APP)
        

    cgenStatement x = 
        tcall nx (show x)
        where nx = snd . head . filter ((== x). fst) $ internalFlist
              internalFlist = 
                [(SUC, 1),
                 (DEC, 1),
                 (NGT, 2),
                 (NEQ, 2),
                 (NLT, 2),
                 (CEQ, 2),
                 (BEQ, 2),
                 (LEFT, 1),
                 (RIGHT, 1)
                ]