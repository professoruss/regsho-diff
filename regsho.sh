#!/bin/bash
baseurl=http://www.nasdaqtrader.com/dynamic/symdir/regsho/nasdaqth
today=$(date +%Y%m%d.txt)

day_or_week=`date +%w`
if [ $day_or_week == 1 ] ; then
  look_back=3
else
  look_back=1
fi

if [[ $(uname) == Darwin ]]; then
  yesterday=$(date -v-${look_back}d +'%Y%m%d.txt')
else
  yesterday=$(date -d "$look_back day ago" +'%Y%m%d.txt')
fi

echo "--------------------"
echo "     R E G S H O    "
echo "REMOVED   |    ADDED"
echo "--------------------"
diff -W 22 -y --suppress-common-lines \
  <(curl -s ${baseurl}${yesterday} | awk -F \| '{print $1}'|sed -e '1d' -e '$d')\
  <(curl -s ${baseurl}${today} | awk -F \| '{print $1}'|sed -e '1d' -e '$d')
echo "--------------------"
echo "  FULL REGSHO LIST"
echo "--------------------"
curl -s ${baseurl}${today} | awk -F \| '{print $1}'|sed -e '1d' -e '$d'
echo "--------------------"
