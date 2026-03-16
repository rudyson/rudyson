$ExifTool = "C:\Core\Software\exiftool\exiftool.exe"
$DateFormat = "%Y-%m-%d_%H-%M-%S"
$DateRegex = "\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}"

$PrefixImage  = 'IMG' 
$PrefixScreen = 'SCR'
$PrefixVideo = 'IMG'

$ImgDoneRegex = "^${PrefixImage}_${DateRegex}"
$ScrDoneRegex = "^${PrefixScreen}_${DateRegex}"
$VidDoneRegex = "^${PrefixVideo}_${DateRegex}"

$Debug = $false
$DebugArgs = @()
if ($Debug) {
  $DebugArgs += "-dryRun"
  $DebugArgs += "-v"
}

function Rename-Pipeline {
  param($ExifTool, $Source)

    # Rename-Photos

    & $ExifTool `
    -r `
    @DebugArgs `
    -if ('defined $DateTimeOriginal and not ($FileName =~ /' + $ImgDoneRegex + '/)') `
    ('-FileName<' + $PrefixImage + '_${DateTimeOriginal;DateFmt("' + $DateFormat + '")}%-c.%e') `
    -ext jpg -ext jpeg -ext heic `
    $Source

    # Rename-Videos

  & $ExifTool `
    -r `
    @DebugArgs `
    -if ('defined $Keys:CreationDate and not ($FileName =~ /' + $VidDoneRegex + '/)') `
    ('-FileName<' + $PrefixVideo + '_${Keys:CreationDate;DateFmt("' + $DateFormat + '")}%-c.%e') `
    -ext mov `
    $Source
    
    # Rename-Screenshots

  & $ExifTool `
    -r `
    @DebugArgs `
    -if ('(
      ($UserComment =~ /screenshot/i) and
      defined $DateTimeOriginal
      ) and not ($FileName =~ /' + $ScrDoneRegex + '/)') `
    ('-FileName<' + $PrefixScreen + '_${DateTimeOriginal;DateFmt("' + $DateFormat + '")}%-c.%e') `
    -ext png `
    $Source

  & $ExifTool `
    -r `
    @DebugArgs `
    -if ('(
      ($FileName =~ /screenshot|screen shot|img_e/i) and
      not defined $DateTimeOriginal and
      defined $FileCreateDate
      ) and not ($FileName =~ /' + $ScrDoneRegex + '/)') `
    ('-FileName<' + $PrefixScreen + '_${FileCreateDate;DateFmt("' + $DateFormat + '")}%-c.%e') `
    -ext png `
    $Source

  & $ExifTool `
    -r `
    @DebugArgs `
    -if ('(
      ($FileName =~ /screenshot|screen shot|img_e/i) and
      not defined $DateTimeOriginal and
      not defined $FileCreateDate
      ) and not ($FileName =~ /' + $ScrDoneRegex + '/)') `
    ('-FileName<' + $PrefixScreen + '_${FileModifyDate;DateFmt("' + $DateFormat + '")}%-c.%e') `
    -ext png `
    $Source
}

function Run-Pipeline {
  param($ExifTool, $Source)

  Rename-Pipeline    $ExifTool $Source

	# TODO: Pipline idea - merge live photos
  # Merge-MotionPhotos $Source
  # Detect-BurstPhotos $ExifTool $Source
}

function Main {
  do {
      $Source = Read-Host "Write path to the media directory"
      if (-not (Test-Path $Source -PathType Container)) {
          Write-Host "[ERR] Folder is not exists. Try again." -ForegroundColor Red
          $IsTargetDirExists = $false
      } else {
          $IsTargetDirExists = $true
      }
  } while (-not $IsTargetDirExists)
  Write-Host "[INF] Source: $Source" -ForegroundColor Green
  Run-Pipeline $ExifTool $Source
  Write-Host "[INF] Ready." -ForegroundColor Cyan
}

Main