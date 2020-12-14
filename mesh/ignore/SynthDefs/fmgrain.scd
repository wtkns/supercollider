SynthDef(\fmGrain, {|

	outBus=(~masterOut),
	freq = 20,
	dur = 0.2,
	carfreq = 440,
	modfreq = 200,
	indexRangeLow = 1,
	indexRangeHi = 10,
	indexRate = 1,
	gate = 1,
	amp = 0.25,
	pan = 0|

	var env = EnvGen.kr(
		      Env([0, 1, 0], [1, 1], 1, 1),
		      gate,
		      levelScale: amp,
		      doneAction: 2);
	var ndx = LFNoise1.kr(indexRate).range(indexRangeLow, indexRangeHi);
	var fmgr = FMGrain.ar(Impulse.ar(freq), dur, carfreq, modfreq, ndx, env);
	Out.ar(outBus, Pan2.ar(fmgr, pan, amp));
},

metadata: (
	\vertexType: \PSynth,
	\author: "james watkins",
	\outBusAr: 2,
))
