/*------------------------------------------------------------------------
    File        : SafeNavigationExample.p
    Purpose     : Demonstrates the Safe Navigation Operator (?:) in ABL
    Syntax      : 
    Description : Shows various scenarios where the safe navigation operator
                  prevents null reference errors in object-oriented ABL
    Author(s)   : 
    Created     : 
    Notes       : The safe navigation operator (?:) provides conditional
                  execution of object member access, returning ? (unknown)
                  if any object in the chain is null/invalid
  ----------------------------------------------------------------------*/

USING examples.Customer.
USING examples.Address.  
USING examples.Order.

/* Variables */
DEFINE VARIABLE oCustomer1 AS Customer NO-UNDO.
DEFINE VARIABLE oCustomer2 AS Customer NO-UNDO.
DEFINE VARIABLE oAddress1 AS Address NO-UNDO.
DEFINE VARIABLE oAddress2 AS Address NO-UNDO.
DEFINE VARIABLE oOrder1 AS Order NO-UNDO.
DEFINE VARIABLE oOrder2 AS Order NO-UNDO.
DEFINE VARIABLE cResult AS CHARACTER NO-UNDO.
DEFINE VARIABLE lResult AS LOGICAL NO-UNDO.

MESSAGE "=== Safe Navigation Operator (?:) Examples ===".

/* Example 1: Basic Safe Navigation with Null Objects */
MESSAGE "Example 1: Basic Safe Navigation with Null Objects" VIEW-AS ALERT-BOX.

/* Traditional Approach: Would require explicit null check to avoid runtime error
   IF oCustomer1 <> ? THEN
       cResult = oCustomer1:FirstName.
   ELSE
       cResult = ?.
*/

/* Safe Navigation Approach: Returns ? instead of causing runtime error */
cResult = oCustomer1?:FirstName.
MESSAGE "Null customer first name: " + STRING(cResult) VIEW-AS ALERT-BOX.

/* Traditional: IF oCustomer1 <> ? THEN cResult = oCustomer1:GetFullName(). ELSE cResult = ?. */
cResult = oCustomer1?:GetFullName().
MESSAGE "Null customer full name: " + STRING(cResult) VIEW-AS ALERT-BOX.

/* Example 2: Safe Navigation with Valid Objects */
MESSAGE "Example 2: Safe Navigation with Valid Objects" VIEW-AS ALERT-BOX.

oCustomer2 = NEW Customer(1001, "John", "Doe", "john.doe@email.com").

/* Traditional Approach: Direct access is safe when object is known to be valid
   cResult = oCustomer2:FirstName.
*/

/* Safe Navigation Approach: Works identically with valid objects */
cResult = oCustomer2?:FirstName.
MESSAGE "Valid customer first name: " + cResult VIEW-AS ALERT-BOX.

/* Traditional: cResult = oCustomer2:GetFullName(). */
cResult = oCustomer2?:GetFullName().
MESSAGE "Valid customer full name: " + cResult VIEW-AS ALERT-BOX.

/* Example 3: Chained Safe Navigation */
MESSAGE "Example 3: Chained Safe Navigation" VIEW-AS ALERT-BOX.

/* Traditional Approach: Requires nested null checks
   IF oCustomer2 <> ? THEN DO:
       IF oCustomer2:BillingAddress <> ? THEN
           cResult = oCustomer2:BillingAddress:City.
       ELSE
           cResult = ?.
   END.
   ELSE
       cResult = ?.
*/

/* Safe Navigation Approach: Chain stops at first null, returns ? */
cResult = oCustomer2?:BillingAddress?:City.
MESSAGE "Customer with no billing address city: " + STRING(cResult) VIEW-AS ALERT-BOX.

/* Add billing address and try again */
oAddress1 = NEW Address("123 Main St", "Anytown", "CA", "12345").
oCustomer2:BillingAddress = oAddress1.

/* Traditional: cResult = oCustomer2:BillingAddress:City. */
cResult = oCustomer2?:BillingAddress?:City.
MESSAGE "Customer with billing address city: " + cResult VIEW-AS ALERT-BOX.

/* Example 4: Safe Navigation in Method Calls */
MESSAGE "Example 4: Safe Navigation in Method Calls" VIEW-AS ALERT-BOX.

/* Traditional Approach: Check object validity before calling methods
   IF oCustomer2 <> ? THEN
       lResult = oCustomer2:HasValidBillingAddress().
   ELSE
       lResult = ?.
*/

/* Safe Navigation Approach: Method calls return ? if object is null */
lResult = oCustomer2?:HasValidBillingAddress().
MESSAGE "Customer has valid billing address: " + STRING(lResult) VIEW-AS ALERT-BOX.

/* Traditional: IF oCustomer2 <> ? THEN lResult = oCustomer2:HasValidShippingAddress(). ELSE lResult = ?. */
lResult = oCustomer2?:HasValidShippingAddress().
MESSAGE "Customer has valid shipping address: " + STRING(lResult) VIEW-AS ALERT-BOX.

/* Example 5: Safe Navigation in Complex Scenarios */
MESSAGE "Example 5: Safe Navigation in Complex Scenarios" VIEW-AS ALERT-BOX.

/* Create order with customer */
oOrder1 = NEW Order(5001, oCustomer2).
oOrder1:SetTotalAmount(299.99):SetStatus("Processing").

/* Traditional Approach: Check each level in the object graph
   IF oOrder1 <> ? THEN
       cResult = oOrder1:GetCustomerName().
   ELSE
       cResult = ?.
*/

/* Safe Navigation Approach: Simplified access through object graph */
cResult = oOrder1?:GetCustomerName().
MESSAGE "Order customer name: " + cResult VIEW-AS ALERT-BOX.

/* Traditional: IF oOrder1 <> ? THEN cResult = oOrder1:GetShippingCity(). ELSE cResult = ?. */
cResult = oOrder1?:GetShippingCity().
MESSAGE "Order shipping city (no shipping address): " + STRING(cResult) VIEW-AS ALERT-BOX.

/* Add shipping address */
oAddress2 = NEW Address("456 Oak Ave", "Somewhere", "NY", "67890").
oCustomer2:ShippingAddress = oAddress2.

/* Traditional: cResult = oOrder1:GetShippingCity(). */
cResult = oOrder1?:GetShippingCity().
MESSAGE "Order shipping city (with shipping address): " + cResult VIEW-AS ALERT-BOX.

/* Example 6: Safe Navigation vs Traditional Approach */
MESSAGE "Example 6: Safe Navigation vs Traditional Approach" VIEW-AS ALERT-BOX.

/* Create order without customer */
oOrder2 = NEW Order().

/* Safe navigation approach - no error */
cResult = oOrder2?:Customer?:FirstName.
MESSAGE "Safe navigation result (null customer): " + STRING(cResult) VIEW-AS ALERT-BOX.

/* Traditional approach would require explicit null checks */
IF oOrder2:Customer <> ? THEN DO:
    cResult = oOrder2:Customer:FirstName.
    MESSAGE "Traditional approach result: " + cResult VIEW-AS ALERT-BOX.
END.
ELSE DO:
    MESSAGE "Traditional approach: Customer is null, cannot access FirstName" VIEW-AS ALERT-BOX.
END.

/* Example 7: Safe Navigation in Complex Method Chains */
MESSAGE "Example 7: Safe Navigation in Complex Method Chains" VIEW-AS ALERT-BOX.

/* Traditional Approach: Explicit null check before method call
   IF oOrder1 <> ? THEN
       cResult = oOrder1:GetOrderSummary().
   ELSE
       cResult = ?.
*/

/* Safe Navigation Approach: Clean, single-line access */
cResult = oOrder1?:GetOrderSummary().
MESSAGE "Order summary:~n" + cResult VIEW-AS ALERT-BOX.

/* Example 8: Safe Navigation with Method Chaining (Fluent Interface) */
MESSAGE "Example 8: Safe Navigation with Method Chaining" VIEW-AS ALERT-BOX.

/* Traditional Approach: Check object before chaining methods
   IF oOrder2 <> ? THEN
       oOrder2:SetCustomer(oCustomer2):SetStatus("Shipped"):SetTotalAmount(150.00).
*/

/* Safe Navigation Approach: Can be used in fluent interfaces
   Note: The methods return THIS-OBJECT to enable chaining */
oOrder2?:SetCustomer(oCustomer2)?:SetStatus("Shipped")?:SetTotalAmount(150.00).

IF oOrder2 <> ? THEN DO:
    cResult = oOrder2:GetOrderSummary().
    MESSAGE "Fluent interface order summary:~n" + cResult VIEW-AS ALERT-BOX.
END.

/* Example 9: Performance Consideration */
MESSAGE "Example 9: Performance and Best Practices" VIEW-AS ALERT-BOX.

/* Traditional Approach: Manual checks at each level
   IF oCustomer2 <> ? THEN DO:
       IF oCustomer2:BillingAddress <> ? THEN
           cResult = oCustomer2:BillingAddress:GetFullAddress().
       ELSE
           cResult = ?.
   END.
   ELSE
       cResult = ?.
*/

/* Safe Navigation Approach: Short-circuit evaluation
   Stops as soon as it encounters a null reference
   More efficient and cleaner than checking each level manually */

/* Good practice: Store result if used multiple times */
cResult = oCustomer2?:BillingAddress?:GetFullAddress().
IF cResult <> ? THEN DO:
    MESSAGE "Billing address:~n" + cResult VIEW-AS ALERT-BOX.
END.
ELSE DO:
    MESSAGE "No billing address available" VIEW-AS ALERT-BOX.
END.

MESSAGE "=== Safe Navigation Operator Examples Complete ===" VIEW-AS ALERT-BOX.

/* Cleanup */
DELETE OBJECT oCustomer2 NO-ERROR.
DELETE OBJECT oAddress1 NO-ERROR.
DELETE OBJECT oAddress2 NO-ERROR.
DELETE OBJECT oOrder1 NO-ERROR.
DELETE OBJECT oOrder2 NO-ERROR.
