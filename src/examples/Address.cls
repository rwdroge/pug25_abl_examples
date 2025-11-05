/*------------------------------------------------------------------------
    File        : Address.cls
    Purpose     : Address class for safe navigation operator example
    Syntax      : 
    Description : Demonstrates object-oriented ABL with properties
    Author(s)   : 
    Created     : 
    Notes       : 
  ----------------------------------------------------------------------*/

CLASS examples.Address:

    /* Properties */
    DEFINE PUBLIC PROPERTY Street AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY City AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY ZipCode AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY Country AS CHARACTER NO-UNDO 
        GET.
        SET.

    /* Constructor */
    CONSTRUCTOR PUBLIC Address():
        SUPER().
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC Address(pcStreet AS CHARACTER, pcCity AS CHARACTER, 
                              pcState AS CHARACTER, pcZipCode AS CHARACTER):
        THIS-OBJECT().
        ASSIGN 
            Street = pcStreet
            City = pcCity
            State = pcState
            ZipCode = pcZipCode
            Country = "USA".
    END CONSTRUCTOR.

    /* Methods */
    METHOD PUBLIC CHARACTER GetFullAddress():
        DEFINE VARIABLE cFullAddress AS CHARACTER NO-UNDO.
        
        cFullAddress = TRIM(Street) + "~n" +
                      TRIM(City) + ", " + TRIM(State) + " " + TRIM(ZipCode).
        
        IF Country <> ? AND Country <> "" AND Country <> "USA" THEN
            cFullAddress = cFullAddress + "~n" + Country.
            
        RETURN cFullAddress.
    END METHOD.

    METHOD PUBLIC LOGICAL IsValid():
        RETURN (Street <> ? AND Street <> "" AND
                City <> ? AND City <> "" AND
                State <> ? AND State <> "" AND
                ZipCode <> ? AND ZipCode <> "").
    END METHOD.

END CLASS.
