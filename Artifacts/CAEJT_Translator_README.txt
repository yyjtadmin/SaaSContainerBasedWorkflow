CAEJT Translator - v2412
Nov 18, 2024
==========================================

SECTION 1 - Release Information

SECTION 2 - About the JT translator

SECTION 3 - Platforms and OS Supported

SECTION 4 - Installation Instructions and Usage

SECTION 5 - Licensing

SECTION 6 - Support

-------------------------------------------------------------------------

SECTION 1 - Release Information

This CAE to JT translator is based on NX2412 Phase 1700 binaries and doesn't contain any new functionality other than just supporting NX files created in 2412.
-------------------------------------------------------------------------

SECTION 2 - About the CAE JT translator
 
CAE to JT translator produces JT files for input fem part file. The translator is invoked
through Linux console. User can provide single part and get one JT file as an output.

Following parts are currently not supported in the CAE to JT translator. 
	- Assembly fem parts
	- Simulation parts

-------------------------------------------------------------------------

SECTION 3 - Platforms and OS Supported

LINUX:
       - Rocky Linux
				- Linux to be running on a minimum OS level of Rocky 8.8
				- The Rocky Linux version should be updated with most recent security fixes and is recommended to run CAE to JT translator.


-------------------------------------------------------------------------

SECTION 4 - Installation Instructions and Usage

	- Following Linux packages are prerequisites to run translator binaries -
			fontconfig 
			ksh
						  
	- Set following environment variables -
			UGII_BASE_DIR=.../app                  ---> This is base directory containing translator binaries.
			SPLM_LICENSE_SERVER=<License server>   ---> This is as per "Licensing" section below.
		
	- Sample docker file 
			FROM rockylinux:8.7
			RUN yum update --assumeyes --skip-broken && yum install --assumeyes fontconfig ksh && yum clean all
			WORKDIR /app
			COPY nxbin/     /app/nxbin
			COPY pvtrans/   /app/pvtrans
			COPY ugii/      /app/ugii
			COPY rule/      /app/rule
			COPY mbd/       /app/mbd
			COPY stage_model/   /app/stage_model
			COPY diagramming/   /app/diagramming
			COPY xlatorworker/  /app/xlatorworker
			COPY vdv/           /app/vdv
			COPY nx_vsa/   /app/nx_vsa
			COPY nxjoin/   /app/nxjoin
			COPY nxcoatings/   /app/nxcoatings
			COPY simulation/      /app/simulation
			COPY ugstructures/      /app/ugstructures

			COPY run_caetojt         /app/run_caetojt

			ENV UGII_BASE_DIR=/app
			ENV SPLM_LICENSE_SERVER=29000@<License server>
			
	- CAE to JT Translator workflow
 			This CAE to JT translator usage is for fem part files created by Simcenter3D.
 			 "run_caetojt" is the parent script and should be the entry point. It should be used as,
						e.g. run_caetojt  -inputFile=<path to xxx.fem> -outputDir=<path to directory>
 			 In this case, JT files will be generated at the given output directory.


		
	- By default Log files will be created at location specified by UGII_TMP_DIR variable.
	  If it is not set, Log files will be generated at /var/tmp
	
-------------------------------------------------------------------------

SECTION 5 - Licensing
 
	- NX 2412 requires Siemens License Server version 2.1 or later.Please download the license server from -
 			https://support.sw.siemens.com/en-US/product/1586485382/downloads
	- If you already configred Siemens License Server version 2.1 or later, you can use same License Server setup for this release.
 
	- Please download the development license file compatible with NX2412.
	  from https://license/lws/#licenses:main. You need to provide host ID of a license server to get a license file.
	
	- Starting in NX 2212, the license you receive from Siemens must be installed using the Siemens License Server installer	  
	
	- During installation, the Siemens License Server installer defaults to port number 29000, which was 28000 in previous releases. 
	  You can change the port number while running the installer. 
	  The port number value is used in the value for the SPLM_LICENSE_SERVER environment variable.
	
	- After license server and license file is configured, please specify SPLM_LICENSE_SERVER
	  variable in run_caetojt launch script as SPLM_LICENSE_SERVER=29000@<license server>
	  
-------------------------------------------------------------------------

SECTION 6 - Support
 
	- Please contact Open Tools Translator Products development if you have any queries or issues
	  about translator configuration and usage.

-------------------------------------------------------------------------
