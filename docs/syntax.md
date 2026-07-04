# Template Syntax

`templates` supports variables, conditionals, and loops. It preserves template
whitespace exactly.

## Variables

```handlebars
{{name}}
{{user.name}}
{{.}}
```

Variables are resolved from the active context. `{{.}}` resolves to the active
context itself, which is most useful inside loops.

All variable output is HTML-escaped.

## Conditionals

```handlebars
{{#if user.email}}
  <p>{{user.email}}</p>
{{/if}}
```

The block renders only when the resolved value is truthy.

## Loops

```handlebars
{{#each user.roles}}
  <li>{{.}}</li>
{{/each}}
```

The block renders once for each list item. During each iteration, the active
context is the current item.

## Paths

Allowed paths:

```text
name
user.name
.
user_name
user-name
user1.name2
```

Path components may contain ASCII letters, digits, underscore, and hyphen.

Rejected paths:

```text
.user
user.
user..name
user[0]
../name
user/name
this.name
```

## Unsupported Syntax

The following features are intentionally unsupported:

- helpers
- expressions
- partials
- inheritance
- filters
- layout systems
- raw HTML variables
- safe-string flags
- parent lookup such as `../name`
- `this.name`
- indexing such as `user.roles[0]`
- whitespace trimming such as `{{~name}}`

Block open syntax requires an exact keyword followed by whitespace:

```handlebars
{{#if user}}       valid
{{#ifuser}}        invalid
{{#ifdef user}}    invalid
{{#each items}}    valid
{{#eachitems}}     invalid
```
