// |	attime=0.2,
// dectime=0.2,
// sustime=0.3,
// reltime=0.4 |
//

(
SynthDef(\stringResJames, {
var attime=0.2;
var	dectime=0.2;
var	sustime=0.3;
var	reltime=0.4;
var	len=1;
var sus= 1;
var dec= 1;
var att=0.2;
var res = 0.9;
var amp = 0.25;
var startfreq=1;
var endfreq=20;
var	t_gate = 1;

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

	Out.ar(out, resonator);
}).add