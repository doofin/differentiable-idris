[![Join the chat at https://gitter.im/idris-gitter/Lobby](https://badges.gitter.im/idris-gitter/Lobby.svg)](https://gitter.im/idris-gitter/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# tensorflow on idris,why? (WIP!)
Learn & Research dependent types with deep learning

Elaborator reflection,maybe the most advanced macro system ,will make our great statically typed functional code terse and beautiful

Utilize existing efforts on optimizations for deep learning,rather than a whole new framework

syntax,api :

```idris
depGraph2 : FreeGraphD $ (TensorD [1],TensorD [2])
depGraph2 = do
  in1<-liftF $ PlaceholderD [1]
  out1<-liftF $ PlaceholderD [2]
  out2<-PlaceholderD [2] -- using implicits
  pure (in1,out1)

compGraphD : FreeGraphD $ TensorD [1]
compGraphD = do
  (in1,out1)<-depGraph2
  pure in1
```

# Prepare
1.verify tf c lib is installed
```
ls /usr/lib | grep tensor

should give sth like:

libtensorflow_framework.so
libtensorflow.so

```

2.install idris-free package with freer

https://github.com/idris-industry/idris-free (not merged yet)

and https://github.com/idris-industry/derive

then idris-emacs mode will load fine (you can take a look at .ipkg file)

warning! idris-free is also under active development,please check dependencies are the newest!

# Run
```
idris Ffi.idr -o idr
./idr
```

which should output your installed tf version

# Overview
Construct idris computation graph with free monad approach,transform it and send to tf c api

c_api.h is the tf low level api,we can get `operations` or `op` , for exmaple,matmul,placeholders,variables,etc,with TF_newOperation . Unfortunately,there is not a type-safe list for such operations. 

At high level, User defined computation graph would be optimised and then transformed to tf graph.

project files:

```
Elabs.idr : macros
UserApi : user level graph construction and ops ,with freer monad
Ffi : tf ffi bindings , link to /usr/include/tensorflow/c/c_api.h
Midlevel : anything else between userapi and FFi
```

# Info
Free monad:
https://github.com/idris-hackers/idris-free

https://towardsdatascience.com/gradient-descend-with-free-monads-ebf9a23bece5

https://typelevel.org/cats/datatypes/freemonad.html

haskell and scala example:

https://github.com/tensorflow/haskell/blob/master/tensorflow/src/TensorFlow/Internal/Raw.chs

https://github.com/tensorflow/haskell

https://github.com/helq/tensorflow-haskell-deptyped

https://github.com/eaplatanios/tensorflow_scala

idris ffi:

bind to c struct ! : https://github.com/idris-lang/Idris-dev/tree/master/libs/contrib/CFFI

http://docs.idris-lang.org/en/latest/tutorial/miscellany.html

http://docs.idris-lang.org/en/latest/reference/ffi.html

https://github.com/idris-lang/Idris-dev/blob/8b6f86e4291b8978c5e01a2dfd387ce695c5ff85/libs/base/Data/IORef.idr

https://github.com/idris-lang/Idris-dev/blob/24f580d45455b3fee35d0e96e48415612e58aaed/libs/prelude/IO.idr

idris elab refl:

http://www.davidchristiansen.dk/david-christiansen-phd.pdf

http://www.davidchristiansen.dk/pubs/type-directed-elaboration-of-quasiquotations.pdf

http://cattheory.com/editTimeTacticsDraft.pdf

tf c api usage:

https://stackoverflow.com/questions/44378764/hello-tensorflow-using-the-c-api

https://www.tensorflow.org/install/install_c

https://www.tensorflow.org/extend/language_bindings

`TensorFlow has many ops, and the list is not static, so we recommend generating the functions for adding ops to a graph instead of writing them by individually by hand (though writing a few by hand is a good way to figure out what the generator should generate)`

https://github.com/tensorflow/tensorflow/blob/r1.8/tensorflow/core/ops/ops.pbtxt

https://www.tensorflow.org/api_docs/python/tf/Operation

`An Operation is a node in a TensorFlow Graph that takes zero or more Tensor objects as input, and produces zero or more Tensor objects as output. Objects of type Operation are created by calling a Python op constructor (such as tf.matmul) or tf.Graph.create_op.`

# Road map

1.get idris tf ffi to work (ok)

2.implement tf ops api with free monad 

3.write your own computational graph

4.train and predict

# Looking forward for your to join!

more about idris ffi

tf c api usage

a free/freer/algebraic effects computation graph api

tf architecture

elaborator reflection

any ideas!
