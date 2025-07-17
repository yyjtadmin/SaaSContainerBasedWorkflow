#!/bin/bash

if [ $# -ne 5 ] 
then
	echo "CreateUnit.sh called with incorrect number of arguments."
	echo "CreateUnit.sh <NXVersion> <UnitPath> <HCflag> <SeriesFlag> <SeriesName>"
	echo "For example; CreateUnit.sh nx2206.latest /plm/pnnas/ppic/users/<unit_name> <false/true> <false/true> nx2312_Series.3000"
	exit 1
fi

NX_RELEASE=$1
UNIT_PATH=$2
HC_FLAG=$3
SeriesFlag=$4
SeriesName=$5

if [ ${SeriesFlag} == "false" ]
then 
	if [ ${HC_FLAG} == "false" ]
	then
		/usr/site/devop_tools/bin/unit add -b -p @${NX_RELEASE} -t DEV -w SUB ${UNIT_PATH} -R y -O y -DO_LINK_OPT y
	else
		/usr/site/devop_tools/bin/unit add -b -p @${NX_RELEASE} -t DEV -w SUB ${UNIT_PATH} -R y -O y -DO_LINK_OPT y

		initFile=${UNIT_PATH}/init.def
		sed -i 's/DO_TARI_RECOMPILES.*/DO_TARI_RECOMPILES       1/g' $initFile
		sed -i 's/DO_SOURCE_RECOMPILES.*/DO_SOURCE_RECOMPILES       1/g' $initFile
		sed -i 's/DO_LINK_OPT.*/DO_LINK_OPT       1/g' $initFile
		sed -i 's/DO_DEBUG.*/DO_DEBUG       0/g' $initFile
		sed -i 's/DO_QAZ.*/DO_QAZ       1/g' $initFile
		sed -i 's/DO_DLL_COMPARISON.*/DO_DLL_COMPARISON       1/g' $initFile
	fi
else
    if [ ! -d "/plm/pnnas/ppic/Data_Exchange/SaaS_distributions/cloudsetup/JenkinsBase/local_distrib/${SeriesName}" ] && [ ! -e "/plm/pnnas/ppic/Data_Exchange/SaaS_distributions/cloudsetup/JenkinsBase/local_distrib/${SeriesName}/${SeriesName/_Series/}/init.def" ]; then
        /usr/site/devop_tools/UDU/tools/bin/unx/udistrib -s -u -t /plm/pnnas/ppic/Data_Exchange/SaaS_distributions/cloudsetup/JenkinsBase/local_distrib/${SeriesName}/ -p "common lnx64" -v @NX::${SeriesName} -L 1 -A
    fi
    /usr/site/devop_tools/bin/unit add -p /plm/pnnas/ppic/Data_Exchange/SaaS_distributions/cloudsetup/JenkinsBase/local_distrib/${SeriesName}/${SeriesName/_Series/} ${UNIT_PATH}
    #C:\apps\devop_tools\UDU\tools\bin\wnt\runme.bat C:\apps\devop_tools\UDU\tools\udistrib.pl  -v "@NX::NX2312_Series.3000" -p "common lnx64 " -C -s -u -L 1 -t "C:\workdir\delete"
fi
