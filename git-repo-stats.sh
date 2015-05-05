#!/bin/bash

OUTPUT_FILE="/tmp/commits-stats.csv"
REV_LIST_FILE="/tmp/rev_list.txt"
TMP_DIFF_FILE="/tmp/current_diff.txt"

rm -f ${OUTPUT_FILE}

BRANCH=$(git symbolic-ref -q HEAD)

git rev-list ${BRANCH} > ${REV_LIST_FILE}

COMMIT_COUNT=`wc -l ${REV_LIST_FILE} | awk '{ print $1 }'`

echo "There are ${COMMIT_COUNT} commits in ${BRANCH} branch"

for i in $(seq 2 $COMMIT_COUNT);
do
	INDEX_MINUS_ONE=$(expr "$i" - "1")

	COMMIT=`head -n ${INDEX_MINUS_ONE} ${REV_LIST_FILE} | tail -1`
	COMMIT_PREV=`head -n ${i} ${REV_LIST_FILE} | tail -1`

	git diff --numstat ${COMMIT_PREV} ${COMMIT} > ${TMP_DIFF_FILE}

	#echo "Computing additions..."
	LINE="`awk '{ adds += $1 } END { print adds }' ${TMP_DIFF_FILE}`"

	#echo "Computing deletions..."
	LINE="$LINE `awk '{ dels += $2 } END { print dels }' ${TMP_DIFF_FILE}`"

	#echo "Computing files..."
	LINE="$LINE `wc -l ${TMP_DIFF_FILE} | awk '{ print $1 }'`"

	echo $LINE >> ${OUTPUT_FILE}
done

rm -f ${REV_LIST_FILE}
rm -f ${TMP_DIFF_FILE}

exit;