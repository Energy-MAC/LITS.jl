function dq_ri(δ::Real)
    ## Uses the referenceframe of the Kundur page 852 of dq to RI
    return [
        sin(δ) cos(δ)
        -cos(δ) sin(δ)
    ]
end

function ri_dq(δ::Real)
    #Uses the reference frame of the Kundur page 852 of RI to dq
    return [
        sin(δ) -cos(δ)
        cos(δ) sin(δ)
    ]
end

function dq_ri(δ::Float64)
    ## Uses the referenceframe of the Kundur page 852 of dq to RI
    return [
        sin(δ) cos(δ)
        -cos(δ) sin(δ)
    ]
end

function ri_dq(δ::Float64)
    #Uses the reference frame of the Kundur page 852 of RI to dq
    return [
        sin(δ) -cos(δ)
        cos(δ) sin(δ)
    ]
end
