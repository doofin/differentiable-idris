# tensorflow on idris,why?

a chance to learn dependent types with deep learning

elaborator reflection,maybe the most advanced macro system ,will make our great statically typed functional code terse and beautiful

Utilize existing efforts on optimizations for deep leanring,rather than a whole new framework,and tensorflow is the most popular one.However,python is really not my love

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
# How to
haskell example:

https://github.com/tensorflow/haskell/blob/master/tensorflow/src/TensorFlow/Internal/Raw.chs

https://github.com/tensorflow/haskell

https://github.com/helq/tensorflow-haskell-deptyped

use idris c ffi to link to tf:
https://www.tensorflow.org/install/install_c

(which says: `TensorFlow provides a C API defined in c_api.h, which is suitable for building bindings for other languages. The API leans towards simplicity and uniformity rather than convenience.` )

# Road map
1.get idris tf ffi to work

2.implement tf ops api with free monad 

3.write your own computational graph

4.train and predict

# Looking forward for your to join!

more about idris ffi

tf architecture

elaborator reflection

any ideas!
