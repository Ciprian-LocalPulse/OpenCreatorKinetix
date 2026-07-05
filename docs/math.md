# Mathematical Notes

The first version of OpenCreatorKinetix uses transparent heuristic models. They are not presented as universal truths. They are scaffolding for empirical work.

## Segment Score

Each content segment has:

- intensity
- novelty
- friction
- promise
- payoff

The segment score is:

```text
score = 0.35 * intensity
      + 0.25 * novelty
      + 0.25 * promise
      + 0.15 * payoff
      - friction_penalty * friction
      - decay * start_time
```

This encodes a simple hypothesis: later content must work harder because baseline attention decays over time.

## Attention Curve

At each time step, the active segment contributes local signal:

```text
attention(t) = baseline
             + novelty_gain * novelty
             + promise_gain * promise
             + payoff_gain * payoff
             - friction_penalty * friction
             - decay * t
             + reanchor_boost(t)
```

Values are clamped to `[0, 1]`.

## Diagnosis

The diagnostic layer compares creator metrics with target thresholds:

```text
hook deficit       = max(0, 0.72 - hook_retention)
story deficit      = max(0, 0.62 - midpoint_retention)
resolution deficit = max(0, 0.48 - completion_rate)
signal deficit     = max(0, 0.06 - saves_rate)
discipline deficit = max(0, 0.80 - consistency_score)
```

The largest deficit becomes the primary training focus.

## Progressive Overload

Training load is increased through a readiness-and-stress estimate:

```text
readiness = mean(hook_retention, midpoint_retention, completion_rate, consistency)
stress    = mean(deficits)
wave      = 1 + 0.07 * (week - 1)
load      = clamp(0.75 + readiness - 0.35 * stress, 0.70, 1.65) * wave
```

This gives weak creators enough load to grow without pretending that maximum volume is always optimal.

## A/B Sample Size

The A/B planner uses a normal approximation for two proportions:

```text
n = 2 * p * (1 - p) * (z_alpha + z_power)^2 / delta^2
```

where `p` is the baseline conversion or retention rate and `delta` is the minimum detectable effect.

Future versions should add Bayesian sequential testing, creator-specific priors, and guardrails against repeated peeking.
