#sample run
#.\SelfRegisterMachine-Template.ps1 -systemdbservername "maheshgautam-localhost.8ff678fa9950.database.windows.net" -slotworkerservername "maheshgautam-localhost.8ff678fa9950.database.windows.net" -dbusername "adminuser" -dbpassword "P@ssw0rd12345678910!"" -clustername "TSE Service Cluster"

param ($systemdbservername,$slotworkerservername,$dbusername,$dbpassword, $clustername)
$global:systemDbConnectionString = 'Server=tcp:'+$systemdbservername+',1433;Persist Security Info=False;User ID='+$dbusername+';Password='+$dbpassword+';Initial Catalog=SystemDB'
$global:slotDbConnectionString = 'Server=tcp:'+$slotworkerservername+',1433;Persist Security Info=False;User ID='+$dbusernamer+';Password='+$dbpassword+';Initial Catalog=SlotService'

New-EventLog -LogName "Application" -Source "Exacttarget Slot Init"

function Invoke-SQL-No-Count-Timeout {
    param(
        [string] $connectionString,
        [string] $sqlCommand,
        [int] $timeout
      )

    $cnn = New-Object system.data.SqlClient.SQLConnection($connectionString)

	$cnn.Open()
	
	$cmd = New-Object system.data.sqlclient.sqlcommand($sqlCommand, $cnn)
    $cmd.CommandTimeout = $timeout;
    $retval = $cmd.ExecuteNonQuery()
	if ( $retval -lt -1 )
    {
		Write-Host "Failed with error code $($retval)"
	}
    
    $cnn.Close()

    return $retval
}


function Register-Slot-Machine {
    param(
        [string] $connectionString,
        [string] $clustername
      )
    # TODO
    # retrieve Clusterid by ClusterName
  
    $sqlQuery="declare @machineid TINYINT = 0
               declare @Stamp timestamp 
               Exec dbo.SSISaveServiceMachine  @machineid, 1, '$env:computername', 'Azure Slot VM', 1, 8097, 20, 1, 5, NULL, 0, 0, 0, 0, '$env:computername', 0, @Stamp"

    return Invoke-SQL-No-Count-Timeout $connectionString $sqlQuery 30
}

Write-EventLog -LogName "Application" -Source "Exacttarget Slot Init" -EventID 3001 -EntryType Information -Message "Registering machine with SystemDB" -Category 1 -RawData 10,20

Register-Slot-Machine $global:systemDbConnectionString $clustername

Write-EventLog -LogName "Application" -Source "Exacttarget Slot Init" -EventID 3001 -EntryType Information -Message "Registering machine with SlotDatabase" -Category 1 -RawData 10,20

Register-Slot-Machine $global:slotDbConnectionString $clustername


Set-Service "Exacttarget Slot Service" -StartupType "Automatic"

Write-EventLog -LogName "Application" -Source "Exacttarget Slot Init" -EventID 3001 -EntryType Information -Message "Starting ET Slot service" -Category 1 -RawData 10,20
#start the service
Start-Service "Exacttarget Slot Service"