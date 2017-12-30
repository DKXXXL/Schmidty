module IRep where

    --- CPS style
    data EForm =
        | ENone
        | EVar Id
        | ECVar Id
        | EZero
        | ETrue
        | EFalse
        | EFunC Id Cont Ty TForm
        | ECont Cont TForm 
        | EField Ty Id

    newtype Cont = Cont Id
        
    data TForm =
        | TFIf EForm TForm TForm
        | TFSuc EForm EForm
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
        | TFLet Id Ty EForm TForm
        | TFBEQ EForm EForm EForm
        | TFLeft EForm EForm
        | TFRight EForm EForm
        | TFCase EForm EForm EForm EForm
        | TFLetRcd Id TyId Ty [(Id, Ty)] TForm 
        | TFSeq TForm TForm 

    --- Machine Style

    type Register = Integer
    type Envloc = Integer
    

    type Entrance = Integer
    type Exit = Integer
    --- Both Label Name

    type Env = Register
    --- Environment Pointer

    data Value =
        | VNone
        | VZero
        | VTrue
        | VFalse
        | VVar Envloc
        | VField Ty Id
        | VConstructor TyId
        --- Construct a closure with Integer as label name
        --- Envloc as the environment with closure, with Envloc back
        | VClosure Integer Envloc
        | VContStack Env Entrance Value [Value]
        --- Responsible for the evaluation of letrec
        --- Here 'Value' must be the VClosure
        deriving (Show, Eq)

    

    data MachL =
        | SetRegReg Register Register
        | SetRegEnv Register Envloc
        | SetEnvReg Envloc Register
        | SetEnvEnv Envloc Envloc
        | SetReg Register Value
        | SetEnv Envloc Value
        | SetEnvPt Envloc
        --- move up pointer to upper 'Envloc'
        | EnvptToReg Register
        | RegToEnvpt Register
        --- Save envpt to register and vice versa
        | AddEnv Integer
        --- Internal Func
        | SUC
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
        | IFJUMP Register Register Register
        | CASEJUMP Register Register Register Register
        --- About Evaluation of fixpoint
        | JUMPBACKCONT Envloc
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
        deriving (Show, Eq)


    data MLabel = MLabel Integer [MachL]
    
    reg :: Integer -> Register
    reg x = x

    

    

        