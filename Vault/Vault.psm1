Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$class = @(Get-ChildItem -File -Recurse -Filter *.ps1 -Path (Join-Path -Path $PSScriptRoot -ChildPath 'class') -ErrorAction SilentlyContinue)
$public = @(Get-ChildItem -File -Recurse -Filter *.ps1 -Path (Join-Path -Path $PSScriptRoot -ChildPath 'public') -ErrorAction SilentlyContinue)
$private = @(Get-ChildItem -File -Recurse -Filter *.ps1 -Path (Join-Path -Path $PSScriptRoot -ChildPath 'private') -ErrorAction SilentlyContinue)

foreach ($file in @($class + $public + $private)) {

    try {

        . $file.Fullname

    }

    catch {

        Write-Error -Message "Failed to import function '$($file.fullname)': $_"
    }

}

try {

    $script:Scoped_ModuleConfig = Import-PowerShellDataFile -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Config.psd1')

} catch {

    Write-Error -Exception $_.Exception

}