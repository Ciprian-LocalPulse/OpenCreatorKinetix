using OpenCreatorKinetix

protocol_path = joinpath(@__DIR__, "..", "protocols", "shortform-retention.scm")
protocol = load_protocol(protocol_path)

metrics = CreatorMetrics(
    views=2400,
    watch_time_ratio=0.41,
    hook_retention=0.39,
    midpoint_retention=0.28,
    completion_rate=0.19,
    saves_rate=0.021,
    comments_rate=0.008,
    baseline_wpm=150,
    consistency_score=0.52,
)

plans = run_protocol(protocol, metrics; weeks=3)

for plan in plans
    println("Week $(plan.week): $(plan.focus)")
    println("Objective: $(plan.objective)")
    println("Load multiplier: $(round(plan.load_multiplier; digits=2))")
    for exercise in plan.exercises
        println("  - $(exercise.name): $(exercise.sets)x$(exercise.reps), load $(exercise.load)")
    end
    println()
end

script = """
Why are your viewers not staying past three seconds?
[visual] Show the analytics drop.
The problem is not your idea. It is the missing conflict.
[proof] Compare two openings side by side.
Therefore, rewrite the first line until ignoring it feels expensive.
"""

scores = score_script(script)
exercise = protocol.exercises[:("negative-question-hook")]
decision = gate_submission(scores, exercise)

println("Gate accepted: $(decision.accepted)")
println("Score: $(round(decision.score; digits=3))")
println("Recommendations: $(join(decision.recommendations, "; "))")
