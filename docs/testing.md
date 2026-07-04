# Testing

The tests are an AUnit crate in `tests/`.

Build and run from the repository root:

```sh
alr exec -- gprbuild -P tests/templates_tests.gpr
./tests/bin/tests
```

Build and run from the tests crate:

```sh
cd tests
alr exec -- gprbuild -P templates_tests.gpr
./bin/tests
```

Run the Ada test tool from the tools crate:

```sh
cd tools
alr exec -- ./bin/check_tests
```

The suite covers:

- values and copy-on-write behavior
- HTML escaping
- diagnostics
- parser success and rejection cases
- renderer behavior
- public parse-once/render-many API behavior

## AUnit Package Inventory

- `templates_values_tests`
- `templates_html_tests`
- `templates_diagnostics_tests`
- `templates_parser_tests`
- `templates_renderer_tests`
- `templates_public_tests`
