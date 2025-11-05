# HashMap Collections in ABL - Examples and Use Cases

## Overview

This document provides comprehensive examples and real-world use cases for HashMap collections in OpenEdge ABL. HashMaps provide efficient key-value storage with O(1) average-case lookup performance.

## Two HashMap Implementations

### 1. Progress.Collections.HashMap<K,V> (Recommended)
- **Modern generic implementation** introduced in OpenEdge 12.8
- Type-safe with compile-time checking
- Better performance
- **Use this for all new development**

### 2. OpenEdge.Core.Collections.HashMap (Legacy)
- Backwards compatibility with older code
- Non-generic (uses Progress.Lang.Object)
- Requires explicit casting
- Retained for legacy applications only

---

## Common Use Cases

### 1. Configuration Management
Store application configuration settings with fast key-based lookup.

```abl
var oConfig = new HashMap<String, String>().
oConfig:Add(new String("database"), new String("sports2020")).
oConfig:Add(new String("host"), new String("localhost")).
oConfig:Add(new String("port"), new String("5162")).

var oDbName = oConfig:GetValue(new String("database")).
```

**Why HashMap?**
- Fast lookup by configuration key name
- Easy to add/remove settings dynamically
- No need for complex IF-THEN chains

---

### 2. Session Management
Cache user sessions by token for quick authentication checks.

```abl
var oSessionCache = new HashMap<String, String>().

/* Store session */
oSessionCache:Add(new String("abc123xyz"), new String("user001")).

/* Validate session */
if oSessionCache:ContainsKey(new String("abc123xyz")) then do:
    var oUserId = oSessionCache:GetValue(new String("abc123xyz")).
    /* User is authenticated */
end.
```

**Why HashMap?**
- O(1) session lookup vs O(n) temp-table scan
- Efficient for thousands of concurrent sessions
- Easy to expire sessions with Remove()

---

### 3. HTTP Request/Response Headers
Store and manipulate HTTP headers efficiently.

```abl
var oHeaders = new HashMap<String, String>().

oHeaders:Add(new String("Content-Type"), new String("application/json")).
oHeaders:Add(new String("Authorization"), new String("Bearer token123")).

/* Update header */
oHeaders:Set(new String("Authorization"), new String("Bearer newtoken")).
```

**Why HashMap?**
- Headers are naturally key-value pairs
- Fast header lookup by name
- Easy to add/remove/update headers

---

### 4. Caching Database Records
Cache frequently accessed records by ID to reduce database hits.

```abl
var oCustomerCache = new HashMap<Progress.Lang.Integer, String>().

oCustomerCache:Add(new Progress.Lang.Integer(1001), new String("John Smith")).

/* Fast lookup */
var oCustomer = oCustomerCache:GetValue(new Progress.Lang.Integer(1001)).
```

**Why HashMap?**
- Dramatically faster than repeated database queries
- Reduces database load
- Ideal for read-heavy operations

---

### 5. Query Parameter Parsing
Parse URL query strings into structured data.

```abl
var oQueryParams = new HashMap<String, String>().

/* Parse: ?page=1&limit=50&sort=name */
oQueryParams:Add(new String("page"), new String("1")).
oQueryParams:Add(new String("limit"), new String("50")).
oQueryParams:Add(new String("sort"), new String("name")).

/* Access with defaults */
var iPage = integer(oQueryParams:GetValue(new String("page")):ToString()).
```

**Why HashMap?**
- Clean parameter access by name
- Easy to provide default values
- Better than positional arrays

---

### 6. Request Context/Metadata
Store request-scoped metadata that needs to be passed through multiple layers.

```abl
var oRequestContext = new HashMap<String, String>().

oRequestContext:Add(new String("requestId"), new String("req-12345")).
oRequestContext:Add(new String("userId"), new String("user001")).
oRequestContext:Add(new String("timestamp"), new String("2025-11-03T09:36:00")).
```

**Why HashMap?**
- Flexible metadata storage
- No need to modify method signatures
- Easy to add new context fields

---

### 7. Feature Flags / Toggle Management
Manage application feature flags dynamically.

```abl
var oFeatureFlags = new HashMap<String, Progress.Lang.Boolean>().

oFeatureFlags:Add(new String("newUI"), new Progress.Lang.Boolean(true)).
oFeatureFlags:Add(new String("betaFeature"), new Progress.Lang.Boolean(false)).

if oFeatureFlags:GetValue(new String("newUI")):Value then
    /* Show new UI */
```

**Why HashMap?**
- Dynamic feature control
- No code changes to add/remove flags
- Easy to toggle features at runtime

---

### 8. Data Transformation/Mapping
Map old field names to new field names during migrations.

```abl
var oFieldMapping = new HashMap<String, String>().

oFieldMapping:Add(new String("old_name"), new String("firstName")).
oFieldMapping:Add(new String("old_email"), new String("emailAddress")).

var cNewField = oFieldMapping:GetValue(new String("old_name")):ToString().
```

**Why HashMap?**
- Clean data migration logic
- Centralized mapping configuration
- Easy to maintain and update

---

## Key Methods

### Adding Entries
```abl
/* Add - returns FALSE if key already exists */
var lAdded = oMap:Add(oKey, oValue).

/* Set - adds or updates (no return value) */
oMap:Set(oKey, oValue).
```

### Retrieving Values
```abl
/* GetValue - returns ? if key not found */
var oValue = oMap:GetValue(oKey).

/* TryGetValue - safer, returns TRUE/FALSE */
var lFound = oMap:TryGetValue(oKey, output oValue).
```

### Checking Existence
```abl
/* Check if key exists */
if oMap:ContainsKey(oKey) then ...

/* Check if map is empty */
if oMap:IsEmpty() then ...

/* Get size */
var iSize = oMap:Size.
```

### Removing Entries
```abl
/* Remove single entry */
oMap:Remove(oKey).

/* Clear all entries */
oMap:Clear().
```

### Iterating
```abl
var oIterator = oMap:GetIterator().
do while oIterator:MoveNext():
    var oEntry = cast(oIterator:Current, KeyValuePair<String, String>).
    /* Access oEntry:Key and oEntry:Value */
end.
```

---

## Important Requirements

### Keys Must Implement IHashable
When using the default comparer, key objects must implement `Progress.Collections.IHashable`:
- `Progress.Lang.String` ✓
- `Progress.Lang.Integer` ✓
- `Progress.Lang.Long` ✓
- `OpenEdge.Core.String` ✓
- Custom classes must implement IHashable

### Keys Cannot Be Unknown (?)
```abl
/* This will raise an error */
oMap:Add(?, new String("value")). /* ERROR! */

/* Keys must be valid object references */
oMap:Add(new String("key"), new String("value")). /* OK */
```

### Values Can Be Unknown (?)
```abl
/* This is valid */
oMap:Add(new String("key"), ?). /* OK */

/* But GetValue() becomes ambiguous */
var oValue = oMap:GetValue(new String("key")). /* Returns ? */
/* Is it ? because key not found, or because value is ? ? */

/* Use TryGetValue() instead */
var lFound = oMap:TryGetValue(new String("key"), output oValue).
if lFound then /* Key exists, value might be ? */
else /* Key doesn't exist */
```

---

## Performance Characteristics

| Operation | Average Case | Worst Case |
|-----------|--------------|------------|
| Add       | O(1)         | O(n)       |
| Get       | O(1)         | O(n)       |
| Remove    | O(1)         | O(n)       |
| Contains  | O(1)         | O(n)       |

**Note:** Worst case occurs with hash collisions, which are rare with good hash functions.

---

## When NOT to Use HashMap

### Use Temp-Table Instead When:
- You need complex queries (WHERE clauses, joins)
- You need sorting by multiple fields
- You need to pass data to external procedures
- You need ProDataSet relationships

### Use Array Instead When:
- You have sequential integer keys (0, 1, 2, ...)
- You need guaranteed ordering
- Collection size is small (<10 items)

### Use List Instead When:
- You need ordered collection
- You don't need key-based lookup
- You need index-based access

---

## Best Practices

1. **Use Progress.Collections.HashMap** for new code (not OpenEdge.Core.Collections)
2. **Use TryGetValue()** when Unknown (?) might be a valid value
3. **Check ContainsKey()** before GetValue() to avoid ambiguity
4. **Use Set()** to update existing keys (Add() returns FALSE for duplicates)
5. **Clear()** the map when done to free memory
6. **Use appropriate key types** (String for text, Integer for IDs)
7. **Consider memory** - HashMaps keep all data in memory

---

## Error Handling

```abl
/* Add returns FALSE for duplicate keys (doesn't throw error) */
var lAdded = oMap:Add(new String("key1"), new String("value1")).
if not lAdded then
    message "Key already exists" view-as alert-box.

/* GetValue returns ? for missing keys (doesn't throw error) */
var oValue = oMap:GetValue(new String("nonexistent")).
if oValue = ? then
    message "Key not found" view-as alert-box.

/* Errors ARE thrown for: */
/* - Invalid key object (null or ?) */
/* - Key doesn't implement IHashable (with default comparer) */
/* - Custom comparer raises error */
```

---

## Complete Working Examples

See `HashMapExamples.cls` for 8 complete, runnable examples demonstrating:
1. Basic String-to-String mapping
2. Session cache management
3. HTTP header handling
4. Integer-to-Object caching
5. Safe value retrieval with TryGetValue
6. Query parameter parsing
7. Legacy HashMap usage
8. Error handling patterns

---

## References

- OpenEdge 12.8 Documentation: Progress.Collections.HashMap<K,V>
- OpenEdge.Core.Collections.HashMap (legacy compatibility)
- Progress.Collections.IHashable interface
- Progress.Collections.KeyValuePair<K,V> class

---

## Summary

HashMaps are ideal for:
- ✓ Fast key-value lookups
- ✓ Configuration management
- ✓ Caching
- ✓ Session management
- ✓ Header/metadata storage
- ✓ Dynamic mappings

Use Progress.Collections.HashMap<K,V> for all new development!
