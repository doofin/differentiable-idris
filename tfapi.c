#include <stdio.h>
#include "c_api.h"

int main() {
  printf("Hello from TensorFlow C library version %s\n", TF_Version());
  return 0;
}
