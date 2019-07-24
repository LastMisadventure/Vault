<#
.SYNOPSIS
Gets credentials from the Windows Password Vault.

.PARAMETER Resource
Gets credentials where the resource matches this value. Case-sensitive.

.PARAMETER UserName
Gets credentials where the username matches this value. Case-sensitive.

.PARAMETER All
Gets all credentials for the current user.

.PARAMETER IncludePassword
WARNING: Password will be written in clear-text.

Includes passwords in returns.

.PARAMETER AsPsCredential
Returns a [pscredential] for each credential entry. The password is always included when this mode is selected.

.PARAMETER Force
Bypasses the confirmation prompt when a credential would include clear-text passwords.

.EXAMPLE
Get-VaultEntry -UserName test

UserName Resource         Password Properties
-------- --------         -------- ----------
test     http://test.com/          {[hidden, False], [applicationid, 00000000-0000-0000-0000-000000000000], [application, ]}

Gets all credentials with the username "test".

.EXAMPLE
Get-VaultEntry -Resource http://test.com/

UserName Resource         Password Properties
-------- --------         -------- ----------
test     http://test.com/          {[hidden, False], [applicationid, 00000000-0000-0000-0000-000000000000], [application, ]}

Gets all credentials with the resource "http://test.com/".
Note: URIs are case-sensitive--http://test.com/  is not the same as http://tEsT.cOm/.

.NOTES

The underlying class, [Windows.Security.Credentials.PasswordVault], is oddly case-sensitve.

#>
function Get-VaultEntry {

    [CmdletBinding(DefaultParameterSetName = 'RetrieveAll', ConfirmImpact = "high")]

    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline, ParameterSetName = 'FindAllByResource')]
        [ValidateNotNullOrEmpty()]
        [uri]
        $Resource,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'FindAllByUserName')]
        [ValidateNotNullOrEmpty()]
        [string]
        $UserName,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'RetrieveAll')]
        [switch]
        $All,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'IncludePassword')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'FindAllByResource')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'FindAllByUserName')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'RetrieveAll')]
        [switch]
        $IncludePassword,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'AsPsCredential')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'FindAllByResource')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'FindAllByUserName')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'RetrieveAll')]
        [switch]
        $AsPsCredential,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'IncludePassword')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'FindAllByResource')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'FindAllByUserName')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'RetrieveAll')]
        [switch]
        $Force

    )

    begin {

        $ErrorActionPreference = 'Stop'

    }

    process {

        Write-Verbose "[$($MyInvocation.MyCommand.Name)]: Password-inclusion Mode is set to $($($IncludePassword, $AsPsCredential) -contains $true)."

        try {

            $value = if ($Resource) { Write-Output $Resource } else { Write-Output $UserName }

            $result = GetPasswordVaultEntry -Mode $PsCmdlet.ParameterSetName -Value $value

            if ($IncludePassword.IsPresent) {

                $shouldContinueMessage = "Please make sure you have taken the necessary precautions."

                $shouldContinueCaption = "If you continue, credential passwords will be decrypted and may be written to the host in clear-text. Continue?"

                if ($Force -or $PsCmdlet.ShouldContinue($shouldContinueMessage, $shouldContinueCaption)) {

                    $result.RetrievePassword()

                    Write-Output $result

                }

            }

            if ($AsPsCredential.IsPresent) {

                Write-Verbose "[$($MyInvocation.MyCommand.Name)]: Starting pscredential conversion."

                $result.RetrievePassword()

                Write-Output ($result | ConvertWindowsSecurityCredentialToPSCredential)

                Write-Verbose "[$($MyInvocation.MyCommand.Name)]: Done with pscredential conversion."

            }

            if ($AsPsCredential.IsPresent -eq $false -and $IncludePassword.IsPresent -eq $false) {

                Write-Output $result

            }

        } catch {

            Write-Error -ErrorAction Stop -Exception $_.Exception

        }

    }

    end {

    }

}