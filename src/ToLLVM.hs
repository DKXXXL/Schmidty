module ToLLVM where

    import LLVM.AST

    ---- Reference : Implementing a JIT 
    ------ Compiled Language with Haskell and LLVM

    newtype LLVM a = LLVM (State AST.Module a)
        deriving (Functor, Applicative, Monad, MonadState AST.Module )

    newtype Codegen a = Codegen { runCodegen :: State CodegenState a }
        deriving (Functor, Applicative, Monad, MonadState CodegenState )


    type SymbolTable = [(String, Operand)]

    data CodegenState
    = CodegenState {
    block        :: BlockState  -- Blocks for function
    , symtab       :: SymbolTable              -- Function scope symbol table
    , count        :: Word                     -- Count of unnamed instructions
    } deriving Show

    data BlockState
    = BlockState {
    idx   :: Int                            -- Block index
    , stack :: [Named Instruction]            -- Stack of instructions
    , term  :: Maybe (Named Terminator)       -- Block terminator
    } deriving Show

    retType :: Type
    retType = VoidType

    regType :: Type


    reg :: Integer -> Operand
    reg x = 
        ConstantOperand . 
        GlobalDefinition regType . 
        mkName . ("regPt" ++) $ show i

    envpt :: Operand
    envpt =
        ConstantOperand . 
        GlobalDefinition regType . 
        mkName . ("envPt") 

    addDefn :: Definition -> LLVM ()
    addDefn d = do {
        defs <- gets moduleDefinition
        modify $ \s -> s {moduleDefinition defs ++ [d]}
    }



    defFun :: [BasicBlock] -> LLVM ()
    defFun blks = addDefn . 
        GlobalDefinition $ functionDefaults {
            name = Name "entry"
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
         "ADDCONTSTACKIFEXIST" ]

    internalFuns = 

    externFun = external retType "entry" []

    fresh :: Codegen Word
    fresh = do {
        i <- gets count
        modify $ \s -> s {count = i + 1}
        return i
    }

    instr :: Instruction -> Codegen (Operand)
    instr ins = do{
      n <- fresh
      let ref = (UnName n)
      blk <- gets block
      let i = stack blk
      modifyBlock (blk { stack = (ref := ins) : i } )
      return $ local ref
      }

    store :: Operand -> Operand -> Codegen Operand
    store ptr val = instr $ Store False ptr val Nothing 0 []
    
    load :: Operand -> Codegen Operand
    load ptr = instr $ Load False ptr Nothing 0 []

    

    getPtToEnvloc :: Envloc -> Codegen Operand
    getPtToEnvloc 0 = return $ envpt
    getPtToEnvloc n = do {
        spt <- getPtToEnvloc (n - 1)

        }
        where prevEnvpt :: Instruction
              prevEnvpt = 

    callInternalFunc :: String 

    cgenValue :: Value -> Codegen (Operand)
    cgenValue 

    cgenStatement :: MachL -> Codegen ()
    cgenStatement (SetRegReg r1 r2) = do {
        i <- load (regPt 2)
        j <- store (regPt 1) i
    }

    cgenStatement (SetRegEnv)

