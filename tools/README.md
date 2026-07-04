# templates Tooling

This directory is an Alire crate for project-specific test and release tools.
The tools are Ada programs and use `project_tools`, pinned to
`../../project_tools`, for shared process, file, tree, AUnit, and release
checks.

Build tools:

```sh
cd tools
alr build
```

Run from this directory:

```sh
alr exec -- ./bin/check_tests
alr exec -- ./bin/release_check
alr exec -- ./bin/check_all
```

Or run from the repository root after entering the tools Alire environment:

```sh
cd tools
alr exec -- ./bin/check_all
```
