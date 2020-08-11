Class Examples.OPCUADS.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Examples.OPCUADS.ExampleProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="PollingExample" Category="" ClassName="OPCUA.Service.TCPPollingService" PoolSize="1"
 Enabled="false" Foreground="false" 
 Comment="This example repeatedly polls a locally-running OPC UA server for input." 
 LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DataSourceClass">Examples.OPCUADS.PollingExample</Setting>
    <Setting Target="Adapter" Name="URL">opc.tcp://plc</Setting>
    <Setting Target="Adapter" Name="CallInterval">1</Setting>
  </Item>
  <Item Name="SubscriptionExample" Category="" ClassName="OPCUA.Service.TCPSubscriptionService" PoolSize="1"
 Enabled="false" Foreground="false" 
 Comment="This example receives input data from a subscription to monitored items on a locally-running OPC UA server." 
 LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DataSourceClass">Examples.OPCUADS.SubscriptionExample</Setting>
    <Setting Target="Adapter" Name="URL">opc.tcp://plc</Setting>
    <Setting Target="Adapter" Name="RequestedPublishingInterval">300</Setting>
    <Setting Target="Adapter" Name="RequestedSamplingInterval">0</Setting>
    <Setting Target="Adapter" Name="RequestedQueueSize">5</Setting>
  </Item>
  <Item Name="InternetPollingExample" Category="" ClassName="OPCUA.Service.TCPPollingService" PoolSize="1"
 Enabled="false" Foreground="false" 
 Comment="This example reoeatedly polls a public OPC UA server at opcuaserver.com." 
 LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DataSourceClass">Examples.OPCUADS.InternetPollingExample</Setting>
    <Setting Target="Adapter" Name="URL">opc.tcp://opcuaserver.com:48010</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
  </Item>
  <Item Name="InternetSubscriptionExample" Category="" ClassName="OPCUA.Service.TCPSubscriptionService" PoolSize="1"
 Enabled="false" Foreground="false" 
 Comment="This example creates a subscription to monitored items on a pubic OPC UA server at opcuaserver.com."
 LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DataSourceClass">Examples.OPCUADS.InternetSubscriptionExample</Setting>
    <Setting Target="Adapter" Name="URL">opc.tcp://opcuaserver.com:48010</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
    <Setting Target="Adapter" Name="ReestablishOnEmptyResult">3</Setting>
  </Item>
</Production>
}

}
