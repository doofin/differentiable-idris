module UserApi

import Control.Monad.Freer

%access public export

data Tensor : Type where
  NumT : Int -> Tensor
-- temporary
data Shape

data GraphData : (a : Type) -> Type where 
  Mul : Tensor -> Tensor -> GraphData Tensor
  Placeholder : GraphData Tensor
  Constant : Shape -> GraphData Tensor

FreeGraph : Type --type of computation graph ,freer graph
FreeGraph = Freer GraphData Tensor

newPlaceholder : FreeGraph
newPlaceholder = liftF Placeholder

exampleGraph : FreeGraph
exampleGraph = do 
  t<-newPlaceholder
  a<-liftF Placeholder -- same
  liftF (Mul t a)

runIO : {x : Type}-> GraphData x -> IO x
runIO x@(Mul x y) = do 
  print "Mul x y"
  pure (NumT 1)
runIO Placeholder = do
  print "Placeholder"
  pure (NumT 2)
runIO (Constant x) = do
  print "Constant" 
  pure (NumT 3)

interp : FreeGraph -> IO Tensor
interp   = foldFreer runIO

main : IO ()
main = interp exampleGraph >>= \_ => pure ()
