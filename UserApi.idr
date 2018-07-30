module UserApi

import Control.Monad.Freer
import Debug.Trace
import Control.Monad.Id
import Data.Fin
import Control.Monad.State

%access public export
%default total
||| currently,some explorations on building computational graphs.
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


||| dependent version
data TensorD : List Nat -> Type where
  MkTensorD : TensorD xs

data GraphDataD : Type -> Type where 
  InD : (s : List Nat) -> GraphDataD $ TensorD s -- graph input,like Placeholder
  OutD : (s : List Nat) -> GraphDataD $ TensorD s -- graph output
  TrainableD : (s : List Nat) -> GraphDataD $ TensorD s -- variable in tf
  MulD : TensorD s -> TensorD s -> GraphDataD $ TensorD s
  VecMulD : TensorD [v] -> TensorD [v,_] -> GraphDataD $ TensorD [v] -- vec `mul` matrix ,safely
  MapD : TensorD x -> (TensorD x->TensorD x)->GraphDataD $ TensorD x -- for efficiency,pass map to tf c lib  

tensorRank : TensorD x -> Nat
tensorRank {x=s} _ = length s

tensor1 : TensorD [1,2,3]
tensor1 = MkTensorD

tensorShape1 : TensorD a -> List Nat
tensorShape1 {a=zz} MkTensorD = zz

depGraph1 : GraphDataD $ TensorD [1,2,3]
depGraph1 = MulD tensor1 MkTensorD

FreeGraphD : Type->Type --type of computation graph ,freer graph
FreeGraphD a = Freer GraphDataD a

implicit liftd : GraphDataD a -> Freer GraphDataD a
liftd = liftF

depGraph2 : FreeGraphD $ (TensorD [1],TensorD [1])
depGraph2 = do
  in1<-liftF $ InD [1]
  out1<-liftF $ InD [1]
  out2<-InD [2] -- using implicits
  pure (in1,out1)

compGraphD : FreeGraphD $ TensorD [1]
compGraphD = do
  (in1,out1)<-depGraph2
  MulD in1 in1

interp1 : {x : Type}-> GraphDataD x -> State String x
interp1 (InD s) = ST (\x => Id (MkTensorD, x++" in "++ (show s)++" "))
interp1 (OutD s) = ST (\s => Id (MkTensorD, s++" out "))
interp1 (TrainableD s) = ST (\s => Id (MkTensorD, s++" train "))
interp1 (MulD x y) = ST (\s => Id (MkTensorD, s++" mul "))
interp1 (VecMulD y z) = ST (\s => Id (MkTensorD, s++" vec "))
interp1 (MapD y f) = ST (\s => Id (MkTensorD, s++" map "))
-- FreeGraph : Type --type of computation graph ,freer graph
-- FreeGraph = Freer GraphData Tensor
