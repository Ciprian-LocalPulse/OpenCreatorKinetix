function score_segments(segments::Vector{Segment}, model::AttentionModel=AttentionModel())
    isempty(segments) && return Dict{Symbol,Float64}()
    scores = Dict{Symbol,Float64}()
    for s in segments
        coherence = 0.35 * s.intensity + 0.25 * s.novelty + 0.25 * s.promise + 0.15 * s.payoff
        drag = model.friction_penalty * s.friction + model.decay * max(s.start, 0)
        scores[s.name] = clamp01(coherence - drag)
    end
    return scores
end

function attention_curve(segments::Vector{Segment}, model::AttentionModel=AttentionModel();
                         horizon::Union{Nothing,Real}=nothing, step::Real=1.0)
    step > 0 || throw(ArgumentError("step must be positive."))
    if isempty(segments)
        return Float64[], Float64[]
    end

    final_time = isnothing(horizon) ? maximum(s.start + s.duration for s in segments) : Float64(horizon)
    times = collect(0.0:Float64(step):final_time)
    attention = Float64[]

    for t in times
        active = filter(s -> s.start <= t < s.start + s.duration, segments)
        local_signal = isempty(active) ? 0.0 : mean(
            model.novelty_gain * s.novelty +
            model.promise_gain * s.promise +
            model.payoff_gain * s.payoff -
            model.friction_penalty * s.friction
            for s in active
        )
        reanchor = model.reanchor_interval > 0 && t > 0 && mod(t, model.reanchor_interval) < step ?
                   0.04 : 0.0
        push!(attention, clamp01(model.baseline + local_signal + reanchor - model.decay * t))
    end

    return times, attention
end

function predict_retention(segments::Vector{Segment}, model::AttentionModel=AttentionModel();
                           checkpoints=(3.0, 0.5, 1.0))
    times, attention = attention_curve(segments, model)
    isempty(times) && return Dict(:hook => 0.0, :midpoint => 0.0, :completion => 0.0, :mean => 0.0)
    total = maximum(times)

    at_time(t) = attention[argmin(abs.(times .- t))]
    hook_t = Float64(first(checkpoints))
    midpoint_t = total * Float64(checkpoints[2])
    completion_t = total * Float64(checkpoints[3])

    return Dict(
        :hook => at_time(min(hook_t, total)),
        :midpoint => at_time(midpoint_t),
        :completion => at_time(completion_t),
        :mean => mean(attention),
    )
end
