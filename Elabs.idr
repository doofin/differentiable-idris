module Elabs
import Language.Reflection.Elab
import Derive.Show

%language ElabReflection
-- https://github.com/idris-lang/Idris-dev/blob/master/libs/prelude/Language/Reflection/Elab.idr

addDecls : Elab ()
addDecls = do 
--  declareType (Declare (UN "Tpe") [] (RType) )
--  intro `{{x}}
--  declareType $ Declare `{{FF}} []  RType
  declareDatatype $ Declare `{{FF}} []  RType
  defineDatatype $ DefineDatatype `{{FF}} []
--  let xs = map (\x=>declareType (Declare (UN x) [] (RType) )) [""]
  pure ()
  
-- data FF
%runElab addDecls

xx : FF -> ()
xx x = ()

%runElab (deriveShow `{{FF}})
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
