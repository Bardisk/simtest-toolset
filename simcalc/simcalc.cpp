#include <cstdio>
#include <unordered_set>
#include <getopt.h>
#include <cassert>
char *fn1, *fn2;
#ifdef EXTEND_HASH
  using hash_type = unsigned long long;
  #define PRH "%llx"
#else
  using hash_type = unsigned short;
  #define PRH "%hx"
#endif

std::unordered_set <hash_type> A, B, U;

int main(int argc, char *argv[]) {
  int opt;
  while(~(opt = getopt(argc, argv, "a:b:"))) {
    switch (opt)
    {
    case 'a':
      fn1 = optarg;
      break;
    case 'b':
      fn2 = optarg;
      break;
    default:
      return -1;
      break;
    }
  }
  FILE *fa = fopen(fn1, "r");
  FILE *fb = fopen(fn2, "r");
  assert(fa);
  assert(fb);

  hash_type hash;
  while (~fscanf(fa, PRH, &hash)) {
    A.insert(hash);
    U.insert(hash);
  }
  while (~fscanf(fb, PRH, &hash)) {
    B.insert(hash);
    U.insert(hash);
  }
  printf("%.4lf\n", (A.size() + B.size() - U.size() + 0.0) / U.size());
}