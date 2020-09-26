SynthDef(\formant,
	{|fund = 44,
	form = 9800,
	bw = 880,
	dur = 0.65,
	out = 0,
	amp = 1.0|
		Out.ar(out, Pan2.ar(Formant.ar(fund, form, bw)*amp))
		*
		EnvGen.ar(Env([0, 0.066, 0], [dur/2, dur/2], 0), doneAction: 2);
	},

metadata: (
		\fund: Pseq([12, 14, 12, 16, 17, 14], inf),
		\form: Pn(Pgeom(4900, 1.05914, 12)),
		\bw: Pbrown(440, 1320, 110),
		\dur: Prand([1, Pstutter(Pwhite(1, 6, 1), Pseq([0.375, 0.125])), Pstutter(Pwhite(1, 20, 1), Pn(0.1))], inf),
))

