function ab_plan(hypothesis::AbstractString, variants::Vector{<:AbstractString}, primary_metric::Symbol;
                 baseline::Real=0.45, minimum_detectable_effect::Real=0.08, power::Real=0.80)
    length(variants) >= 2 || throw(ArgumentError("At least two variants are required."))
    p = clamp01(baseline)
    delta = max(Float64(minimum_detectable_effect), 0.01)
    z_alpha = 1.96
    z_power = power >= 0.9 ? 1.28 : power >= 0.8 ? 0.84 : 0.52
    n = ceil(Int, 2 * p * (1 - p) * (z_alpha + z_power)^2 / delta^2)
    rule = "Ship the variant only if it improves $(primary_metric) by at least $(round(delta * 100; digits=1)) percentage points after $(n) qualified views per variant."
    return ABTestPlan(String(hypothesis), String.(variants), primary_metric, n, rule, now())
end
