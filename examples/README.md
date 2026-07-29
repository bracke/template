# templates Examples

This directory is an Alire crate with runnable examples for `templates`.

Build all examples from the repository root:

```sh
alr exec -- gnatls --version
alr exec -- gprbuild -P examples/templates_examples.gpr
```

Or build from this directory:

```sh
alr exec -- gprbuild -P templates_examples.gpr
```

Run examples:

```sh
./examples/bin/basic
./examples/bin/profile_page
./examples/bin/missing_data
./examples/bin/parse_once
```

The examples cover escaped variables, conditionals, loops, missing data, and
reusing a parsed template with multiple contexts.
