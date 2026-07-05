; A niche protocol for technical educators.

(protocol technical-education
  (version "0.1.0")
  (domain "technical education content")

  (model
    (baseline 0.80)
    (decay 0.015)
    (novelty_gain 0.10)
    (friction_penalty 0.22)
    (promise_gain 0.12)
    (payoff_gain 0.11)
    (reanchor_interval 10))

  (exercise misconception-first
    (focus hook)
    (difficulty 1.20)
    (target (hook_retention 0.70))
    (metric hook_retention)
    (load 5)
    (sets 5)
    (reps 1)
    (constraint "Begin with the misconception, not the definition.")
    (constraint "The first sentence must be a negative question."))

  (exercise cognitive-load-budget
    (focus story)
    (difficulty 1.45)
    (target (midpoint_retention 0.64))
    (metric midpoint_retention)
    (load 3)
    (sets 3)
    (reps 2)
    (constraint "Introduce no more than one new symbol per 20 seconds.")
    (constraint "Use a visual anchor whenever notation changes."))

  (exercise transfer-test
    (focus resolution)
    (difficulty 1.35)
    (target (saves_rate 0.08))
    (metric saves_rate)
    (load 4)
    (sets 2)
    (reps 2)
    (constraint "End with a transfer problem the viewer can attempt immediately.")
    (constraint "The payoff must be reusable outside the video."))

  (phase week-1
    (objective "Replace abstract openings with misconception-driven hooks.")
    (exercise misconception-first))

  (phase week-2
    (objective "Reduce cognitive friction while preserving rigor.")
    (exercise cognitive-load-budget))

  (phase week-3
    (objective "Turn comprehension into retention, saves, and action.")
    (exercise transfer-test)))
