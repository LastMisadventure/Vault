function ConvertStringToSecureString {

    [CmdletBinding(PositionalBinding)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]

    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline, Position = 0)]
        [string]
        $StringValue

    )

    try {

        Write-Output ($StringValue | ConvertTo-SecureString -AsPlainText -Force)

    } catch {

        Write-Error -ErrorAction Stop -Message "Error converting string value to secure string."

    }

}