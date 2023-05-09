#!python -i
import os
import re
pttrn = r'.*_birthmark_text\.bin$'
flist = list(filter(
  lambda x : x is not None,
  [name if re.match(pttrn, name) else None for name in os.listdir('./birthmark/')]
))

inverted_list = {}
for i in range(len(flist)):
  fn = flist[i]
  file_set = set()
  with open('birthmark/' + fn, "rb") as f:
    while True:
      value = f.read(8)
      if not value:
        break
      hash_v = int.from_bytes(value, byteorder='little')
      # print("{:016x}".format(hash_v))
      if hash_v not in file_set:
        file_set.add(hash_v)
        if hash_v not in inverted_list:
          inverted_list[hash_v] = 1
        else:
          inverted_list[hash_v] += 1

for typename in sorted(inverted_list):
  print("{:016x} {}".format(typename, inverted_list[typename]))
# for typenum in range(2**16):
#   if typenum not in inverted_list:
#     print("{:04x} {}".format(typenum, 0))
#   else:
#     print("{:04x} {}".format(typenum, inverted_list[typenum]))