function mpc = Twogen2bus
%%-----  Power Flow Data  -----%%

%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	3	10	30	0	0	1	1.02	0	138	1	1.06	0.94; % grid-forming
	2	1	30	10	0	0	1	1.00	0	138	1	1.06	0.94; % grid-following
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	60	0	100	-100	1.02	100	1	200	50	0	0	0	0	0	0	0	0	0	0	0;
	%2	50 -30	100	-100	1.0	100	1	150	37.5	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0.03	0.36	0.5	100	100	100	0	0	1	-1.04	1.04;	
];
