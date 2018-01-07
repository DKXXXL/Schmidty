module Main where
    import AST as AST
    import AbsMachine as AM
    import ToAST as ToAST
    import ToLLVM as ToLLVM
    import LLVM.AST as LAST
    import CPS as CPS
    import IRep as IR
    import NameEli as NE
    import Parsing2 as P
    import Macro as M
    import NameReassign as NR
    import Typing as Ty 
    --- import TypeInfer as Ti

    import System.Environment


    import Data.IORef
    import System.IO.Unsafe
    import System.IO (stdin, stdout, hPutStr, hGetContents)

    toTm :: String -> AST.Tm
    toTm = ToAST.toAst . M.macroTransformer . P.parser

    toNameConflictResolution :: AST.Tm -> AST.Tm
    toNameConflictResolution = 
        NR.tynameConflictResolution . NR.nameConflictResolution

    hasType :: AST.Tm -> Maybe AST.Ty
    hasType = Ty.has_type

    toTmDecoration :: AST.Tm -> AST.Tm
    toTmDecoration = 
        NR.decorateFixCall . NR.fieldNameFixCall

    type ExtDict = AST.Dict Id Id

    toAbsMachineL :: ExtDict -> AST.Tm -> [IR.MLabel]
    toAbsMachineL d = 
         (AM.toAbsMachL d) . NE.nameElimination . CPS.cpsTransform

{-
    toLLVMModule :: [IR.MLabel] -> LAST.Module
    toLLVMModule = ToLLVM.toLLVMModule

    toLLVMAsm :: LAST.Module -> IO ByteString
    toLLVMAsm = ToLLVM.toLLVMAsm
-}
    -------- Declaration Completed.

    preCompilation = toNameConflictResolution . toTm

    typeChecking = (/= Nothing) . hasType

    compilation extdict = (toAbsMachineL extdict) . toTmDecoration

    genLLVM = 
        toLLVMAsm' . 
        toLLVMModule

    compile :: String -> IO String
    compile src =
        let !precompiled = preCompilation src
        in let !extInfo = unsafePerformIO . readIORef $ (NR.us_extDict)
        in if (typeChecking precompiled) 
            then genLLVM . (compilation extInfo) $ precompiled
            else error "Type Checking Failed."  

    compile' :: String -> IO String
    compile' src =
        let !precompiled = preCompilation src
        in let !extInfo = unsafePerformIO . readIORef $ (NR.us_extDict)
        in if (typeChecking precompiled) 
            then return . show . (compilation extInfo) $ precompiled
            else error "Type Checking Failed."  

    main = do
        args <- getArgs
        input <- hGetContents stdin 
        output <- (if ((length args > 0) && ((args !! 0) == "-absM")) 
                  then compile' input
                  else compile input)
  
        hPutStr stdout output
    
    -- jitRunning :: String -> IO ()

