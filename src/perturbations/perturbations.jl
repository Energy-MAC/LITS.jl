abstract type Perturbation end

struct ThreePhaseFault
    time::Float64
    Ybus::SparseMatrixCSC{Complex{Float64}, Int64}
end

struct ControlStepUp
    device::PSY.DynamicInjection
    signal::Symbol
end
