#!/bin/bash

function usage() {
	echo "Usage : $0 [--help] [--output <output file>] [--branch <git branch>] [--since <amount of time>]"
	echo "--output: (Optional) Location for the output file. If no output file is set, then the file will be saved in temporary folder."
	echo "--branch: (Optional) branch to gather commits metrics. If no branch is set, current branch will be used."
	echo "--since: (Optional) Specify the amount of time since metrics will be gathered. It uses same syntax as 'git --since=' command, but w/o the 'equals' signo."
	exit 1;
}

OUTPUT_FILE="/tmp/commits-stats.csv"
BRANCH=$(git symbolic-ref -q HEAD)
SINCE=""

while [ "$1" != "" ]; do
	case $1 in
		--help )	shift
				usage
				;;
		--output )	shift
				OUTPUT_FILE=$1
				;;
		--branch )	shift
				BRANCH=$1
				;;
		--since )	shift
				SINCE="--since=$1"
				;;
		*)
			usage
			;;
	esac
	shift
done

if [ "$OUTPUT_FILE" = "" ]
then
	usage
fi

if [ "$BRANCH" = "" ]
then
	usage
fi

if [ "$SINCE" = "" ]
then
	SINCE=""
fi

REV_LIST_FILE="/tmp/rev_list.txt"
TMP_DIFF_FILE="/tmp/current_diff.txt"

rm -f ${OUTPUT_FILE}

GIT_COMMAND="git rev-list ${BRANCH} ${SINCE}"

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