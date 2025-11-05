/*------------------------------------------------------------------------
    File        : RequestHeaderParser
    Purpose     : Practical example - HTTP request header parser using HashMap
    Syntax      : 
    Description : Real-world utility class demonstrating HashMap usage
    Author(s)   : 
    Created     : Mon Nov 03 09:36:00 UTC 2025
    Notes       : This is a practical example of HashMap in production code
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Progress.Collections.HashMap.
using Progress.Lang.Object.
using OpenEdge.Core.String.

class examples.RequestHeaderParser:
    
    /* HashMap to store parsed headers */
    var private HashMap<String, String> Headers.
    
    /*------------------------------------------------------------------------------
     Purpose: Constructor - initializes the header map
     Notes:
    ------------------------------------------------------------------------------*/
    constructor public RequestHeaderParser():
        Headers = new HashMap<String, String>().
    end constructor.
    
    /*------------------------------------------------------------------------------
     Purpose: Parse a raw header string into the HashMap
     Notes: Expects format "Header-Name: value"
    ------------------------------------------------------------------------------*/
    method public void ParseHeader(input pcHeaderLine as character):
        
        var integer iColonPos.
        var character cHeaderName.
        var character cHeaderValue.
        
        /* Find the colon separator */
        iColonPos = index(pcHeaderLine, ":").
        
        if iColonPos > 0 then do:
            /* Extract header name and value */
            cHeaderName = trim(substring(pcHeaderLine, 1, iColonPos - 1)).
            cHeaderValue = trim(substring(pcHeaderLine, iColonPos + 1)).
            
            /* Store in HashMap */
            Headers:Set(new String(cHeaderName), new String(cHeaderValue)).
        end.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Parse multiple headers from an array
     Notes:
    ------------------------------------------------------------------------------*/
    method public void ParseHeaders(input pcHeaders as character extent):
        
        var integer i.
        
        do i = 1 to extent(pcHeaders):
            if pcHeaders[i] <> "" and pcHeaders[i] <> ? then
                this-object:ParseHeader(pcHeaders[i]).
        end.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Get a header value by name
     Notes: Returns ? if header doesn't exist
    ------------------------------------------------------------------------------*/
    method public character GetHeader(input pcHeaderName as character):
        
        var String oHeaderValue.
        
        oHeaderValue = Headers:GetValue(new String(pcHeaderName)).
        
        if oHeaderValue <> ? then
            return oHeaderValue:ToString().
        else
            return ?.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Get a header value with a default if not found
     Notes:
    ------------------------------------------------------------------------------*/
    method public character GetHeaderOrDefault(input pcHeaderName as character,
                                               input pcDefault as character):
        
        var character cValue.
        
        cValue = this-object:GetHeader(pcHeaderName).
        
        if cValue = ? then
            return pcDefault.
        else
            return cValue.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Check if a specific header exists
     Notes:
    ------------------------------------------------------------------------------*/
    method public logical HasHeader(input pcHeaderName as character):
        
        return Headers:ContainsKey(new String(pcHeaderName)).
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Add or update a header
     Notes:
    ------------------------------------------------------------------------------*/
    method public void SetHeader(input pcHeaderName as character,
                                input pcHeaderValue as character):
        
        Headers:Set(new String(pcHeaderName), new String(pcHeaderValue)).
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Remove a header
     Notes:
    ------------------------------------------------------------------------------*/
    method public void RemoveHeader(input pcHeaderName as character):
        
        Headers:Remove(new String(pcHeaderName)).
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Get the count of headers
     Notes:
    ------------------------------------------------------------------------------*/
    method public integer GetHeaderCount():
        
        return Headers:Count.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Clear all headers
     Notes:
    ------------------------------------------------------------------------------*/
    method public void ClearHeaders():
        
        Headers:Clear().
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Get Content-Type header (common use case)
     Notes:
    ------------------------------------------------------------------------------*/
    method public character GetContentType():
        
        return this-object:GetHeaderOrDefault("Content-Type", "text/plain").
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Get Authorization header (common use case)
     Notes:
    ------------------------------------------------------------------------------*/
    method public character GetAuthorization():
        
        return this-object:GetHeader("Authorization").
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Check if request is JSON
     Notes:
    ------------------------------------------------------------------------------*/
    method public logical IsJsonRequest():
        
        var character cContentType.
        
        cContentType = this-object:GetContentType().
        
        return (index(cContentType, "application/json") > 0).
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Extract bearer token from Authorization header
     Notes: Returns ? if not a bearer token
    ------------------------------------------------------------------------------*/
    method public character GetBearerToken():
        
        var character cAuth.
        var character cToken.
        
        cAuth = this-object:GetAuthorization().
        
        if cAuth <> ? and cAuth begins "Bearer " then do:
            cToken = trim(substring(cAuth, 8)). /* Skip "Bearer " */
            return cToken.
        end.
        
        return ?.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Get all header names as a comma-separated list
     Notes: Useful for debugging
    ------------------------------------------------------------------------------*/
    method public character GetAllHeaderNames():
        
        var Progress.Collections.IIterator<Progress.Collections.KeyValuePair<String, String>> oIterator.
        var Progress.Collections.KeyValuePair<String, String> oEntry.
        var character cHeaderList.
        
        oIterator = Headers:GetIterator().
        
        do while oIterator:MoveNext():
            oEntry = cast(oIterator:Current, Progress.Collections.KeyValuePair<String, String>).
            
            if cHeaderList = "" then
                cHeaderList = oEntry:Key:ToString().
            else
                cHeaderList = cHeaderList + ", " + oEntry:Key:ToString().
        end.
        
        return cHeaderList.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Export headers to a JSON-like string (for debugging)
     Notes:
    ------------------------------------------------------------------------------*/
    method public character ToDebugString():
        
        var Progress.Collections.IIterator<Progress.Collections.KeyValuePair<String, String>> oIterator.
        var Progress.Collections.KeyValuePair<String, String> oEntry.
        var character cOutput.
        
        cOutput = "Headers (~{" + string(Headers:Count) + " total~}):" + chr(10).
        
        oIterator = Headers:GetIterator().
        
        do while oIterator:MoveNext():
            oEntry = cast(oIterator:Current, Progress.Collections.KeyValuePair<String, String>).
            
            cOutput = cOutput + "  " + oEntry:Key:ToString() + ": " + 
                     oEntry:Value:ToString() + chr(10).
        end.
        
        return cOutput.
        
    end method.
    
    /*------------------------------------------------------------------------------
     Purpose: Destructor - cleanup
     Notes:
    ------------------------------------------------------------------------------*/
    destructor public RequestHeaderParser():
        delete object Headers no-error.
    end destructor.

end class.
