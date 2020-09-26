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
		      Env([0, 1, 0], [1, 1], \sin, 1),
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

// s.boot;
// x = Synth.new(\fmGrain);
//
// x.set(\amp, 0.5);
//
// x.set(\freq, 40, \dur, 0.1, \amp, 0.5);
// x.set(\freq, 60, \dur, 0.05, \amp, 0.5);
// x.set(\freq, 80, \dur, 0.03, \amp, 0.5);
// x.set(\freq, 120, \dur, 0.01, \amp, 0.5);
// x.set(\freq, 80, \dur, 0.01, \amp, 0.5);
// x.set(\freq, 40, \dur, 0.01, \amp, 0.5);
//
// x.set(\indexRate, 10, \indexRangeLow, 1, \indexRangeHigh, 20);
// x.set(\indexRate, 100);
// x.set(\carfreq, 100, \modfreq, 600);
// x.set(\carfreq, 100, \modfreq, 10);
// x.set(\gate, 0);