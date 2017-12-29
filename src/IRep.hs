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
        | VContStack Entrance Exit [Exit]
        --- Responsible for the evaluation of letrec

    

    data MachL =
        | SetRegReg Register Register
        | SetRegEnv Register Envloc
        | SetEnvReg Envloc Register
        | SetEnvEnv Envloc Envloc
        | SetReg Register Value
        | SetEnv Envloc Value
        | AddEnv Integer
        --- Internal Func
        | DESTRU Register Register
        --- Destruct for Sum
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
        | CASEJUMP Register Register Register

    data MLabel = MLabel Integer [MachL]
    
    reg :: Integer -> Register
    reg x = x

    

    

        