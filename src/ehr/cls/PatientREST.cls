Class ehr.cls.PatientREST Extends (%CSP.REST, %JSON.Adaptor)
{

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/" Method="GET" Call="getAllPatients"/>
    <Route Url="/create" Method="POST" Call="createPatient"/>
    <!-- <Route Url="/contents" Method="GET" Call="getAllMessageContents"/>
    <Route Url="/contents/:limit" Method="GET" Call="getSomeMessageContents"/> -->
    <!-- using query parameter for timestamp -->
    <!-- <Route Url="/timestamp" Method="GET" Call="getMessageFromTimeStamp"/>
    <Route Url="/create/random/:amount" Method="POST" Call="createRandomMessage"/> -->
</Routes>
}

ClassMethod getAllPatients() As %Status
{
    #dim status As %Status = $$$OK
    set %response.ContentType = ..#CONTENTTYPEJSON

    #; &sql(DECLARE C1 CURSOR FOR
    #; SELECT p.id, p.FirstName, p.LastName, h.VisitDate
    #; INTO :id,:FirstName,:LastName,:VisitDate
    #; FROM ehr_cls.HospitalRecord h
    #; JOIN ehr_cls.Patient p ON h.Patient = p.id)

    #; &sql(DECLARE C1 CURSOR FOR
    #; SELECT Patient->id, Patient->FirstName, Patient->LastName, VisitDate
    #; INTO :id,:FirstName,:LastName,:VisitDate
    #; FROM ehr_cls.HospitalRecord
    #; )

    #;  &sql(OPEN C1)
    #;   QUIT:(SQLCODE'=0)
    #; &sql(FETCH C1)

    #; While (SQLCODE = 0) {

    #;     Write id, ":  ", FirstName,LastName,VisitDate,!        
    #;     &sql(FETCH C1)
    #; }
    
    #; &sql(CLOSE C1)

    set rs=##class(%SQL.Statement).%ExecDirect(,"SELECT Patient->id, Patient->FirstName, Patient->LastName, VisitDate FROM ehr_cls.HospitalRecord")
        while rs.%Next() {
            #; write rs.id, rs.FirstName, rs.LastName, rs.VisitDate,!
            write {"patientId": (rs.id), "firstName": (rs.FirstName), "lastName": (rs.LastName), "visitDate": (rs.VisitDate)}.%ToJSON()
        }

    return status
}

ClassMethod createPatient() As %Status
{
    #dim status As %Status = $$$OK
    set %response.ContentType = ..#CONTENTTYPEJSON

    // Create a new instance
     set patient = ##class(ehr.cls.Patient).%New()
     set patient.FirstName = %request.Data("FirstName", 1)
     set patient.LastName = %request.Data("LastName", 1)
     set status = patient.%Save()

     set historyRecord = ##class(ehr.cls.HospitalRecord).%New()
     set historyRecord.VisitDate = 1
     set historyRecordId = historyRecord.%Id()
     set historyRecord.Patient = patient
     do historyRecord.%Save()


     // Save to database (on disk)

     // Optionally return patient ID or status
    #;  else {
    #;      set %response.Data = {
    #;          "status": "error"
    #;         #;  "message": $system.Status.GetErrorText(status)
    #;      }
    #;  }
    #; do %response.Write(result.%ToJSON())

    return status
}

}
