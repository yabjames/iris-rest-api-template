Class ehr.cls.HospitalRecord Extends %Persistent [ DependsOn = ehr.cls.Patient ]
{

Property VisitDate As %Integer;

Relationship Patient As ehr.cls.Patient [ Cardinality = one, Inverse = HospitalRecord, Required ];

Index PatientIndex On Patient;

/// Description
Storage Default
{
<Data name="HospitalRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitDate</Value>
</Value>
<Value name="3">
<Value>Patient</Value>
</Value>
</Data>
<DataLocation>^ehr.cls.HospitalRecordD</DataLocation>
<DefaultData>HospitalRecordDefaultData</DefaultData>
<Description>
<![CDATA[Description]]></Description>
<IdLocation>^ehr.cls.HospitalRecordD</IdLocation>
<IndexLocation>^ehr.cls.HospitalRecordI</IndexLocation>
<StreamLocation>^ehr.cls.HospitalRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
