#!/bin/bash

if [ $# -ne 3 ] 
then
	echo "BuildUnit.sh called with incorrect number of arguments."
	echo "BuildUnit.sh <UnitPath> <CPNumber> <HCflag>"
	echo "For example; BuildUnit.sh /plm/pnnas/ppic/users/<unit_name> NX#XXXXX <false/true>"
	exit 1
fi

UNIT_PATH=$1
CP_NUMBER=$2
HC_FLAG=$3

if [ ${HC_FLAG} == "false" ]
then
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} b product TranslatorWorker
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} b product validate_worker TranslatorWorker
else
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} /usr/site/devop_tools/bin/dt cli set -C -A ${CP_NUMBER}
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} b 
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} b image ugtopv
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} b product TranslatorWorker
	/usr/site/devop_tools/bin/unit run ${UNIT_PATH} b product validate_worker TranslatorWorker
fi
