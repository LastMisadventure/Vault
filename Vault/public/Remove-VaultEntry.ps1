<#
.SYNOPSIS
Removes credentials from the Windows Password Vault.

.PARAMETER Resource
Removes all credentials where the resource (which is a URI) matches this value. Case-sensitive.

.PARAMETER UserName
Removes all credentials where the username matches this value. Case-sensitive.

.PARAMETER RemoveAll
Removes all credentials for the current user.

.PARAMETER Force
WARNING: Crendential entries removed can not be recovered.
Bypasses the confirmation prompt removing entries.

.EXAMPLE
Remove-VaultEntry -UserName test

UserName Resource         Password Properties
-------- --------         -------- ----------
test     http://test.com/          {[hidden, False], [applicationid, 00000000-0000-0000-0000-000000000000], [application, ]}

Gets all credentials with the username "test".

.EXAMPLE
Remove-VaultEntry -Resource http://test.com/

UserName Resource         Password Properties
-------- --------         -------- ----------
test     http://test.com/          {[hidden, False], [applicationid, 00000000-0000-0000-0000-000000000000], [application, ]}

Gets all credentials with the resource "http://test.com/". Note that URIs in this case are case-sensitive--http://test.com/  is not the same as http://tEsT.cOm/ as far as this cmdlet is concerned.

.NOTES

[Windows.Security.Credentials.PasswordVault] is case-sensitve.

#>
function Remove-VaultEntry {

    [CmdletBinding(DefaultParameterSetName = 'FindAllByResource', ConfirmImpact = "high", SupportsShouldProcess)]

    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline, ValueFromRemainingArguments, ParameterSetName = 'FindAllByResource')]
        [ValidateNotNullOrEmpty()]
        [uri]
        $Resource,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline, ValueFromRemainingArguments, ParameterSetName = 'FindAllByUserName')]
        [ValidateNotNullOrEmpty()]
        [string]
        $UserName,

        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, ParameterSetName = 'RetrieveAll')]
        [switch]
        $All,

        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $Force

    )

    process {

        if ($PSCmdlet.ShouldProcess("Removing credentials--they will not be recoverable")) {

            try {

                $value = if ($Resource) { Write-Output $Resource } else { Write-Output $UserName }

                $windowsSecurityCredential = GetPasswordVaultEntry -ErrorAction Stop -Mode $PsCmdlet.ParameterSetName -Value $value

                $int_ShouldContinueCountValue = ($windowsSecurityCredential | Measure-Object).Count

                $shouldContinueCaption = "If you continue, $($int_ShouldContinueCountValue) credential(s) will be deleted. There is no way to recover them."

                $shouldContinueMessage = "Please make sure you have taken the necessary precautions. Continue?"

                if ($Force -or $PsCmdlet.ShouldContinue($shouldContinueMessage, $shouldContinueCaption)) {

                    $PasswordVault.Remove($windowsSecurityCredential)

                }

            } catch {

                $PsCmdlet.ThrowTerminatingError($PSItem)

            }

        }
    }

}