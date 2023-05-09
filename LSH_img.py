#!python
from datasketch import MinHash, MinHashLSH
import os
import subprocess
import re
import sys

pttrn = r'.*_birthmark_image\.txt$'

flist_A = list(filter(
  lambda x : x is not None,
  [name if re.match(pttrn, name) else None for name in os.listdir('./birthmark/')]
))

flist_B = list(filter(
  lambda x : x is not None,
  [name if re.match(pttrn, name) else None for name in os.listdir('./birthmark/obfuscated/')]
))

lsh = MinHashLSH(num_perm=1000, threshold=0.3, weights=(0.9, 0.1))
minhashes_A = [MinHash(num_perm=1000) for _ in flist_A]
minhashes_B = [MinHash(num_perm=1000) for _ in flist_B]

for i in range(len(flist_A)):
  print(i)
  fn = flist_A[i]
  minhash = MinHash(num_perm=1000)
  with open('birthmark/' + fn, "r") as f:
    for line in f:
      hash_v = int(line, base=16)
      minhashes_A[i].update(str(hash_v).encode())
  lsh.insert(fn, minhashes_A[i])

for i in range(len(flist_B)):
  print(i)
  fn = flist_B[i]
  with open('birthmark/obfuscated/' + fn, "r") as f:
    for line in f:
      hash_v = int(line, base=16)
      minhashes_B[i].update(str(hash_v).encode())
  lsh.insert(fn, minhashes_B[i])

ans = 0

for i in range(len(flist_A)):
  name = flist_A[i]
  result = lsh.query(minhashes_A[i])
  # print(name, result)
  print(name, len(result))
  ans += len(result)

for i in range(len(flist_B)):
  name = flist_B[i]
  result = lsh.query(minhashes_B[i])
  print(name, len(result))
  print(name[:64] + "_birthmark_image.txt" in result)
  ans += len(result)

print("pairs: " + str(ans))