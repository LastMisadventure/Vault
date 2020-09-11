function InitializePasswordVault {

    [CmdletBinding(PositionalBinding, ConfirmImpact = 'low')]

    param (

    )

    try {

        [void] [Windows.Security.Credentials.PasswordVault, Windows.Security.Credentials, ContentType = WindowsRuntime]

        $script:PasswordVault = New-Object -TypeName Windows.Security.Credentials.PasswordVault

    } catch {

        $PSCmdlet.ThrowTerminatingError($PSItem)

    }

}