# OpenCreatorKinetix

![OpenCreatorKinetix RevOps Julia command center](assets/revops-julia.png)

OpenCreatorKinetix is an open-source training engine for creators who want to improve retention, narrative clarity, and publishing discipline through progressive overload.

The project does not promise viral shortcuts. It treats creator skill like strength training: measure the weak point, prescribe a hard exercise, increase the load, deload when necessary, and repeat until the skill becomes durable.

Created by **Ciprian Stefan Plesca**.

## Public Repository Description

OpenCreatorKinetix is a Julia and Scheme research engine for creator training, audience retention, symbolic narrative analysis, RevOps discipline, progressive overload, and measurable content skill acquisition.

Suggested GitHub topics:

`julia`, `scheme`, `creator-economy`, `revops`, `progressive-overload`, `audience-retention`, `attention-modeling`, `symbolic-ai`, `content-creation`, `ab-testing`, `analytics`, `training-engine`, `open-source`, `education`, `mit-license`

## Why This Exists

Most creator tools optimize symptoms: trends, templates, captions, thumbnails, or one-off script generation. OpenCreatorKinetix focuses on the structural causes of poor performance:

- weak hooks
- missing conflict
- slow cognitive re-anchoring
- unresolved promises
- inconsistent execution
- untested assumptions about audience behavior

The system combines Julia for numerical modeling and planning with a Scheme-shaped symbolic protocol language for training rules.

## Architecture

```text
OpenCreatorKinetix
|-- Julia numerical engine
|   |-- attention curve modeling
|   |-- retention diagnostics
|   |-- progressive overload planning
|   |-- script gatekeeping
|   `-- A/B testing math
`-- Scheme protocol layer
    |-- symbolic exercises
    |-- constraints
    |-- targets
    `-- week-by-week training phases
```

Julia answers quantitative questions:

- Where does attention decay?
- Which metric is the limiting factor?
- How much should training load increase this week?
- How large should an A/B test be?

Scheme answers symbolic questions:

- What is the exercise?
- What constraints must the creator satisfy?
- Which metric defines success?
- Which training phase should apply next?

## Quick Start

Install Julia 1.10 or newer, then run:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
julia --project=. examples/run_curriculum.jl
```

Minimal Julia example:

```julia
using OpenCreatorKinetix

protocol = load_protocol("protocols/shortform-retention.scm")

metrics = CreatorMetrics(
    hook_retention=0.39,
    midpoint_retention=0.28,
    completion_rate=0.19,
    saves_rate=0.02,
    consistency_score=0.52,
)

plan = prescribe(protocol, metrics; week=1)
println(plan.focus)
println(plan.objective)
println(plan.exercises)
```

## Example Protocol

Protocols are written as Scheme-style symbolic forms:

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

The Julia engine loads this into typed training objects and uses it to prescribe work.

## Core Concepts

### Attention Curve

A video is represented as timed segments. Each segment has intensity, novelty, friction, promise, payoff, and modality. The attention model estimates retention checkpoints such as hook, midpoint, completion, and mean attention.

### Progressive Overload

The system diagnoses the creator's largest deficit and adjusts load using readiness and stress:

```text
load = f(readiness, deficit stress, week)
```

This deliberately avoids generic advice. A creator with poor hook retention receives hook drills. A creator with strong hooks but weak midpoint retention receives re-anchoring drills.

### RevOps Discipline

The gatekeeping layer scores scripts against exercise constraints. If the creator did not satisfy the training plan, the submission can be rejected before publishing.

This is intentionally strict. The goal is not comfort. The goal is repeatable skill acquisition.

### A/B Testing

The project includes a simple planning utility for variant tests. It estimates minimum sample size and creates an explicit decision rule so creators do not chase random noise.

## Repository Layout

```text
assets/
  revops-julia.png       repository visual identity
src/
  OpenCreatorKinetix.jl  package entry point
  attention.jl           numerical retention model
  scheme_parser.jl       small S-expression parser
  protocols.jl           Scheme protocol loader
  training.jl            diagnosis and progressive overload
  revops.jl              script scoring and gatekeeping
  abtesting.jl           A/B test planner
protocols/
  shortform-retention.scm
  technical-education.scm
examples/
  run_curriculum.jl
docs/
  architecture.md
  math.md
  protocol-dsl.md
CREATOR.md
AUTHORS.md
SECURITY.md
CHANGELOG.md
SUPPORT.md
test/
  runtests.jl
```

## Current Status

This is an initial research-grade foundation, not a finished commercial product. The models are intentionally transparent and inspectable. Contributors can improve them with better retention data, niche-specific protocols, and empirical validation.

## Roadmap

- Add real analytics importers for CSV exports.
- Add protocol linting and schema validation.
- Add Bayesian updating for creator-specific attention curves.
- Add a command line interface.
- Add niche protocol packs for education, entertainment, B2B, storytelling, and livestream clips.
- Add reproducible benchmark datasets.

## License

MIT. Use it, fork it, test it, and make it sharper.
<div align="center">

## 💚 Support

This project is developed and maintained independently, without institutional funding.

If you found it useful, you can donate through any of the channels below.

</div>

<table align="center">
<tr><td colspan="2" align="center">

### 🇪🇺 European Payment — SEPA / EUR <sub>· CEA · AES-256</sub>

| Field | Detail |
|---|---|
| Recipient | Ciprian Stefan Plesca |
| IBAN | `BE83 9679 1975 8915` |
| SWIFT / BIC | `TRWIBEB1XXX` |
| Bank | Wise, Rue du Trône 100, 3rd floor, Brussels, 1050, Belgium |

</td></tr>
<tr><td colspan="2" align="center">

### 🇬🇧 United Kingdom Payment — Faster Payments / GBP <sub>· AIA · SHA-3</sub>

| Field | Detail |
|---|---|
| Container | Ciprian Stefan Plesca |
| Account number | `92055372` |
| Sort code | `23-14-70` |
| IBAN | `GB68 TRWI 2314 7092 0553 72` |
| SWIFT / BIC | `TRWIGB2LXXX' |
| Bank | Wise Payments Limited, 1st Floor, Worship Square, 65 Clifton Street, London, EC2A 4JE, United Kingdom |

</td></tr>
<tr><td colspan="2" align="center">

### 🇺🇸 United States Payment — ACH / Wire / USD <sub>· ICA · RSA-4096</sub>

| Field | Detail |
|---|---|
| Container | Ciprian Stefan Plesca |
| Account type | Checking |
| Routing number | `026073150` |
| Account number | `8314225367` |
| SWIFT / BIC | `CMFGUS33` |
| Bank | Community Federal Savings Bank, 89-16 Jamaica Ave, Woodhaven, NY, 11421, United States |

</td></tr>
</table>

<div align="center">

| ₿ Bitcoin (BTC) | Ξ Ethereum (ETH) | PP PayPal |
|---|---|---|
| `bc1qf3yy0w8z37rwavxpu38wem3yffpanw7wzj32qj` | `0x27d9a6a5b8507e6031bb044319410da96222d402` | [paypal.me/agentflowenterprise](https://paypal.me/agentflowenterprise) |

<br/>


<sub>Made with ☕ and too much entropy, independently, in Romania.</sub>

</div>
