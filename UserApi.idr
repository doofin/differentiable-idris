module UserApi

data Tensor -- temporary

data Edge : Type where
     Placeholder : Edge
     Constant : Tensor -> Edge

data Pgraph : (a : Type) -> Type where 
     Matmul : Edge -> Edge -> Pgraph Edge
--     Sum : Edge -> Edge -> Pgraph
implementation Functor Pgraph where
  map f m = ?aa
-- temporary                              
data Free : (f : Type -> Type) -> (a : Type) -> Type where
  Pure : a -> Free f a
  Bind : f (Free f a) -> Free f a

Functor f => Functor (Free f) where
  map f m = assert_total $ case m of
    Pure x => Pure (f x)
    Bind x => Bind (map (map f) x)

Functor f => Applicative (Free f) where
  pure = Pure

  m <*> x = assert_total $ case m of
    Pure f => map f x
    Bind f => Bind (map (<*> x) f)

Functor f => Monad (Free f) where
  m >>= f = assert_total $ case m of
    Pure x => f x
    Bind x => Bind (map (>>= f) x)

liftFree : Functor f => f a -> Free f a
liftFree = assert_total $ Bind . map Pure

Cgraph : Type --type of computation graph 
Cgraph = Free Pgraph Edge

matmul : Edge -> Edge -> Cgraph
matmul e1 e2 = liftFree (Matmul e1 e2)
