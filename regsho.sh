#!/bin/bash
baseurl=http://www.nasdaqtrader.com/dynamic/symdir/regsho/nasdaqth
today=$(date +%Y%m%d.txt)
day_of_week=`date +%w`

# check if it's the weekend
if [[ $day_of_week == 6 ]] || [[ $day_of_week == 7 ]] ; then
  # it's the weekend so just exit silently
  exit 0
fi

# if it's monday, look back to friday
if [[ $day_of_week == 1 ]] ; then
  look_back=3
else
  look_back=1
fi

# macos doesn't use gnu date so tweak how we look back
if [[ $(uname) == Darwin ]]; then
  yesterday=$(date -v-${look_back}d +'%Y%m%d.txt')
else
  yesterday=$(date -d "$look_back day ago" +'%Y%m%d.txt')
fi

# output/diff everything
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

exit 0
