SynthDef(\fm, {|
	outBus=(~masterOut),
	freq=440,
	carPartial = 1,
	modPartial = 1,
	index = 3,
	dur=1.0,
	amp=0.25,
	pan=0,
	att=0.15,
	mod1=0.001,
	mod2=0.001,
	int=0.5|

	// index values usually are between 0 and 24
	// carPartial :: modPartial => car/mod ratio

	var mod = SinOsc.ar(freq * modPartial, 0,
        freq * index * LFNoise1.kr(5.reciprocal).abs);

	var car = SinOsc.ar((freq * carPartial) + mod, 0, amp);

	var env = Env([0.001, 0.9, 0.001], [att, 1.0-att], [\sin, \sin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	Out.ar(outBus, Pan2.ar(car * envGen, pan));
},

metadata: (
	\vertexType: \PSynth,
	\author: "james watkins",
	\outBusAr: 2,
))
