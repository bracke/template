# Agent instructions

This crate enforces GNAT 15 through Alire with `gnat_native = "=15.2.1"` in
every active manifest. Do not run plain system GNAT, GPRBuild, GNATprove,
GNATdoc, or related `gnat*` tools from `PATH`.

Use Alire-selected tools:

```sh
alr exec -- gnatls --version
alr build
cd tests && alr exec -- gprbuild -P templates_tests.gpr
cd examples && alr exec -- gprbuild -P templates_examples.gpr
cd tools && alr build
```

The compiler version command must report `GNATLS 15.x`.
