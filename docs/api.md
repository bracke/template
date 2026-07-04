# API

The public facade is the `Templates` package:

```ada
with Templates;
with Templates.Values;
```

The main workflow is:

1. Build a `Templates.Values.Value` context.
2. Parse template source with `Templates.Parse`.
3. Render with `Templates.Render`.
4. Reuse the parsed template for more contexts.

## Template Handles

`Templates.Template` is a controlled handle to an immutable AST. Copying a
template increments an internal reference count. Finalization decrements that
count and releases the AST recursively when the last handle is finalized.

```ada
T := Templates.Parse ("Hello {{name}}");
Html := Templates.Render (T, Context);
```

Malformed templates raise `Templates.Template_Error` during `Parse`.

## Values

The value API is in `Templates.Values`.

Constructors:

```ada
Null_Item
String_Item ("text")
Boolean_Item (True)
Object
List
```

Object and list mutation:

```ada
Set (Obj, "name", String_Item ("Ada"));
Append (Items, String_Item ("one"));
```

Lookup and inspection:

```ada
Lookup (Obj, "name")
Element (Items, 1)
Length (Items)
Kind (Item)
As_String (Item)
As_Boolean (Item)
Is_Truthy (Item)
```

`Element` uses one-based indexing.

## Complete Example

```ada
with Ada.Text_IO;
with Templates;
with Templates.Values;

procedure Example is
   use Templates.Values;

   T       : constant Templates.Template :=
     Templates.Parse ("<p>{{user.name}}</p>{{#each user.roles}}<b>{{.}}</b>{{/each}}");
   Context : Value := Object;
   User    : Value := Object;
   Roles   : Value := List;
begin
   Set (User, "name", String_Item ("Ada & Lovelace"));
   Append (Roles, String_Item ("admin"));
   Append (Roles, String_Item ("developer"));
   Set (User, "roles", Roles);
   Set (Context, "user", User);

   Ada.Text_IO.Put_Line (Templates.Render (T, Context));
end Example;
```
