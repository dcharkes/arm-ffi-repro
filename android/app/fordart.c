#include <stdint.h>

int test_1(const char* foo, void** out, int bar, const char *baz) {
  // same signature as sqlite3_open_v2
  return ~bar;
}

int test_2(void* stmt, int bar, int64_t baz) {
  // same signature as sqlite3_bind_int64
  return baz >> 32;
}