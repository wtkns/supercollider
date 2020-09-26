/*

Intro to Filters. FIR (Finite Impulse Response) examples

*/

Server.default = s = Server.internal.boot;
f = FreqScope.new;
g = s.scope;

a = CtkSynthDef(\singleSampleFIR, {arg dur, amp, a0, a1;
	var src, del, env, out;
	src = WhiteNoise.ar(amp.dbamp);
	del = Delay1.ar(src);
	out = (src * a0) + (del * a1);
	Out.ar(0, out);
	});
	
// first, just the source

a.note(0.0, 3).dur_(3).amp_(-3).a0_(1).a1_(0).play;

// next, acting as a lowpass filter
// 6dB/oct. rolloff up to SR/2

a.note(0.0, 3).dur_(3).amp_(-3).a0_(0.5).a1_(0.5).play;

// inverting the delay with a negative coefficient creates a highpass effect
// 6dB/oct. rolloff down to 0Hz
a.note(0.0, 3).dur_(3).amp_(-3).a0_(0.5).a1_(-0.5).play;

/* \twoSampleFIR uses a two sample delay */

a = CtkSynthDef(\twoSampleFIR, {arg dur, amp, a0, a1;
	var src, del, env, out;
	env = Line.kr(1, 1, dur, doneAction: 2);
	src = WhiteNoise.ar(amp.dbamp);
	del = Delay2.ar(src);
	out = (src * a0) + (del * a1);
	Out.ar(0, out * env);
	});
	
// band reject (notch @ SR/4, 6dB/oct. rolloff)
a.note(0.0, 3).dur_(3).amp_(-3).a0_(0.5).a1_(0.5).play;


// band pass (peak @ SR/4, 6dB/oct. rolloff)
a.note(0.0, 3).dur_(3).amp_(-3).a0_(0.5).a1_(-0.5).play;

/*

Another sound source - the pluse train / buzz / blip

Like noise - the spectrum of these sounds can be very rich - however, since they are made up of harmonic sounds, you can also predict where there will be peaks in the spectrum.

*/

a = CtkSynthDef(\pulsetrain, {arg dur, freq, amp;
	var env, pulse, numharms;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	// by baseing the number of harmonics on the Nyquist, the signal will be 
	// band-limited.
	numharms = (SampleRate.ir * 0.4) / freq;
	// Numharms should be an integer. .floor will truncate the value of numharms.
	pulse = Blip.ar(freq, numharms.floor, amp.dbamp);
	Out.ar(0, pulse * env);
	});

a.note(0.0, 5.0).dur_(5.0).freq_(200).amp_(-12).play;

a.note(0.0, 5.0).dur_(5.0).freq_(CtkControl.env(Env([200, 5], [5], \exp))).amp_(-12).play

a = CtkSynthDef(\pulsetrainTwo, {arg dur, freq, amp, numharms;
	var env, pulse;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin),
		doneAction: 2);
	// Numharms should be an integer. .floor will truncate the value of numharms.
	pulse = Blip.ar(freq, numharms, amp.dbamp);
	Out.ar(0, pulse * env);
	});


a.note(0.0,2.0).dur_(2.0).freq_(400).amp_(-12).numharms_(1).play;

a.note(0.0,2.0).dur_(2.0).freq_(400).amp_(-12).numharms_(3).play;

a.note(0.0,2.0).dur_(2.0).freq_(400).amp_(-12).numharms_(7).play;

a.note(0.0,2.0).dur_(2.0).freq_(400).amp_(-12).numharms_(17).play;

a.note(0.0,2.0).dur_(2.0).freq_(400).amp_(-12).numharms_(45).play;

/* The Resonz filter - an Infinite Impulse Response filter (uses feedback in the algorithm multi-channel expansion, mixing */

a = CtkSynthDef(\resonz, {arg dur, freq, amp;
	var env, pulse, numharms, bw, reson, bal;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	numharms = (SampleRate.ir * 0.4) / freq;
	// a pulse generator
	pulse = Blip.ar(freq, numharms.floor, amp.dbamp);
	// in EnvGen, timeScale will scale the time values in the envelope.
	// if these values are percentages, this can be a useful way to alter
	// envelopes based on a notes duration.  bw will control the bandwidth
	bw = EnvGen.kr(
		Env([10000, 10000, 1, 1], [0.2, 0.6, 0.2]), 
		timeScale: dur);
	// Resonz.ar(arg in, freq, rq, mul, add);
	// rq is the reciprocal of q, or bandwidth / centerfreq.
	// Resonz is a two pole filter that is effetively a resonant 
	// band pass filter
	reson = Resonz.ar(pulse, freq, (bw / freq));
	reson = Balance.ar(reson, pulse, 20);
	Out.ar(0, reson * env);
	});



a.note(0.0, 5.0).dur_(5.0).freq_(440).amp_(-3).play;

a = CtkSynthDef(\resonz2, {arg dur, freq, amp;
	var env, pulse, numharms, cf, reson, bal;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	numharms = (SampleRate.ir * 0.4) / freq;
	// a pulse generator
	pulse = Blip.ar(freq, numharms.floor, amp.dbamp);
	// leveScale will scale the values in the level array. 
	// So, the output of this
	// evnvelope will start at 4 * freq, and will move to 5 * freq 
	// over 0.2 * dur in time.
	cf = EnvGen.kr(
		Env([4, 5, 1, 2], [0.2, 0.7, 0.1]), 
		levelScale: freq, timeScale: dur);
	// bw is always 1% of the cf.  This can be plugged straight into the 
	// rq argument since:
	// (0.01 * cf) / cf = 0.01
	reson = Resonz.ar(pulse, cf, 0.01, 1);
	// Here, the balance greatly affects the output! Try both;
//	reson = Balance.ar(reson, pulse, 50);
	Out.ar(0, reson * env);
	});
	

a.note(0.0, 5.0).dur_(5.0).freq_(440).amp_(12).play;


a = CtkSynthDef(\resonz3, {arg dur, freq, amp;
	var env, src, numharms, bw, reson, bal;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	// a WhiteNoise gen
	src = WhiteNoise.ar(amp.dbamp);
	bw = EnvGen.kr(
		Env([10000, 10000, 1, 1], [0.2, 0.4, 0.4]), 
		timeScale: dur);
	reson = Resonz.ar(src, freq, (bw / freq)) * (freq / bw);
//	reson = Balance.ar(reson, src, 20);
	Out.ar(0, reson * env);
	});

a.note(0.0, 5.0).dur_(5.0).freq_(440).amp_(-18).play;


a = CtkSynthDef(\resonz4, {arg dur, freq, amp;
	var env, src, numharms, cf, reson;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	// Noise
	src = WhiteNoise.ar(amp.dbamp);
	cf = EnvGen.kr(
		Env([4, 5, 1, 2], [0.2, 0.7, 0.1]), 
		levelScale: freq, timeScale: dur);
	// bw is fixed at 50Hz
	reson = Resonz.ar(src, cf, 5.0 / cf, 1);
	Out.ar(0, reson * env);
	});

a.note(0.0, 5.0).dur_(5.0).freq_(440).amp_(6).play;

// multi channel expansion, .sum and banks of filters

a = CtkSynthDef(\resonz5, {arg dur, basefreq, amp;
	var env, src, freqs, reson;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	// Noise
	src = WhiteNoise.ar(amp.dbamp);
	// this creates an array of 6 members
	freqs = basefreq * [1, 2.1, 3.9, 4.1, 7, 8];
	// this will create a 6 channel output, based on the six channel array
	reson = Resonz.ar(src, freqs, 1 / freqs, [0.2, 0.1, 0.5, 0.1, 0.05, 0.5]);
	// .sum will mix everything in that array down to a single channel
	Out.ar(0, reson.sum * env);
	});

a.note(0.0, 5.0).dur_(5.0).basefreq_(440).amp_(12).play;

a = CtkSynthDef(\resonz6, {arg dur, basefreq, amp;
	var env, src, freqs, reson;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	// Noise
	src = WhiteNoise.ar(amp.dbamp);
	// this creates an array of 6 members
	freqs = basefreq * Array.fill(6, {IRand.new(1, 200)});
	// this will create a 6 channel output, based on the six channel array
	reson = Resonz.ar(src, freqs, 1 / freqs, freqs.size.reciprocal);
	// .sum will mix everything in that array down to a single channel
	Out.ar(0, reson.sum * env);
	});

a.note(0.0, 10.0).dur_(10.0).basefreq_(440).amp_(12).play;

// every time this runs, a new set of partials will be created
// execute the following lines one after another... eventually, a "buzz-y" sound will result

a.note(0.0, 10.0).dur_(10.0).basefreq_(440).amp_(3).play;
a.note(0.0, 10.0).dur_(10.0).basefreq_(440).amp_(3).play;
a.note(0.0, 10.0).dur_(10.0).basefreq_(440).amp_(3).play;
a.note(0.0, 10.0).dur_(10.0).basefreq_(440).amp_(3).play;
a.note(0.0, 10.0).dur_(10.0).basefreq_(440).amp_(3).play;
a.note(0.0, 10.0).dur_(10.0).basefreq_(440).amp_(3).play;


z.window.close;

/*
Other filters to explore:

related ot Resonz
Ringz, Klank
 
2nd order Butterworth Filters
BPF, BRF, LPF, HPF

Resonant Lowpass and Highpass with a resonant peak at the cutoff
RLPF, RHPF

Filter guts - you supply the coefs
FOS, SOS

and there will be more next week
*/


