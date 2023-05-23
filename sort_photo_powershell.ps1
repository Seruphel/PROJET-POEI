
#First version 

# foreach ($arg in $args) {
#     param (
#     [string]$SRC_DIR,
#     [string]$DEST_DIR
# )

# Write-Host "Sorting photos..."
# Write-Host "Scanning for photos in directory: $SRC_DIR"
# Write-Host "Sorting photos in directory: $DEST_DIR"

# Move-Item $SRC_DIR\*.jpg $DEST_DIR\
# }


# Second Version,PowerShell script that sorts photos by name and creation date

# param (
#     [string]$SRC_DIR,     # Source directory
#     [string]$DEST_DIR     # Destination directory
# )

# # Function to sort files by name
# function sortByName {
#     Write-Host "Sorting files by name..."
#     Get-ChildItem "$SRC_DIR\*.jpg" | Sort-Object Name | ForEach-Object { Move-Item $_.FullNamegi $DEST_DIR }
# }

# # Function to sort files by creation date
# function sortByDate {
#     Write-Host "Sorting files by creation date..."
#     Get-ChildItem "$SRC_DIR\*.jpg" | Sort-Object CreationTime | ForEach-Object { Move-Item $_.FullName $DEST_DIR }
# }

# # Main script

# Write-Host "Sorting photos..."
# Write-Host "Scanning for photos in directory: $SRC_DIR"
# Write-Host "Sorting photos in directory: $DEST_DIR"



# # Call the sorting functions
# sortByName
# sortByDate

#Version 3

$Src_Folder=$args[0]
$Dest_Folder=$args[1]

# Verifying the number of arguments
if ($args.count -ne 2) {
        Write-Host Syntax Error, wrong number of arguments
        Exit
}
# Verifying that Src_Folder exists and not empty
if (!(Test-Path $Src_Folder)) {
    Write-Host Error : Source Folder does not exists
    Exit
}
if ((Get-ChildItem -Path $Src_Folder).count -eq 0){
    Write-Host Error : $Src_Folder Folder is empty 
    Exit
}
if (!(Test-Path $Dest_Folder)) {
    Write-Host Error : $Dest_Folder Folder does not exists
    Exit
}
# Scaning and sorting

foreach($arg in Get-ChildItem -Path $Src_Folder -Filter *.jpg | Select-Object -ExpandProperty Name){
    $year=$arg.Substring(4,4)
    $month=$arg.Substring(8,2)
    $day=$arg.Substring(10,2)

    $YDest = Join-Path $Dest_Folder ($year).ToString()
    $MDest = Join-Path $YDest ($month).ToString()
    $DDest = Join-Path $MDest ($day).ToString()

    if (!(Test-path $YDest)) {
        mkdir $YDest | Out-Null

    }
    if (!(Test-path $MDest)) {
        mkdir $MDest | Out-Null

    }
    if (!(Test-path $DDest)) {
        mkdir $DDest | Out-Null

    }
    Move-Item $Src_Folder$arg $DDest\

}