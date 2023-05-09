#!python -i
import os
import subprocess
import re
import sys
pttrn = r'.*_birthmark_text\.bin$'
flist = list(filter(
  lambda x : x is not None,
  [name if re.match(pttrn, name) else None for name in os.listdir('./birthmark/obfuscated/')]
))
# os.system('rm simlist.log')
for i in range(len(flist)):
  result = subprocess.run('build\\simcalc_txt.exe -a birthmark/obfuscated/{} -b birthmark/{}'.format(flist[i], flist[i][:64] + "_birthmark_text.bin"), shell=True, capture_output=True, text=True)
  # print(result)
  print(float(result.stdout))