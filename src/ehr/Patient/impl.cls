/// Business logic class defined by OpenAPI in ehr.Patient.spec<br/>
/// Updated Oct 29, 2025 17:37:58
Class ehr.Patient.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Returns the OpenAPI 2.0 (Swagger) specification for this service.
ClassMethod GetSpec() As %DynamicObject
{
    set specname=$p(..%ClassName(1),".impl")
    Set spec = {}.%FromJSON(##class(%Dictionary.CompiledXData).%OpenId(specname_".spec||OpenAPI").Data)
	Set url = $Select(%request.Secure:"https",1:"http") _ "://"_$Get(%request.CgiEnvs("SERVER_NAME")) _ ":" _ $Get(%request.CgiEnvs("SERVER_PORT")) _ %request.Application
	Set spec.servers = [{"url" : (url)}]
	Quit spec
}

/// Collects form input data and stores it for processing.<br/>
/// The method arguments hold values for:<br/>
///     formData, Form data to be submitted<br/>
ClassMethod submitForm(formData As %Stream.Object) As %Stream.Object
{
    //(Place business logic here)
    //Do ..%SetStatusCode(<HTTP_status_code>)
    Do ..%SetStatusCode($$$OK)
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
}

/// Fetches all patient data (e.g. 'firstName', 'lastName')
ClassMethod getAllPatients() As %Stream.Object
{
    set result=[]
    set rs=##class(%SQL.Statement).%ExecDirect(,"SELECT id, FirstName, LastName FROM ehr_cls.Patient")
        if (rs.%SQLCODE'=0) return rs.%SQLCODE
        while rs.%Next() {
            set result=result.%Push({"patientId": (rs.id), "firstName": (rs.FirstName), "lastName": (rs.LastName)})
        }
    return result
}

/// Send data to create a Patient on disk<br/>
/// The method arguments hold values for:<br/>
///     patientData, The patient to create<br/>
ClassMethod createPatient(patientData As %Stream.Object) As %Stream.Object
{
     set patient = ##class(ehr.cls.Patient).%New()
     set patient.FirstName = %request.Data("firstName", 1)
     set patient.LastName = %request.Data("lastName", 1)
     do patient.%Save()

     set response = {}
     set response.status = "ok"
     set response.patientId = patient.%Id()
     return response.%ToJSON()
}

}
