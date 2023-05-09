#!python -i
import os
import subprocess
import re
import sys
pttrn = r'.*_birthmark_text\.bin$'
flist = list(filter(
  lambda x : x is not None,
  [name if re.match(pttrn, name) else None for name in os.listdir('./birthmark/')]
))
# os.system('rm simlist.log')
for i in range(len(flist)):
  for j in range(i + 1, len(flist)):
    print("{} {}".format(i, j), file=sys.stderr)
    result = subprocess.run('build\\simcalc_txt.exe -a birthmark/{} -b birthmark/{}'.format(flist[i], flist[j]), shell=True, capture_output=True, text=True)
    print(float(result.stdout))