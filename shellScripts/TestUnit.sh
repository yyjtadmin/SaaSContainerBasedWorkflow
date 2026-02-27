#!/bin/bash

if [ $# -lt 1 ] 
then
	echo "TestUnit.sh called with incorrect number of arguments."
	echo "TestUnit.sh <UnitPath>"
	echo "For example; TestUnit.sh /plm/pnnas/ppic/users/<unit_name>"
	exit 1
fi

UNIT_PATH=$1
export SPLM_LICENSE_SERVER=29000@pnnxflex3:29000@pnnxflex4 
/usr/site/devop_tools/bin/unit run ${UNIT_PATH} devtest runtest NXTranslators.rep:NXJT_TranslatorWorker.set -p 6
casesFailed=`grep "Number of tests:" ${UNIT_PATH}/dt/runs/devtestLastRunFails.txt | cut -d ":" -f2 | tr -d " "`
if [ $casesFailed != 0 ]
then
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} devtest runfails -p 6 -keep -local -parent
	casesFailed=`grep "Number of tests:" ${UNIT_PATH}/dt/runs/devtestLastRunFails.txt | cut -d ":" -f2 | tr -d " "`
	if [ $casesFailed != 0 ]
	then
		echo "Number of auto test cases failed for NXJT= $casesFailed...Exiting with error."
		exit 1
	fi
else
	echo "No test case failed. So skipping re-run of devtest."
fi