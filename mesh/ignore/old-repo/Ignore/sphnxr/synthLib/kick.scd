SynthDef(\kick, {|
	outBus=(~masterOut),
	subFreq=60,
	hitFreq=1500,
	dur=0.02,
	amp=0.25,
	pan=0|
	var env = Env([1.0, 0], [1], [\lin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	var subOsc = SinOsc.ar(subFreq);
	var hitOsc = LPF.ar(WhiteNoise.ar(1), hitFreq);
	Out.ar(outBus, Pan2.ar(((subOsc+hitOsc) * envGen * amp), pan));
},

metadata: (
	\vertexType: \PSynth,
	\author: "james watkins",
	\outBusAr: 2,
))