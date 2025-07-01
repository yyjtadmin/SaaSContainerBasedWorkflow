#!/bin/bash

if [ $# -ne 4 ]
then
        echo "stage_and_deploy_artifacts.sh called with incorrect number of arguments."
        echo "stage_and_deploy_artifacts.sh <unitPaht> <StageBaseDir> <CustomerArtifactDir> <DeployFlag>"
        echo "For example; stage_and_deploy_artifacts.sh /plm/pnnas/ppic/users/<unit_name> /plm/pnnas/ppic/users/<stage_dir> <Artifacts> true/false"
        exit 1
fi

echo "Executing stage_and_deploy_artifacts.sh..."

UNIT_PATH=$1
STAGE_BASE_DIR=$2
CUSTOMER_ARTIFACTS_DIR=$3
EXECUTE_DEPLOY=$4

STAGE_DIR=${STAGE_BASE_DIR}/TranslatorBinaries/
SOURCE_PATH=${UNIT_PATH}/lnx64/Products/TranslatorWorker

if [ ! -d ${STAGE_DIR} ]
then
	echo "Creating staging directory ${STAGE_DIR}"
	mkdir -p ${STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${SOURCE_PATH}/*   ${STAGE_DIR}/ || { exit 1;}

# Then remove selected iteams
rm -rf ${STAGE_DIR}/debug || { exit 1;}
rm -rf ${STAGE_DIR}/license || { exit 1;}
rm -rf ${STAGE_DIR}/dockerfile || { exit 1;}

CONFIG_FILE_MULTICAD=${STAGE_DIR}/tessUG_multicad.config
CONFIG_FILE_VIS=${STAGE_DIR}/tessUG_vis.config
RUN_UGTOPV_MULTICAD=${STAGE_DIR}/run_ugtopv_multicad
RUN_UGTOPV_VIS=${STAGE_DIR}/run_ugtopv_vis

cp -f ${CUSTOMER_ARTIFACTS_DIR}/run_ugtopv_multicad ${RUN_UGTOPV_MULTICAD} || { exit 1;}
cp -f ${CUSTOMER_ARTIFACTS_DIR}/run_ugtopv_vis ${RUN_UGTOPV_VIS} || { exit 1;}
cp -f ${CUSTOMER_ARTIFACTS_DIR}/tessUG_multicad.config ${CONFIG_FILE_MULTICAD} || { exit 1;}
cp -f ${CUSTOMER_ARTIFACTS_DIR}/tessUG_vis.config ${CONFIG_FILE_VIS} || { exit 1;}
cp -f ${CUSTOMER_ARTIFACTS_DIR}/NXJT_Translator_README.txt ${STAGE_BASE_DIR}/ || { exit 1;}

chmod 0755 ${CONFIG_FILE_MULTICAD} || { exit 1;}
chmod 0755 ${CONFIG_FILE_VIS} || { exit 1;}
chmod 0755 ${RUN_UGTOPV_MULTICAD} || { exit 1;}
chmod 0755 ${RUN_UGTOPV_VIS} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	INIT_DEF_FILE=${UNIT_PATH}/init.def
	stringarray=(`grep DMS_PARENT_BASELINE ${INIT_DEF_FILE} || { exit 1;}`)
	RELEASE_IP=${stringarray[1]}
	echo "Deploy flag is set to true. Executing deploy step with release IP =${RELEASE_IP}..."
	
	orig=${RELEASE_IP}
	releaseName=${orig//'.'/'_TranslatorWorker.'}
	
	cd ${STAGE_BASE_DIR} || { exit 1;}
	tar -czf $releaseName.tar.gz TranslatorBinaries/ || { exit 1;}
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/NXtoJT/$releaseName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/NXtoJT/$releaseName/ || { exit 1;}"

	cd -
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
