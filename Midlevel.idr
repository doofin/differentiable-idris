module Midlevel 


data TFops : Type where
  Placeholder : String->TFops
  
str2tfops : String -> TFops
str2tfops x = Placeholder ""

