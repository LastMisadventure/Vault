function ConvertWindowsSecurityCredentialToPSCredential {

    [CmdletBinding()]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '')]

    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Windows.Security.Credentials.PasswordCredential]
        $WindowsSecurityCredential

    )

    try {

        Write-Verbose "[$($MyInvocation.MyCommand.Name)]: Converting input to pscredential type."

        $psCredential = New-Object -TypeName pscredential -ArgumentList $WindowsSecurityCredential.UserName, ($WindowsSecurityCredential.Password | ConvertStringToSecureString)

        Add-Member -ErrorAction Stop -MemberType NoteProperty -Value $WindowsSecurityCredential.Resource -Name Resource -InputObject $psCredential

        Write-Output $psCredential

    } catch {

        $PSCmdlet.ThrowTerminatingError($PSItem)

    }

}