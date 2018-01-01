module Macro (macroTransformer, carefulOperator) where
import Parsing2 
import Data.List (foldl')

type MacroT = SStruc -> (SStruc,Bool)

macroTransformer :: SStruc -> SStruc
macroTransformer = falsethenend allT
  where falsethenend t = \x -> case t x of (x', False) -> x'
                                           (x', True) -> falsethenend t x'
        allT = makeallT allT'
        everywhereT :: MacroT -> MacroT
        everywhereT t = everywhereT' `combineTs` t
          where everywhereT' :: MacroT
                everywhereT' (SList x) =
                  let res :: [(SStruc,Bool)]
                      res = map (everywhereT' `combineTs` t) x
                  in (SList $ map fst res,
                      foldl' (||) False $ map snd res)
                everywhereT' x = t x
        makeallT :: [MacroT] -> (MacroT)
        makeallT (x:y) = foldl' combineTs x y
        combineTs t1 t2 = (\x ->
                            let (x' ,res1) = t2 x
                            in case res1 of False -> t1 x'
                                            True -> case t1 x' of (x'',_) -> (x'', True))
        allT' =
          map everywhereT
          --          $ [quoteTransformer,beginTransformer]
          $[{-beginTransformer,-}appcurried, lamcurried, binaried]

{-
beginTransformer (SList ((SAtom "begin"):x)) =
  (SList [SList ((SAtom "lambda"):(SList []):x)] ,True)

beginTransformer x = (x,False)
-}

binOps  = [SAtom "begin", SAtom "->", SAtom "TSum"]

isin :: Eq a => a -> [a] -> Bool
isin x (y:z) = (x == y) || (isin x z)
isin x [] = False

intOps = binOps ++ [SAtom "lambda", 
      SAtom "if", SAtom "suc", SAtom "dec",
      SAtom "ceq", SAtom "beq", SAtom "let",
      SAtom "letrcd", SAtom "letext", SAtom "Record",
      SAtom "left", SAtom "right",
      SAtom ">",  SAtom "<", SAtom "="]

carefulOperator :: SStruc -> Bool 
carefulOperator x = x `isin` intOps

binOperator :: SStruc -> Bool
binOperator x = x `isin` binOps

appcurried :: MacroT
appcurried (SList (x:y:[])) = 
  (SList (x:y:[]), False)

appcurried (SList (x:y:z)) = 
  if (carefulOperator x) 
    then (SList (x:y:z), False)
    else (SList (SList (x:y:[]):z), True)

appcurried x = (x, False)

lamcurried :: MacroT
lamcurried (SList ((SAtom "lambda"): (SList (x:y:z)): body)) =
  ((SList [SAtom "lambda", 

            (SList (x:[])), 

            SList ([SAtom "lambda", 
                    SList (y:z)] ++ body)] ), True)

lamcurried x = (x, False)


binaried :: MacroT
binaried (SList (x:y:z:[])) =
  ((SList (x:y:z:[])), False)
binaried (SList (x:y:z:a)) =
  if (binOperator x) 
    then (SList (x:y:(SList (x:z:a):[])), True) 
    else (SList (x:y:z:a), False)

binaried x = (x, False)

