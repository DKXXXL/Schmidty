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

    

    

        