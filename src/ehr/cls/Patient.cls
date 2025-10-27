Class ehr.cls.Patient Extends (%Persistent, %JSON.Adaptor)
{

Property id As %String [ InitialExpression = {$System.Util.CreateGUID()}, Required ];

Index PatientIdIDX On id [ IdKey, Unique ];

Property FirstName As %String [ Required ];

Property LastName As %String [ Required ];

// Property DOB As %Date [ Required ];

// Property Condition As %String;

Relationship HospitalRecord As ehr.cls.HospitalRecord [ Cardinality = many, Inverse = Patient ];

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FirstName</Value>
</Value>
<Value name="3">
<Value>LastName</Value>
</Value>
</Data>
<DataLocation>^ehr.cls.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^ehr.cls.PatientD</IdLocation>
<IndexLocation>^ehr.cls.PatientI</IndexLocation>
<StreamLocation>^ehr.cls.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
