# Values

`Templates.Values.Value` is a controlled handle with reference-counted internal
data. Object and list mutations use copy-on-write so copied values can be
mutated independently.

Reference counters are not atomic. Sharing values across worker threads
requires external synchronization.

## Kinds

```ada
Null_Value
String_Value
Boolean_Value
Object_Value
List_Value
```

## Missing Data

Missing data is represented as null:

- lookup on a non-object returns null
- lookup of a missing key returns null
- element access on a non-list returns null
- out-of-range element access returns null

Duplicate object keys are replaced:

```ada
Set (Obj, "name", String_Item ("A"));
Set (Obj, "name", String_Item ("B"));
```

After these calls, `Lookup (Obj, "name")` returns `"B"`.

## Truthiness

```text
null              false
false             false
true              true
""                false
non-empty string  true
empty list        false
non-empty list    true
object            true
```

## Rendering Output

During rendering:

- string values render as HTML-escaped text
- boolean values render as `true` or `false`
- null values render as an empty string
- object values render as an empty string
- list values render as an empty string
