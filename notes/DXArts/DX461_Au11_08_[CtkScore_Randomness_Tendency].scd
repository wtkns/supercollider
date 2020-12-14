/* Non Real Time (NRT) and CtkScore */
/*

CtkScore collects objects to render in a NRT instance of scsynth. CtkScore DOES also run in real-time (you can 'play' them). Pretty much any CtkObject can be added to a CtkScore. 

When using CtkScore, the starttime and duration values of CtkObjects gain a huge importance... they are used to schedule AND to help calculate how long the rendered (or performed) sound needs for calculation. Adding CtkBuffers to a CtkScore will also ensure that they are added FIRST or, in the real-time case, loaded to the server before ANY synthesis takes place. 

When to use CtkScore: 
	* in work where the synthesis can NOT run in real-time.
	* for work where you want to ensure precise start and endtime work.
	* whenever a 'score' (or event listing) approach is beneficial. 
	
*/

(
var score, noteObj, grainBuffer, now, cloud;

score = CtkScore.new;

grainBuffer = CtkBuffer.env(1024, Env([0, 1, 0], [0.5, 0.5], \sin), 1);
// add it to the score! DO NOT LOAD IT!
score.add(grainBuffer);

noteObj = CtkSynthDef(\grain, {arg envBuffer, freq1, freq2, dur, amp;
	Out.ar(0, Pan2.ar(
		SinOsc.ar(XLine.kr(freq1, freq2, dur),
			0,
			Osc.ar(envBuffer, dur.reciprocal) * amp)
		)
	);
});

now = 2;

cloud = {arg startTime, cloudDur, amp, freqLow, freqHigh, grainDur, density;
	var now, thisDur, thisAmp;
	now = 0; // keeps track of how long we have been generating grains for
	if(amp.isKindOf(Env), {amp.times = amp.times.normalizeSum});
	amp.postcs;
	while({
		now < cloudDur;
	}, {
		thisDur = grainDur.value;
		thisAmp = if(amp.isKindOf(Env), 
			{amp.at(now / cloudDur).dbamp}, 
			{amp.dbamp});
		// add a note to the CtkScore - DO NOT PLAY IT!
		score.add(
			// offset by startTime
			noteObj.note(now + startTime, thisDur)
				.freq1_(freqLow.rrand(freqHigh))
				.freq2_(freqLow.rrand(freqHigh))
				.dur_(thisDur)
				.amp_(thisAmp)
				.envBuffer_(grainBuffer);
			);
		now = now + (density.reciprocal);
	})
};

cloud.value(2, 10, -48, 440, 880, 0.05, 1300);
/*
cloud.value(13, 10, Env([-90, -24, -90], [0.1, 0.9]), 440, 880, 0.05, 1300);
cloud.value(2, 20, Env([-90, -24, -90], [0.6, 0.4]), 4400, 8800, {2.0.rrand(4.0)}, 13);
*/

score.write("~/Desktop/test.aif".standardizePath, options: 
	ServerOptions.new.numOutputBusChannels_(2))
)


/* Randomness - lang and server side representations */

// there are a number of random methods inside the language:

10.rand; 				// returns ran integers between 0 an 10
10.0.rand;				// float between 0.0 and 10.0
10.rrand(20); 		// ints between 10 and 20
10.0.rrand(20.0); 	// floats (you get the idea)
10.0.rand2; 			// between -10.0 and 10.0

10.rand;
rand(10);
10.rrand(20);
rrand(10, 20);


(
a = 0;
100000.do({a = a + 1.0.rand});
a * 0.00001;
)

10.0.rand2 + 440;

// same results???

430.rrand(450);

10.0.linrand; 		// between 0.0 and 10.0, with decreasing linear prob from 0 to 10
10.0.bilinrand;		// between -10.0 and 10.0, prob highest at 0.0
10.0.sum3rand;		// between -10.0 and 10.0, prob highest at 0.0, bell-like distribution
10.0.sum3rand + 440;	// move into a different range
0.001.exprand(1.0);	// between 0.001 and 1.0, exponential dist, no values of 0 (or 0 crossing)
0.5.coin;				// a 50/50 coin toss
0.9.coin;				// a 90/10 coin toss

/* exprand mean of 1000 samples */
a = 0;
1000.do({a = a + 0.001.exprand(1.0)});
a/1000; // about 0.145

(
var note, score;
score = CtkScore.new;
/* Don't do this */
note = CtkSynthDef(\sin, {
	Out.ar(0, SinOsc.ar(440.rrand(880), 0, XLine.kr(1, 0.0001, 0.2)))
	});
	
10.do({arg i;
	score.add(note.note(i * 0.1 + 1, 0.2));
	});
	
score.play;
)

(
var note, score;
score = CtkScore.new;
/* Do this */
note = CtkSynthDef(\sin, {arg freq = 440;
	Out.ar(0, SinOsc.ar(freq, 0, XLine.kr(1, 0.0001, 0.2)))
	});	

	
10.do({arg i;
	score.add(note.note(i * 0.1 + 1, 0.2).freq_(440.rrand(880)));
	});

score.play;
)

// seeding the randomness. I HIGHLY suggest you do this
(
var seed;
seed = 1234; // can be pretty much any integer
thisThread.randSeed_(seed); 

10.do({
	1000.rand.postln;
	})
)

(
var note, score;

thisThread.randSeed_(1234); 

score = CtkScore.new;

note = CtkSynthDef(\sin, {arg freq = 440;
	Out.ar(0, SinOsc.ar(freq, 0, XLine.kr(1, 0.0001, 0.2)))
	});	
	
10.do({arg i;
	score.add(note.note(i * 0.1 + 1, 0.2).freq_(440.rrand(880)));
	});

score.play;
)

(
var note, score;

thisThread.randSeed_(1234); 

score = CtkScore.new;

note = CtkSynthDef(\sin, {arg freq = 440;
	Out.ar(0, SinOsc.ar(freq, 0, XLine.kr(1, 0.0001, 0.2)))
	});	
	
10.do({arg i;
	score.add(note.note(i * 0.1 + 1, 0.2).freq_(440.rrand(880)));
	});
	
thisThread.randSeed_(1234); 

10.do({arg i;
	score.add(note.note(i * 0.1 + 3, 0.2).freq_(440.rrand(880)));
	});
	
score.play;
)

(
var note, score;

score = CtkScore.new;

note = CtkSynthDef(\sin, {arg freq = 440, pan = 0;
	Out.ar(0, Pan2.ar(
		SinOsc.ar(freq, 0, XLine.kr(1, 0.0001, 0.2)), pan))
	});	

5.do({arg offset;
	// reset the seed every time we turn the loop!
	thisThread.randSeed_(1234); 
	
	10.do({arg i;
		score.add(note.note(i * 0.1 + offset, 0.2)
			// notice freq is different then above! Because we now make
			// more calls to the random number generator with the pan args
			.freq_(440.rrand(880))
			.pan_(0.707.rand2)); // between mid left and mid right
		});
	});
		
score.play;
)

(
// random seeding isn't really predictable. If you like some values, but
// not others... you can't 'nudge' the seed.

thisThread.randSeed_(1234);

10.do({
	10.rand.postln;
	});
	
"New set of values!".postln;

thisThread.randSeed_(1233);
10.do({
	10.rand.postln;
	});
)

// Arrays also have random methods
a = Array.rand(10, 0.0, 10.0); // 10 values between 0.0 and 10.0
// there are also exprand, rand2 and linrand methods

// randomly pick a value from an Array
a.choose;

// weighted choose
a.wchoose([0.91, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]);

a = a.scramble; // random re-order of the Array

// Audio rate noise UGens:

a = {WhiteNoise.ar(0.4)}.play(s); 	// Random distribution values +- mul
a.free;
a = {PinkNoise.ar(0.4)}.play(s); 	// 8 octaves. higher spectrum is weaker
a.free;
a = {GrayNoise.ar(0.4)}.play(s);	// "randomly flipped bits" of a word.
a.free;
a = {BrownNoise.ar(0.4)}.play(s);	// "Brownian" noise
a.free;
a = {ClipNoise.ar(0.4)}.play(s);	// generates only two values, +-mul
a.free;

// Interpolated Noises - Non band limited - freq to produce new values
a = {LFNoise0.ar(1000, 0.4)}.play(s);	// sample and hold
a.free;
a = {LFNoise1.ar(1000, 0.4)}.play(s);	// linear interpolated noise
a.free;
a = {LFNoise2.ar(1000, 0.4)}.play(s);	// quadratic interpolated noise
a.free;

// Modulated noise can create 'bands' of noise around the modulating
// frequency. Here - simple Ring Mod of linear interp noise

a = {LFNoise1.ar(MouseY.kr(4, 1000), 0.5) * 
	SinOsc.ar(MouseX.kr(200, 2000), 0, 0.3)}.play(s);
a.free;

a = {Dust.ar(10, 0.4)}.play(s); // density of random impulses (0 to mul)
a.free;
a = {Dust2.ar(100, 0.4)}.play(s);	// density of random impulses from +-mul 
a.free;

// chaos noise
a = {Crackle.ar(MouseX.kr(0.99, 2.01), 0.4)}.play(s);
a.free;

// The LF UGens are particularly useful for controlling parameters at a 
// 'Low Frequency'
a = {SinOsc.ar(LFNoise2.ar(1).range(220, 440), 0, 0.2)}.play(s);
a.free;

(
var note, score;
score = CtkScore.new;

note = CtkSynthDef(\rantwo, {arg dur = 0.2;
		var env, src;
		env = EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], \sin), timeScale: dur);
		src = SinOsc.ar(Rand.new(440.0, 880.0), 0, 0.2); // the Rand UGen
		Out.ar(0, Pan2.ar(src * env, 0));
		});	

10.do({arg i;
	// get a new random freq with each note
	score.add(note.note(i * 0.1 + 1, 0.2));
	});
	
score.play;
)
	
// IRand.new(lo, hi) 	// produces random integers
// NRand.new(lo, hi, n)	// produces a single ran value from a sum of n ran numbers. 
// 		Hi n = gaussian
// ExpRand.new(lo, hi) 	// exponential dist between lo and hi

// random seed in a SynthDef

// also, TIRand, TExpRand
// randomness on the Server can also be seeded:
a = CtkSynthDef(\seedrand, {arg dur = 1, seed = 100, id = 1, pan = 0;
		var env, src, freq, loc;
		RandID.kr(id);
		RandSeed.kr(1, seed);
		env = EnvGen.kr(
			Env([0, 1, 0], [0.5, 0.5], \sin), 
			timeScale: dur);
		freq = TRand.kr(440.0, 880.0, Dust.kr(1));
		loc = LFNoise1.ar(1);
		src = SinOsc.ar(freq, 0, 0.2);
		Out.ar(0, Pan2.ar(src * env, pan));
		});

a.note(1.0, 4.0).id_(1).dur_(4.0).play;	

(
a.note(1, 4).dur_(4).seed_(100).pan_(-0.5).play;
a.note(2, 4).dur_(4).seed_(100).pan_(0.5).play;
)
// to generate random values from 2 different synths at the same time, 
// give them unique ids and the same seed
(
a.note(1, 4).id_(1).dur_(4).seed_(100).pan_(-0.5).play;
a.note(2, 4).id_(2).dur_(4).seed_(100).pan_(0.5).play;
)


// Env.at

a = Env([880, 220], [1], \sin);
a.plot
a.at(0.5);
a.at(1.0);
a.at(2.0);
a[0.2];

a = Env([880, 220], [1]);
b = Env([220, 220], [1]);

t = 1;
a[t];

(a.at(t)).rrand(b.at(t));

z = 100;
b = z.collect({arg i; i = i / z; (a.at(i)).rrand(b.at(i)).postln});
b.plot(minval: 0, maxval: 1000, discrete: true);


z = 100; // number of values to collect into an Array

a = Tendency.new(880, 220);
a[0.5]
b = z.collect({arg i; i = i / z; a.at(i)});
b.plot(minval: 0, maxval: 1000, discrete: true);

a = Tendency.new(Env([880, 220, 880], [0.5, 0.5]), 220);

b = z.collect({arg i; i = i / z; a.at(i)});
b.plot(minval: 0, maxval: 1000, discrete: true);
thisThread.randSeed_(1234);
a = Tendency.new(
	Env([880, 220, 880], [0.5, 0.5]), 
	Env([780, 220, 110], [0.5, 0.5])
	);

b = z.collect({arg i; i = i / z; a.at(i)});
b.plot(minval: 0, maxval: 1000, discrete: true);

(
var singrain;
var score, periodic;

thisThread.randSeed_(1234);

score = CtkScore.new;

singrain = CtkSynthDef(\singraina, {arg dur = 1, amp = -3, freq = 440;
	var env, halfdur, car;
	halfdur = dur * 0.5;
	amp = amp.dbamp;
	env = EnvGen.kr(Env([0, amp, 0], [halfdur, halfdur], \sin));
	car = SinOsc.ar(freq, 0, 1);
	OffsetOut.ar(0, Pan2.ar(car * env, 0));
	});

// creates sinusoidal periodic grains
periodic = {arg starttime, duration, grainPeriod, grainMaxFreq = 500, grainMinFreq = 400, 
		grainAmp = 0;
	var now, n, freq, noteFreq, noteAmp, rDuration;
	now = 0.0;
	rDuration = 1 / duration; // the reciprocal of durations
	freq = Tendency(grainMinFreq, grainMaxFreq);
	while({
		// 'n' will tell us how far we are into the function, 
		//	percentage wise. This let's envelopes
		// have values between 0 and 1 for the durations
		n = now * rDuration;
		noteFreq = freq.at(n);
		// check and see if grainAmp is an Env... if it is, call .at(n)
		noteAmp = grainAmp.isKindOf(Env).if({
			grainAmp.at(n)
			}, {
			grainAmp
			});
		score.add(singrain.note(now + starttime, grainPeriod)
			.dur_(grainPeriod).freq_(noteFreq)
			.amp_(noteAmp));
		now = now + grainPeriod;
		(now < duration)
		})
	};

// low density - 10 grains per second
/*
periodic.value(1.0, 9.0, 1/10);
*/
// 100 hz fundamental, fromant sweep
/*
periodic.value(1.0, 9.0, 1/100, 
	grainMaxFreq: Env([1000, 609, 1000], [0.5, 0.5]), 
	grainMinFreq: Env([1000, 609, 1000], [0.5, 0.5]));
*/
// the vowel 'A' with five formants

periodic.value(1.0, 5.0, 1/100, 609, 609, 
	Env([-60, -6, -6, -60], [0.3, 0.4, 0.3]));
periodic.value(1.0, 5.0, 1/100, 1000, 1000, 
	Env([-60, -12, -12, -60], [0.3, 0.4, 0.3]));
periodic.value(1.0, 5.0, 1/100, 2450, 2450, 
	Env([-60, -18, -18, -60], [0.3, 0.4, 0.3]));
periodic.value(1.0, 5.0, 1/100, 2700, 2700, 
	Env([-60, -17, -17, -60], [0.3, 0.4, 0.3]));
periodic.value(1.0, 5.0, 1/100, 3240, 3240, 
	Env([-60, -30, -30, -60], [0.3, 0.4, 0.3]));


score.write("~/Desktop/test.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2));

score.play;
)

a = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui;


(
var singrain, fmgrain;
var score, grains;

thisThread.randSeed_(1234);

score = CtkScore.new;

singrain = CtkSynthDef(\singraina, {arg dur = 1, amp = -3, freq = 440;
	var env, halfdur, car;
	halfdur = dur * 0.5;
	amp = amp.dbamp;
	env = EnvGen.kr(Env([0, amp, 0], [halfdur, halfdur], \sin));
	car = SinOsc.ar(freq, 0, 1);
	OffsetOut.ar(0, Pan2.ar(car * env, 0));
	});

fmgrain = CtkSynthDef(\fmgraina, {arg dur = 1, amp = -3, carfreq = 440, modfreq = 220, dev = 1;
	var env, halfdur, mod, car;
	halfdur = dur * 0.5;
	amp = amp.dbamp;
	dev = dev * modfreq;
	env = EnvGen.ar(
		Env([0, amp, 0], [halfdur, halfdur], \sin));
	mod = SinOsc.ar(modfreq, 0, dev);
	car = SinOsc.ar(carfreq + mod, 0, 1);
	OffsetOut.ar(0, Pan2.ar(car * env, 0));
	});
	
// creates sinusoidal or fm grains - periodic or not (depending on the parameters passed in)

grains = {arg starttime, duration, grainAmp = -24, grainDur = 0.1, 
		maxDensity = 10, minDensity = 10, grainMaxFreq = 500, 
		grainMinFreq = 400, modFreqRatio, modIndex;
	var now, n, freq, density, dur, rDuration, noteDur, noteFreq, 
		noteAmp, thisDensity, modFreq, idx;
	now = 0.0;
	rDuration = duration.reciprocal;
	freq = Tendency(grainMinFreq, grainMaxFreq);
	density = Tendency(minDensity, maxDensity);
	while({
		n = now * rDuration;
		noteFreq = freq.at(n);
		thisDensity = density.at(n);
		// check if grainDur is an Env - if it is, call .at(n). 
		// Otherwise, call .value(n). This lets grainDur be an Env, 
		// Number OR a function that can use 'n' as an arg.
		noteDur = grainDur.isKindOf(Env).if({
			grainDur.at(n)
			}, {
			grainDur.value(n);
			});
		noteAmp = grainAmp.isKindOf(Env).if({
			grainAmp.at(n)
			}, {
			grainAmp.value(n);
			});
		// check what kind of note we are creating. If modFreqRatio AND 
		// modIndex are both values, create FM note
		(modFreqRatio.notNil and: {modIndex.notNil}).if({
			modFreq = modFreqRatio.isKindOf(Env).if({
				modFreqRatio.at(n);
				}, {
				modFreqRatio.value(n);
				});
			idx = modIndex.isKindOf(Env).if({
				modIndex.at(n);
				}, {
				modIndex.value(n);
				});
			score.add(
				fmgrain.note(now + starttime, noteDur).dur_(noteDur)
					.amp_(noteAmp).carfreq_(noteFreq)
					.modfreq_(noteFreq * modFreq).dev_(idx));
			}, {
			score.add(
				singrain.note(now + starttime, noteDur).dur_(noteDur)
					.amp_(noteAmp).freq_(noteFreq).amp_(noteAmp))
			});
		// divide the noteDur by thisDensity to create overlapping events.
		now = now + (noteDur / thisDensity);
		now < duration;
		})
	};

// 100 grains per second (density of 10, grain size of 0.1)

grains.value(1.0, 9.0);


// chaning grain duraiton over time
/*
grains.value(1.0, 9.0, grainDur: Env([0.01, 0.5, 0.01], [0.5, 0.5]));
*/

// changing density over time
/*
grains.value(1.0, 9.0, maxDensity: Env([1, 10, 1], [0.5, 0.5]), 
	minDensity: Env([1, 10, 1], [0.5, 0.5]));
*/
// longer grains, enhancing a band between 1000 and 1500
/*
grains.value(1.0, 9.0, grainDur: Env([0.1, 0.2, 0.1], [0.5, 0.5]),
	maxDensity: Env([200, 200, 700, 700], [0.3, 0.4, 0.3]),
	minDensity: Env([100, 100, 500, 500], [0.3, 0.4, 0.3]),
	grainMaxFreq: 1500,
	grainMinFreq: 1000,
	grainAmp: Env([-60, -30, -30, -60], [0.3, 0.4, 0.3]));
*/
// FM grains
/*
grains.value(1.0, 9.0, grainDur: Env([0.01, 0.1, 0.01], [0.5, 0.5]), modFreqRatio: 1.6666, 
	modIndex: 1.0);
*/
// changing index over time
/*
grains.value(1.0, 9.0, grainDur: 0.1, modFreqRatio: 1.6666, modIndex: Env([1, 4, 1], [0.5, 0.5]));
*/
// changing index and modfreq over time
/*
grains.value(1.0, 9.0, grainDur: 0.1, modFreqRatio: Env([1.6666, 4.0, 1.666], [0.5, 0.5]), 
	modIndex: Env([1, 4, 1], [0.5, 0.5]));
*/
// changing index, modfreq, density and grainamp over time
/*
grains.value(1.0, 9.0, grainDur: 0.1, 
	modFreqRatio: Env([1.6666, 4.0, 1.666], [0.5, 0.5]), 
	modIndex: Env([1, 4, 1], [0.5, 0.5]),
	maxDensity: Env([200, 20, 200], [0.5, 0.5]),	
	minDensity: Env([200, 20, 200], [0.5, 0.5]),
	grainMaxFreq: 300,
	grainMinFreq: 200,
	grainAmp: Env([-60, -24, -60], [0.5, 0.5])
	);
*/

// score.play;
score.write("~/Desktop/test.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2));

)

a = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui;


(
Server.default = s = Server.internal.boot;
s.waitForBoot({
	s.scope
	})
)
(
var note, score;

score = CtkScore.new;

note = CtkSynthDef(\periodic, {arg duration, grainPeriod, grainMinFreq, grainMaxFreq, grainAmp, 
		id = 1, seed = 123;
	var grains, env, freq, trigger;
	RandID.kr(id);
	RandSeed.kr(seed);
	env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
	// grains are produced with a trigger signal. This can be any UGen that changes from
	// <=0 to > 0. Impulse works well for this. If Impulse is used at 'ar', then Grain onsets
	// will be sample accurate. The reciporcal of our grain's duration is the freq we want
	trigger = Impulse.ar(grainPeriod.reciprocal);
	// to imitate a Tendency mask - we can use TRand, polling for a new random value
	// with every trigger.
	freq = TRand.ar(grainMinFreq, grainMaxFreq, trigger);
	// finally, the grains. The arguments to the UGen are polled whenever a trigger occurs, 
	// so you can use a number of different UGens to control the synth
	grains = SinGrain.ar(trigger, grainPeriod, freq, grainAmp);
	Out.ar(0, Pan2.ar(grains * env), 0);
	});
	
score.add(
	note.new(1.0, 4.0).duration_(4.0).grainPeriod_(0.01).grainMinFreq_(400).grainMaxFreq_(5000)
		.grainAmp_(-12.dbamp));
		
score.play;
)

/* "BUT!" you may ask... "How do I get the flexibility I want with the Tendency mask?" ... excellent question. 
Introducing CtkControl.env
This can be used for any parameter to a synth
*/

(
var note, score;

score = CtkScore.new;

note = CtkSynthDef(\periodic, {arg duration, grainPeriod, grainMinFreq, grainMaxFreq, grainAmp, 
		id = 1, seed = 123;
	var grains, env, freq, trigger;
	RandID.kr(id);
	RandSeed.kr(seed);
//	env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
	trigger = Impulse.ar(grainPeriod.reciprocal);
	freq = TRand.ar(grainMinFreq, grainMaxFreq, trigger);
	grains = GrainSin.ar(2, trigger, grainPeriod, freq, mul: grainAmp);
	Out.ar(0, grains);
	});
	
score.add(
	note.new(1.0, 4.0).duration_(4.0).grainPeriod_(0.005)
		.grainMinFreq_(CtkControl.env(Env([400, 800, 800], [0.5, 0.5], \exp), timeScale: 4))
		.grainMaxFreq_(CtkControl.env(Env([900, 800, 900], [0.5, 0.5], \exp), timeScale: 4))
		.grainAmp_(CtkControl.env(Env([0.0001, 1, 1, 0.0001], [0.1, 0.8, 0.1], \exp), timeScale: 4)));
		
score.play;
)

(
var note, score;

score = CtkScore.new;

note = CtkSynthDef(\periodic, {arg duration, grainPeriod, grainMinFreq, grainMaxFreq, grainAmp, 
		id = 1, seed = 123;
	var grains, env, freq, trigger, pan;
	RandID.kr(id);
	RandSeed.kr(seed);
	env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
	trigger = Impulse.ar(grainPeriod.reciprocal);
	freq = TRand.ar(grainMinFreq, grainMaxFreq, trigger);
	pan = TRand.ar(-1, 1, trigger) * Line.kr(1, 0, duration * 0.5);
	// first argument here is number of outputs. Use the 'pan' parameter
	grains = GrainSin.ar(2, trigger, grainPeriod, freq, pan, mul: grainAmp);
	Out.ar(0, grains * env);
	});
	
score.add(
	note.new(1.0, 4.0).duration_(4.0).grainPeriod_(0.02)
		.grainMinFreq_(CtkControl.env(Env([200, 500, 400], [0.5, 0.5], \exp), timeScale: 4))
		.grainMaxFreq_(CtkControl.env(Env([300, 500, 900], [0.5, 0.5], \exp), timeScale: 4))
		.grainAmp_(-12.dbamp));
		
score.play;
)

// BUT - the panning isn't very clear. Let's give each grain a sharper envelope

(
var note, score, buffer;

a = score = CtkScore.new;

buffer = CtkBuffer.new(size: 512);
// there is a bug CtkScore... make sure you give this a time of 0.1... ergh
buffer.fillWithEnv(0.1, env: Env([0, 1, 0], [0.1, 0.9], [10, -10]));

score.add(buffer);

note = CtkSynthDef(\periodic, {arg duration, grainPeriod, grainMinFreq, grainMaxFreq, grainAmp, 
		id = 1, seed = 123, envbuf;
	var grains, env, freq, trigger, pan;
	RandID.kr(id);
	RandSeed.kr(seed);
	env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
	trigger = Impulse.ar(grainPeriod.reciprocal);
	freq = TRand.ar(grainMinFreq, grainMaxFreq, trigger);
	pan = TRand.ar(-1, 1, trigger) * Line.kr(1, 0, duration * 0.5);
	// first argument here is number of outputs. 
	grains = GrainSin.ar(2, trigger, grainPeriod, freq, pan, envbuf, mul: grainAmp);
	Out.ar(0, grains * env);
	});
	
score.add(
	note.new(0.1, 4.0).duration_(4.0).grainPeriod_(0.01)
		.grainMinFreq_(CtkControl.env(Env([200, 500, 400], [0.5, 0.5], \exp), timeScale: 4))
		.grainMaxFreq_(CtkControl.env(Env([300, 500, 900], [0.5, 0.5], \exp), timeScale: 4))
		.grainAmp_(-12.dbamp)
		.envbuf_(buffer));

score.play;
)


/* the FM Synth-O-Matic */

(
var note, score, buffer, thisnote;

a = score = CtkScore.new;
// There is now just a CtkBuffer.env creation method
buffer = CtkBuffer.env(size: 512, env:Env([0, 1, 0], [0.1, 0.9], [10, -10]));
//buffer.fillWithEnv(env: Env([0, 1, 0], [0.1, 0.9], [10, -10]));

score.add(buffer);

note = CtkSynthDef(\periodic, {arg duration, grainPeriod, grainMinFreq, grainMaxFreq, grainAmp, 
		id = 1, seed = 123, envbuf = -1;
	var grains, env, freq, trigger, pan;
	RandID.kr(id);
	RandSeed.kr(seed);
	env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
	// create overlaps
	trigger = Impulse.ar(grainPeriod.reciprocal * 4);
	freq = TRand.ar(grainMinFreq, grainMaxFreq, trigger);
	pan = TRand.ar(-1, 1, trigger) * Line.kr(1, 0, duration * 0.5);
	// first argument here is number of outputs. 
	grains = GrainFM.ar(2, trigger, grainPeriod, freq, freq * 0.77, LFNoise1.kr.range(4, 10),
		pan, envbuf, mul: grainAmp);
	Out.ar(0, grains * env);
	});
	

thisnote = note.new(1.0, 20.0).duration_(20.0).grainPeriod_(0.1)
	.grainMinFreq_(CtkControl.env(Env([400, 500, 400], [0.5, 0.5], \exp), timeScale: 20))
	.grainMaxFreq_(CtkControl.env(Env([900, 500, 900], [0.5, 0.5], \exp), timeScale: 20))
	.grainAmp_(-12.dbamp);

// also - you can schedule parameter changes!
// give the change, followed by the time AFTER the note starts that you want the change to happen
thisnote.envbuf_(buffer, 10);
thisnote.envbuf_(-1, 15);

score.add(thisnote);
score.play;
)
 