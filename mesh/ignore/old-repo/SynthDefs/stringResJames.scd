SynthDef(\stringResJames, {
| out = 0,
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

	Out.ar(out, Limiter.ar(Sanitize.ar(resonator, 0), limit, 0.01));

}).add;
