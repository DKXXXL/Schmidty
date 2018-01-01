module CPS where
    import AST
    import IRep


    type Kont = EForm

    -- Variable
    


    cps :: Counter -> Tm -> Kont -> TForm
    cps ct MNone kont =
        (TFApp kont MNone)
    
    cps ct (MIf crit ba bb) kont =
        let ba' = cps ba kont
            bb' = cps bb kont
            xc = unsafePerformIO $ accCt ct
        in let xi = Cont xc
               x = ECVar xc
        in cps crit (ECont xi (TFIf x ba' bb'))

    cps (MVar Id) kont =
        (TFApp kont (EVar Id))
    
    cps (MZero) kont = 
        (TFApp kont (EZero))
    
    cps (MInt i) kont =
        (TFApp kont (EInt i))
    
    cps (MSuc a) kont =
        let xc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               x = ECVar xc
        in cps a (ECont xi (TFSuc x kont))
    
    cps (MNGT a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps b (ECont yi (TFNGT x y kont))
        in cps a (ECont xi kont1)

    cps (MNEQ a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps b (ECont yi (TFNEQ x y kont))
        in cps a (ECont xi kont1)

    cps (MNLT a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps b (ECont yi (TFNLT x y kont))
        in cps a (ECont xi kont1)

    cps (MChr i) kont =
        TFApp kont (EChr i)
    
    cps (MCEQ a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps b (ECont yi (TFCEQ x y kont))
        in cps a (ECont xi kont1)

    cps (MFun i T body) kont =
        let xc = unsafePerformIO $ accCt ct
        in let xi = Cont xc
               x = ECVar xc
        in let body' = cps body x
        in TFApp kont (EFunC i xi T body')
    
    cps (MApp a b) kont =
        let fc = unsafePerformIO $ accCt ct 
            xc = unsafePerformIO $ accCt ct 
        in let fi = Cont fc 
               xi = Cont xc
               f = ECVar fc
               x = ECVar xc
        in let kont1 = cps b (ECont xi (TFAppC f x kont))
        in cps a (ECont fi kont1)

    cps (MLet i ty bind body) kont =
        let ibind = unsafePerformIO $ accCt ct
            ibind' = unsafePerformIO $ accCt ct
        in let ibindi = Cont ibind
               ibindx = ECVar ibind
               ibindi' = Cont ibind'
               ibindx' = ECVar ibind'
               bodyTF = cps body kont
        in TFixApp 
            i ibindi 
            (cps bind ibindx) 
            (ECont ibindi' (TFLet i ty ibindx' bodyTF))
    
    cps (MLetExt i ty body) kont =
        TFLetExt i ty (cps body kont)

    cps (MTrue) kont =
        TFApp kont ETrue
    
    cps MFalse kont = 
        TFApp kont EFalse

    cps (MBEQ a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps b (ECont yi (TFBEQ x y kont))
        in cps a (ECont xi kont1)

    cps (MLeft l RT) kont =
        let xc = unsafePerformIO $ accCt ct
        in let x = ECVar xc
               xi = Cont xc
        in cps l (ECont xi (TFLeft x kont))

    cps (MRight LT r) kont =
        let xc = unsafePerformIO $ accCt ct
        in let x = ECVar xc
               xi = Cont xc
        in cps r (ECont xi (TFRight x kont))

    cps (MCase crit lb rb) kont =
        let xc = unsafePerformIO $ accCt ct
        in let x = ECVar xc
               xi = Cont xc
        in let (TFApp _ lb') = cps lb ETrue
               (TFApp _ rb') = cps rb ETrue
        in cps crit (ECont xi (TFCase x lb' rb' kont))
    
    cps (MLetRcd cons ty suty rcd body) kont =
        cps (MLet cons TInfer (consConstructor rcd) body) kont
        where consConstructor :: [(Id, Ty)] -> Tm
              consConstructor [] = MFun 1 TNat (MVar 1)
              consConstructor ((_, ty):x) = MFun 1 ty (consConstructor x)
    
    cps (MField ty fld) kont =
        TFApp kont (EField ty fld)
    
    cps (MSeq pre post) kont =
        let xc = unsafePerformIO $ accCt ct
        in let x = ECVar xc
               xi = Cont xc
        in TFSeq (cps pre (ECont xi x)) (cps post kont)

    cps (MCallFix i) kont =
        TFFixC (EVar i) kont