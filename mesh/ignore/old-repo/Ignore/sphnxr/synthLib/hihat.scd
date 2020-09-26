SynthDef(\hihat, {|
	outBus=(~masterOut),
	lpFreq=6000,
	hpFreq=2500,
	dur=0.02,
	amp=0.25,
	pan=0|
	var env = Env([1.0, 0], [1], [\lin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	var hit = HPF.ar(LPF.ar(WhiteNoise.ar(1), lpFreq), hpFreq);
	Out.ar(outBus, Pan2.ar((hit * envGen * amp), pan));
},

metadata: (
	\vertexType: \PSynth,
	\author: "james watkins",
	\outBusAr: 2,
))