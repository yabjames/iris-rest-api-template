Class dc.Hello.Message Extends (%Persistent, %JSON.Adaptor, %Populate)
{

Property content As %String;

Property timestamp As %TimeStamp;

Property author As %String;

Storage Default
{
<Data name="MessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>content</Value>
</Value>
<Value name="3">
<Value>timestamp</Value>
</Value>
<Value name="4">
<Value>author</Value>
</Value>
</Data>
<DataLocation>^dc.Hello.MessageD</DataLocation>
<DefaultData>MessageDefaultData</DefaultData>
<IdLocation>^dc.Hello.MessageD</IdLocation>
<IndexLocation>^dc.Hello.MessageI</IndexLocation>
<StreamLocation>^dc.Hello.MessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod AddTestData(amount As %Integer)
{
        do ..Populate(amount)
}

}
