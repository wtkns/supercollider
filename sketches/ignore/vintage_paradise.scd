//ultimate vintage paradise

(

Server.default = s = Server.internal;

s.waitForBoot({

var sample, player, func, dur;
var delayGrainulator, grains, primary, baselayer1, baselayer2, baselayer3, baselayer4;
var globalamp;

globalamp = 3;

sample = CtkBuffer("/Users/jameswatkins/samp/summerstart1.wav").load(sync: true);

grains =    CtkBuffer("/Users/jameswatkins/samp/crush.wav").load(sync: true);

player = CtkSynthDef(\playing, {arg bufnumb, rate = 1, ampenv, pan = 0;
	var playback, output, lowpass, highpass;
	playback = PlayBuf.ar(1, bufnumb, rate, loop:1);
	//lowpass filter
	playback = LPF.ar(playback, 400, 8);
	//highpass filter
	playback = HPF.ar(playback, 2000, 8);
	//bandpass filter
	playback = BPF.ar(playback, 500, 0.5, 8);
	//compressor
	playback = Compander.ar(playback, playback,
		thresh: 0.5,
		slopeBelow: 1,
		slopeAbove: 0.25,
		clampTime: 0.002,
		relaxTime: 0.01);
	output = playback * ampenv.dbamp;
	Out.ar(0, Pan2.ar(output, pan));
});

delayGrainulator = CtkSynthDef(\dgrain, {arg buffer, dust, ampenv, grainsize, roomsize = 30, pan = 0, rate = 1, outbus = 1;
	var src, delay, reverb, output;
	src = GrainBuf.ar(1, Dust.kr(dust), grainsize, buffer, rate, LFNoise2.kr(0.1).range(0, 1), 1, 0);
	delay = DelayN.ar(src, 1.0, WhiteNoise.ar.abs);
	delay = LPF.ar(delay, 400, 8);
	//highpass filter
	delay = HPF.ar(delay, 2000, 8);
	//bandpass filter
	delay = BPF.ar(delay, 500, 0.5, 8);
	//compressor
	delay = Compander.ar(delay, delay,
	thresh: 0.5,
		slopeBelow: 1,
		slopeAbove: 0.25,
		clampTime: 0.002,
		relaxTime: 0.01);
	reverb = GVerb.ar(delay, roomsize, revtime: 0.5, damping: 0.61, inputbw: 0.34, spread: 15, drylevel: -2.5, maxroomsize: roomsize + 1);
	output = reverb;
	output = output * (ampenv.dbamp * globalamp);
	Out.ar(0, Pan2.ar(output, pan));
});

dur = 60;

func = player.note(duration: dur)
	.bufnumb_(sample)
	.ampenv_(CtkControl.env(Env([-100, -25, -25, -25, -100], [0.01, 0.49, 0.49, 0.01].normalizeSum, \sin), timeScale: dur))
	.play;
	//wait for compressor
	1.2.wait;

primary = delayGrainulator.note(duration: dur)
	.buffer_(grains)
	.dust_(1.6)
	.ampenv_(CtkControl.env(Env([-100, -20, -20, -20, -100], [0.01, 0.49, 0.49, 0.01].normalizeSum, \sin), timeScale: dur))
	.grainsize_(0.01)
	.pan_(CtkControl.env(Env([0, -0.2, 0.2, 0], [1, 1, 1].normalizeSum, \lin), timeScale: dur))
	.play;

baselayer1 = delayGrainulator.note(duration: dur)
	.buffer_(grains)
	.dust_(10)
	.ampenv_(CtkControl.env(Env([-100, -35, -35, -35, -100], [0.01, 0.49, 0.49, 0.01].normalizeSum, \sin), timeScale: dur))
	.grainsize_(0.01)
	.pan_(0.15)
	.play;

baselayer2 = delayGrainulator.note(duration: dur)
	.buffer_(grains)
	.dust_(10)
	.ampenv_(CtkControl.env(Env([-100, -35, -35, -35, -100], [0.01, 0.49, 0.49, 0.01].normalizeSum, \sin), timeScale: dur))
	.grainsize_(0.01)
	.pan_(-0.15)
	.play;

baselayer3 = delayGrainulator.note(duration: dur)
	.buffer_(grains)
	.dust_(5)
	.ampenv_(CtkControl.env(Env([-100, -35, -35, -35, -100], [0.01, 0.49, 0.49, 0.01].normalizeSum, \sin), timeScale: dur))
	.grainsize_(0.005)
	.pan_(0.75)
	.play;

baselayer4 = delayGrainulator.note(duration: dur)
	.buffer_(grains)
	.dust_(5)
	.ampenv_(CtkControl.env(Env([-100, -35, -35, -35, -100], [0.01, 0.49, 0.49, 0.01].normalizeSum, \sin), timeScale: dur))
	.grainsize_(0.005)
	.pan_(-0.75)
	.play;


})
)