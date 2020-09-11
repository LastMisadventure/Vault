function GetPasswordVaultEntry {

    [CmdletBinding(ConfirmImpact = "low")]

    param (

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Mode,

        [Parameter()]
        [string]
        $Value
    )

    InitializePasswordVault

    Write-Verbose "[$($MyInvocation.MyCommand.Name)]: Mode '$($Mode)' selected."

    if ($Mode -eq 'RetrieveAll') {

        $result = $PasswordVault.$Mode()

    } else {

        $result = $PasswordVault.$Mode($Value)
    }

    $result | ForEach-Object { $_ }

}