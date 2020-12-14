SynthDef(\fmGrain, {|
    t_gate = 1,
	amp = 0,
	limit = 0.1,
	indexRate = 1,
	indexRangeLow = 1,
	indexRangeHi = 10,
	freq = 20,
	len = 0.2,
	carfreq = 440,
	modfreq = 200,
	panX = 0,
	panY=0|

	var env = EnvGen.kr(
		      Env([0, 0, 1, 0], [0, 1, 1], \sin, 1),
		      t_gate,
		      levelScale: amp,
		      doneAction: 0);
	var ndx = LFNoise1.kr(indexRate).range(indexRangeLow, indexRangeHi);
	var fmgr = FMGrain.ar(Impulse.ar(freq), len, carfreq, modfreq, ndx, env*amp);
	Out.ar(0, Pan4.ar(Limiter.ar(Sanitize.ar(fmgr, 0), limit, 0.01), panX, panY));
}, metadata:()
).add;