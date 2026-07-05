const NEGATIVE_TERMS = Set(["not", "never", "no", "nobody", "nothing", "without", "stop", "avoid", "wrong", "fail"])

function first_sentence(text::AbstractString)
    pieces = split(text, r"(?<=[.!?])\s+")
    return isempty(pieces) ? strip(text) : strip(first(pieces))
end

function score_script(text::AbstractString)
    words = split(lowercase(replace(text, r"[^A-Za-z0-9\[\]\s?!.'-]" => " ")))
    words = filter(!isempty, words)
    first = lowercase(first_sentence(text))
    visual_anchors = length(collect(eachmatch(r"\[(visual|cut|show|zoom|graph|proof)\]", lowercase(text))))
    questions = count(s -> occursin("?", s), split(text, r"\s+"))
    negative_hook = any(term -> occursin(Regex("\\b$(term)\\b"), first), NEGATIVE_TERMS) && occursin("?", first)
    wpm_target = clamp(length(words) / 45, 0.0, 1.0)

    structure = 0.25 * (negative_hook ? 1.0 : 0.0) +
                0.20 * clamp01(visual_anchors / 4) +
                0.20 * clamp01(questions / 3) +
                0.20 * wpm_target +
                0.15 * (occursin("therefore", lowercase(text)) || occursin("so ", lowercase(text)) ? 1.0 : 0.0)

    return Dict(
        :overall => clamp01(structure),
        :negative_hook => negative_hook ? 1.0 : 0.0,
        :visual_anchors => Float64(visual_anchors),
        :question_density => clamp01(questions / max(length(words), 1) * 20),
        :pace_proxy => wpm_target,
        :word_count => Float64(length(words)),
    )
end

function gate_submission(scores::Dict, exercise::Exercise; minimum_score::Real=0.72)
    failed = String[]
    recommendations = String[]

    if any(c -> occursin("negative question", lowercase(c)), exercise.constraints)
        get(scores, :negative_hook, 0.0) >= 1.0 || begin
            push!(failed, "The opening sentence is not a negative question.")
            push!(recommendations, "Rewrite the first sentence as a direct negative question.")
        end
    end

    if any(c -> occursin("visual", lowercase(c)) || occursin("anchor", lowercase(c)), exercise.constraints)
        get(scores, :visual_anchors, 0.0) >= 2.0 || begin
            push!(failed, "The script does not contain enough explicit visual anchors.")
            push!(recommendations, "Add bracketed visual anchors such as [visual], [show], or [proof].")
        end
    end

    overall = Float64(get(scores, :overall, 0.0))
    overall >= minimum_score || push!(failed, "Overall structural score is below $(minimum_score).")
    accepted = isempty(failed)
    accepted || push!(recommendations, "Repeat the exercise before publishing.")
    return GateDecision(accepted, overall, failed, unique(recommendations))
end
