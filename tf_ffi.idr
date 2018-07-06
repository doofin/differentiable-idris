-- http://docs.idris-lang.org/en/latest/reference/ffi.html
module Main


%lib C "tensorflow"
%include C "tensorflow/c/c_api.h"
-- %include C "/usr/include/tensorflow/c/c_api.h"
-- %link C "testlib.o"

foo : IO String
foo = foreign FFI_C "TF_Version" (IO String) 

main : IO ()
main = do 
     x<-foo
     print x
