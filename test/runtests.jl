using Test
using OpenCreatorKinetix

@testset "Scheme parser" begin
    forms = parse_scheme("(protocol demo (version \"0.1.0\") (model (baseline 0.8)))")
    @test length(forms) == 1
    @test forms[1][1] isa OpenCreatorKinetix.SchemeSymbol
end

@testset "Protocol loading" begin
    path = joinpath(@__DIR__, "..", "protocols", "shortform-retention.scm")
    protocol = load_protocol(path)
    @test protocol.name == :("shortform-retention")
    @test haskey(protocol.exercises, :("negative-question-hook"))
    @test protocol.model.reanchor_interval == 8.0
end

@testset "Attention model" begin
    segments = [
        Segment(:hook, 0, 3; intensity=0.9, novelty=0.8, friction=0.1, promise=0.9),
        Segment(:conflict, 3, 10; intensity=0.7, novelty=0.6, friction=0.25, promise=0.6),
        Segment(:payoff, 13, 5; intensity=0.8, novelty=0.5, friction=0.1, promise=0.4, payoff=0.9),
    ]
    times, curve = attention_curve(segments)
    @test length(times) == length(curve)
    @test all(x -> 0 <= x <= 1, curve)
    retention = predict_retention(segments)
    @test retention[:hook] >= retention[:completion]
end

@testset "Training prescription" begin
    protocol = load_protocol(joinpath(@__DIR__, "..", "protocols", "shortform-retention.scm"))
    metrics = CreatorMetrics(hook_retention=0.35, midpoint_retention=0.25, completion_rate=0.15,
                             saves_rate=0.01, consistency_score=0.45)
    primary, deficits = diagnose(metrics)
    @test primary in keys(deficits)
    plan = prescribe(protocol, metrics; week=1)
    @test !isempty(plan.exercises)
    @test plan.load_multiplier > 0
    wave = progressive_overload(metrics; weeks=6)
    @test length(wave) == 6
end

@testset "RevOps gate and A/B planning" begin
    protocol = load_protocol(joinpath(@__DIR__, "..", "protocols", "shortform-retention.scm"))
    script = "Why are people not watching your tutorial? [visual] Show drop-off. [proof] Show two hooks. Therefore, fix the first sentence."
    scores = score_script(script)
    decision = gate_submission(scores, protocol.exercises[:("negative-question-hook")]; minimum_score=0.4)
    @test decision.accepted

    plan = ab_plan("Negative questions beat neutral statements", ["A", "B"], :hook_retention)
    @test plan.minimum_sample_per_variant > 0
end
