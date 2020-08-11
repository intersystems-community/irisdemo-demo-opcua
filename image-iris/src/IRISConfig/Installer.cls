Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

/// This method will create an Interoperability credential meant to be used on Interoperability Productions.
/// It will use the standard SuperUser/sys password for demos.
ClassMethod CreateCredentials(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		Set tNS=$Namespace
		ZN pNamespace
		
		Set tSC = ##class(Ens.Config.Credentials).SetCredential("IrisOpcUaDemo", "SuperUser", "sys", 1)
		Quit:$System.Status.IsError(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN tNS
	
	Quit tSC 
}

ClassMethod LoadConnectorAndDemos(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		Set tNS=$Namespace
		ZN pNamespace
				
        set tSC = ##class(OPCUA.Utils).Install("/usr/irissys/bin/irisopcua.so")	

		Do ##class(Examples.OPCUADS.Utils).LoadOnInstallation()
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN tNS
	
	Quit tSC 
}

/// Runs during docker build
XData Install [ XMLNamespace = INSTALLER ]
{ 
<Manifest>

	<Namespace Name="${Namespace}" Create="no"> 
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>            
        </IfDef>                
	</Namespace>

	<Log Text="Loading transactional data..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadConnectorAndDemos" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<Log Text="Creating credentials..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="CreateCredentials" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
</Manifest>
}
}