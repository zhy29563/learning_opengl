#include "add_two.h"

#include "add.h"

namespace AppAdd {
int AddIntTwoTimes(int a, int b, int c) {
  int temp = 0;
  temp     = ModuleAdd::AddInt(a, b);
  temp     = ModuleAdd::AddInt(temp, c);
  return temp;
}
}  // namespace AppAdd
