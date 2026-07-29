# templates

`templates` is a small Ada 2022, dependency-light, server-side HTML template
engine. It supports a deliberately small Handlebars-like block syntax for
variables, conditionals, and loops.

The implementation is Ada-centric: parsing builds a reusable AST, rendering is
separate from parsing, values are reference-counted handles with copy-on-write
mutation, and template nodes are reference-counted immutable AST nodes.
Reference counters are not atomic; shared access across worker threads requires
external synchronization or a future atomic-counter implementation.

## Supported syntax

Variables:

```handlebars
{{name}}
{{user.name}}
{{.}}
```

Conditionals:

```handlebars
{{#if error}}
  ...
{{/if}}
```

Loops:

```handlebars
{{#each items}}
  ...
{{/each}}
```

Nested `if` and `each` blocks are supported.

## Unsupported features

This crate intentionally does not implement helpers, expressions, partials,
inheritance, filters, layouts, raw HTML variables, safe-string flags, parent
lookup such as `../name`, `this.name`, indexing such as `user.roles[0]`, or
whitespace trimming such as `{{~name}}`.

## Escaping

All variable output is HTML-escaped. The escaped characters are:

```text
&  => &amp;
<  => &lt;
>  => &gt;
"  => &quot;
'  => &#39;
```

Raw HTML output is not supported.

## Missing data

Missing values are not rendering errors. Missing variables render as an empty
string, missing `if` paths are false, and missing `each` paths render nothing.
Lookup on a non-object and list indexing outside the list both return null.

Truthiness rules are:

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

## Build

This crate enforces GNAT 15 through Alire. Every active manifest pins:

```toml
[[depends-on]]
gnat_native = "=15.2.1"
```

Do not run plain system GNAT, GPRBuild, GNATprove, GNATdoc, or related `gnat*`
tools from `PATH`. Build, test, and inspect the compiler through Alire so the
pinned toolchain is selected:

```sh
alr exec -- gnatls --version
alr build
```

The compiler version command must report `GNATLS 15.x`. The release checklist
verifies the exact `gnat_native = "=15.2.1"` dependency in the root, tests,
examples, and tools manifests.

## Test

The tests use AUnit:

```sh
alr exec -- gprbuild -P tests/templates_tests.gpr
./tests/bin/tests
```

More documentation is available in [docs/index.md](docs/index.md).
Runnable examples are available in [examples/](examples/).
Ada test and release tools are available in [tools/](tools/).

## Example

```ada
with Ada.Text_IO;
with Templates;
with Templates.Values;

procedure Example is
   use Templates.Values;

   Source : constant String :=
     "<div class=""profile"">" & ASCII.LF &
     "  <h2>{{user.name}}</h2>" & ASCII.LF &
     "  {{#if user.email}}" & ASCII.LF &
     "    <p>{{user.email}}</p>" & ASCII.LF &
     "  {{/if}}" & ASCII.LF &
     "  <ul>" & ASCII.LF &
     "  {{#each user.roles}}" & ASCII.LF &
     "    <li>{{.}}</li>" & ASCII.LF &
     "  {{/each}}" & ASCII.LF &
     "  </ul>" & ASCII.LF &
     "</div>";

   T       : constant Templates.Template := Templates.Parse (Source);
   Context : Value := Object;
   User    : Value := Object;
   Roles   : Value := List;
begin
   Set (User, "name", String_Item ("Ada & Lovelace"));
   Set (User, "email", String_Item ("ada@example.test"));

   Append (Roles, String_Item ("admin"));
   Append (Roles, String_Item ("developer"));
   Set (User, "roles", Roles);

   Set (Context, "user", User);

   Ada.Text_IO.Put_Line (Templates.Render (T, Context));
end Example;
```
