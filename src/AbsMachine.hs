module AbsMachine where
    
    type Register = Integer
    type Envloc = Integer
    

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

    data MachL =
        | SetRegReg Register Register
        | SetRegEnv Register Envloc
        | SetEnvReg Envloc Register
        | SetEnvEnv Envloc Envloc
        | SetReg Register Value
        | SetEnv Envloc Value
        | AddEnv Integer
        | LABEL Integer
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


    

    

    
    