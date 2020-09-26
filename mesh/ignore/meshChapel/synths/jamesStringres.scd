// stringRes synth, Robert
SynthDef(\stringRes, {
	|out=0, len=1,
	startfreq=1, endfreq=20,

	t_gate,
	res=0.9, // for streson

	amp=0,
	att=0.2,
	dec=0.6,
	sus=1,

	attime=0.2,
	dectime=0.2,
	sustime=0.3,
	reltime=0.4

	|

	var env = Env(
		[startfreq, startfreq, endfreq],
		[0, len],
		'exp'),
	t_gate, doneAction: 0).reciprocal;



	Out.ar(out,
		Streson.ar(
			WhiteNoise.ar,
			EnvGen.kr( env, res, amp
		) * EnvGen.ar(
			Env(
				[0, 0, att, dec, sus, 0],
				[0, attime, dectime, sustime, reltime].normalizeSum * len,
				'lin'), t_gate, doneAction: 0)
	)


}, metadata:(
	\dur: 40,
	\out: Prand([0, 1, 2, 3], inf),
	\startfreq: 40,
	\endfreq: 40,
	\len: 40,
	\t_gate: 1,
	\res: 0.99,
	\amp: 0.01,
	\att: 1,
	\dec: 1,
	\sus: 1,
	\attime: 1,
	\dectime: 1,
	\sustime: 1,
	\reltime: 0.4
)).add;
