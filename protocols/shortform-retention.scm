; Open Creator Kinetix protocol.
; This is a Scheme-shaped symbolic training grammar consumed by Julia.

(protocol shortform-retention
  (version "0.1.0")
  (domain "short-form video retention")

  (model
    (baseline 0.84)
    (decay 0.019)
    (novelty_gain 0.13)
    (friction_penalty 0.17)
    (promise_gain 0.10)
    (payoff_gain 0.08)
    (reanchor_interval 8))

  (exercise negative-question-hook
    (focus hook)
    (difficulty 1.15)
    (target (hook_retention 0.72))
    (metric hook_retention)
    (load 5)
    (sets 5)
    (reps 1)
    (constraint "First sentence must be a negative question.")
    (constraint "The hook must create a clear cost for ignoring the video.")
    (constraint "Verbal pace must increase by 15 percent over baseline."))

  (exercise proof-before-context
    (focus hook)
    (difficulty 1.30)
    (target (hook_retention 0.76))
    (metric hook_retention)
    (load 4)
    (sets 4)
    (reps 1)
    (constraint "Show proof before explaining context.")
    (constraint "The first visual anchor must appear before second 2."))

  (exercise eight-second-reanchor
    (focus story)
    (difficulty 1.25)
    (target (midpoint_retention 0.62))
    (metric midpoint_retention)
    (load 3)
    (sets 3)
    (reps 2)
    (constraint "Insert a visual anchor at least every 8 seconds.")
    (constraint "Each anchor must change the viewer's question, not only the shot."))

  (exercise compression-ladder
    (focus story)
    (difficulty 1.40)
    (target (watch_time_ratio 0.58))
    (metric watch_time_ratio)
    (load 3)
    (sets 3)
    (reps 3)
    (constraint "Rewrite the same idea in 90, 60, and 30 seconds.")
    (constraint "The 30 second version must preserve the conflict and payoff."))

  (exercise payoff-loop
    (focus resolution)
    (difficulty 1.20)
    (target (completion_rate 0.48))
    (metric completion_rate)
    (load 4)
    (sets 2)
    (reps 2)
    (constraint "The ending must resolve the opening promise explicitly.")
    (constraint "The final line must point to a repeatable viewer action."))

  (phase week-1
    (objective "Stop early abandonment by making the first three seconds costly to ignore.")
    (exercise negative-question-hook)
    (exercise proof-before-context))

  (phase week-2
    (objective "Prevent midpoint collapse with re-anchoring and compression.")
    (exercise eight-second-reanchor)
    (exercise compression-ladder))

  (phase week-3
    (objective "Make the ending feel earned instead of merely finished.")
    (exercise payoff-loop)
    (exercise compression-ladder)))
