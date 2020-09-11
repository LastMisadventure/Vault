Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'

$public = @(Get-ChildItem -File -Recurse -Filter *.ps1 -Path (Join-Path -Path $PSScriptRoot -ChildPath 'public') -ErrorAction SilentlyContinue)

$private = @(Get-ChildItem -File -Recurse -Filter *.ps1 -Path (Join-Path -Path $PSScriptRoot -ChildPath 'private') -ErrorAction SilentlyContinue)

foreach ($file in @($public + $private)) {

    try {

        . $file.Fullname

    } catch {

        Write-Error -Message "Failed to import function '$($file.fullname)': $_"
    }

}

InitializePasswordVault