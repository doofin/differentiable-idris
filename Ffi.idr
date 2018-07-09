module Main

%lib C "tensorflow"
%include C "tensorflow/c/c_api.h"
-- %include C "/usr/include/tensorflow/c/c_api.h"
-- %link C "testlib.o"

-- data TF_Tensor
-- IO (Raw TF_Tensor) works,but c warns assignment from incompatible pointer type
-- data TF_Status

TF_Status : Type
TF_Status = Ptr -- attention!

-- Tfs : Raw TF_Status
-- Tfs = MkRaw TF_Status


tfNewStatus : IO TF_Status
tfNewStatus = foreign FFI_C "TF_NewStatus" (IO TF_Status) 

tfVersion : IO String
tfVersion = foreign FFI_C "TF_Version" (IO String) 

main : IO ()
main = do 
     x<-tfVersion
     s<-tfNewStatus
     putStrLn x
