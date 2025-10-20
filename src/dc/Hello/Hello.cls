Class dc.Hello.Hello Extends Sample.REST.Base
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/hello" Method="GET" Call="Hello" Cors="true"/>
<!-- Get all records of Person class -->

</Routes>
}

ClassMethod Hello() As %Status
{

    Set %response.Status = 200
    do ##class(%REST.Impl).%WriteResponse({"Hello":"World"}.%ToJSON())
    return %response
}

}
