/*------------------------------------------------------------------------
    File        : run_hashmap_examples.p
    Purpose     : Demonstrates HashMap usage by running all examples
    Syntax      : RUN run_hashmap_examples.p
    Description : Executes all HashMap examples from HashMapExamples.cls
    Author(s)   : 
    Created     : Mon Nov 03 09:36:00 UTC 2025
    Notes       : Run this to see HashMap examples in action
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using examples.HashMapExamples.

/* Create instance of examples class */
var HashMapExamples oExamples = new HashMapExamples().

message "========================================" skip
        "HashMap Examples - ABL Collections" skip
        "========================================" skip(1)
    view-as alert-box information title "HashMap Examples".

/* Example 1: Basic String to String */
message "Running Example 1: Basic String to String HashMap..." skip
        "This demonstrates configuration storage." skip(1)
    view-as alert-box information title "Example 1".
oExamples:Example1_BasicStringToString().

/* Example 2: Session Cache */
message "Running Example 2: Session Cache..." skip
        "This demonstrates user session management." skip(1)
    view-as alert-box information title "Example 2".
oExamples:Example2_SessionCache().

/* Example 3: HTTP Headers */
message "Running Example 3: HTTP Headers..." skip
        "This demonstrates HTTP header storage." skip(1)
    view-as alert-box information title "Example 3".
oExamples:Example3_HttpHeaders().

/* Example 4: Integer to Object */
message "Running Example 4: Integer to Object HashMap..." skip
        "This demonstrates caching by numeric ID." skip(1)
    view-as alert-box information title "Example 4".
oExamples:Example4_IntegerToObject().

/* Example 5: TryGetValue */
message "Running Example 5: TryGetValue..." skip
        "This demonstrates safe value retrieval." skip(1)
    view-as alert-box information title "Example 5".
oExamples:Example5_TryGetValue().

/* Example 6: Query Parameters */
message "Running Example 6: Query Parameters..." skip
        "This demonstrates URL query string parsing." skip(1)
    view-as alert-box information title "Example 6".
oExamples:Example6_QueryParameters().

/* Example 7: Legacy HashMap */
message "Running Example 7: Legacy HashMap..." skip
        "This demonstrates backwards compatibility." skip(1)
    view-as alert-box information title "Example 7".
oExamples:Example7_LegacyHashMap().

/* Example 8: Error Handling */
message "Running Example 8: Error Handling..." skip
        "This demonstrates proper error handling." skip(1)
    view-as alert-box information title "Example 8".
oExamples:Example8_ErrorHandling().

message "========================================" skip
        "All HashMap Examples Completed!" skip
        "========================================" skip(1)
        "See HashMap_UseCases.md for detailed documentation."
    view-as alert-box information title "Complete".

/* Cleanup */
delete object oExamples no-error.
