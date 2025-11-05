/*------------------------------------------------------------------------
    File        : Customer.cls
    Purpose     : Customer class for safe navigation operator example
    Syntax      : 
    Description : Demonstrates object-oriented ABL with nested object references
    Author(s)   : 
    Created     : 
    Notes       : 
  ----------------------------------------------------------------------*/

USING examples.Address.

CLASS examples.Customer:

    /* Properties */
    DEFINE PUBLIC PROPERTY CustomerId AS INTEGER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY FirstName AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY LastName AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY Email AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY BillingAddress AS examples.Address NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY ShippingAddress AS Address NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY IsActive AS LOGICAL NO-UNDO 
        GET.
        SET.

    /* Constructor */
    CONSTRUCTOR PUBLIC Customer():
        SUPER().
        IsActive = TRUE.
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC Customer(piCustomerId AS INTEGER, pcFirstName AS CHARACTER, 
                               pcLastName AS CHARACTER, pcEmail AS CHARACTER):
        THIS-OBJECT().
        ASSIGN 
            CustomerId = piCustomerId
            FirstName = pcFirstName
            LastName = pcLastName
            Email = pcEmail.
    END CONSTRUCTOR.

    /* Methods */
    METHOD PUBLIC CHARACTER GetFullName():
        RETURN TRIM(FirstName) + " " + TRIM(LastName).
    END METHOD.

    METHOD PUBLIC CHARACTER GetDisplayName():
        DEFINE VARIABLE cDisplayName AS CHARACTER NO-UNDO.
        
        cDisplayName = GetFullName().
        IF Email <> ? AND Email <> "" THEN
            cDisplayName = cDisplayName + " (" + Email + ")".
            
        RETURN cDisplayName.
    END METHOD.

    METHOD PUBLIC LOGICAL HasValidBillingAddress():
        /* Using safe navigation operator to avoid null reference errors */
        RETURN BillingAddress?:IsValid().
    END METHOD.

    METHOD PUBLIC LOGICAL HasValidShippingAddress():
        /* Using safe navigation operator to avoid null reference errors */
        RETURN ShippingAddress?:IsValid().
    END METHOD.

    METHOD PUBLIC CHARACTER GetBillingCity():
        /* Safe navigation operator returns ? if BillingAddress is null */
        RETURN BillingAddress?:City.
    END METHOD.

    METHOD PUBLIC CHARACTER GetShippingCity():
        /* Safe navigation operator returns ? if ShippingAddress is null */
        RETURN ShippingAddress?:City.
    END METHOD.

    METHOD PUBLIC examples.Customer SetBillingAddress(poAddress AS examples.Address):
        BillingAddress = poAddress.
        RETURN THIS-OBJECT.
    END METHOD.

    METHOD PUBLIC examples.Customer SetShippingAddress(poAddress AS examples.Address):
        ShippingAddress = poAddress.
        RETURN THIS-OBJECT.
    END METHOD.

END CLASS.
