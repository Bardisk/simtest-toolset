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

#ifndef MULTI
std::unordered_set <hash_type> A, B, U;
#else
std::unordered_multiset <hash_type> A, B, U;
#endif

bool is_text = false;

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

#ifdef BIN_BIRTHMARK
  FILE *fa = fopen(fn1, "rb");
  FILE *fb = fopen(fn2, "rb");
#else
  FILE *fa = fopen(fn1, "r");
  FILE *fb = fopen(fn2, "r");
#endif
  
  assert(fa);
  assert(fb);

  hash_type hash;
#ifdef BIN_BIRTHMARK
  while (fread(&hash, sizeof(hash_type), 1, fa) == 1) {
    A.insert(hash);
    U.insert(hash);
  }
  while (fread(&hash, sizeof(hash_type), 1, fb) == 1) {
    B.insert(hash);
#ifdef MULTI
    if (U.count(hash) < B.count(hash))
      U.insert(hash);
#else
    U.insert(hash);
#endif
  }
#else
  while (~fscanf(fa, PRH, &hash)) {
    A.insert(hash);
    U.insert(hash);
  }
  while (~fscanf(fb, PRH, &hash)) {
    B.insert(hash);
#ifdef MULTI
    if (U.count(hash) < B.count(hash))
      U.insert(hash);
#else
    U.insert(hash);
#endif
  }
#endif
  if (U.size() < 100) printf("2.0\n");
  else printf("%.4lf\n", (A.size() + B.size() - U.size() + 0.0) / U.size());
  // printf("%d %d %d\n", A.size(), B.size(), U.size());
}