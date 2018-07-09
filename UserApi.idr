module UserApi

import Control.Monad.Freer


data Tensor -- temporary

data Edge : Type where
     Placeholder : Edge
     Constant : Tensor -> Edge

data Pgraph : (a : Type) -> Type where 
     Matmul : Edge -> Edge -> Pgraph Edge
--     Sum : Edge -> Edge -> Pgraph

Cgraph : Type --type of computation graph 
Cgraph = Freer Pgraph Edge

matmul : Edge -> Edge -> Cgraph
matmul e1 e2 = liftF (Matmul e1 e2)
