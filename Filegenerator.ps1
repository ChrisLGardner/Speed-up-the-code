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
$rnd = [Random]::new()
$Date = [DateTime]::Now
 
$Loglines= foreach ($i in (1..50000)) {
    $timestamp = $date.AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")
    $plc =  $plcnames[$rnd.next($plcNames.count)]
    $operator = $rnd.Next(101, 121)
    $batch = $rnd.Next(1000, 1101)
    $status = $statusCodes[$rnd.Next($statuscodes.count)]
    $machineTemp = [math]::Round(($rnd.Next(60, 110)) + (Get-Random),2)
    $load = $rnd.Next(0, 101)
 
    if (($rnd.Next(1, 8)) -eq 4) {
        $errorType = $errorTypes[$rnd.next($errorTypes.count)]
        if ($errorType -eq 'Sandextrator overload') {
            $value = ($rnd.Next(1, 11))
            "ERROR; $timestamp; $plc; $errorType; $value; $status; $operator; $batch; $machineTemp; $load"
        } else {
            "ERROR; $timestamp; $plc; $errorType; ; $status; $operator; $batch; $machineTemp; $load"
        }
    } else {
        "INFO; $timestamp; $plc; System running normally; ; $status; $operator; $batch; $machineTemp; $load"
    }
}
 
Set-Content -Path $bigFileName -Value $logLines
Write-Output "PLC log file generated."
}