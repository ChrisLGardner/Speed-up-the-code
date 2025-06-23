Measure-Command{
$bigFileName = "plc_log.txt"
$plcNames = 'PLC_A','PLC_B','PLC_C','PLC_D'
$errorTypes = @(
    'Sandextrator overload',
    'Conveyor misalignment',
    'Valve stuck',
    'Temperature warning'
)
$statusCodes = 'OK','WARN','ERR'

 
$Loglines= foreach ($i in (1..50000)) {
    $timestamp = (Get-Date).AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")
    $plc = Get-Random -InputObject $plcNames
    $operator = Get-Random -Minimum 101 -Maximum 121
    $batch = Get-Random -Minimum 1000 -Maximum 1101
    $status = Get-Random -InputObject $statusCodes
    $machineTemp = [math]::Round((Get-Random -Minimum 60 -Maximum 110) + (Get-Random),2)
    $load = Get-Random -Minimum 0 -Maximum 101
 
    if ((Get-Random -Minimum 1 -Maximum 8) -eq 4) {
        $errorType = Get-Random -InputObject $errorTypes
        if ($errorType -eq 'Sandextrator overload') {
            $value = (Get-Random -Minimum 1 -Maximum 11)
            "ERROR; $timestamp; $plc; $errorType; $value; $status; $operator; $batch; $machineTemp; $load"
        } else {
            "ERROR; $timestamp; $plc; $errorType; ; $status; $operator; $batch; $machineTemp; $load"
        }
    } else {
        "INFO; $timestamp; $plc; System running normally; ; $status; $operator; $batch; $machineTemp; $load"
    }
}
 
#set-Content -Path $bigFileName -Value $logLines
Write-Output "PLC log file generated."
}