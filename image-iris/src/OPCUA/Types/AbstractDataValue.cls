Class OPCUA.Types.AbstractDataValue Extends %SerialObject [ PropertyClass = OPCUA.Types.PropertyClass ]
{

Property SourceTimeStamp As %TimeStamp;

Property ServerTimeStamp As %TimeStamp;

Property Status As %Integer;

Storage Default
{
<Data name="AbstractDataValueState">
<Value name="1">
<Value>SourceTimeStamp</Value>
</Value>
<Value name="2">
<Value>ServerTimeStamp</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<State>AbstractDataValueState</State>
<StreamLocation>^OPCUA.Types.AbstractDataValueS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
