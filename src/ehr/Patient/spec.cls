Class ehr.Patient.spec Extends %REST.Spec [ ProcedureBlock ]
{

Parameter CONTENTTYPE = "application/json";

Parameter ExposeServerExceptions = 1;

XData OpenAPI [ MimeType = application/json ]
{
{
    "swagger": "2.0",
    "info": {
        "version": "1.0.0",
        "title": "Patient API"
    },
    "basePath": "/crud/patient",
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
                "summary": "Fetch all patient data",
                "description": "Fetches all patient data (e.g. 'firstName', 'lastName')",
                "operationId": "getAllPatients",
                "responses": {
                    "200": {
                        "description": "All patient data successfully fetched",
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
                                }
                            }
                        }
                    }
                }
            }
        },
        "/create": {
            "post": {
                "summary": "Send data to create a Patient on disk",
                "operationId": "createPatient",
                "parameters": [
                    {
                        "in": "body",
                        "name": "patientData",
                        "description": "The patient to create",
                        "schema": {
                            "type": "object",
                            "required": [
                                "firstName",
                                "lastName"
                            ],
                            "properties": {
                                "firstName": {
                                    "type": "string"
                                },
                                "lastName": {
                                    "type": "string"
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
                                "status": {
                                    "type": "string",
                                    "example": "success"
                                },
                                "message": {
                                    "type": "string",
                                    "example": "Form data received successfully."
                                }
                            }
                        }
                    }
                }
            }
        },
        "/submit": {
            "post": {
                "summary": "Submit form data",
                "description": "Collects form input data and stores it for processing.",
                "operationId": "submitForms",
                "parameters": [
                    {
                        "in": "body",
                        "name": "formData",
                        "description": "Form data to be submitted",
                        "required": true,
                        "schema": {
                            "type": "object",
                            "required": [
                                "amount",
                                "name",
                                "taxid",
                                "nationality",
                                "email"
                            ],
                            "properties": {
                                "amount": {
                                    "type": "number",
                                    "format": "integer",
                                    "description": "The monetary amount"
                                },
                                "name": {
                                    "type": "string",
                                    "example": "John Doe",
                                    "description": "Full name of the individual"
                                },
                                "taxid": {
                                    "type": "string",
                                    "example": "AB123456C",
                                    "description": "Tax identification number"
                                },
                                "nationality": {
                                    "type": "string",
                                    "example": "british",
                                    "description": "Nationality of the individual"
                                },
                                "email": {
                                    "type": "string",
                                    "format": "email",
                                    "example": "john.doe@example.com",
                                    "description": "Email address of the individual"
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
                                "status": {
                                    "type": "string",
                                    "example": "success"
                                },
                                "message": {
                                    "type": "string",
                                    "example": "Form data received successfully."
                                }
                            }
                        }
                    },
                    "400": {
                        "description": "Invalid input data",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "status": {
                                    "type": "string",
                                    "example": "error"
                                },
                                "message": {
                                    "type": "string",
                                    "example": "Validation error: missing or invalid fields."
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
