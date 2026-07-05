struct SchemeSymbol
    name::Symbol
end

Base.string(s::SchemeSymbol) = String(s.name)

function tokenize_scheme(source::AbstractString)
    tokens = String[]
    i = firstindex(source)
    while i <= lastindex(source)
        c = source[i]
        if c == ';'
            while i <= lastindex(source) && source[i] != '\n'
                i = nextind(source, i)
            end
        elseif isspace(c)
            i = nextind(source, i)
        elseif c == '(' || c == ')'
            push!(tokens, string(c))
            i = nextind(source, i)
        elseif c == '"'
            buf = IOBuffer()
            i = nextind(source, i)
            while i <= lastindex(source) && source[i] != '"'
                if source[i] == '\\'
                    i = nextind(source, i)
                    i > lastindex(source) && throw(ArgumentError("Unterminated escape in string."))
                end
                print(buf, source[i])
                i = nextind(source, i)
            end
            i <= lastindex(source) || throw(ArgumentError("Unterminated string."))
            push!(tokens, "\"" * String(take!(buf)) * "\"")
            i = nextind(source, i)
        else
            buf = IOBuffer()
            while i <= lastindex(source) && !isspace(source[i]) && source[i] != '(' && source[i] != ')'
                print(buf, source[i])
                i = nextind(source, i)
            end
            push!(tokens, String(take!(buf)))
        end
    end
    return tokens
end

function atom(token::String)
    if startswith(token, "\"") && endswith(token, "\"")
        return token[2:end-1]
    end
    parsed = tryparse(Float64, token)
    isnothing(parsed) || return parsed
    return SchemeSymbol(Symbol(token))
end

function read_from_tokens(tokens::Vector{String}, index::Int=1)
    index > length(tokens) && throw(ArgumentError("Unexpected EOF while reading Scheme form."))
    token = tokens[index]
    if token == "("
        index += 1
        form = Any[]
        while index <= length(tokens) && tokens[index] != ")"
            item, index = read_from_tokens(tokens, index)
            push!(form, item)
        end
        index <= length(tokens) || throw(ArgumentError("Missing closing parenthesis."))
        return form, index + 1
    elseif token == ")"
        throw(ArgumentError("Unexpected closing parenthesis."))
    else
        return atom(token), index + 1
    end
end

function parse_scheme(source::AbstractString)
    tokens = tokenize_scheme(source)
    forms = Any[]
    index = 1
    while index <= length(tokens)
        form, index = read_from_tokens(tokens, index)
        push!(forms, form)
    end
    return forms
end
