module UserApi

import Control.Monad.Freer

data Tensor -- temporary
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
