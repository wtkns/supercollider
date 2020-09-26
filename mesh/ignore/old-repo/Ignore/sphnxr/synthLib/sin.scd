SynthDef(\sin, {|
	outBus=0,
	freq=440,
	dur=1.0,
	amp=0.25,
	pan=0,
	att=0.15,
	mod1=0.25,
	mod2=0.01|
	var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	var modulate = SinOsc.ar(XLine.kr((mod1*2000)+0.001, (mod2*2000)+0.001, dur), 0, 2pi);
	var sin = SinOsc.ar(freq, modulate, amp); //phase modulation by sin between -2pi and 2pi
	Out.ar(outBus, Pan2.ar(sin * envGen, pan))
},

metadata: (
	\vertexType: \PSynth,
	\author: "james watkins",
	\inBusAr: 0,
	\outBusAr: 2,
	\inBusKr: 0,
	\outBusKr: 0,
	\freq: (Pseq([0, 2, 4, 7, 9], inf) + 40).midicps,
	\dur: Pshuf([1/4, 1/4, 1/8, 1/8], inf),
	\amp: Pmeanrand(0.2, 0.3, inf),
	\pan: Pmeanrand(-0.5, 0.5, inf),
	\att: Pmeanrand(0.1, 0.2, inf)
))