# Architecture

The implementation is split into small packages:

```text
Templates              public facade
Templates.Values       value model and copy-on-write mutation
Templates.Html         HTML escaping
Templates.Diagnostics  parse diagnostic formatting and raising
Templates.Ast          AST nodes and AST ownership
Templates.Parser       stack-based parser
Templates.Renderer     AST renderer
```

## Parser

The parser scans the source for `{{` and `}}`, emits text nodes for text outside
tags, and handles tags with a stack.

The root node is always `stack[0]`. Text and variable nodes are appended to the
current stack top. Opening `#if` and `#each` nodes are appended and pushed.
Closing tags only pop the matching top block.

At end of file, only the root node may remain on the stack.

## AST

AST node kinds are:

```text
Root_Node
Text_Node
Variable_Node
If_Node
Each_Node
```

Each node stores its kind, text, source line, source column, children, and a
reference count. Template copies share the immutable AST.

## Renderer

Rendering walks the AST against the active context.

- variables resolve from the active context
- dotted paths resolve by repeated object lookup
- `{{.}}` returns the active context
- conditionals render children when the path is truthy
- loops render children once for each list item

There is no parent context lookup.
