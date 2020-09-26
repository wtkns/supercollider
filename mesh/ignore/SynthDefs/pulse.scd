SynthDef(\pulse, {|
	outBus=(~masterOut),
	freq=440,
	dur=0.1,
	amp=0.25,
	pan=0,
	att=0.15,
	mod1=0.001,
	mod2=0.001,
	int=0.5|
	var harmonics = 3;
	var env = Env([0.001, 0.9, 0.001], [att, 1.0-att], [1, 1]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	var freqArry = Array.fill(harmonics, {
		arg i; (freq + (i * int * freq)) });

	var width = XLine.ar(mod1, mod2, dur);
	var pulse = Pulse.ar(freqArry, width, amp/harmonics);
	Out.ar(outBus, Pan2.ar(pulse * envGen, pan));
},

metadata: (
	\vertexType: \PSynth,
	\author: "james watkins",
	\outBusAr: 2,
	\freq: (Pseq([0, 2, 4, 7, 9], inf) + 40).midicps,
	\dur: Pshuf([1/4, 1/4, 1/8, 1/8], inf),
	\amp: Pmeanrand(0.2, 0.3, inf),
	\pan: Pmeanrand(-0.5, 0.5, inf),
	\att: Pmeanrand(0.1, 0.2, inf)
))
