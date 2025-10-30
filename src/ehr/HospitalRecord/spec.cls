Class ehr.HospitalRecord.spec Extends %REST.Spec [ ProcedureBlock ]
{

Parameter CONTENTTYPE = "application/json";

Parameter ExposeServerExceptions = 1;

XData OpenAPI [ MimeType = application/json ]
{
{
    "swagger": "2.0",
    "info": {
        "version": "1.0.0",
        "title": "Hospital Records API"
    },
    "basePath": "/ehr/record",
    "schemes": [
        "http",
        "https"
    ],
    "paths": {
        "/_spec": {
            "get": {
                "summary": "Get this API's Swagger spec",
                "description": "Returns the OpenAPI 2.0 (Swagger) specification for this service.",
                "operationId": "GetSpec",
                "produces": [
                    "application/json"
                ],
                "responses": {
                    "200": {
                        "description": "The Swagger spec document",
                        "schema": {
                            "type": "object",
                            "additionalProperties": true
                        }
                    }
                }
            }
        },
        "/": {
            "get": {
                "summary": "Fetch all patient hospital records",
                "description": "Fetches all patient hospital records",
                "operationId": "getAllRecords",
                "responses": {
                    "200": {
                        "description": "All record data successfully fetched",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "patientId": {
                                    "type": "string",
                                    "format": "UUID",
                                    "example": "550e8400-e29b-41d4-a716-446655440000"
                                },
                                "firstName": {
                                    "type": "string",
                                    "example": "John"
                                },
                                "lastName": {
                                    "type": "string",
                                    "example": "Doe"
                                },
                                "visitDate": {
                                    "type": "string",
                                    "format": "UTC DateTime in $ZTIMESTAMP",
                                    "example": "64701,55047.9843342" 
                                }
                            }
                        }
                    }
                }
            }
        },
        "/tz/{region}/{location}": {
            "get": {
                "summary": "Fetch all patient hospital records and returns them in a given timezone",
                "description": "Fetches all patient hospital records in your preferred timezone. For example, if you want to view the records in EST, then you can call with '/ehr/record/tz/America/New_York'",
                "operationId": "getAllRecordsTZ",
                "parameters": [
                    {
                        "in": "path",
                        "name": "region",
                        "type": "string",
                        "description": "This is the part of the TZ identifier that indicates the continent, country, or region (e.g. America, Europe, Pacific)"
                    },
                    {
                        "in": "path",
                        "name": "location",
                        "type": "string",
                        "description": "The location part of the TZ identifier is usually a major city, island, or region (e.g. New_York, Berlin, Tokyo)"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "All record data successfully fetched",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "patientId": {
                                    "type": "string",
                                    "format": "UUID",
                                    "example": "550e8400-e29b-41d4-a716-446655440000"
                                },
                                "firstName": {
                                    "type": "string",
                                    "example": "John"
                                },
                                "lastName": {
                                    "type": "string",
                                    "example": "Doe"
                                },
                                "visitDate": {
                                    "type": "string",
                                    "format": "%Y-%m-%d %H:%M:%S",
                                    "example": "64701,55047.9843342" 
                                }
}
                        }
                    }
                }
            }
        },
        "/create": {
            "post": {
                "summary": "Create a hospital record for a patient",
                "description": "Create a hospital record for a patient with a given patientId in UUID format",
                "operationId": "createRecord",
                "parameters": [
                    {
                        "in": "body",
                        "name": "patientData",
                        "description": "The hospital record to create",
                        "schema": {
                            "type": "object",
                            "required": [
                                "patientId"
                            ],
                            "properties": {
                                "patientId": {
                                    "type": "string",
                                    "format":"UUID",
                                    "example":"550e8400-e29b-41d4-a716-446655440000"
                                }
                            }
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Form submitted successfully",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "recordId": {
                                    "type": "string",
                                    "format":"UUID",
                                    "example":"550e8400-e29b-41d4-a716-446655440000"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
}

}
