module CPS where
    import AST
    import IRep
    import Data.IORef 
    import System.IO.Unsafe


    type Kont = EForm

    -- Variable
    
    cpsTransform :: Tm -> TForm
    cpsTransform x =
        cps (unsafePerformIO (newIORef 2)) x EndCont

    cps :: Counter -> Tm -> Kont -> TForm
    cps ct MNone kont =
        (TFApp kont ENone)
    
    cps ct (MIf crit ba bb) kont =
        let ba' = cps ct ba kont
            bb' = cps ct bb kont
            xc = unsafePerformIO $ accCt ct
        in let xi = Cont xc
               x = ECVar xc
        in cps ct crit (ECont xi (TFIf x ba' bb'))

    cps ct (MVar id) kont =
        (TFApp kont (EVar id))
    
    cps ct (MZero) kont = 
        (TFApp kont (EZero))
    
    cps ct (MInt i) kont =
        (TFApp kont (EInt i))
    
    cps ct (MSuc a) kont =
        let xc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               x = ECVar xc
        in cps ct a (ECont xi (TFSuc x kont))

    cps ct (MDec a) kont =
        let xc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               x = ECVar xc
        in cps ct a (ECont xi (TFDec x kont))
    
    cps ct (MNGT a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps ct b (ECont yi (TFNGT x y kont))
        in cps ct a (ECont xi kont1)

    cps ct (MNEQ a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps ct b (ECont yi (TFNEQ x y kont))
        in cps ct a (ECont xi kont1)

    cps ct (MNLT a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps ct b (ECont yi (TFNLT x y kont))
        in cps ct a (ECont xi kont1)

    cps ct (MChr i) kont =
        TFApp kont (EChr i)
    
    cps ct (MCEQ a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps ct b (ECont yi (TFCEQ x y kont))
        in cps ct a (ECont xi kont1)

    cps ct (MFun i ty body) kont =
        let xc = unsafePerformIO $ accCt ct
        in let xi = Cont xc
               x = ECVar xc
        in let body' = cps ct body x
        in TFApp kont (EFunC i xi ty body')
    
    cps ct (MApp a b) kont =
        let fc = unsafePerformIO $ accCt ct 
            xc = unsafePerformIO $ accCt ct 
        in let fi = Cont fc 
               xi = Cont xc
               f = ECVar fc
               x = ECVar xc
        in let kont1 = cps ct b (ECont xi (TFAppc f x kont))
        in cps ct a (ECont fi kont1)

    cps ct (MLet i ty bind body) kont =
        let ibind = unsafePerformIO $ accCt ct
            ibind' = unsafePerformIO $ accCt ct
        in let ibindi = Cont ibind
               ibindx = ECVar ibind
               ibindi' = Cont ibind'
               ibindx' = ECVar ibind'
               bodyTF = cps ct body kont
        in TFixApp 
            i ibindi 
            (cps ct bind ibindx) 
            (ECont ibindi' (TFLet i ty ibindx' bodyTF))
    
    cps ct (MLetExt i ty body) kont =
        TFLetExt i ty (cps ct body kont)

    cps ct (MTrue) kont =
        TFApp kont ETrue
    
    cps ct MFalse kont = 
        TFApp kont EFalse

    cps ct (MBEQ a b) kont =
        let xc = unsafePerformIO $ accCt ct 
            yc = unsafePerformIO $ accCt ct 
        in let xi = Cont xc 
               yi = Cont yc
               x = ECVar xc
               y = ECVar yc
        in let kont1 = cps ct b (ECont yi (TFBEQ x y kont))
        in cps ct a (ECont xi kont1)

    cps ct (MLeft l _) kont =
        let xc = unsafePerformIO $ accCt ct
        in let x = ECVar xc
               xi = Cont xc
        in cps ct l (ECont xi (TFLeft x kont))

    cps ct (MRight _ r) kont =
        let xc = unsafePerformIO $ accCt ct
        in let x = ECVar xc
               xi = Cont xc
        in cps ct r (ECont xi (TFRight x kont))

    cps ct (MCase crit lb rb) kont =
        let xc = unsafePerformIO $ accCt ct
        in let x = ECVar xc
               xi = Cont xc
        in let (TFApp _ lb') = cps ct lb ETrue
               (TFApp _ rb') = cps ct rb ETrue
        in cps ct crit (ECont xi (TFCase x lb' rb' kont))
    
    cps ct (MLetRcd cons ty suty rcd body) kont =
        cps ct (MLet cons (TInfer 0) (consConstructor rcd) body) kont
        where consConstructor :: [(Id, Ty)] -> Tm
              consConstructor [] = MFun 1 TNat (MVar 1)
              consConstructor ((_, ty):x) = MFun 1 ty (consConstructor x)
    
    cps ct (MField ty fld) kont =
        TFApp kont (EField ty fld)
    
    cps ct (MSeq pre post) kont =
        TFSeq (cps ct pre EndCont) (cps ct post kont)

    cps ct (MCallFix i) kont =
        TFFixC (EVar i) kont