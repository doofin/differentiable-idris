# tensorflow on idris,why?

a chance to learn dependent types with deep learning

elaborator reflection,maybe the most advanced macro system ,will make our great statically typed functional code terse and beautiful

Utilize existing efforts on optimizations for deep leanring,rather than a whole new framework,and tensorflow is the most popular one.However,python is really not my love

# Run
```
idris Ffi.idr -o idr
./idr
```

which should output your installed tf version

# Overview
construct idris computation graph with free monad approach,transform it and send to tf c api

# pre
verify tf c lib is installed
```
ls /usr/lib | grep tenso

should give sth like:
libtensorflow_framework.so
libtensorflow.so

```
# Info
haskell example:

https://github.com/tensorflow/haskell/blob/master/tensorflow/src/TensorFlow/Internal/Raw.chs

https://github.com/tensorflow/haskell

https://github.com/helq/tensorflow-haskell-deptyped

idris ffi:

http://docs.idris-lang.org/en/latest/tutorial/miscellany.html

http://docs.idris-lang.org/en/latest/reference/ffi.html

idris elab refl:

http://www.davidchristiansen.dk/david-christiansen-phd.pdf

http://www.davidchristiansen.dk/pubs/type-directed-elaboration-of-quasiquotations.pdf

tf c api:

https://www.tensorflow.org/install/install_c

 `TensorFlow provides a C API defined in c_api.h, which is suitable for building bindings for other languages. The API leans towards simplicity and uniformity rather than convenience.`

# Road map

1.get idris tf ffi to work (ok)

2.implement tf ops api with free monad 

3.write your own computational graph

4.train and predict

# Looking forward for your to join!

more about idris ffi

a free/freer/algebraic effects computation graph api

tf architecture

elaborator reflection

any ideas!
