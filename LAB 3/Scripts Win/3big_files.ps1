# 3big_files.ps1

param (
    [int]$no_files,         # Number of smallest files to display
    [string]$max_size,      # Maximum file size (e.g., "1GB", "500MB")
    [string]$directory = "." # Optional search directory (default: current directory)
)

# Get the absolute path of the search directory
$searchDirectory = (Resolve-Path -Path $directory).Path

# Convert max_size to bytes
$size_multiplier = @{ "KB" = 1KB; "MB" = 1MB; "GB" = 1GB }
$max_size_bytes = if ($max_size -match "(\d+)(KB|MB|GB)") {
    [int]$matches[1] * $size_multiplier[$matches[2]]
} else {
    1GB
}

# Verify if the directory exists
if (-Not (Test-Path -Path $searchDirectory -PathType Container)) {
    Write-Host "ERROR: Directory '$searchDirectory' does not exist!" -ForegroundColor Red
    exit
}

# Function to wrap long directory paths into multiple lines
function Format-DirectoryPath {
    param (
        [string]$path,
        [int]$maxWidth = 40  # Maximum width before wrapping to a new line
    )
    
    if ($path.Length -le $maxWidth) { return $path }
    
    $formattedPath = @()
    $currentLine = ""

    foreach ($part in $path -split '\\') {
        if (($currentLine.Length + $part.Length) -le $maxWidth) {
            if ($currentLine -eq "") {
                $currentLine = $part
            } else {
                $currentLine += "\" + $part
            }
        } else {
            $formattedPath += $currentLine
            $currentLine = $part
        }
    }
    $formattedPath += $currentLine
    return $formattedPath -join "`n"  # Returns the path with line breaks
}

# Find the smallest files within the specified size limit
$smallest_files = Get-ChildItem -Path $searchDirectory -Recurse -File |
    Where-Object { $_.Length -le $max_size_bytes } |
    Sort-Object Length |
    Select-Object -First $no_files

# Display results
if ($smallest_files) {
    $output = $smallest_files | ForEach-Object {
        # Get the relative path from the search directory
        $relativePath = $_.FullName -replace [regex]::Escape($searchDirectory), ""
        $relativePath = $relativePath.TrimStart('\')

        # Extract only the directory, without the file name
        $relativeDir = Split-Path -Path $relativePath -Parent
        if ([string]::IsNullOrEmpty($relativeDir)) { $relativeDir = "." }

        # Format the directory to wrap long paths
        $formattedDir = Format-DirectoryPath -path $relativeDir

        [PSCustomObject]@{
            "File Name"  = $_.Name
            "Size (KB)"  = "{0:N2}" -f ($_.Length / 1KB)
            "Directory"  = $formattedDir
        }
    }

    # Ensure correct table formatting and alignment
    $output | Format-Table -Property "File Name", "Size (KB)", "Directory" -AutoSize
} else {
    Write-Host "No files found within the specified size limit." -ForegroundColor Red
}
