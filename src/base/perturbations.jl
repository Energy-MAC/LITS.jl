abstract type Perturbation end

mutable struct ThreePhaseFault <: Perturbation
    time::Float64
    Ybus::SparseMatrixCSC{Complex{Float64}, Int64}
end

get_affect(::PSY.System, pert::ThreePhaseFault) =
    (integrator) -> PSY.get_ext(integrator.p)["Ybus"] = pert.Ybus

mutable struct ControlReferenceChange <: Perturbation
    time::Float64
    device::PSY.DynamicInjection
    signal_index::Int64
    ref_value::Float64
end

function get_affect(system::PSY.System, pert::ControlReferenceChange)
    device = PSY.get_component(typeof(pert.device), system, PSY.get_name(pert.device))
    pert.device = device
    return (integrator) -> begin
        control_ref = PSY.get_ext(device)[CONTROL_REFS]
        return control_ref[pert.signal_index] = pert.ref_value
    end
end
