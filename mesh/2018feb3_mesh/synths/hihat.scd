SynthDef(\hihat, {|
	t_gate=1,
	len=0.02,
	lpFreq=6000,
	hpFreq=2500,
	out=0,
	amp=0|
	var env = Env([0, 1.0, 0], [0, 1], [\lin]);
	var envGen = EnvGen.kr(env, t_gate, doneAction: 0, timeScale: len);
	var hit = HPF.ar(LPF.ar(WhiteNoise.ar(1), lpFreq), hpFreq);
	Out.ar(out, (hit * envGen * amp));
},

metadata:(
	\dur: Pn(Pseries(0.05, 0.01, 20)),
	\gate: 1,
	\lpFreq: 6000,
	\hpFreq: 2500,
	\out: Prand((0..3), inf),
	\amp: Pseq([Pseries(0, 0.0004, 500), Pn(0.2)])
)
).add;
