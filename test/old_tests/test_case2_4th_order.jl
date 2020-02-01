"""
Case 2:
This case study a three bus system with 2 machines (One d- One q-: 4th order model) and an infinite source.
The fault drop the connection between buses 1 and 3, eliminating the direct connection between the infinite source
and the generator located in bus 3.
"""

##################################################
############### LOAD DATA ########################
##################################################

############### Data Network ########################

nodes_case234   = [Bus(1 , "Bus 1"  , "REF" , 0 , 1.02  , (min=0.94, max=1.06), 138),
                    Bus(2 , "Bus 2"  , "PV" , 0 , 1.00 , (min=0.94, max=1.06), 138),
                    Bus(3 , "Bus 3"  , "PV" , 0 , 1.00 , (min=0.94, max=1.06), 138)]

branch_case234  =  [Line("Line1", true, 0.0, 0.0, Arc(from=nodes_case234[1], to=nodes_case234[3]), 0.01, 0.12, (from=0.0, to=0.0), 100, 1.04),
                    Line("Line2", true, 0.0, 0.0, Arc(from=nodes_case234[1], to=nodes_case234[2]), 0.01, 0.12, (from=0.0, to=0.0), 100, 1.04),
                    Line("Line3", true, 0.0, 0.0, Arc(from=nodes_case234[2], to=nodes_case234[3]), 0.01, 0.12, (from=0.0, to=0.0), 100, 1.04)]

#Trip of Line 1.
branch_case234_fault = [Line("Line2", true, 0.0, 0.0, Arc(from=nodes_case234[1], to=nodes_case234[2]), 0.01, 0.12, (from=0.0, to=0.0), 100, 1.04),
                        Line("Line3", true, 0.0, 0.0, Arc(from=nodes_case234[2], to=nodes_case234[3]), 0.01, 0.12, (from=0.0, to=0.0), 100, 1.04)]

loads_case234 =   [PowerLoad("Bus1", true, nodes_case234[1], PowerSystems.ConstantPower, 1.5, 0.8, 1.5, 0.8),
                   PowerLoad("Bus2", true, nodes_case234[2], PowerSystems.ConstantPower, 1.5, 0.7, 1.5, 0.8),
                   PowerLoad("Bus3", true, nodes_case234[3], PowerSystems.ConstantPower, 0.5, 0.3, 0.5, 0.3)]


############### Data devices ########################

inf_gen_case234 = StaticSource(1, #number
                :InfBus, #name
                nodes_case234[1], #bus
                1.02, #VR
                0.0, #VI
                0.000001) #Xth

######## Machine Data #########

### Case 2: 4th Order Model with AVR (3-bus case) ###
case2_machine2 =  OneDOneQMachine(0.0, #R
                                  1.3125, #Xd
                                  1.2578, #Xq
                                  0.1813, #Xd_p
                                  0.25, #Xq_p
                                  5.89, #Td0_p
                                  0.6, #Tq0_p
                                  100.0)   #MVABase

case2_machine3 =  OneDOneQMachine(0.0, #R
                                  1.3125, #Xd
                                  1.2578, #Xq
                                  0.1813, #Xd_p
                                  0.25, #Xq_p
                                  5.89, #Td0_p
                                  0.6, #Tq0_p
                                  100.0)   #MVABase

######## Shaft Data #########

### Shafts for Gens 2 and 3: Cases 2, 3 and 4 ###
case234_shaft2 = SingleMass(3.01, #H (M = 6.02 -> H = M/2)
                            0.0) #D


case234_shaft3 = SingleMass(3.01, #H (M = 6.02 -> H = M/2)
                            0.0) #D

######## PSS Data #########
cases_no_pss = PSSFixed(0.0)


######## TG Data #########

### No TG for Cases 1, 2, 3, 4 ###
case1234_no_tg = TGFixed(1.0) #eff


########  AVR Data #########
### AVRs for Case 2, 3, 4 and 5 ###
case2345_avr2 = AVRTypeI(20.0, #Ka - Gain
                        0.01, #Ke
                        0.063, #Kf
                        0.2, #Ta
                        0.314, #Te
                        0.35, #Tf
                        0.001, #Tr
                        5.0, #Vrmax
                        -5.0, #Vrmin
                        0.0039, #Ae - 1st ceiling coefficient
                        1.555) #Be - 2nd ceiling coefficient

case2345_avr3 = AVRTypeI(20.0, #Ka - Gain
                        0.01, #Ke
                        0.063, #Kf
                        0.2, #Ta
                        0.314, #Te
                        0.35, #Tf
                        0.001, #Tr
                        5.0, #Vrmax
                        -5.0, #Vrmin
                        0.0039, #Ae - 1st ceiling coefficient
                        1.555) #Be - 2nd ceiling coefficient

### Case 2 Generators ###
case2_gen2 = PSY.DynamicGenerator(1, #Number
                         :Case2Gen2,
                         nodes_case234[2], #bus
                         1.0, # ω_ref,
                         1.0142, #V_ref
                         1.0, #P_ref
                         case2_machine2, #machine
                         case234_shaft2, #shaft
                         case2345_avr2, #avr
                         case1234_no_tg, #tg
                         cases_no_pss) #pss

case2_gen3 = PSY.DynamicGenerator(2, #Number
                         :Case2Gen3,
                         nodes_case234[3], #bus
                         1.0, # ω_ref,
                         1.0059, #V_ref
                         1.0, #P_ref
                         case2_machine3, #machine
                         case234_shaft3, #shaft
                         case2345_avr3, #avr
                         case1234_no_tg, #tg
                         cases_no_pss) #pss

######################### Dynamical System ########################

case2_DynSystem = PSY.System(nodes_case234,
                                branch_case234,
                                [case2_gen2, case2_gen3],
                                vcat(inf_gen_case234,loads_case234),
                                100.0,
                                60.0)


##################################################
############### SOLVE PROBLEM ####################
##################################################


#Compute Y_bus after fault
Ybus_fault = PSY.Ybus(branch_case234_fault, nodes_case234)[:,:]

#Initialize variables
dx0 = zeros(LITS.get_total_rows(case2_DynSystem))
x0 = [1.02, 1.0, 1.0, 0.0, -0.01, -0.01,
      1.0, #eq_p
      0.47, #ed_p
      0.6, #δ
      1.0, #ω
      2.1, #Vf
      0.28, #Vr1
      -0.39, #Vr2,
      1.0, #Vm
      0.81, #eq_p
      0.59, #ed_p
      0.86, #δ
      1.0, #ω
      1.7, #Vf
      0.11, #Vr1
      -0.31, #Vr2,
      1.0] #Vm
tspan = (0.0, 30.0);

#Find initial condition
inif! = (out,x) -> LITS.system_model!(out, dx0 ,x, (Ybus_fault,case2_DynSystem), 0.0)
sys_solve = nlsolve(inif!, x0)
x0_init = sys_solve.zero
cb = DiffEqBase.DiscreteCallback(LITS.change_t_one, LITS.Y_change!)

sim = DynamicSimulation(case2_DynSystem, tspan, Ybus_fault, cb, x0_init)

#Solve problem in equilibrium
run_simulation!(sim, IDA());

#Obtain data for angles
series = get_state_series(sim, (:Case2Gen2, :δ));

@test sim.solution.retcode == :Success
