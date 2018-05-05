#include "testing_header.h"

int main(int argc, char **args) {
  int i = 10;

  _test_debug(argc, args);

  log("Debugging is enabled.");
  log("Debug level: %d", i);

}
