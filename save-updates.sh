#!/bin/sh

grep Share `ls *.md | egrep -v README\|TODO` | \
awk -F: '{ print $1, $4 }' | sed -e 's/share/source/' | \
while read f u
  do
    echo "Fetching https:$u into $f"; curl -sS https:$u | \
    sed -e 's,&lt;,<,g' \
        -e 's,&gt;,>,g' \
        -e 's,<code><pre>,,g' \
        -e 's,</pre></code>,,g' \
    > $f; 
done

echo
echo "Pending changes:"
svn status
