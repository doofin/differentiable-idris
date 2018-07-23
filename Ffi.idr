module Main

%lib C "tensorflow"
%include C "tensorflow/c/c_api.h"
-- %include C "/usr/include/tensorflow/c/c_api.h"
-- %link C "testlib.o"

-- data TF_Tensor
-- IO (Raw TF_Tensor) works,but c warns assignment from incompatible pointer type
-- data TF_Status2:(a:Type)->Type where --safer way
--  TF_Status22:TF_Status2 Ptr

TF_Status : Type
TF_Status = Ptr -- attention!

-- Tfs : Raw TF_Status
-- Tfs = MkRaw TF_Status


tfNewStatus : IO TF_Status
tfNewStatus = foreign FFI_C "TF_NewStatus" (IO TF_Status) 

tfGetCode : TF_Status ->IO Int
tfGetCode = foreign FFI_C "TF_Code" (TF_Status ->IO Int) 

tfVersion : IO String
tfVersion = foreign FFI_C "TF_Version" (IO String) 

|||Always returns an empty string if TF_GetCode(s) is  TF_OK.
tfMessage : TF_Status -> IO String
tfMessage = foreign FFI_C "TF_Message" (TF_Status -> IO String)

TF_Buffer : Type
TF_Buffer = Ptr

TF_Library : Type
TF_Library = Ptr

||| Get the OpList of OpDefs defined in the library pointed by lib_handle,like matmul,placeholder,etc
tfGetOpList : TF_Library->IO TF_Buffer 
tfGetOpList = foreign FFI_C "TF_GetOpList" (TF_Library->IO TF_Buffer )

main : IO ()
main = do 
     ver<-tfVersion
     s<-tfNewStatus
     msg<-tfMessage s
     putStrLn $ "tfMessage is : " ++ msg
     putStrLn $ "tfVersion is : " ++ ver
