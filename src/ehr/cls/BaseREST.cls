Class ehr.cls.BaseREST Extends ehr.REST.Base
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/_spec" Method="GET" Call="SwaggerSpec"/>
    <Map Prefix="/patient" Forward="ehr.Patient.disp"/> 
    <Map Prefix="/record" Forward="ehr.HospitalRecord.disp"/>
</Routes>
}

ClassMethod SwaggerSpec() As %Status
{
    Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
    Do swagger.info.%Remove("x-ISC_Namespace")
    Set swagger.basePath = "/crud"
    Set swagger.info.title = "InterSystems IRIS REST CRUD demo"
    Set swagger.info.version = "0.1"
    Set swagger.host = "localhost:52773"

    #; write swagger.%ToJSON()
    #; return $$$OK
    return ..%ProcessResult($$$OK, swagger)
}

}
