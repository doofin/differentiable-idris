module UserApi

import Control.Monad.Freer
import Debug.Trace
import Control.Monad.Id

%access public export
%default total

data Tensor : Type where
  DoubleT : Double -> Tensor

implementation Show Tensor where
  show (DoubleT x) = show x
  
-- temporary
data Shape

data GraphData : Type -> Type where 
  Mul : Tensor -> Tensor -> GraphData Tensor
  Placeholder : GraphData Tensor
  Constant : Double -> GraphData Tensor

FreeGraph : Type --type of computation graph ,freer graph
FreeGraph = Freer GraphData Tensor

implicit gt2fg : GraphData Tensor -> FreeGraph
gt2fg = liftF

newPlaceholder : FreeGraph
newPlaceholder = liftF Placeholder

exampleGraph : FreeGraph
exampleGraph = do 
  t<-newPlaceholder
  a<-liftF Placeholder -- same
  b<-Placeholder -- same
  liftF (Mul t a)

const1 : GraphData Tensor
const1 = Constant 1

mulG : FreeGraph
mulG = do
  x<-liftF $ Constant 1
  y<-liftF $ Constant 3
  liftF $ Mul x y

numericGradId : {x : Type}->  GraphData Tensor->GraphData x -> Id x
numericGradId Placeholder (Mul x y) =  pure $ DoubleT  2.0
numericGradId (Constant z) (Mul (DoubleT x) (DoubleT y)) =  
  let res : Double =(x*y + 0.1)/(z+0.1) in
  pure $ trace (show z ++ "," ++show x) $ DoubleT res
numericGradId (Mul x y) (Mul (DoubleT z) (DoubleT w)) = pure $ DoubleT 3.0
numericGradId _ (Constant x) = pure $ DoubleT 3.0
numericGradId _ Placeholder = pure $ DoubleT 4.0


mainGradId : Id String
mainGradId = do 
  x <- (foldFreer ((trace "xxx" numericGradId) const1) mulG) 
  --print x
  pure $ show x

