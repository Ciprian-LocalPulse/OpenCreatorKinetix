function metric_value(metrics::CreatorMetrics, name::Symbol)
    if name == :views
        return Float64(metrics.views)
    elseif hasproperty(metrics, name)
        return Float64(getproperty(metrics, name))
    else
        throw(ArgumentError("Unknown metric: $(name)"))
    end
end

function diagnose(metrics::CreatorMetrics)
    deficits = Dict{Symbol,Float64}(
        :hook => clamp01(0.72 - metrics.hook_retention),
        :story => clamp01(0.62 - metrics.midpoint_retention),
        :resolution => clamp01(0.48 - metrics.completion_rate),
        :signal => clamp01(0.06 - metrics.saves_rate),
        :discipline => clamp01(0.80 - metrics.consistency_score),
    )
    primary = first(sort(collect(keys(deficits)), by=k -> deficits[k], rev=true))
    return primary, deficits
end

function overload_multiplier(metrics::CreatorMetrics; week::Int=1)
    _, deficits = diagnose(metrics)
    readiness = mean([metrics.hook_retention, metrics.midpoint_retention,
                      metrics.completion_rate, metrics.consistency_score])
    stress = mean(values(deficits))
    wave = 1.0 + 0.07 * max(week - 1, 0)
    return clamp(0.75 + readiness - 0.35 * stress, 0.70, 1.65) * wave
end

function prescribe(protocol::Protocol, metrics::CreatorMetrics; week::Int=1)
    primary, deficits = diagnose(metrics)
    phase_order = sort(collect(keys(protocol.phases)), by=string)
    phase = isempty(phase_order) ? :default : phase_order[mod1(week, length(phase_order))]
    names = get(protocol.phases, phase, collect(keys(protocol.exercises)))

    selected = Exercise[]
    for name in names
        haskey(protocol.exercises, name) || continue
        ex = protocol.exercises[name]
        if ex.focus == primary || ex.focus == :general || week <= 1
            push!(selected, ex)
        end
    end
    isempty(selected) && append!(selected, collect(values(protocol.exercises)))

    objective = get(protocol.objectives, phase, "Apply progressive overload to a measurable creator skill.")
    return TrainingPlan(week, primary, objective, selected, overload_multiplier(metrics; week=week), deficits)
end

function progressive_overload(metrics::CreatorMetrics; weeks::Int=6)
    weeks > 0 || throw(ArgumentError("weeks must be positive."))
    primary, deficits = diagnose(metrics)
    baseline = overload_multiplier(metrics)
    return [
        Dict(
            :week => week,
            :focus => primary,
            :load_multiplier => round(baseline * (1 + 0.075 * (week - 1)); digits=3),
            :deload => week % 4 == 0,
            :deficit => round(get(deficits, primary, 0.0); digits=3),
        )
        for week in 1:weeks
    ]
end

function run_protocol(protocol::Protocol, metrics::CreatorMetrics; weeks::Int=4)
    return [prescribe(protocol, metrics; week=week) for week in 1:weeks]
end
