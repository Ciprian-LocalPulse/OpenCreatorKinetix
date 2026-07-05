# Contributing

OpenCreatorKinetix is designed for serious, empirical contributions. Please prefer measurable claims over generic creator advice.

## Good Contributions

- new niche protocols in `protocols/*.scm`
- improvements to the attention model
- better gatekeeping rules
- analytics importers
- tests that cover protocol behavior
- documentation that makes assumptions explicit

## Protocol Standards

Every new protocol should include:

- a clear domain
- at least one model block
- at least three exercises
- at least one phase
- target metrics for every exercise
- constraints that are observable in a script or workflow

## Development

Run tests before opening a pull request:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

Keep the core transparent. If a model becomes more complex, document the assumptions in `docs/math.md`.
