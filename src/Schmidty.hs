module Schmidty where
    import AST as AST
    import LLVM.AST as LAST
    import CPS as CPS
    import IRep as IR
    import NameEli as NE
    import NameReassign as NR
    import Typing as Ty 
    --- import TypeInfer as Ti

    passToLLVMModule :: String -> LAST.Module


    passToLLVMAssembly :: String -> IO ByteString

    jitRunning :: String -> IO ()

