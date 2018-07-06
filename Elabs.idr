module Elabs
import Language.Reflection.Elab

%language ElabReflection
-- https://github.com/idris-lang/Idris-dev/blob/master/libs/prelude/Language/Reflection/Elab.idr

addDecls : Elab ()
addDecls = do 
  declareType (Declare (UN "Tpe") [] (RType) )
  let xs = map (\x=>declareType (Declare (UN x) [] (RType) )) [""]
  pure ()
  

-- %runElab addDecls
-- %runElab defineFunction (DefineFun (UN "myf") [MkFunClause (Var `{{x}}) (Var `{{x}})  ])
-- %runElab `{{}}`
{- 
xxx : Tpe -> IO ()
xxx _  = do
  print ""
-}

idNat : Nat -> Nat
idNat = %runElab (do intro `{{x}}
                     fill (Var `{{x}})
                     solve)
