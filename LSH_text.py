#!python
from datasketch import MinHash, MinHashLSH
import os
import subprocess
import re
import sys

pttrn = r'.*_birthmark_text\.bin$'

flist_A = list(filter(
  lambda x : x is not None,
  [name if re.match(pttrn, name) else None for name in os.listdir('./birthmark/')]
))

flist_B = list(filter(
  lambda x : x is not None,
  [name if re.match(pttrn, name) else None for name in os.listdir('./birthmark/obfuscated/')]
))

lsh = MinHashLSH(num_perm=1000, threshold=0.9, weights=(0.3, 0.7))
minhashes_A = [MinHash(num_perm=1000) for _ in flist_A]
minhashes_B = [MinHash(num_perm=1000) for _ in flist_B]

for i in range(len(flist_A)):
  print(i)
  fn = flist_A[i]
  minhash = MinHash(num_perm=1000)
  with open('birthmark/' + fn, "rb") as f:
    while True:
      value = f.read(8)
      if not value:
        break
      hash_v = int.from_bytes(value, byteorder='little')
      minhashes_A[i].update(str(hash_v).encode())
  lsh.insert(fn, minhashes_A[i])

for i in range(len(flist_B)):
  print(i)
  fn = flist_B[i]
  with open('birthmark/obfuscated/' + fn, "rb") as f:
    while True:
      value = f.read(8)
      if not value:
        break
      hash_v = int.from_bytes(value, byteorder='little')
      minhashes_B[i].update(str(hash_v).encode())
  lsh.insert(fn, minhashes_B[i])

for i in range(len(flist_A)):
  name = flist_A[i]
  result = lsh.query(minhashes_A[i])
  # print(name, result)
  print(name, len(result))

for i in range(len(flist_B)):
  name = flist_B[i]
  result = lsh.query(minhashes_B[i])
  print(name, result)
  print(name[:64] + "_birthmark_text.bin" in result)