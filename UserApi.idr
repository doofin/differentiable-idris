module Main

import Control.Monad.Freer

%access public export
-- %default total

data Id : Type where
  IdF : (a:Type)->Id
  
data Tensor : Type where
  NumT : Int -> Tensor
  DoubleT : Double -> Tensor
-- temporary
data Shape

data GraphData : (a : Type) -> Type where 
  Mul : Tensor -> Tensor -> GraphData Tensor
  Placeholder : GraphData Tensor
  Constant : Int -> GraphData Tensor

FreeGraph : Type --type of computation graph ,freer graph
FreeGraph = Freer GraphData Tensor

newPlaceholder : FreeGraph
newPlaceholder = liftF Placeholder

exampleGraph : FreeGraph
exampleGraph = do 
  t<-newPlaceholder
  a<-liftF Placeholder -- same
  liftF (Mul t a)

const1 : GraphData Tensor
const1 = Constant 1

addG : FreeGraph
addG = do
  x<-liftF $ const1
  y<-liftF $ Constant 2
  liftF $ Mul x y

runIO : {x : Type}-> GraphData x -> IO x
runIO (Mul (NumT x) (NumT y)) = do 
  let res=x*y
  print $ "Mul x y is " ++ (show res)
  pure (NumT res)
  
runIO Placeholder = do
  print "Placeholder"
  pure (NumT 0)
  
runIO (Constant x) = do
  print $ "Constant " ++ (show x)
  pure (NumT x)
  
-- runIO xx =  pure (NumT 1)

numericGrad : {x : Type}->  GraphData Tensor->GraphData x -> IO x
numericGrad (Constant x) (Mul (NumT y) (NumT z)) = do 
  print "sadfsdf"
  -- let res : Double =((cast $ y*z) + 0.01)/((cast x)+0.01)
  pure $ DoubleT 1.0
-- numericGrad _ _ =     pure $ DoubleT 1.0

interp : FreeGraph -> IO Tensor
interp   = foldFreer runIO



mainGrad : IO ()
mainGrad = do 
  x <- (foldFreer (numericGrad const1) addG) 
  --print x
  pure ()

main : IO ()
main = mainGrad

-- main = interp addG >>= \_ => pure ()
