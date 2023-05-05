#!/bin/bash
APKNAME=$(basename $1 .apk)
APKDIR=apkout/${APKNAME}
echo begin process $1
if [ -f birthmark/${APKNAME}_birthmark_image.txt ] && [ -f birthmark/${APKNAME}_birthmark_text.bin ]; then
  echo birthmark already exists, nothing to do.
  exit 0
fi
#depackage
if [ -d ${APKDIR} ]; then 
  echo "${APKDIR} already exists! skip depackaging..."
else
  if apktool d -s $1 -o ${APKDIR}; then
    echo succeed\ depkg\ $1
  else
    echo depackage failed!
    rm -r ${APKDIR}
    exit 1
  fi
fi
#generate image birthmark
if [ -f birthmark/${APKNAME}_birthmark_image.txt ]; then
  echo birthmark \(img\) already exists, skipping...
else
  if [ -f ${APKDIR}/hashlist.txt ]; then 
    rm ${APKDIR}/hashlist.txt
  fi
  echo processing ${APKDIR} images
  for fn in $(find ${APKDIR}/res -name '*.png') $(find ${APKDIR}/assets -name '*.png'); do
    python dhash.py $fn >> ${APKDIR}/hashlist.txt
  done
  build/classifier <${APKDIR}/hashlist.txt >${APKDIR}/classifiedhashlist.txt;
  cat ${APKDIR}/classifiedhashlist.txt >birthmark/${APKNAME}_birthmark_image.txt
fi
if [ -f birthmark/${APKNAME}_birthmark_text.bin ]; then
  echo birthmark \(txt\) already exists, skipping...
else
  if [ -f ${APKDIR}/txtall.txt ]; then 
    rm ${APKDIR}/txtall.txt
  fi
  echo processing ${APKDIR} texts
  for fn in $(find ${APKDIR}/res -name '*.xml') $(find ${APKDIR}/assets -name '*.xml'); do
    cat $fn >> ${APKDIR}/txtall.txt
  done
  simtxt/build/simtxt -is -D ${APKDIR} <${APKDIR}/txtall.txt
  cp ${APKDIR}/g1.bm birthmark/${APKNAME}_birthmark_text.bin
fi
rm -r ${APKDIR}