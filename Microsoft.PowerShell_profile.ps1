Add-PSSnapin AzureManagementCmdletsSnapIn
Add-PSSnapin CloudServicesCmdlets

function Start-Explorer{
	if(!$args) { explorer . }
	else { explorer $args }
}
Set-Alias e Start-Explorer

function Start-Vim
{
    & "C:\Program Files (x86)\Vim\vim73\vim.exe" $args
}

Set-Alias vim Start-Vim

function Start-Notepad{
	& "C:\Program Files (x86)\Notepad++\notepad++.exe" $args
}
set-alias n Start-Notepad

function Start-VisualStudio{
	param([string]$projFile = "")

	if($projFile -eq ""){
		ls *.sln | select -first 1 | %{
			$projFile = $_
		}
	}

	if(($projFile -eq "") -and (Test-Path src)){
		ls src\*.sln | select -first 1 | %{
			$projFile = $_
		}
	}

	if($projFile -eq ""){
		echo "No project file found"
		return
	}

	echo "Starting visual studio with $projFile"
	. $projFile
}
set-alias vs Start-VisualStudio

# Preserve history across sessions

Register-EngineEvent PowerShell.Exiting {
    Get-History -Count 32767 | Group CommandLine | Foreach {$_.Group[0]} | Export-CliXml "$home\pshist.xml"
} -SupportEvent

Import-CliXml "$home\pshist.xml" | Add-History

#Set environment variables for Visual Studio Command Prompt
pushd 'c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC'
cmd /c "vcvarsall.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd