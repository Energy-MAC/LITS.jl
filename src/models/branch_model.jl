### Temporal Structs ###
abstract type DynBranch <: PSY.Component end

mutable struct DynLine <: DynBranch end
#####

function branch_model!(
    x,
    dx,
    output_ode::Vector{Float64},
    V_r_from,
    V_i_from,
    V_r_to,
    V_i_to,
    current_r_from,
    current_i_from,
    current_r_to,
    current_i_to,
    ix_range::UnitRange{Int64},
    ix_dx::Vector{Int64},
    ode_range::UnitRange{Int64},
    branch::DynBr,
    sys::PSY.System,
) where {DynBr<:DynBranch}

    #Obtain local device states
    n_states = total_device_states(branch)
    device_states = @view x[ix_range]
    dv_from = view(dx, ix_dx[1:2])
    dv_to = view(dx, ix_dx[3:4])

    #Obtain references
    Sbase = PSY.get_basepower(sys)
    sys_f = PSY.get_frequency(sys)

    #Obtain ODEs and Mechanical Power for Turbine Governor
    mdl_line_ode!(
        device_states,
        view(output_ode, ode_range),
        V_r_from,
        V_i_from,
        V_r_to,
        V_i_to,
        current_r_from,
        current_i_from,
        current_r_to,
        current_i_to,
        dv_from,
        dv_to,
        sys_f,
        branch,
    )

    return

end
