module OpenCreatorKinetix

using Dates
using Random
using Statistics

include("types.jl")
include("attention.jl")
include("scheme_parser.jl")
include("protocols.jl")
include("training.jl")
include("revops.jl")
include("abtesting.jl")

export Segment,
       CreatorMetrics,
       AttentionModel,
       Exercise,
       TrainingPlan,
       Protocol,
       GateDecision,
       ABTestPlan,
       attention_curve,
       predict_retention,
       score_segments,
       load_protocol,
       parse_scheme,
       diagnose,
       prescribe,
       progressive_overload,
       score_script,
       gate_submission,
       ab_plan,
       run_protocol

end
