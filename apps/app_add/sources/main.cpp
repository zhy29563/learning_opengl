#include <iostream>

#include "add_two.h"

#ifdef ENABLE_TEST_CPU_GPERFTOOLS
#include <gperftools/profiler.h>

#include <csignal>
#include <cstdlib>
#endif
#include <chrono>
#include <thread>

int main() {
#ifdef ENABLE_TEST_CPU_GPERFTOOLS
  (void)atexit([] { ProfilerStop(); });
#endif

#ifdef ENABLE_TEST_CPU_GPERFTOOLS
  ProfilerStart("app_add.prof");
#endif

#if defined(ENABLE_TEST_HEAP_GPERFTOOLS) || defined(ENABLE_TEST_HEAP_VALGRIND)
  int* p = new int[10];  // 测试内存泄漏
#endif

#if defined(ENABLE_TEST_CPU_GPERFTOOLS) || defined(ENABLE_TEST_HEAP_GPERFTOOLS) || defined(ENABLE_TEST_CPU_GPROF) || \
    defined(ENABLE_TEST_CPU_PROF) || defined(ENABLE_TEST_HEAP_VALGRIND)
  for (size_t i = 0; i < 10000000; i++) {
#endif
    int a = 100;
    int b = 10;
    int c = 20;
    AppAdd::AddIntTwoTimes(a, b, c);
    // std::cout << "add two = " << AppAdd::AddIntTwoTimes(a, b, c) << std::endl;
#if defined(ENABLE_TEST_CPU_GPERFTOOLS) || defined(ENABLE_TEST_HEAP_GPERFTOOLS) || defined(ENABLE_TEST_CPU_GPROF) || \
    defined(ENABLE_TEST_CPU_PROF) || defined(ENABLE_TEST_HEAP_VALGRIND)
#if defined(ENABLE_TEST_CPU_PROF)
    std::this_thread::sleep_for(std::chrono::microseconds(1));
#endif
  }
#endif

  return EXIT_SUCCESS;
}
