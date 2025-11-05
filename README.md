# PUG Challenge 2025 - ABL HashMap Examples

This repository contains comprehensive examples and documentation for using HashMap collections in OpenEdge ABL, created for the PUG Challenge 2025.

## Files Overview

### Documentation
- **`HashMap_UseCases.md`** - Complete guide to HashMap usage, use cases, best practices, and API reference

### Example Classes
- **`HashMapExamples.cls`** - 8 different HashMap examples covering common patterns
- **`RequestHeaderParser.cls`** - Real-world utility class demonstrating practical HashMap usage for HTTP header management

### Demo Programs
- **`run_hashmap_examples.p`** - Runs all 8 examples from HashMapExamples.cls
- **`demo_header_parser.p`** - Interactive demo of the RequestHeaderParser utility

## Quick Start

### Run All Basic Examples
```abl
RUN run_hashmap_examples.p
```

### Run Practical Demo
```abl
RUN demo_header_parser.p
```

## What's Included

### HashMapExamples.cls - 8 Examples

1. **Basic String to String** - Configuration storage
2. **Session Cache** - User session management
3. **HTTP Headers** - Header storage and manipulation
4. **Integer to Object** - Caching by numeric ID
5. **TryGetValue** - Safe value retrieval
6. **Query Parameters** - URL query string parsing
7. **Legacy HashMap** - Backwards compatibility
8. **Error Handling** - Proper error handling patterns

### RequestHeaderParser.cls - Practical Utility

A complete, production-ready utility class demonstrating:
- Parsing HTTP headers into a HashMap
- Fast header lookup by name
- Common operations (get, set, remove, check existence)
- Helper methods for common headers (Content-Type, Authorization)
- Bearer token extraction
- JSON request detection
- Debug output generation

## Key Concepts Demonstrated

### HashMap Basics
- Creating HashMap instances with generic types
- Adding key-value pairs
- Retrieving values by key
- Checking for key existence
- Iterating over entries
- Removing entries
- Clearing the map

### Best Practices
- Using `Progress.Collections.HashMap<K,V>` (modern, recommended)
- Type-safe operations with generics
- Proper error handling
- Using `TryGetValue()` for safer retrieval
- Using `Set()` vs `Add()` appropriately
- Memory management and cleanup

### Real-World Use Cases
- Configuration management
- Session caching
- HTTP header handling
- Database record caching
- Query parameter parsing
- Request context storage
- Feature flag management
- Data transformation/mapping

## Performance Benefits

HashMap provides **O(1) average-case** performance for:
- Lookups by key
- Insertions
- Deletions
- Existence checks

This is significantly faster than:
- Temp-table scans: O(n)
- Array searches: O(n)
- Nested IF-THEN chains: O(n)

## When to Use HashMap

✅ **Use HashMap when you need:**
- Fast key-value lookups
- Dynamic key-value storage
- Flexible metadata/context storage
- Caching by ID or name
- Header/parameter management

❌ **Don't use HashMap when you need:**
- Complex queries (use temp-tables)
- Guaranteed ordering (use List)
- Sequential integer keys (use arrays)
- ProDataSet relationships (use temp-tables)

## API Quick Reference

### Creating
```abl
var oMap = new HashMap<String, String>().
```

### Adding
```abl
oMap:Add(oKey, oValue).      /* Returns FALSE if key exists */
oMap:Set(oKey, oValue).       /* Adds or updates */
```

### Getting
```abl
var oValue = oMap:GetValue(oKey).                    /* Returns ? if not found */
var lFound = oMap:TryGetValue(oKey, output oValue).  /* Safer */
```

### Checking
```abl
if oMap:ContainsKey(oKey) then ...
if oMap:IsEmpty() then ...
var iSize = oMap:Size.
```

### Removing
```abl
oMap:Remove(oKey).
oMap:Clear().
```

### Iterating
```abl
var oIterator = oMap:GetIterator().
do while oIterator:MoveNext():
    var oEntry = cast(oIterator:Current, KeyValuePair<K,V>).
    /* Use oEntry:Key and oEntry:Value */
end.
```

## Important Notes

### Keys Must Implement IHashable
- `Progress.Lang.String` ✓
- `Progress.Lang.Integer` ✓
- `Progress.Lang.Long` ✓
- `OpenEdge.Core.String` ✓
- Custom classes must implement `Progress.Collections.IHashable`

### Keys Cannot Be Unknown (?)
```abl
oMap:Add(?, oValue).  /* ERROR! */
```

### Values Can Be Unknown (?)
```abl
oMap:Add(oKey, ?).  /* OK, but use TryGetValue() for retrieval */
```

## Learning Path

1. **Start with** `HashMap_UseCases.md` - Read the complete guide
2. **Review** `HashMapExamples.cls` - Study the 8 example patterns
3. **Run** `run_hashmap_examples.p` - See examples in action
4. **Study** `RequestHeaderParser.cls` - See practical implementation
5. **Run** `demo_header_parser.p` - Interactive demonstration
6. **Apply** - Use HashMap in your own code!

## Additional Resources

- OpenEdge 12.8 Documentation: `Progress.Collections.HashMap<K,V>`
- OpenEdge 12.8 Documentation: `Progress.Collections.IHashable`
- OpenEdge 12.8 Documentation: `Progress.Collections.KeyValuePair<K,V>`

## Questions?

Common questions answered in `HashMap_UseCases.md`:
- When should I use HashMap vs temp-table?
- How do I handle Unknown (?) values?
- What's the difference between Add() and Set()?
- How do I iterate over all entries?
- What are the performance characteristics?
- When should I use TryGetValue()?

---

**Note:** All examples use `Progress.Collections.HashMap<K,V>` (the modern, recommended approach) rather than the legacy `OpenEdge.Core.Collections.HashMap`.
