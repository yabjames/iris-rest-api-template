Class ehr.cls.HospitalRecordREST Extends %CSP.REST
{

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/" Method="GET" Call="getAllRecords"/>
    <Route Url="/tz/:region/:zone" Method="GET" Call="getAllRecordsTZ"/>
    <Route Url="/create" Method="POST" Call="createRecord"/>
</Routes>
}

ClassMethod getAllRecordsTZ(region As %String, zone As %String) As %Status
{
        #dim status As %Status = $$$OK
        set %response.ContentType = ..#CONTENTTYPEJSON

        set sql = "SELECT Patient->id, Patient->FirstName, Patient->LastName, VisitDate FROM ehr_cls.HospitalRecord"
        set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
        if (rs.%SQLCODE'=0) return rs.%SQLCODE
        while rs.%Next() {
			set date = $ZDATETIME(rs.VisitDate, 8, 1)
			set hl7 = $REPLACE(date, ":", "")
			set hl7 = $REPLACE(hl7, " ", "")

			set tz = region_"/"_zone
			set visitLocalDateTime = ##class(tz.Ens).TZ(hl7, "Etc/UTC", tz, "%Y-%m-%d %H:%M:%S")

			write {"patientId": (rs.id),
            "firstName": (rs.FirstName),
            "lastName": (rs.LastName),
            "visitDate": (rs.VisitDate),
            "localDate": (visitLocalDateTime)
            }.%ToJSON()
        }

        return status
}

ClassMethod getAllRecords() As %Status
{
        #dim status As %Status = $$$OK
        set %response.ContentType = ..#CONTENTTYPEJSON
        set sql = "SELECT Patient->id, Patient->FirstName, Patient->LastName, VisitDate FROM ehr_cls.HospitalRecord"
        set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
        if (rs.%SQLCODE'=0) return rs.%SQLCODE
        set $ZTIMEZONE = 240
        while rs.%Next() {
            write {"patientId": (rs.id),
            "firstName": (rs.FirstName),
            "lastName": (rs.LastName),
            "visitDate": (rs.VisitDate),
            "localDate": ($ZDATETIME($SYSTEM.Util.UTCtoLocalWithZTIMEZONE(rs.VisitDate), 7, 4))
            }.%ToJSON()
        }
        set $ZTIMEZONE = 0
        return status
}

ClassMethod createRecord() As %Status
{
        #dim status As %Status = $$$OK
        // fetch the request body
        set patientId = %request.Data("patient", 1)
        set patient = ##class(ehr.cls.Patient).%OpenId(patientId)

        // check if the patientId exists
        if ('patient) return $$$NOTOK

        set historyRecord = ##class(ehr.cls.HospitalRecord).%New()
        set historyRecord.VisitDate = $ZTIMESTAMP
        set historyRecord.Patient = patient
        set status = historyRecord.%Save()

        return status
}

}
