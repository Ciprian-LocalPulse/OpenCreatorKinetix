# Protocol DSL

OpenCreatorKinetix protocols are written in a constrained Scheme-shaped DSL. The current loader parses S-expressions and maps them into Julia structs.

## Protocol

```scheme
(protocol shortform-retention
  (version "0.1.0")
  (domain "short-form video retention")
  ...)
```

The protocol name should be stable and lowercase with hyphens.

## Model

```scheme
(model
  (baseline 0.84)
  (decay 0.019)
  (novelty_gain 0.13)
  (friction_penalty 0.17)
  (promise_gain 0.10)
  (payoff_gain 0.08)
  (reanchor_interval 8))
```

The model controls the attention curve. Higher friction increases drop-off. Higher novelty, promise, and payoff increase retention.

## Exercise

```scheme
(exercise negative-question-hook
  (focus hook)
  (difficulty 1.15)
  (target (hook_retention 0.72))
  (metric hook_retention)
  (load 5)
  (sets 5)
  (reps 1)
  (constraint "First sentence must be a negative question."))
```

Fields:

- `focus`: `hook`, `story`, `resolution`, `signal`, `discipline`, or `general`
- `difficulty`: relative intensity
- `target`: metric and target value
- `metric`: primary metric to watch
- `load`: number of deliverables or attempts
- `sets`: number of work blocks
- `reps`: repetitions per block
- `constraint`: hard symbolic rule

## Phase

```scheme
(phase week-1
  (objective "Stop early abandonment.")
  (exercise negative-question-hook))
```

Phases define week-level training objectives and the exercises that belong to each phase.

## Design Rule

A good protocol should be falsifiable:

- It names the weak skill.
- It gives a hard exercise.
- It states the metric that should improve.
- It explains the constraint that should cause the improvement.
