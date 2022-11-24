$ErrorActionPreference = "Stop"

[string]$cmdA = "Add-AppxPackage -Register -DisableDevelopmentMode `"C:\Program Files\WindowsApps\"
[string]$cmdB = "\AppxManifest.xml`""
[int]$selectNo = 0
[int]$Cnt = 1
# $App = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like "*Pana*"}
$App = @(Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like "*Pana*"})
$AppCnt = $App.Length

if ($AppCnt -eq 0) {
    Write-Host "プロビジョニング領域にPanasonicアプリが見つかりませんでした" -ForegroundColor Red
    Write-host "プログラムを終了します"
    Pause
}

Clear-Host
Write-host "プロビジョニング領域にPanasonicアプリが "$AppCnt" 個見つかりました" -ForegroundColor Green
Write-host ""

for([int]$idx=0; $idx -lt $AppCnt; $idx++){
    Write-host ($idx + $Cnt) " ： "$App.PackageName[$idx]
}

Write-host ""
$selectNo = Read-host "インストールするアプリの番号を入力してください"
$selectNo = ($selectNo - 1)

Clear-Host
if ($selectNo -lt $AppCnt ) {
    #すでにアプリがユーザにインストールされているかチェック
    $hikaku = Get-AppxPackage | Where-Object -FilterScript {$_.PackageFullName -eq $App.PackageName[$selectNo]}

    if ($hikaku.count -eq 0) {
        Write-Output "以下のアプリをログインしているユーザにインストールします" $App.PackageName[$selectNo]
        $null = Read-Host "処理を継続する場合は何かキーを押してください．．．"

        $cmdLine =  (-join($cmdA,$App.PackageName[$selectNo],$cmdB))
        Invoke-Expression $cmdLine

        # インストールが完了するまでsleep
        Start-Sleep -s 2
        $kekka = Get-AppxPackage | Where-Object -FilterScript {$_.PackageFullName -eq $App.PackageName[$selectNo]}

        Clear-Host
        if ($kekka.count -eq 1) {
            Write-Host "アプリがインストールされました" -ForegroundColor Green
        }else{
            Write-Host "インストールに失敗しました" -BackgroundColor Red
        }


    }else{
        Write-Output "このアプリはすでにログインユーザにインストールされています" $App.PackageName[$selectNo]
    }
    
}else{
    Write-Host "範囲外が選択されました プログラムを終了します" -BackgroundColor Red
}

<#
foreach ($A in $App){
    #Write-host $cmdA $A.PackageName $cmdB
    Write-Host (-join($cmdA,$A.PackageName,$cmdB))
}
#>