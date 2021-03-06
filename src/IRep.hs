module IRep where
    import AST
    --- CPS style
    data EForm =
        ENone
        | EVar Id
        | ECVar Id
        | EChr Integer
        | EZero
        | EInt Integer
        | ETrue
        | EFalse
        | EFunC Id Cont Ty TForm
        | ECont Cont TForm 
        | EField Ty Id
        | EndCont
        deriving Show

    newtype Cont = Cont Id deriving (Show, Eq)
        
    data TForm =
        TFIf EForm TForm TForm
        | TFSuc EForm EForm
        | TFDec EForm EForm
        | TFNGT EForm EForm EForm
        | TFNEQ EForm EForm EForm 
        | TFNLT EForm EForm EForm
        | TFCEQ EForm EForm EForm
        | TFApp EForm EForm 
        | TFAppc EForm EForm EForm
        | TFixApp Id Cont TForm EForm
        -- 
        | TFFixC EForm EForm 
        --
        | TFLetExt Id Ty TForm
        | TFBEQ EForm EForm EForm
        | TFLeft EForm EForm
        | TFRight EForm EForm
        | TFCase EForm EForm EForm EForm
--        | TFLetRcd Id TyId Ty [(Id, Ty)] TForm 
        | TFSeq TForm TForm 
        deriving Show
    --- Machine Style

    type Register = Integer
    type Envloc = Integer
    

    type Entrance = Integer
    type Exit = Integer
    --- Both Label Name

    type Env = Register
    --- Environment Pointer

    data Value =
        VNone
        | VZero
        | VInt Integer
        | VChr Integer
        | VTrue
        | VFalse
        | VVar Envloc
        | VDeclare Id Ty
        --- Construct a closure with Integer as label name
        --- Envloc as the environment with closure, with Envloc back
        | VClosure Integer Envloc
        | VContStack Envloc Entrance Value [Value]
        --- Responsible for the evaluation of letrec
        --- Here 'Value' must be the VClosure
        deriving (Show, Eq)

    

    data MachL =
        SetRegReg Register Register
        | SetRegEnv Register Envloc
        | SetEnvReg Envloc Register
        | SetEnvEnv Envloc Envloc
        | SetReg Register Value
        | SetEnv Envloc Value
        | SetEnvPt Envloc
        | ExtractEnvptfromclsToReg Register Register
        --- move up pointer to upper 'Envloc'
        | EnvptToReg Register
        | RegToEnvpt Register
        --- Save envpt to register and vice versa
        | AddEnv Integer
        --- Internal Func
        | SUC
        | DEC
        | NGT
        | NEQ
        | NLT
        | CEQ
        | BEQ
        | LEFT
        | RIGHT
        --- Application
        | APP
        --- Control Flow
        | IFJUMP
        | CASEJUMP
        --- About Evaluation of fixpoint
        --- Jump back to last continuation where fixpoint is asked
        --- Which should be at 'Envloc' but if it is not then it
        --- definitely at 'Register'
        | JUMPBACKCONT Envloc Register
        --- Check fixnode at envloc if need to subst
        ---- if it is, it will be subst
        | CHECKFIXNODENECESSARY Envloc
        --- JUMPBACKCONT is different from below two
        --- Below two still have to work even 
        ----- the evaluation of binding finishes
        ----- So GOTOEVALBIND is actually doing differently 
        ----- if envloc has a 
        ----- VContStack and not have one
        | GOTOEVALBIND Envloc Register
        ----- ADDCONTSTACKIFEXIST will add register into stack of
        ----- envloc if stack is there, or do nothing
        | ADDCONTSTACKIFEXIST Envloc Register
        | EXTRACTINFOIFNOTSTACK Envloc Register
        ----- Ending
        | ENDPROGRAM
        deriving (Show, Eq)


    data MLabel = MLabel Integer [MachL] 
            
    instance Show MLabel where
        show (MLabel i body) =
            "LABEL" ++ show i ++ ":" ++ "\n" 
            ++ ((foldl (\x y -> x ++ "\n" ++ y) ""). map show $ body ) 
            ++ "\n"

    instance Eq MLabel where
        (MLabel i _) == (MLabel j _) = i == j

    instance Ord MLabel where
        (MLabel i _) `compare` (MLabel j _) = i `compare` j

    reg :: Integer -> Register
    reg x = x

    

    

        