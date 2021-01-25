function Test-ItemProperty
{
    param ( [string]$path = $(throw "Need a path"),
            [string]$name = $(throw "Need a name") )

    $temp = $null
    $temp = Get-ItemProperty -path $path -name $name -errorAction SilentlyContinue
    return $null -ne $temp
}

$InformationPreference = "Continue"
$WarningPreference = "Continue"

$InformationPreference = "Continue"
if(Test-Path HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer)
{
    $TimerSettings = Get-Item -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer"
    $MiningCycleCap = ($TimerSettings | Get-ItemPropertyValue -Name "Capacity")
    $MiningCycleTime = ($TimerSettings | Get-ItemPropertyValue -Name "Time")
    $MiningNumber = ($TimerSettings | Get-ItemPropertyValue -Name "Number")
    $HoldCapacity = ($TimerSettings | Get-ItemPropertyValue -Name "HoldCapacity")
    Write-Information ("Found Settings for " + $MiningNumber + " Mining Lasers at " + $MiningCycleCap + "m3 every " + $MiningCycleTime + " seconds.`nShip Ore Capacity: " + $HoldCapacity + "m3.")
    $SettingsConfirm = Read-Host -Prompt "Do you want to use these settings"
}
else
{
    $SettingsConfirm = "N"    
}

if(([String]($SettingsConfirm.ToCharArray())[0]).ToUpper() -eq "Y")
{
    $NumbersValid = $true
}
else
{
    do{
        try
        {    
            [double]$MiningCycleCap = Read-Host -Prompt "Single Laser Cycle Capacity"
        }
        catch
        {
            Write-Warning -MessageData "Invalid Entry"
        }
    }until($?)
    do{
        try
        {    
            [double]$MiningCycleTime = Read-Host -Prompt "Time per Cycle (Seconds)"
        }
        catch
        {
            Write-Warning -MessageData "Invalid Entry"
        }
    }until($?)
    do{
        try
        {    
            [double]$MiningNumber = Read-Host -Prompt "Number of Mining Lasers"
        }
        catch
        {
            Write-Warning -MessageData "Invalid Entry"
        }
    }until($?)
    do{
        try
        {    
            [double]$HoldCapacity = Read-Host -Prompt "Ship Ore Hold Capacity"
        }
        catch
        {
            Write-Warning -MessageData "Invalid Entry"
        }
    }until($?)

    $NumbersValid = $true
    do{
        try
        {    
            $SaveSettings = Read-Host -Prompt "Do you want to save current settings for future use?"
        }
        catch
        {
            Write-Warning -MessageData "Invalid Entry"
        }
    }until($?)

    if(([String]($SaveSettings.ToCharArray())[0]).ToUpper() -eq "Y")
    {
       if(!(Test-Path "HKLM:\SOFTWARE\CustomPowershell\"))
       {
            New-Item -Path "HKLM:\SOFTWARE" -Name "CustomPowershell"
       } 
       if(!(TEst-Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\"))
       {
            New-Item -Path "HKLM:\SOFTWARE\CustomPowershell\" -Name "EVEMiningTimer"
       }
       if(Test-ItemProperty -path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -name "Capacity")
       {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "Capacity" -Value $MiningCycleCap
       }
       else
       {
            New-ItemProperty  -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "Capacity" -Value $MiningCycleCap
       }
       if(Test-ItemProperty -path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -name "Time")
       {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "Time" -Value $MiningCycleTime
       }
       else
       {
            New-ItemProperty  -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "Time" -Value $MiningCycleTime
       }
       if(Test-ItemProperty -path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -name "Number")
       {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "Number" -Value $MiningNumber
       }
       else
       {
            New-ItemProperty  -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "Number" -Value $MiningNumber
       }
       if(Test-ItemProperty -path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -name "HoldCapacity")
       {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "HoldCapacity" -Value $HoldCapacity
       }
       else
       {
            New-ItemProperty  -Path "HKLM:\SOFTWARE\CustomPowershell\EVEMiningTimer\" -Name "HoldCapacity" -Value $HoldCapacity
       }

    }
}
if($NumbersValid)
{
    [double]$AsteroidSize = 0
    [double]$TimeRemaining = 0
    [double]$AsteroidTime = 0
    [int]$Pretimer = 3
    $Repeat = $true
    while($Repeat)
    {
        $AsteroidSize = Read-Host -Prompt "Asteroid Size"
        if($AsteroidSize -gt 0)
        {
            $Repeat = $true
            $AsteroidTime = [math]::round($AsteroidSize / ($MiningCycleCap/$MiningCycleTime*$MiningNumber))
            $TimeRemaining = $AsteroidTime
            Write-Information ("Asteroid will take " + [math]::Ceiling($AsteroidTime) + " seconds.")
            Write-Information "Starting in 5 seconds."
            $Pretimer
            while($PreTimer -ge 0)
            {
                Write-Information ("Starting in " + $Pretimer)
                if ($Pretimer -le 3)
                {
                    if($Pretimer -eq 0)
                    {
                        [console]::beep(1000,500)
                    }
                    else {
                        [console]::beep(750,250)
                    }
                }
                $Pretimer -= 1               
                Start-Sleep -Seconds 1                                               
            }
            $PreTimer = 5

            while($TimeRemaining -ge 0)
            {
                Write-Progress -ID 1 -Activity "Mining Timer Active" -Status ("Time Remaining: " + [math]::Floor($TimeRemaining / 60) + ":" + ([math]::Floor($TimeRemaining % 60).ToString("00")))  -PercentComplete (($TimeRemaining / $AsteroidTime) * 100) -ErrorAction "SilentlyContinue"
                if($TimeRemaining -le 3)
                {
                    if($TimeRemaining -eq 0)
                    {
                        [console]::beep(1000,500)
                    }
                    else {
                        [console]::beep(750,250)
                    }
                }
                $TimeRemaining -= 1
                Start-Sleep -Seconds 1
            }
        }
        else {
            Write-Information "Leaving"
            $Repeat = $false

        }
        
    }
}