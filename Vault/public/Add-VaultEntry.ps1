<#
.SYNOPSIS
Adds a credential to the Windows Credential Manager.

.PARAMETER PsCredential
A [pscredential] that represents the username and password you want to store in the vault.

[pscredential] objects can be made with the `Get-Credential` cmdlet.

.PARAMETER Resource
The name to store the credential under in the vault.

.EXAMPLE

$credentialToAdd = Get-Credential

Add-VaultEntry -PsCredential $credentialToAdd -Resource ApiUser

.NOTES

#>
function Add-VaultEntry {

    [CmdletBinding()]

    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        $PsCredential,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [uri]
        $Resource

    )

    process {

        Write-Verbose "[$($MyInvocation.MyCommand.Name)]: $($Resource): Adding credential for user '$($PsCredential.UserName)'..."

        try {

            $splat = @{

                TypeName     = 'Windows.Security.Credentials.PasswordCredential'

                ArgumentList = $Resource, $PsCredential.UserName, (ConvertSecureStringToString -SecureString $PsCredential.Password)

                ErrorAction  = 'Stop'

            }

            $vaultEntry = New-Object @splat

            $PasswordVault.Add($vaultEntry)

            Write-Verbose "[$($MyInvocation.MyCommand.Name)]: $($Resource): Added credential for user '$($PsCredential.UserName)'."

        }

        catch {

            $PsCmdlet.ThrowTerminatingError($PSItem)

        }

    }

}