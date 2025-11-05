# HashMap Quick Reference Card

## Create HashMap
```abl
using Progress.Collections.HashMap.
using OpenEdge.Core.String.

var oMap = new HashMap<String, String>().
```

## Add Entry
```abl
/* Add - returns FALSE if key already exists */
var lAdded = oMap:Add(new String("key"), new String("value")).

/* Set - adds or updates (no return value) */
oMap:Set(new String("key"), new String("value")).
```

## Get Value
```abl
/* GetValue - returns ? if key not found */
var oValue = oMap:GetValue(new String("key")).

/* TryGetValue - safer, returns TRUE/FALSE */
var oValue as String no-undo.
var lFound = oMap:TryGetValue(new String("key"), output oValue).
```

## Check Existence
```abl
/* Check if key exists */
if oMap:ContainsKey(new String("key")) then ...

/* Check if empty */
if oMap:IsEmpty() then ...

/* Get size */
var iSize = oMap:Size.
```

## Remove Entry
```abl
/* Remove single entry */
oMap:Remove(new String("key")).

/* Clear all */
oMap:Clear().
```

## Iterate
```abl
using Progress.Collections.KeyValuePair.

var oIterator = oMap:GetIterator().
do while oIterator:MoveNext():
    var oEntry = cast(oIterator:Current, KeyValuePair<String, String>).
    /* Access oEntry:Key and oEntry:Value */
end.
```

## Common Patterns

### Configuration Map
```abl
var oConfig = new HashMap<String, String>().
oConfig:Add(new String("host"), new String("localhost")).
var cHost = oConfig:GetValue(new String("host")):ToString().
```

### Session Cache
```abl
var oSessions = new HashMap<String, String>().
oSessions:Add(new String("token123"), new String("user001")).
if oSessions:ContainsKey(new String("token123")) then
    /* Valid session */
```

### Integer Keys
```abl
var oCache = new HashMap<Progress.Lang.Integer, String>().
oCache:Add(new Progress.Lang.Integer(1001), new String("John")).
var oName = oCache:GetValue(new Progress.Lang.Integer(1001)).
```

### With Defaults
```abl
var oValue = oMap:GetValue(new String("key")).
var cValue = if oValue <> ? then oValue:ToString() else "default".
```

## Key Types (Must Implement IHashable)
- ✓ `Progress.Lang.String`
- ✓ `Progress.Lang.Integer`
- ✓ `Progress.Lang.Long`
- ✓ `OpenEdge.Core.String`
- ✓ Custom classes implementing `Progress.Collections.IHashable`

## Important Rules
- ❌ Keys cannot be Unknown (?)
- ✓ Values can be Unknown (?)
- ✓ Add() returns FALSE for duplicates (doesn't throw error)
- ✓ GetValue() returns ? for missing keys (doesn't throw error)
- ✓ Set() adds or updates (use instead of Add for updates)

## Performance
| Operation | Average | Worst |
|-----------|---------|-------|
| Add       | O(1)    | O(n)  |
| Get       | O(1)    | O(n)  |
| Remove    | O(1)    | O(n)  |
| Contains  | O(1)    | O(n)  |

## Use HashMap For
- ✓ Fast key-value lookups
- ✓ Configuration storage
- ✓ Session caching
- ✓ HTTP headers
- ✓ Query parameters
- ✓ Request context
- ✓ Feature flags

## Don't Use HashMap For
- ❌ Complex queries → use temp-tables
- ❌ Guaranteed ordering → use List
- ❌ Sequential integer keys → use arrays
- ❌ ProDataSet relationships → use temp-tables

## Error Handling
```abl
/* Check before adding */
if not oMap:ContainsKey(oKey) then
    oMap:Add(oKey, oValue).

/* Safe retrieval */
var lFound = oMap:TryGetValue(oKey, output oValue).
if lFound then
    /* Key exists, use oValue */
else
    /* Key doesn't exist */
```

## Cleanup
```abl
oMap:Clear().
delete object oMap no-error.
```

---

**Prefer:** `Progress.Collections.HashMap<K,V>` (modern)  
**Avoid:** `OpenEdge.Core.Collections.HashMap` (legacy)
