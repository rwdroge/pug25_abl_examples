/*------------------------------------------------------------------------
    File        : demo_header_parser.p
    Purpose     : Demonstrates the RequestHeaderParser utility class
    Syntax      : RUN demo_header_parser.p
    Description : Shows practical HashMap usage in a real-world scenario
    Author(s)   : 
    Created     : Mon Nov 03 09:36:00 UTC 2025
    Notes       : Demonstrates HTTP header parsing with HashMap
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using examples.RequestHeaderParser.

/* Create parser instance */
var examples.RequestHeaderParser oParser = new RequestHeaderParser().
var character cToken.
var character cCookie.
var character[3] cHeaders.

message "========================================" skip
        "RequestHeaderParser Demo" skip
        "Practical HashMap Example" skip
        "========================================" skip(1)
    view-as alert-box information title "Demo Start".

/* Simulate parsing HTTP request headers */
message "Parsing HTTP request headers..." skip(1)
    view-as alert-box information title "Step 1".

oParser:ParseHeader("Content-Type: application/json").
oParser:ParseHeader("Authorization: Bearer abc123xyz789").
oParser:ParseHeader("Accept: application/json").
oParser:ParseHeader("User-Agent: OpenEdge/12.8").
oParser:ParseHeader("X-Request-ID: req-12345").
oParser:ParseHeader("Host: api.example.com").

/* Display header count */
message substitute("Parsed &1 headers", oParser:GetHeaderCount()) skip(1)
    view-as alert-box information title "Step 2".

/* Check for specific headers */
message "Checking for specific headers..." skip(1)
        "Has Content-Type: " string(oParser:HasHeader("Content-Type")) skip
        "Has Authorization: " string(oParser:HasHeader("Authorization")) skip
        "Has Cookie: " string(oParser:HasHeader("Cookie")) skip(1)
    view-as alert-box information title "Step 3".

/* Get specific header values */
message "Retrieving header values..." skip(1)
        "Content-Type: " oParser:GetContentType() skip
        "User-Agent: " oParser:GetHeader("User-Agent") skip
        "Request ID: " oParser:GetHeader("X-Request-ID") skip(1)
    view-as alert-box information title "Step 4".

/* Check if JSON request */
if oParser:IsJsonRequest() then
    message "This is a JSON request!" skip(1)
        view-as alert-box information title "Step 5".

/* Extract bearer token */

cToken = oParser:GetBearerToken().

if cToken <> ? then
    message "Bearer token extracted:" skip
            cToken skip(1)
        view-as alert-box information title "Step 6".

/* Get header with default value */

cCookie = oParser:GetHeaderOrDefault("Cookie", "no-cookie").

message "Cookie header (with default):" skip
        cCookie skip(1)
    view-as alert-box information title "Step 7".

/* List all header names */
message "All header names:" skip
        oParser:GetAllHeaderNames() skip(1)
    view-as alert-box information title "Step 8".

/* Update a header */
oParser:SetHeader("User-Agent", "OpenEdge/12.8 (Updated)").

message "Updated User-Agent header:" skip
        oParser:GetHeader("User-Agent") skip(1)
    view-as alert-box information title "Step 9".

/* Remove a header */
oParser:RemoveHeader("X-Request-ID").

message "Removed X-Request-ID header" skip
        "Remaining headers: " string(oParser:GetHeaderCount()) skip(1)
    view-as alert-box information title "Step 10".

/* Display debug output */
message "Complete header dump:" skip(1)
        oParser:ToDebugString() skip(1)
    view-as alert-box information title "Step 11".

/* Parse multiple headers at once */

cHeaders[1] = "X-Custom-Header: custom-value".
cHeaders[2] = "X-API-Version: 2.0".
cHeaders[3] = "X-Client-ID: client-456".

oParser:ParseHeaders(cHeaders).

message "Added 3 more headers using ParseHeaders()" skip
        "Total headers now: " string(oParser:GetHeaderCount()) skip(1)
    view-as alert-box information title "Step 12".

/* Final debug output */
message "Final header state:" skip(1)
        oParser:ToDebugString() skip(1)
    view-as alert-box information title "Step 13".

/* Clear all headers */
oParser:ClearHeaders().

message "Cleared all headers" skip
        "Header count: " string(oParser:GetHeaderCount()) skip(1)
    view-as alert-box information title "Step 14".

message "========================================" skip
        "Demo Complete!" skip
        "========================================" skip(1)
        "This demonstrates practical HashMap usage" skip
        "for HTTP header management." skip(1)
        "Key benefits:" skip
        "- Fast O(1) header lookup by name" skip
        "- Easy to add/remove/update headers" skip
        "- Type-safe with generics" skip
        "- Clean, maintainable code"
    view-as alert-box information title "Complete".

/* Cleanup */
delete object oParser no-error.
