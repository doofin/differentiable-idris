module Midlevel 
import UserApi
import Control.Monad.Freer

%access public export

data TFops : Type where
  Placeholder : String->TFops
  
str2tfops : String -> TFops
str2tfops x = Placeholder ""

runFreeGraph : FreeGraph -> IO ()
runFreeGraph (Pure x) = pure ()
runFreeGraph (Bind _ _) = pure ()

