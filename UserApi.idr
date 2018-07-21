module UserApi

import Control.Monad.Freer
import Debug.Trace
import Control.Monad.Id
import Data.Fin

%access public export
%default total

-- non dependent version,for testing only.see below for dependent version
data Tensor : Type where
  DoubleT : Double -> Tensor

implementation Show Tensor where
  show (DoubleT x) = show x

data GraphData : Type -> Type where 
  Mul : Tensor -> Tensor -> GraphData Tensor
  Placeholder : GraphData Tensor
  Constant : Double -> GraphData Tensor

FreeGraph : Type --type of computation graph ,freer graph
FreeGraph = Freer GraphData Tensor

implicit gt2fg : GraphData Tensor -> FreeGraph
gt2fg = liftF

--check this at repl!
exampleGraph : FreeGraph
exampleGraph = do 
  t<-liftF Placeholder 
  a<-liftF Placeholder 
  b<-Placeholder -- same,with implicits
  liftF (Mul t a)

--another example
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

--try do some gradients,not ok yet
const1 : GraphData Tensor
const1 = Constant 1

mainGradId : Id String
mainGradId = do 
  x <- (foldFreer ((trace "xxx" numericGradId) const1) mulG) 
  --print x
  pure $ show x


-- dependent version
data TensorD : List Nat -> Type where
  MkTensorD : TensorD xs

data GraphDataD : Type -> Type where 
  MulD : TensorD s -> TensorD s -> GraphDataD $ TensorD $ s ++ [1]
  PlaceholderD : (s : List Nat) -> GraphDataD $ TensorD s
  VecMulD : TensorD [v] -> TensorD [v,_] -> GraphDataD $ TensorD [v] -- vec `mul` matrix ,safely
  
p1 : GraphDataD $ TensorD [1]
p1 = PlaceholderD [1]

depTs1 : TensorD [1,2,3]
depTs1 = MkTensorD

computeDepT : TensorD a -> List Nat
computeDepT {a=zz} MkTensorD = zz

depGraph1 : GraphDataD $ TensorD [1,2,3,1]
depGraph1 = MulD depTs1 MkTensorD
-- FreeGraph : Type --type of computation graph ,freer graph
-- FreeGraph = Freer GraphData Tensor
