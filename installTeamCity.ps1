#Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName -Filter "Name like 'Java%'"
#Get-WmiObject -Class Win32_Product  -Filter "Name like 'Java%'" | Select -Expand Version
#Start-Process "C:\\Downloads\jdk-8u60-windows-x64\\jdk-8u60-windows-x64.exe /s /L jdk_install.log" -Wait

try{
    Start-Process -FilePath "C:\\Java8.6\\jdk-8u60-windows-x64.exe" -ArgumentList "/s /L jdk_install.log"
}
catch{
    $Time=Get-Date
    "$Time -- Error trying to install Java " | out-file installTeamCity.log -append
    Exit
}

$JavaExists = $false

while($JavaExists -eq $false){
    try{
        start-process  java  -ArgumentList "-version" -NoNewWindow
        $JavaExists = $true
    }
    catch{
        $JavaExists = $false
        
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName

        $Time=Get-Date
        "$Time -- Java still not installed, waiting 5 secs " | out-file installTeamCity.log -append

        Start-Sleep -s 5
    }
}

try{
    $Time = Get-Date
    "$Time -- Installing teamcity " | out-file installTeamCity.log -append
    tcsmanage.cmd install
}
catch{
    "$Time -- Error trying to install TeamCity " | out-file installTeamCity.log -append
    Exit
}

try{
    $Time = Get-Date
    "$Time -- Installing teamcity " | out-file installTeamCity.log -append
    tcsmanage.cmd start
}
catch{
    "$Time -- Error trying to start TeamCity " | out-file installTeamCity.log -append
    Exit
}


