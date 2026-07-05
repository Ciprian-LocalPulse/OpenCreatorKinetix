sym(x::SchemeSymbol) = x.name
sym(x::Symbol) = x
sym(x::AbstractString) = Symbol(x)

function form_head(form)
    form isa Vector || return nothing
    isempty(form) && return nothing
    return form[1] isa SchemeSymbol ? sym(form[1]) : form[1]
end

function child_value(form::Vector, key::Symbol, default=nothing)
    for child in form[2:end]
        child isa Vector || continue
        form_head(child) == key || continue
        return length(child) >= 2 ? child[2] : default
    end
    return default
end

function child_form(form::Vector, key::Symbol)
    for child in form[2:end]
        child isa Vector || continue
        form_head(child) == key || continue
        return child
    end
    return nothing
end

function child_values(form::Vector, key::Symbol)
    values = Any[]
    for child in form[2:end]
        child isa Vector || continue
        form_head(child) == key || continue
        length(child) >= 2 && push!(values, child[2])
    end
    return values
end

function parse_model(form::Vector)
    model_form = child_form(form, :model)
    model_form isa Vector || return AttentionModel()
    getnum(k, d) = Float64(child_value(model_form, k, d))
    return AttentionModel(
        baseline=getnum(:baseline, 0.82),
        decay=getnum(:decay, 0.018),
        novelty_gain=getnum(:novelty_gain, 0.12),
        friction_penalty=getnum(:friction_penalty, 0.15),
        promise_gain=getnum(:promise_gain, 0.09),
        payoff_gain=getnum(:payoff_gain, 0.08),
        reanchor_interval=getnum(:reanchor_interval, 8.0),
    )
end

function parse_exercise(form::Vector)
    name = sym(form[2])
    constraints = String[string(v) for v in child_values(form, :constraint)]
    target = child_value(form, :target, Any[])
    metric = :watch_time_ratio
    target_value = 0.5
    if target isa Vector && length(target) >= 2
        metric = sym(target[1])
        target_value = Float64(target[2])
    end

    return Exercise(
        name;
        focus=sym(child_value(form, :focus, "general")),
        difficulty=Float64(child_value(form, :difficulty, 1.0)),
        target_metric=sym(child_value(form, :metric, metric)),
        target_value=target_value,
        load=Int(round(Float64(child_value(form, :load, 1)))),
        sets=Int(round(Float64(child_value(form, :sets, 1)))),
        reps=Int(round(Float64(child_value(form, :reps, 1)))),
        constraints=constraints,
    )
end

function parse_phase(form::Vector)
    name = sym(form[2])
    objective = string(child_value(form, :objective, "Build a measurable retention skill."))
    exercise_names = Symbol[]
    for child in form[3:end]
        child isa Vector || continue
        form_head(child) == :exercise || continue
        length(child) >= 2 && push!(exercise_names, sym(child[2]))
    end
    return name, objective, exercise_names
end

function protocol_from_forms(forms::Vector{Any})
    protocol_form = findfirst(f -> f isa Vector && form_head(f) == :protocol, forms)
    isnothing(protocol_form) && throw(ArgumentError("No (protocol ...) form found."))
    form = forms[protocol_form]
    name = sym(form[2])
    version = string(child_value(form, :version, "0.1.0"))
    domain = string(child_value(form, :domain, "creator training"))
    model = parse_model(form)

    exercises = Dict{Symbol,Exercise}()
    phases = Dict{Symbol,Vector{Symbol}}()
    objectives = Dict{Symbol,String}()

    for child in form[3:end]
        child isa Vector || continue
        if form_head(child) == :exercise
            ex = parse_exercise(child)
            exercises[ex.name] = ex
        elseif form_head(child) == :phase
            phase, objective, names = parse_phase(child)
            phases[phase] = names
            objectives[phase] = objective
        end
    end

    return Protocol(name, version, domain, model, exercises, phases, objectives, forms)
end

function load_protocol(path::AbstractString)
    source = read(path, String)
    return protocol_from_forms(parse_scheme(source))
end
