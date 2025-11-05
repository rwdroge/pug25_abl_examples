/*------------------------------------------------------------------------
    File        : Order.cls
    Purpose     : Order class for safe navigation operator example
    Syntax      : 
    Description : Demonstrates method chaining with safe navigation operator
    Author(s)   : 
    Created     : 
    Notes       : 
  ----------------------------------------------------------------------*/

USING examples.Customer.
USING examples.Address.

CLASS examples.Order:

    /* Properties */
    DEFINE PUBLIC PROPERTY OrderId AS INTEGER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY OrderDate AS DATE NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY Customer AS Customer NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY TotalAmount AS DECIMAL NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY Status AS CHARACTER NO-UNDO 
        GET.
        SET.

    DEFINE PUBLIC PROPERTY ShippingMethod AS CHARACTER NO-UNDO 
        GET.
        SET.

    /* Constructor */
    CONSTRUCTOR PUBLIC Order():
        SUPER().
        assign
            this-object:OrderDate = TODAY
            this-object:Status = "Pending".
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC Order(piOrderId AS INTEGER, poCustomer AS Customer):
        THIS-OBJECT().
        ASSIGN 
            OrderId = piOrderId
            Customer = poCustomer.
    END CONSTRUCTOR.

    /* Methods */
    METHOD PUBLIC CHARACTER GetCustomerName():
        /* Safe navigation operator prevents null reference error */
        RETURN Customer?:GetFullName().
    END METHOD.

    METHOD PUBLIC CHARACTER GetCustomerEmail():
        /* Safe navigation operator returns ? if Customer is null */
        RETURN Customer?:Email.
    END METHOD.

    METHOD PUBLIC CHARACTER GetShippingCity():
        /* Chained safe navigation operator - stops at first null reference */
        RETURN Customer?:ShippingAddress?:City.
    END METHOD.

    METHOD PUBLIC CHARACTER GetBillingState():
        /* Chained safe navigation operator */
        RETURN Customer?:BillingAddress?:State.
    END METHOD.

    METHOD PUBLIC LOGICAL HasValidShippingAddress():
        /* Method chaining with safe navigation operator */
        RETURN Customer?:HasValidShippingAddress().
    END METHOD.

    METHOD PUBLIC CHARACTER GetOrderSummary():
        DEFINE VARIABLE cSummary AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cCustomerName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cShippingCity AS CHARACTER NO-UNDO.
        
        /* Using safe navigation to build summary safely */
        cCustomerName = Customer?:GetDisplayName().
        cShippingCity = Customer?:ShippingAddress?:City.
        
        cSummary = "Order " + STRING(this-object:OrderId) + 
                  " - Date: " + STRING(this-object:OrderDate) +
                  " - Status: " + this-object:Status.
                  
        IF cCustomerName <> ? THEN
            cSummary = cSummary + "~nCustomer: " + cCustomerName.
            
        IF cShippingCity <> ? THEN
            cSummary = cSummary + "~nShipping to: " + cShippingCity.
            
        IF TotalAmount > 0 THEN
            cSummary = cSummary + "~nTotal: $" + STRING(TotalAmount, ">>>,>>9.99").
            
        RETURN cSummary.
    END METHOD.

    METHOD PUBLIC examples.Order SetCustomer(poCustomer AS Customer):
        Customer = poCustomer.
        RETURN THIS-OBJECT.
    END METHOD.

    METHOD PUBLIC examples.Order SetStatus(pcStatus AS CHARACTER):
        this-object:Status = pcStatus.
        RETURN THIS-OBJECT.
    END METHOD.

    METHOD PUBLIC examples.Order SetTotalAmount(pdAmount AS DECIMAL):
        TotalAmount = pdAmount.
        RETURN THIS-OBJECT.
    END METHOD.

END CLASS.
