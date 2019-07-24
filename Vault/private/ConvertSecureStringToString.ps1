function ConvertSecureStringToString {

    [CmdletBinding(ConfirmImpact = 'low', PositionalBinding)]

    param (

        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [securestring]
        $SecureString

    )

    try {

        Write-Verbose "[$($MyInvocation.MyCommand.Name)]: Converting input to clear-text string."

        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)

        $plainTextString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        Write-Output $plainTextString

        Write-Verbose "[$($MyInvocation.MyCommand.Name)]: Converted input to clear-text string."

    } catch {

        Write-Error -ErrorAction Stop -Message "Error converting securestring to string."

    }

}