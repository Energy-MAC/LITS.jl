"""
Inner variables are used for keeping track of internal variables
of different dynamic devices. These are not states, since can be computed
algebraically using states and parameters, and are only used internally in each
component. In such case, it is possible to avoid creating dummy states that
must be added to the vector of states, by handling those as inner variables.
In some cases, depending on the complexity of the model, some inner vars are
also defined as states, but for the sake of generality are also added as inner
variables, since some models may not treat such variables as states.
"""

"""
Generator Inner Vars:
*  τe_var :: Electric torque
*  τm_var :: Mechanical torque
*  Vf_var :: Field voltage
*  V_pss_var :: Additional PSS voltage
*  VR_gen_var :: Real part of the terminal voltage
*  VI_gen_var :: Imaginary part of the terminal voltage
*  ψd_var :: Stator Flux (if defined) in the d-axis
*  ψq_var :: Stator Flux (if defined) in the q-axis
"""

@enum generator_inner_vars begin
    τe_var = 1
    τm_var = 2
    Vf_var = 3
    V_pss_var = 4
    VR_gen_var = 5
    VI_gen_var = 6
    ψd_var = 7
    ψq_var = 8
end

Base.to_index(ix::generator_inner_vars) = Int(ix)

"""
Inverter Inner Vars:
@enum inverter_inner_vars begin
md_var :: Modulation signal on the d-component
mq_var :: Modulation signal on the q-component
Vdc_var :: DC voltage supplied by the DC source
Vdo_var :: Voltage seen in the capacitor of the filter in the d-component
Vqo_var :: Voltage seen in the capacitor of the filter in the q-component
ω_freq_estimator_var :: Frequency estimated by the frequency estimator.
v_control_var :: Control voltage supplied from the outer loop control to the inner loop
ω_control_var :: Control frequency supplied from the outer loop control the inner loop
δdqRI_var :: Variation of the angle (PLL or VSM) of the inverter
VR_inv_var :: Real terminal voltage on the inverter
VI_inv_var :: Imaginary terminal voltage on the inverter
Vdcnv_var :: Voltage supplied from the converter in the d-component
Vqcnv_var :: Voltage supplied from the converter in the q-component
"""

@enum inverter_inner_vars begin
    md_var = 1
    mq_var = 2
    Vdc_var = 3
    Vdo_var = 4
    Vqo_var = 5
    ω_freq_estimator_var = 6
    v_control_var = 7
    ω_control_var = 8
    δdqRI_var = 9
    VR_inv_var = 10
    VI_inv_var = 11
    Vdcnv_var = 12
    Vqcnv_var = 13
end

Base.to_index(ix::inverter_inner_vars) = Int(ix)

const LITS_COUNTS = "lits_counts"
const LOCAL_STATE_MAPPING = "local_state_mapping"
const INPUT_PORT_MAPPING = "input_port_mapping"
const PORTS = "ports"
const GLOBAL_INDEX = "global_index"
const INNER_VARS = "inner_vars"
const YBUS = "Ybus"
