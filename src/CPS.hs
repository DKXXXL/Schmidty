module CPS where

    data EForm =
        | ENone
        | EVar Id
        | EZero
        | ETrue
        | EFalse
        | EFunC Id Cont Ty TForm
        | ECont Cont Ty TForm 

    newtype Cont = Cont Id
        
    data TForm =
        | TFNone
        | TFIf EForm TForm TForm
        | TFVar Id
        | TFZero
        | TFSuc EForm 
        | TFNGT EForm EForm 
        | TFNEQ EForm EForm
        | TFNLT EForm EForm
        | TFChr Integer
        | TFCEQ EForm EForm 
        | TFFunC Id Cont Ty TForm
        | TFCont Cont Ty TForm 
        | TFApp EForm EForm 
        | TFAppc EForm EForm EForm
        | TFLet Id Ty EForm TForm
        | TFTrue 
        | TFFalse
        | TFBEQ EForm EForm 
        | TFLeft EForm
        | TFRight EForm 
        | TFCase EForm EForm EForm 
        | TFLetRcd Id TyId Ty [(Id, Ty)] TForm 
        | TFField Ty Id
        | TFSeq TForm TForm 

    type Kont = EForm

    -- Variable
    xc = 0
    yc = xc + 1
    zc = yc + 1
    xi = Cont xc
    yi = Cont yc
    zi = Cont zc 
    x = EVar xc
    y = EVar yc
    z = EVar zc

    cps :: Tm -> Kont -> TForm
    cps MNone kont =
        (TFApp kont MNone)
    
    cps (MIf crit ba bb) kont =
        let ba' = cps ba kont
            bb' = cps bb kont
        in cps crit (EFCont x (TFIf x ba' bb'))

    cps (MVar Id) kont =
        (TFApp kont (EVar Id))
    
    cps (MZero) kont = 
        (TFApp kont (EZero))
    
    cps (MSuc a) kont =
        cps a (ECont x (TFApp kont ()))