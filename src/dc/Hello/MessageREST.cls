Class dc.Hello.MessageREST Extends %CSP.REST [ DependsOn = dc.Hello.Message ]
{

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/" Method="GET" Call="getAllMessages"/>
    <Route Url="/contents" Method="GET" Call="getAllMessageContents"/>
    <!-- using query parameter for timestamp -->
    <Route Url="/timestamp" Method="GET" Call="getMessageFromTimeStamp"/>
    <Route Url="/create/random/:amount" Method="POST" Call="createRandomMessage"/>
</Routes>
}

ClassMethod getAllMessages() As %Status
{
    #dim status As %Status = $$$OK
    set %response.ContentType = ..#CONTENTTYPEJSON

    ; the result set
    set rset = ##class(dc.Hello.Message).ExtentFunc()

    ; the json response body stream
    write "["
    if (rset.%Next()) {
        set message = ##class(dc.Hello.Message).%OpenId(rset.ID)
        do message.%JSONExport()
    }
    while (rset.%Next()) {
        write ","
        set message = ##class(dc.Hello.Message).%OpenId(rset.ID)
        do message.%JSONExport()
    }
    write "]"

    return status
}

ClassMethod getMessageFromTimeStamp() As %Status
{
    #dim status As %Status = $$$OK
    set %response.ContentType = ..#CONTENTTYPEJSON
    try {
        set timestamp = %request.Get("timestamp")
        set responseBody = {"timestamp": (timestamp), "DeviceType": (##class(%Library.Device).GetType())}
        write responseBody.%ToJSON()
    }
    catch (ex)
    {
        set status = ex.Code
    }
    return status
}

ClassMethod getAllMessageContents() As %Status
{
    #dim status As %Status = $$$OK
    set %response.ContentType = ..#CONTENTTYPEJSON

    &sql(DECLARE C1 CURSOR FOR
    SELECT id,content INTO :id,:content FROM Message)

    &sql(OPEN C1)
        return:(SQLCODE'=0) status
    &sql(FETCH C1)

    write "["
    if (SQLCODE = 0)
    {
        write { "messageID": ((+id)_""), "content": (content)}.%ToJSON()
        #; write "{'messageID': ",id,",'content': ",'(content)',"}"
        &sql(FETCH C1)
    }
    while (SQLCODE = 0) 
    {
        write ","
        #; write "{message ID: ",+id,",content: ",content,"}"
        write { "messageID": (+id), "content": (content)}.%ToJSON()
        &sql(FETCH C1)
    }
    &sql(CLOSE C1)
    write "]"

    return status
    #; Set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM dc.Hello.Message")
    #; While rs.%Next() {
    #;     Write rs.ID, !
    #; }
}

ClassMethod createRandomMessage(amount As %Integer = 1) As %Status
{
    #dim status As %Status = $$$OK
    set %response.ContentType = ..#CONTENTTYPEJSON

    try
    {
    set allowed = ##class(dc.Hello.Message).AddTestData(amount)
        $$$ThrowOnError(allowed)
    }
    catch (ex)
    {
        set status = ex.Code
    }

    return status
}

}
