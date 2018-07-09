# tensorflow on idris,why?

Learn & Research dependent types with deep learning

Elaborator reflection,maybe the most advanced macro system ,will make our great statically typed functional code terse and beautiful

Utilize existing efforts on optimizations for deep learning,rather than a whole new framework

# pre
verify tf c lib is installed
```
ls /usr/lib | grep tenso

should give sth like:
libtensorflow_framework.so
libtensorflow.so

```

install idris-free package with freer

https://github.com/clayrat/idris-free (not merged yet)

then idris-emacs mode will load fine (you can look at .ipkg file)

# Run
```
idris Ffi.idr -o idr
./idr
```

which should output your installed tf version

# Overview
Construct idris computation graph with free monad approach,transform it and send to tf c api

c_api.h is the tf low level api,we can get `operations` or `op` , for exmaple,matmul,placeholders,variables,etc,with TF_newOperation . Unfortunately,there is not a type-safe list for operations. 

At high level, User defined computation graph would be optimised and then transformed to tf graph.

Elabs.idr : macros

UserApi : user level graph construction and ops ,with freer

Ffi : tf ffi bindings , link to /usr/include/tensorflow/c/c_api.h

Midlevel : anything else between userapi and FFi

# Info
Free monad:
https://github.com/idris-hackers/idris-free

https://towardsdatascience.com/gradient-descend-with-free-monads-ebf9a23bece5

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

https://stackoverflow.com/questions/44378764/hello-tensorflow-using-the-c-api

https://www.tensorflow.org/install/install_c

 `TensorFlow provides a C API defined in c_api.h, which is suitable for building bindings for other languages. The API leans towards simplicity and uniformity rather than convenience.`

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
