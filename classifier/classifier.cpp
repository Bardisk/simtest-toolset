#include <cstdio>
#include "hashtype.h"
#include <cassert>

#define MAX_CLSTR 65536
int center_cnt;
hashtype centers[MAX_CLSTR];

int main() {
  FILE *class_file = fopen("build/piclass.txt", "r");
  assert(class_file);
  ULL x;
  fscanf(class_file, "%*d");
  while(~fscanf(class_file, "%*x%llx%*d", &x)) {
    assert(center_cnt < MAX_CLSTR);
    centers[center_cnt++] = x;
  }
  while(~scanf("%llx", &x)) {
    hashtype now = x;
    int min_center_num = 0;
    hashtype min_center = centers[0];
    for (int i = 1; i < center_cnt; i++) {
      if (centers[i] - now < min_center - now) {
        min_center = centers[i];
        min_center_num = i;
      }
    }
    printf("%04x\n", min_center_num);
  }
  return 0;
}