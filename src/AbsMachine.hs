module AbsMachine where
    
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
        | IF Register Register Register
        | LEFTTHENJUMP Register Register

    data MLabel = MLabel Integer [MachL]


    

    

    
    