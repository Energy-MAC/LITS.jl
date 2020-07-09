"""
Case 2:
This case study a three bus system with 2 machines (One d- One q-: 4th order model) and an infinite source.
The fault drop the connection between buses 1 and 3, eliminating the direct connection between the infinite source
and the generator located in bus 3.
"""

##################################################
############### LOAD DATA ########################
##################################################

include(joinpath(dirname(@__FILE__), "data_tests/test02.jl"))

##################################################
############### SOLVE PROBLEM ####################
##################################################

#Define Fault: Change of YBus
Ybus_change = ThreePhaseFault(
    1.0, #change at t = 1.0
    Ybus_fault,
) #New YBus

#Define Simulation Problem
sim = Simulation(
    threebus_sys, #system
    (0.0, 30.0), #time span
    Ybus_change, #Type of Fault
) #initial guess

small_sig = small_signal_analysis(sim)

#Solve problem in equilibrium
run_simulation!(sim, IDA(), dtmax = 0.02)

#Obtain data for angles
series = get_state_series(sim, ("generator-2-1", :δ))

@test LinearAlgebra.norm(sim.x0_init - test02_x0_init) < 1e-6
@test sim.solution.retcode == :Success
@test small_sig.stable