function InitializePasswordVault {

    [CmdletBinding(PositionalBinding, ConfirmImpact = 'medium')]

    param (

    )

    [void] [Windows.Security.Credentials.PasswordVault, Windows.Security.Credentials, ContentType = WindowsRuntime]

    $PasswordVault = New-Object -TypeName Windows.Security.Credentials.PasswordVault

    Write-Output $PasswordVault

}