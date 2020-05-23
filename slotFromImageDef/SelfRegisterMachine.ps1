#$global:systemDbConnectionString = 'Server=tcp:async-api-slot-test.9feb36e36d8c.database.windows.net,1433;Persist Security Info=False;User ID=async_api_test;Password=atxqQ4RXH^$$M7QW;Initial Catalog=SystemDB'
#$global:slotDbConnectionString = 'Server=tcp:async-api-slot-test.9feb36e36d8c.database.windows.net,1433;Persist Security Info=False;User ID=async_api_test;Password=atxqQ4RXH^$$M7QW;Initial Catalog=SlotService'
$global:systemDbConnectionString = 'Server=tcp:shared-db-tse.ca78f0df869a.database.windows.net,1433;Persist Security Info=False;User ID=adminuser;Password=HelloWorld123456;Initial Catalog=SystemDB'
$global:slotDbConnectionString = 'Server=tcp:shared-db-tse.ca78f0df869a.database.windows.net,1433;Persist Security Info=False;User ID=adminuser;Password=HelloWorld123456;Initial Catalog=SlotService'

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
        [string] $clusterId
      )
  
    $sqlQuery="declare @machineid TINYINT = 0
               declare @Stamp timestamp 
               Exec dbo.SSISaveServiceMachine  @machineid, $clusterId, '$env:computername', 'Azure Slot VM', 1, 8097, 20, 1, 5, NULL, 0, 0, 0, 0, '$env:computername', 0, @Stamp"

    return Invoke-SQL-No-Count-Timeout $connectionString $sqlQuery 30
}

Write-EventLog -LogName "Application" -Source "Exacttarget Slot Init" -EventID 3001 -EntryType Information -Message "Registering machine with SystemDB" -Category 1 -RawData 10,20

Register-Slot-Machine $global:systemDbConnectionString 1

Write-EventLog -LogName "Application" -Source "Exacttarget Slot Init" -EventID 3001 -EntryType Information -Message "Registering machine with SlotDatabase" -Category 1 -RawData 10,20

Register-Slot-Machine $global:slotDbConnectionString 1


Set-Service "Exacttarget Slot Service" -StartupType "Automatic"

Write-EventLog -LogName "Application" -Source "Exacttarget Slot Init" -EventID 3001 -EntryType Information -Message "Starting ET Slot service" -Category 1 -RawData 10,20
#start the service
Start-Service "Exacttarget Slot Service"