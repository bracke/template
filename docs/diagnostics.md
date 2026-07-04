# Diagnostics

Malformed templates raise `Templates.Template_Error` during parsing.

Messages include source line and column:

```text
template parse error at line 4, column 12: unclosed #each block
```

## Parse Errors

The parser rejects:

- missing `}}`
- empty tags such as `{{ }}`
- empty variable names
- `{{#if}}` without a path
- `{{#each}}` without a path
- closing tags without an open block
- mismatched closing tags
- unclosed `if` blocks
- unclosed `each` blocks
- unknown block syntax
- invalid path syntax

Rendering missing data is not an error.
