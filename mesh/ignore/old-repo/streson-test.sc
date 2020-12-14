(

SynthDef(\testEnvSynth, {|
out = 0,
attime = 0.2,
dectime = 0.2,
sustime = 0.3,
reltime = 0.4,
len = 1,
sus = 1,
dec = 1,
att = 0.2,
res = 0.9,
amp = 0.25,
startfreq = 1,
endfreq = 20,
limit = 0.1,
t_gate = 0 |

var source = WhiteNoise.ar;

var delayTimeEnv = Env.new(
	levels: [startfreq, startfreq, endfreq],
	times: [0, len],
	curve: 'exp');

var delayTimeEnvGen = EnvGen.kr(
	delayTimeEnv,
	gate: t_gate,
	doneAction: 0).reciprocal;

var ampEnv = Env(
	levels: [0, 0, att, dec, sus, 0],
	times: [0, attime, dectime, sustime, reltime].normalizeSum * len,
	curve:	'lin');

var ampEnvGen = EnvGen.ar(
	ampEnv,
	gate: t_gate,
	doneAction: 0);

var resonator = Streson.ar(
	source,
	delayTime: delayTimeEnvGen,
	res: res,
	mul: (ampEnvGen * amp));

	// Out.ar(out, Limiter.ar(Sanitize.ar(resonator, 0), limit, 0.01));
	
	Out.ar(out, resonator);

}).add;


)


s.boot

(
p = Pmono(\testEnvSynth,
    \dur, Pdefn(\srM1dur, 5, inf),
	\out, Pdefn(\srM1out, Prand([0, 1], inf)),
    \startfreq, Pdefn(\srM1startfreq, 40, inf),
    \endfreq, Pdefn(\srM1endfreq, 40, inf),
    \len, Pdefn(\srM1len, 3, inf),
    \gate, Pdefn(\srM1t_gate, 0, inf),
    \res, Pdefn(\srM1res, 0.99, inf),
    \amp, Pdefn(\srM1amp, 0.01, inf),
    \att, Pdefn(\srM1att, 0.5, inf),
    \dec, Pdefn(\srM1dec, 0.5, inf),
    \sus, Pdefn(\srM1sus, 0.5, inf),
    \attime, Pdefn(\srM1attime, 1, inf),
    \dectime, Pdefn(\srM1dectime, 1, inf),
    \sustime, Pdefn(\srM1sustime, 1, inf),
	\reltime, Pdefn(\srM1reltime, 0.5, inf)
).play;
)


Pdefn(\srM1t_gate, 1, inf)

p.stop;




(
p = Pmono(\testEnvSynth,
    \dur, Pdefn(\srM1dur, 5, inf),
	\out, Pdefn(\srM1out, Prand([0, 1], inf)),
    \startfreq, Pdefn(\srM1startfreq, 40, inf),
    \endfreq, Pdefn(\srM1endfreq, 40, inf),
    \len, Pdefn(\srM1len, 3, inf),
    \gate, Pdefn(\srM1t_gate, 1, inf),
    \res, Pdefn(\srM1res, 0.99, inf),
    \amp, Pdefn(\srM1amp, 0.01, inf),
    \att, Pdefn(\srM1att, 0.5, inf),
    \dec, Pdefn(\srM1dec, 0.5, inf),
    \sus, Pdefn(\srM1sus, 0.5, inf),
    \attime, Pdefn(\srM1attime, 1, inf),
    \dectime, Pdefn(\srM1dectime, 1, inf),
    \sustime, Pdefn(\srM1sustime, 1, inf),
	\reltime, Pdefn(\srM1reltime, 0.5, inf)
).play;
)


p.stop;
)


s.boot

p = { Streson.ar(LFSaw.ar([220, 180], 0, mul:EnvGen.kr(Env.asr(0.5, 1, 0.02), 1.0) * 0.2), LinExp.kr(LFCub.kr(0.1, 0.5*pi), -1, 1, 280, 377).reciprocal, 0.9, 0.3) }.play

p.feee

Streson.ar(input, delayTime: 0.003, res: 0.9, mul: 1, add: 0)

(

{ Streson.ar(
	LFSaw.ar(
		[220, 180],
		0,
		mul:EnvGen.kr(Env.asr(0.5, 1, 0.02), 1.0) * 0.2),
	LinExp.kr(
		LFCub.kr(0.1, 0.5*pi),
		-1,
		1,
		280,
		377
	).reciprocal,
	0.9,
	0.3
)}.play

)

s.boot

(


//LFSaw.ar(freq: 440, iphase: 0, mul: 1, add: 0)

//Env.asr(attackTime: 0.01, sustainLevel: 1, releaseTime: 1, curve: -4)
SynthDef(\testStresonExample, {|
	out = 0,
	resonance = 0.9,
	mult = 0.3 |

	var source = LFSaw.ar(
		freq: [220, 180],
		iphase: 0,
		mul: EnvGen.kr(
			Env.asr(
				attackTime: 0.5,
				sustainLevel: 1,
				releaseTime: 0.02
			),
			gate: 1.0
		) * 0.2
	);

	var delay = LinExp.kr(
		   in: LFCub.kr(
			   freq: 0.1,
			   iphase: 0.5*pi),
		   srclo: -1,
		   srchi: 1,
		   dstlo: 280,
		   dsthi: 377
	   ).reciprocal;

	var resonator = Streson.ar( source, delay, resonance, mult );

	Out.ar(out, resonator);

	}).add;

)


p = Synth(\testStresonExample);

p.free

