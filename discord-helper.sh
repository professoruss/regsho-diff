#!/bin/bash
# get webhook url from external file
source vars

# run regsho script, replace tabs with spaces so json doesn't freak out later
bash ./regsho.sh |expand -t 4 >> regsho.tmp

# add json header to file we will use with curl
echo -n '{ "content": "```' > regsho2.tmp

# change internal field separator to newline
IFS=$'\n'

# iterate over lines of file as single line and add newline to end of each input line
for i in `cat regsho.tmp`; do echo -n " $i\\n" >> regsho2.tmp; done

# add json footer
echo '```"}' >> regsho2.tmp

# post to discord
curl -X POST ${DISCORDURL1} -H "Content-Type: application/json" -d @regsho2.tmp

# cleanup
rm -f regsho2.tmp
rm -f regsho.tmp

exit 0
