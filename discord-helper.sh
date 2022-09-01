#!/bin/bash
# get webhook url from external file
scriptdir=$(dirname "$(readlink -f "$BASH_SOURCE")")

source ${scriptdir}/vars

# run regsho script, replace tabs with spaces so json doesn't freak out later
bash ${scriptdir}/regsho.sh |expand -t 4 >> ${scriptdir}/regsho.tmp

# add json header to file we will use with curl
echo -n '{ "content": "```' > ${scriptdir}/regsho2.tmp

# change internal field separator to newline
IFS=$'\n'

# iterate over lines of file as single line and add newline to end of each input line
for i in `cat ${scriptdir}/regsho.tmp`; do echo -n " $i\\n" >> ${scriptdir}/regsho2.tmp; done

# add json footer
echo '```"}' >> ${scriptdir}/regsho2.tmp

# post to discord
curl -X POST ${DISCORDURL1} -H "Content-Type: application/json" -d @${scriptdir}/regsho2.tmp

# cleanup
rm -f ${scriptdir}/regsho2.tmp
rm -f ${scriptdir}/regsho.tmp

exit 0
