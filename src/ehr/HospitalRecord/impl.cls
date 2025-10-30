/// Business logic class defined by OpenAPI in ehr.HospitalRecord.spec<br/>
/// Created Oct 30, 2025 14:31:59
Class ehr.HospitalRecord.impl Extends %REST.Impl [ ProcedureBlock ]
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

/// Fetches all patient hospital records
ClassMethod getAllRecords() As %Stream.Object
{

    set sql = "SELECT Patient->id, Patient->FirstName, Patient->LastName, VisitDate FROM ehr_cls.HospitalRecord"
    set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
    if (rs.%SQLCODE'=0) return rs.%SQLCODE

    set response = []
    while rs.%Next() {
        set row = {}
        set row.patientId = rs.id
        set row.firstName = rs.FirstName
        set row.lastName = rs.LastName
        set row.visitDate = rs.VisitDate
        do response.%Push(row)
    }
    return response
}

/// Fetches all patient hospital records in your preferred timezone. For example, if you want to view the records in EST, then you can call with '/ehr/record/tz/America/New_York'<br/>
/// The method arguments hold values for:<br/>
///     region, This is the part of the TZ identifier that indicates the continent, country, or region (e.g. America, Europe, Pacific)<br/>
///     location, The location part of the TZ identifier is usually a major city, island, or region (e.g. New_York, Berlin, Tokyo)<br/>
ClassMethod getAllRecordsTZ(region As %String, location As %String) As %Stream.Object
{
    set sql = "SELECT Patient->id, Patient->FirstName, Patient->LastName, VisitDate FROM ehr_cls.HospitalRecord"
    set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
    if (rs.%SQLCODE'=0) return rs.%SQLCODE

    set response = []
    while rs.%Next() {
        set date = $ZDATETIME(rs.VisitDate, 8, 1)
        set hl7 = $REPLACE(date, ":", "")
        set hl7 = $REPLACE(hl7, " ", "")

        set tz = region_"/"_location
        set visitLocalDateTime = ##class(tz.Ens).TZ(hl7, "Etc/UTC", tz, "%Y-%m-%d %H:%M:%S")

        set row = {}
        set row.patientId = rs.id
        set row.firstName = rs.FirstName
        set row.lastName = rs.LastName
        set row.visitDate = visitLocalDateTime
        do response.%Push(row)
    }
    return response
}

/// Create a hospital record for a patient with a given patientId in UUID format<br/>
/// The method arguments hold values for:<br/>
///     patientData, The hospital record to create<br/>
ClassMethod createRecord(patientData As %Stream.Object) As %Stream.Object
{
        // fetch the request body
        set patientId = %request.Data("patientId", 1)
        set patient = ##class(ehr.cls.Patient).%OpenId(patientId)

        // check if the patientId exists
        if ('patient) return $$$NOTOK

        set record = ##class(ehr.cls.HospitalRecord).%New()
        set record.VisitDate = $ZTIMESTAMP
        set record.Patient = patient
        set status = record.%Save()

        set response = {}
        set response.recordId = record.%Id()
        return response
}

}
