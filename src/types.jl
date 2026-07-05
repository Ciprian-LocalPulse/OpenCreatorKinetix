const MetricName = Symbol

struct Segment
    name::Symbol
    start::Float64
    duration::Float64
    intensity::Float64
    novelty::Float64
    friction::Float64
    promise::Float64
    payoff::Float64
    modality::Symbol
end

function Segment(name::Symbol, start::Real, duration::Real; intensity=0.5, novelty=0.5,
                 friction=0.2, promise=0.4, payoff=0.3, modality=:spoken)
    duration > 0 || throw(ArgumentError("Segment duration must be positive."))
    return Segment(name, Float64(start), Float64(duration), Float64(intensity),
                   Float64(novelty), Float64(friction), Float64(promise),
                   Float64(payoff), Symbol(modality))
end

struct CreatorMetrics
    views::Int
    watch_time_ratio::Float64
    hook_retention::Float64
    midpoint_retention::Float64
    completion_rate::Float64
    saves_rate::Float64
    comments_rate::Float64
    baseline_wpm::Float64
    consistency_score::Float64
end

function CreatorMetrics(; views=0, watch_time_ratio=0.0, hook_retention=0.0,
                        midpoint_retention=0.0, completion_rate=0.0, saves_rate=0.0,
                        comments_rate=0.0, baseline_wpm=145.0, consistency_score=0.0)
    return CreatorMetrics(Int(views), clamp01(watch_time_ratio), clamp01(hook_retention),
                          clamp01(midpoint_retention), clamp01(completion_rate),
                          clamp01(saves_rate), clamp01(comments_rate),
                          Float64(baseline_wpm), clamp01(consistency_score))
end

struct AttentionModel
    baseline::Float64
    decay::Float64
    novelty_gain::Float64
    friction_penalty::Float64
    promise_gain::Float64
    payoff_gain::Float64
    reanchor_interval::Float64
end

function AttentionModel(; baseline=0.82, decay=0.018, novelty_gain=0.12,
                        friction_penalty=0.15, promise_gain=0.09, payoff_gain=0.08,
                        reanchor_interval=8.0)
    return AttentionModel(clamp01(baseline), Float64(decay), Float64(novelty_gain),
                          Float64(friction_penalty), Float64(promise_gain),
                          Float64(payoff_gain), Float64(reanchor_interval))
end

struct Exercise
    name::Symbol
    focus::Symbol
    difficulty::Float64
    target_metric::MetricName
    target_value::Float64
    load::Int
    sets::Int
    reps::Int
    constraints::Vector{String}
end

function Exercise(name::Symbol; focus=:general, difficulty=1.0, target_metric=:watch_time_ratio,
                  target_value=0.5, load=1, sets=1, reps=1, constraints=String[])
    return Exercise(name, Symbol(focus), Float64(difficulty), Symbol(target_metric),
                    clamp01(target_value), Int(load), Int(sets), Int(reps),
                    collect(String, constraints))
end

struct TrainingPlan
    week::Int
    focus::Symbol
    objective::String
    exercises::Vector{Exercise}
    load_multiplier::Float64
    diagnostic::Dict{Symbol,Float64}
end

struct Protocol
    name::Symbol
    version::String
    domain::String
    model::AttentionModel
    exercises::Dict{Symbol,Exercise}
    phases::Dict{Symbol,Vector{Symbol}}
    objectives::Dict{Symbol,String}
    raw_forms::Vector{Any}
end

struct GateDecision
    accepted::Bool
    score::Float64
    failed_constraints::Vector{String}
    recommendations::Vector{String}
end

struct ABTestPlan
    hypothesis::String
    variants::Vector{String}
    primary_metric::MetricName
    minimum_sample_per_variant::Int
    decision_rule::String
    created_at::DateTime
end

clamp01(x::Real) = clamp(Float64(x), 0.0, 1.0)
