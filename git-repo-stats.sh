#!/bin/bash

OUTPUT_FILE="/tmp/commits-stats.csv"
REV_LIST_FILE="/tmp/rev_list.txt"
TMP_DIFF_FILE="/tmp/current_diff.txt"

rm -f ${OUTPUT_FILE}

BRANCH=$(git symbolic-ref -q HEAD)

GIT_COMMAND="git rev-list ${BRANCH}"

${GIT_COMMAND} > ${REV_LIST_FILE}

COMMIT_COUNT=`wc -l ${REV_LIST_FILE} | awk '{ print $1 }'`

echo "There are ${COMMIT_COUNT} commits in ${BRANCH} branch"

echo "addedLines deletedLines modifiedFiles" >> ${OUTPUT_FILE}

for i in $(seq 1 $COMMIT_COUNT);
do
	COMMIT=`head -n ${i} ${REV_LIST_FILE} | tail -1`

	git show ${COMMIT} --pretty=tformat: --numstat > ${TMP_DIFF_FILE}

	#echo "Computing additions..."
	ADDED_LINES="`awk '{ adds += $1 } END { print adds }' ${TMP_DIFF_FILE}`"

	#echo "Computing deletions..."
	DELETED_LINES="`awk '{ dels += $2 } END { print dels }' ${TMP_DIFF_FILE}`"

	#echo "Computing files..."
	MODIFIED_FILES="`wc -l ${TMP_DIFF_FILE} | awk '{ print $1 }'`"

	if [ "${MODIFIED_FILES}" == "0" ]; then
		echo "Avoiding commit[${i}] with SHA ${COMMIT} as it is a merge or is empty"
	else
		echo "${ADDED_LINES} ${DELETED_LINES} ${MODIFIED_FILES}" >> ${OUTPUT_FILE}
	fi
done

rm -f ${REV_LIST_FILE}
rm -f ${TMP_DIFF_FILE}

exit;