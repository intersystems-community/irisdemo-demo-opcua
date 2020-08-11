Include (%callout, OPCUA.Constants)

Class OPCUA.Adapter.Common Extends Ens.InboundAdapter
{

/// Configurable settings
Parameter SETTINGS = "URL:Connection,ConnectionRetryTimeout:Connection,DataSourceClass:Data";

// *** PROPERTIES INFLUENCED BY SETTINGS ***

/// The URL of the server from which data is sought. 
/// (e.g. <i>opc.tcp://servername:4840</i>)
Property URL As %String;

/// The name of the DataSource class specifying the 
/// data types and nodes from which to obtain data
/// as well as the fields in which to deposit the results.
Property DataSourceClass As %String;

/// The duration (in seconds), since the last time that 
/// the OPC UA client was able to connect to the target
/// OPC UA server, after which no more connection attempts
/// will be made.
Property ConnectionRetryTimeout As %Integer [ InitialExpression = 600 ];

// *** PRIVATE PROPERTIES ***

Property Client As OPCUA.Client [ Private ];

Property IsConnected As %Integer [ Private ];

Property LastReportedError As %Status [ Private ]; 

Property ConnectionRetryEndTime As %TimeStamp [ Private ];

// *** METHODS ***

Method OnInit() As %Status
{
	#dim tSC as %Status = $$$OK

	try {

		set ..IsConnected = 0

		set ..Client = ##class(OPCUA.Client).%New()
		set tSC = ..Client.Initialize()  Quit:$$$ISERR(tSC)
		Quit:$$$ISERR(tSC)

		set tSC = ..Client.SetupClient()  Quit:$$$ISERR(tSC)
		Quit:$$$ISERR(tSC)

	} catch (e) {
		Set tSC=e.AsStatus()
	}
	
	if $$$ISERR(tSC) {
		$$$LOGERROR("OPCUA Client initialization failed [c.oi] : "_$SYSTEM.Status.GetErrorText(tSC))
		Quit tSC
	} 
	
	Quit tSC  // Quit $$$OK
}

Method Connect() As %Status [ Private ]
{
	#dim tSC as %Status = $$$OK
	
	try {
	
		set tSC = ..Client.Connect(..URL)
		//Quit:$$$ISERR(tSC)

	} catch (e) {
		set tSC = e.AsStatus()
	}

	Quit tSC
}

Method Disconnect() As %Status [ Private ]
{
	#dim tSC as %Status = $$$OK
	
	try {
	
		set tSC = ..Client.Disconnect()
		//Quit:$$$ISERR(tSC)

	} catch (e) {
		set tSC = e.AsStatus()
	}

	Quit tSC
}

Method OnTearDown() As %Status
{
	#dim tSC as %Status = $$$OK

	try {
	
		set tSC = ..Client.Disconnect()
				
	} catch (e) {
		Set tSC=e.AsStatus()
	}
	
	Quit tSC
}

}
