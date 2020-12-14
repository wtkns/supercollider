SynthDef(\kick, {|
	t_gate=1,
	len=0.02,
	subFreq=60,
	hitFreq=1500,
	panX=0,
	panY=0,
	amp=0|
	var env = Env([0, 1.0, 0], [0, 1], [\lin]);
	var envGen = EnvGen.kr(env, t_gate, doneAction: 0, timeScale: len);
	var subOsc = SinOsc.ar(subFreq);
	var hitOsc = LPF.ar(WhiteNoise.ar(1), hitFreq);
	Out.ar(0, Pan4.ar((subOsc+hitOsc) * envGen, panX, panY, amp));
}, metadata:()).add;

