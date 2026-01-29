# ITNOA

$vcpkgFolder = "D:\vcpkg"
if (Test-Path -Path $vcpkgFolder) {
    $env:VCPKG_ROOT = $vcpkgFolder
} else {
    $vcpkgFolder = "D:\Source\Repos\vcpkg"
    if (Test-Path -Path $vcpkgFolder) {
        $env:VCPKG_ROOT = $vcpkgFolder
    } else {
        Write-Error "vcpkg path does not found"
    }
}

$env:PATH="$env:VCPKG_ROOT;$env:PATH"
