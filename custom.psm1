
Set-Alias Get-Environment "Get-ChildItem Env:"
Set-Alias Get-Version $Host.Version

function Get-Editor {
	$path = Resolve-Path ("$env:ProgramFiles*" + "\notepad*\notepad*");
	if(Test-Path $path) {
		return $path.Path;
	}
	
	$path = Join-Path $env:windir "\system32\notepad.exe"
	if(Test-Path $path) {
		return $path;
	}
	
	return $null;
}

###########################
#
# Approve-Syntax
# http://rkeithhill.wordpress.com/2007/10/30/powershell-quicktip-preparsing-scripts-to-check-for-syntax-errors/
#
###########################

function Approve-Syntax {
	param($path, [switch]$verbose)

	if ($verbose) {
		$VerbosePreference = �Continue�
	}

	trap { Write-Warning $_; $false; continue }
	& `
	{
		$contents = get-content $path
		$contents = [string]::Join([Environment]::NewLine, $contents)
		[void]$ExecutionContext.InvokeCommand.NewScriptBlock($contents)
		Write-Verbose "Parsed without errors"
		$true
	}
}

###########################
#
# Reload Profile
#
###########################

function Update-Profile {
	@(
		$Profile.AllUsersAllHosts,
		$Profile.AllUsersCurrentHost,
		$Profile.CurrentUserAllHosts,
		$Profile.CurrentUserCurrentHost
	) | foreach {
		if(Test-Path $_){
			Write-Verbose "Running $_"
			. $_
		}
	}    
}
Set-Alias Reload-Profile Update-Profile
