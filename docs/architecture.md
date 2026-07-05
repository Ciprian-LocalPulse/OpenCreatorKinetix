# Architecture

OpenCreatorKinetix separates creator training into two layers:

1. a numerical layer that estimates retention and training load
2. a symbolic layer that defines exercises, constraints, and phases

This split is deliberate. Numerical models are good at measuring and forecasting. Symbolic protocols are good at expressing rules, pedagogy, and domain-specific training logic.

## Data Flow

```text
Creator metrics
    |
    v
Diagnosis engine
    |
    v
Protocol selection
    |
    v
Training plan
    |
    v
Script scoring and gatekeeping
    |
    v
A/B test planning
```

## Julia Layer

The Julia package owns:

- typed domain objects
- attention curve computation
- retention checkpoint prediction
- deficit diagnosis
- progressive overload scheduling
- submission gates
- A/B planning

The code is dependency-light by design. A public research tool should be easy to inspect, run, and modify.

## Scheme Layer

The Scheme files describe training protocols as symbolic forms:

- `(protocol ...)`
- `(model ...)`
- `(exercise ...)`
- `(phase ...)`

The repository currently parses a constrained Scheme-shaped DSL rather than evaluating arbitrary Scheme. This keeps protocol loading deterministic and safe while preserving a Lisp-like format that is easy to generate, diff, and reason about.

## Extension Points

New contributors can add value in four places:

- `protocols/*.scm`: niche-specific training programs
- `src/attention.jl`: better audience attention models
- `src/revops.jl`: stricter script gates
- `src/abtesting.jl`: stronger experimental design

The long-term direction is to make every claim testable: a protocol should declare what metric it improves, what constraint causes the improvement, and what data would falsify it.
