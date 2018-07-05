///http://docs.idris-lang.org/en/latest/reference/ffi.html
Module TFffi
%include C "testlib.h"
%link C "testlib.o"
foo : Int -> IO Int
foo x = foreign FFI_C "foo" (Int -> IO Int) x

main : IO ()
main = do x <- foo 42
putStrLn ("foo 42 ---> " ++ show x)
