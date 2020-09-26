//This synth doesn't have panning capability. Assign note events to an out (0, 1, 2, or 3) or an array of outs.

SynthDef(\pulse, {|
	out=0,
	freq=440,
	len=0.5,
	t_gate=1,
	amp=0.25,
	att=0.15,
	mod1=0.001,
	mod2=0.001,
	int=0.5|

	var harmonics = 3;
	var env = Env([0.001, 0.9, 0.001], [att, 1.0-att], [\sin, \sin]);
	var envGen = EnvGen.kr(env, t_gate, doneAction: 0, timeScale: len);
	var freqArry = Array.fill(harmonics, {
		arg i; (freq + (i * int * freq)) });

	var width = XLine.ar(mod1, mod2, len);
	var pulse = Pulse.ar(freqArry, width, amp/harmonics);
	Out.ar(out, pulse * envGen);
}, metadata:(
	\out: Prand((0..3), inf),
	\dur: Prand([Pn(5, 20),
		                Pgeom(2, 1.1, 20),
		                4,
	                    Pgeom(1.345, 0.909, 20),
		                Pn(1, 3)], inf),
	\len: 0.5,
	\gate: 1,
	\freq: 80,
	\mod1: Pn(Pseries(0.01, 0.01, 99), inf),
	\mod2: Pn(Pseries(0.99, -0.01, 99), inf),
	\int: Prand([
		Pgeom(0.4, 1.3, 19),
		Pgeom(0.5, 1.1, 19),
	    Pgeom(4, 0.8, 19),
		Pseq([Pgeom(5, 0.83, 10),
		         Pgeom(4, 0.9, 9)], 1),
		         Pseq([Pseries(0.5, 0.5, 10), Pseries(0.1, 0.6, 9)], 1)], inf),
	\att:Pwrand([0.05, 0.95, \rest], [0.05, 0.90, 0.05], inf),
	\amp: 0.25
)).add;
