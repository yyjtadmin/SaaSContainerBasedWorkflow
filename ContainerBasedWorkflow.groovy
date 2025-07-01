def CreateUnit(String buildDir)
{
	echo "Executing CreateUnit..."
	script{		
		def unitFullPath="${buildDir}"
		sh "chmod +x ./shellScripts/CreateUnit.sh "
		sh "./shellScripts/CreateUnit.sh ${params.NXRelease} ${unitFullPath} ${params.HC} ${params.SeriesBuild} ${params.SeriesName}"		
	}
}

def BuildUnit(String buildDir)
{
	echo "Executing BuildUnit..."
	script{		
		def unitFullPath="${buildDir}"
		sh "chmod +x ./shellScripts/BuildUnit.sh "
		sh "./shellScripts/BuildUnit.sh ${unitFullPath} ${params.CPNumber} ${params.HC}"		
	}
}

def TestUnit(String buildDir)
{
	echo "Executing TestUnit..."
	script{		
		def unitFullPath="${buildDir}"
		sh "chmod +x ./shellScripts/TestUnit.sh "
		sh "./shellScripts/TestUnit.sh ${unitFullPath}"	
	}
}

def StageForContainer(String buildDir, String stageDir)
{
	echo "Executing StageForContainer..."
	script{		
		def unitFullPath="${buildDir}"
		def stagePath="${stageDir}"
		
		sh "chmod +x ./shellScripts/StageForContainer.sh "
		sh "./shellScripts/StageForContainer.sh ${unitFullPath} ${stagePath} 'Artifacts' "		
	}
}

def CheckLicenseServer()
{
	echo "Executing CheckLicenseServer..."
	script{
		sh "chmod +x ./shellScripts/CheckLicenseServer.sh "
		sh "./shellScripts/CheckLicenseServer.sh"		
	}
}

def RemoveRunningContainers()
{
	echo "Executing RemoveRunningContainers..."
	script{
		sh "chmod +x ./shellScripts/RemoveRunningContainers.sh "
		sh "./shellScripts/RemoveRunningContainers.sh"		
	}
}

def BuildAndRunDocker(String buildDir, String stageDir)
{
	echo "Executing BuildAndRunDocker..."
	script{		
		def unitFullPath="${buildDir}"
		def stagePath="${stageDir}"
		
		sh "chmod +x ./shellScripts/BuildAndRunDocker.sh "
		sh "./shellScripts/BuildAndRunDocker.sh ${unitFullPath} ${stagePath}"		
	}
}

def BuildAndRunDockerRockyLinux(String buildDir, String stageDir)
{
	echo "Executing BuildAndRunDocker..."
	script{		
		def unitFullPath="${buildDir}"
		def stagePath="${stageDir}"
		
		sh "chmod +x ./shellScripts/BuildAndRunDockerRockyLinux.sh "
		sh "./shellScripts/BuildAndRunDockerRockyLinux.sh ${unitFullPath} ${stagePath}"		
	}
}

def ValidateDockerTest()
{
	echo "Executing ValidateDockerTest..."
	
	sh "chmod +x ./shellScripts/ValidateDockerTest.sh "
	sh "./shellScripts/ValidateDockerTest.sh"
}

def DockerCleanup(String stageDir)
{
	echo "Executing DockerCleanup..."
	script{		
		def stagePath="${stageDir}"
		
		sh "chmod +x ./shellScripts/DockerCleanup.sh "
		sh "./shellScripts/DockerCleanup.sh ${stagePath}"		
	}
}

def DeployContainer(String buildDir,String stageDir)
{
	echo "Executing DeployContainer..."
	script{		
		def stagePath="${stageDir}"
		def deployFlag="${params.Deploy}"
		def unitFullPath="${buildDir}"
		
		sh "chmod +x ./shellScripts/DeployContainer.sh "
		sh "./shellScripts/DeployContainer.sh ${stagePath} ${deployFlag} ${unitFullPath}"		
	}
}

def Purge(String dirName)
{
	echo "Executing Purge ..."
	script{		
		def fullPath="${dirName}"
		sh "chmod +x ./shellScripts/Purge.sh "
		sh "./shellScripts/Purge.sh ${fullPath}"		
	}
}

return this
