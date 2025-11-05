/*------------------------------------------------------------------------
    File        : HashMapExamples
    Purpose     : Demonstrates various HashMap collection usage patterns in ABL
    Syntax      : 
    Description : Examples showing both Progress.Collections.HashMap (recommended)
                  and OpenEdge.Core.Collections.HashMap (legacy compatibility)
    Author(s)   : 
    Created     : Mon Nov 03 09:36:00 UTC 2025
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Collections.HashMap.
using Progress.Collections.IHashable.
using Progress.Collections.KeyValuePair.
using Progress.Lang.Object.
using OpenEdge.Core.String.
using OpenEdge.Core.Integer.

class examples.HashMapExamples:
    
    /*------------------------------------------------------------------------------
     Purpose: Example 1 - Basic String to String HashMap
     Notes: Most common use case - storing configuration settings, request headers, etc.
    ------------------------------------------------------------------------------*/
    method public void Example1_BasicStringToString():
        
        /* Using the modern Progress.Collections.HashMap with generic types */
        var HashMap<String, String> oConfigMap = new HashMap<String, String>().
        var String oDbName = ?.
        var Progress.Collections.IIterator<KeyValuePair<String, String>> oIterator = ?.
        var KeyValuePair<String, String> oEntry = ?.
        
        /* Add key-value pairs */
        oConfigMap:Add(new String("database"), new String("sports2020")).
        oConfigMap:Add(new String("host"), new String("localhost")).
        oConfigMap:Add(new String("port"), new String("5162")).
        
        /* Retrieve values */
        oDbName = oConfigMap:GetValue(new String("database")).
        message "Database:" oDbName:ToString() view-as alert-box.
        
        /* Check if key exists */
        if oConfigMap:ContainsKey(new String("host")) then
            message "Host configuration found" view-as alert-box.
        
        /* Iterate over all entries */
        oIterator = oConfigMap:GetIterator().
        do while oIterator:MoveNext():
            oEntry = cast(oIterator:Current, KeyValuePair<String, String>).
            message substitute("Key: &1, Value: &2", 
                             oEntry:Key:ToString(), 
                             oEntry:Value:ToString()) 
                view-as alert-box.
        end.
        
        /* Get size */
        message substitute("Total config items: &1", oConfigMap:Count) 
            view-as alert-box.
            
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Example 2 - Caching User Sessions
     Notes: Real-world use case - storing user session data by session ID
    ------------------------------------------------------------------------------*/
    method public void Example2_SessionCache():
        
        /* HashMap to store session tokens and user IDs */
        var HashMap<String, String> oSessionCache = new HashMap<String, String>().
        var character cTokenToCheck = "abc123xyz".
        var String oToken = ?.
        var String oUserId = ?.
        
        /* Simulate adding user sessions */
        oSessionCache:Add(new String("abc123xyz"), new String("user001")).
        oSessionCache:Add(new String("def456uvw"), new String("user002")).
        oSessionCache:Add(new String("ghi789rst"), new String("user003")).
        
        /* Validate a session token */
        oToken = new String(cTokenToCheck).
        
        if oSessionCache:ContainsKey(oToken) then do:
            oUserId = oSessionCache:GetValue(oToken).
            message substitute("Valid session for user: &1", oUserId:ToString())
                view-as alert-box.
        end.
        else
            message "Invalid session token" view-as alert-box.
        
        /* Remove expired session */
        oSessionCache:Remove(new String("def456uvw")).
        
        message substitute("Active sessions: &1", oSessionCache:Count)
            view-as alert-box.
            
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Example 3 - HTTP Request Headers
     Notes: Storing and accessing HTTP headers (case-insensitive keys)
    ------------------------------------------------------------------------------*/
    method public void Example3_HttpHeaders():
        
        var HashMap<String, String> oHeaders = new HashMap<String, String>().
        var String oContentType = ?.
        var String oValue = ?.
        
        /* Add common HTTP headers */
        oHeaders:Add(new String("Content-Type"), new String("application/json")).
        oHeaders:Add(new String("Authorization"), new String("Bearer token123")).
        oHeaders:Add(new String("Accept"), new String("application/json")).
        oHeaders:Add(new String("User-Agent"), new String("OpenEdge/12.8")).
        
        /* Check for specific header */
        oContentType = new String("Content-Type").
        if oHeaders:ContainsKey(oContentType) then do:
            oValue = oHeaders:GetValue(oContentType).
            message substitute("Content-Type: &1", oValue:ToString())
                view-as alert-box.
        end.
        
        /* Update a header value using Set (replaces if exists, adds if not) */
        oHeaders:Set(new String("Authorization"), new String("Bearer newtoken456")).
        
        /* Remove a header */
        oHeaders:Remove(new String("User-Agent")).
        
        message substitute("Total headers: &1", oHeaders:Count)
            view-as alert-box.
            
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Example 4 - Integer to Object HashMap
     Notes: Storing objects by numeric ID (e.g., caching database records)
    ------------------------------------------------------------------------------*/
    method public void Example4_IntegerToObject():
        
        /* Using Integer class as key (wraps integer) and String as value (could be any object) */
        var HashMap<OpenEdge.Core.Integer, String> oCustomerCache = new HashMap<OpenEdge.Core.Integer, String>().
        var integer iCustomerId = 1002.
        var OpenEdge.Core.Integer oCustomerId = ?.
        var String oCustomerName = ?.
        
        /* Add customer records by ID */
        oCustomerCache:Add(new OpenEdge.Core.Integer(1001), 
                          new String("John Smith")).
        oCustomerCache:Add(new OpenEdge.Core.Integer(1002), 
                          new String("Jane Doe")).
        oCustomerCache:Add(new OpenEdge.Core.Integer(1003), 
                          new String("Bob Johnson")).
        
        /* Lookup customer by ID */
        oCustomerId = new OpenEdge.Core.Integer(iCustomerId).
        
        if oCustomerCache:ContainsKey(oCustomerId) then do:
            oCustomerName = oCustomerCache:GetValue(oCustomerId).
            message substitute("Customer &1: &2", iCustomerId, oCustomerName:ToString())
                view-as alert-box.
        end.
        
        /* Check if cache is empty */
        if not oCustomerCache:IsEmpty then
            message substitute("Cache contains &1 customers", oCustomerCache:Count)
                view-as alert-box.
                
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Example 5 - Using TryGetValue for safer value retrieval
     Notes: Avoids ambiguity when Unknown (?) might be a valid stored value
    ------------------------------------------------------------------------------*/
    method public void Example5_TryGetValue():
        
        var HashMap<String, String> oMap = new HashMap<String, String>().
        var String oValue = ?.
        var logical lFound = ?.
        
        oMap:Add(new String("key1"), new String("value1")).
        oMap:Add(new String("key2"), new String("value2")).
        
        /* TryGetValue returns TRUE if key exists, FALSE otherwise */
        
        lFound = oMap:TryGetValue(new String("key1"), output oValue).
        
        if lFound then
            message substitute("Found: &1", oValue:ToString()) view-as alert-box.
        else
            message "Key not found" view-as alert-box.
        
        /* Try with non-existent key */
        lFound = oMap:TryGetValue(new String("key999"), output oValue).
        
        if not lFound then
            message "Key999 does not exist in map" view-as alert-box.
            
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Example 6 - Query Parameter Parsing
     Notes: Real-world use case - parsing URL query strings into a map
    ------------------------------------------------------------------------------*/
    method public void Example6_QueryParameters():
        
        var HashMap<String, String> oQueryParams = new HashMap<String, String>().
        var integer iPage.
        var integer iLimit.
        var character cSort.
        
        /* Simulate parsing query string: ?page=1&limit=50&sort=name&order=asc */
        oQueryParams:Add(new String("page"), new String("1")).
        oQueryParams:Add(new String("limit"), new String("50")).
        oQueryParams:Add(new String("sort"), new String("name")).
        oQueryParams:Add(new String("order"), new String("asc")).
        
        /* Access parameters with defaults */
        
        if oQueryParams:ContainsKey(new String("page")) then
            iPage = integer(oQueryParams:GetValue(new String("page")):ToString()).
        else
            iPage = 1. /* default */
        
        if oQueryParams:ContainsKey(new String("limit")) then
            iLimit = integer(oQueryParams:GetValue(new String("limit")):ToString()).
        else
            iLimit = 25. /* default */
        
        if oQueryParams:ContainsKey(new String("sort")) then
            cSort = oQueryParams:GetValue(new String("sort")):ToString().
        else
            cSort = "id". /* default */
        
        message substitute("Pagination: page=&1, limit=&2, sort by &3", 
                         iPage, iLimit, cSort)
            view-as alert-box.
            
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Example 7 - Legacy OpenEdge.Core.Collections.HashMap
     Notes: For backwards compatibility - not recommended for new code
    ------------------------------------------------------------------------------*/
    method public void Example7_LegacyHashMap():
        
        /* Using the older OpenEdge.Core.Collections.HashMap */
        var OpenEdge.Core.Collections.HashMap oLegacyMap = new OpenEdge.Core.Collections.HashMap().
        var String oName = ?.
        
        /* Keys and values must be Progress.Lang.Object */
        oLegacyMap:Put(new String("name"), new String("Test User")).
        oLegacyMap:Put(new String("email"), new String("test@example.com")).
        
        /* Retrieve value */
        oName = cast(oLegacyMap:Get(new String("name")), String).
        message substitute("Name: &1", oName:ToString()) view-as alert-box.
        
        /* Check size */
        message substitute("Legacy map size: &1", oLegacyMap:Size)
            view-as alert-box.
            
        /* Note: Progress.Collections.HashMap is preferred for new development */
            
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Example 8 - Error Handling with HashMap
     Notes: Demonstrates proper error handling when working with HashMaps
    ------------------------------------------------------------------------------*/
    method public void Example8_ErrorHandling():
        
        var HashMap<String, String> oMap = new HashMap<String, String>().
        var logical lAdded.
        var String oValue = ?.
        
        /* Adding duplicate keys returns FALSE (doesn't throw error) */
        
        lAdded = oMap:Add(new String("key1"), new String("value1")).
        message substitute("First add: &1", lAdded) view-as alert-box. /* TRUE */
        
        lAdded = oMap:Add(new String("key1"), new String("value2")).
        message substitute("Duplicate add: &1", lAdded) view-as alert-box. /* FALSE */
        
        /* Use Set to update existing keys */
        oMap:Set(new String("key1"), new String("updated_value")).
        
        /* GetValue returns ? if key doesn't exist */
        oValue = oMap:GetValue(new String("nonexistent")).
        if oValue = ? then
            message "Key not found - returned unknown value" view-as alert-box.
        
        /* Clear all entries */
        oMap:Clear().
        
        if oMap:IsEmpty then
            message "Map is now empty" view-as alert-box.
            
    end method.

end class.
