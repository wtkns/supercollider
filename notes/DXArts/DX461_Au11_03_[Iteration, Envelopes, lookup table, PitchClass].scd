/*

Integer:do and other ways to iterate

We saw last week how to iterate over a collection, but another VERY powerful tool in SuperCollider is the Integer:do method. With this, you pass in a Function to be performed a certain number of times. 

*/

// notice that the value for i starts at 0 and goes up to the Integer - 1.
10.do({arg i; "I am looping!".postln; i.postln});

// starts at 9, goes down to 0 
10.reverseDo({arg i; "I am looping!".postln; i.postln});

// alternate syntax:

do(10, {arg i; "I am looping!".postln; i.postln});

// to start at a different value and increment to a different endval, you 'for'

// start.for(end, Function); // end IS included! 
10.for(20, {arg curVal, i; [curVal, i].postln});
// you can go in either direction
20.for(-10, {arg curVal, i; [curVal, i].postln});

// forBy lets you increment by values other then 1
// start.forBy(end, step, Function);

440.forBy(4400, 440, {arg curVal, i; [curVal, i].postln})

// the Integer:collect method is also handy - you give it a Function, and the function
// is run Integer times, and the results collected into an Array:

a = 10.collect({arg i; 440 * i});
a; 

/*

Envelopes!

Envelopes give a dynamic control over different aspects of our sound. The first way we will use them is to shape the Amplitude of our sound. 

Most UGens in SuperCollider that are used for generating sound output a floating point signal between -1.0 and 1.0. However, to just play a sound for a given duration and stop it will likely cause a discontinuity in the sound (which we hear as a click)

*/

// a simple sine tone example - note the click when the note ends!
(
var note, sd;
sd = CtkSynthDef(\note, {arg freq, amp;
	Out.ar(0, Pan2.ar(
		// 'amp' is a value between 0 and 1. 
		SinOsc.ar(freq, 0, amp)))
});

note = sd.note(0.2, 4).freq_(402).amp_(0.3);
note.play;
)

/* 

The SinOsc has two arguments that are unique to it: freq and phase. But the next two are very common to almost all UGens - mul and add. mul scales the signal (in the above example, I multiplied the -1 to 1 range of SinOsc by 0.3 so it wouldn't be as loud... the range of output became -0.3 to 0.3). add will give the signal an offset from 0. However, to smoothly start a sound and end it, we actually want to apply a more dynamic signal. We have a number of options.

*/

// Line creates a linear ramp from 1 to 0 over dur - multiplying the output
// of SinOsc with this creates a linear fade
(
var note, sd;
sd = CtkSynthDef(\note, {arg freq, amp, dur;
	Out.ar(0, Pan2.ar(
		// 'amp' is a value between 0 and 1. 
		SinOsc.ar(freq, 0, amp) * Line.kr(1, 0, dur)
		)
	)
});

note = sd.note(0.2, 4).freq_(402).amp_(0.3).dur_(4.0);
note.play;
)

// XLine creates an exponential ramp from 1 to a very small number (don't cross 0!)
// over dur - multiplying the output of SinOsc with this creates an exponential fade
(
var note, sd;
sd = CtkSynthDef(\note, {arg freq, amp, dur;
	Out.ar(0, Pan2.ar(
		// 'amp' is a value between 0 and 1. 
		SinOsc.ar(freq, 0, amp) * XLine.kr(1, 0.00001, dur)
		)
	)
});

note = sd.note(0.2, 4).freq_(402).amp_(0.3).dur_(4.0);
note.play;
)

/* 

Line and XLine create a single segment. Env can describe much more complex shapes, and EnvGen can generate values from the Env description. 

Env([level1, level2 ... leveln], [time1, time2 ... timen-1], [curve1, curve2 ... curen-1]);

note that there is one more level value then time value - times describe how long it takes to get BETWEEN levels. Curves can have a single value OR an array that corresponds to each segment:
*/


// a simple line like Line:
Env([1, 0], [1]).plot; // no curve - Linear - or \lin - is assumed.
// like XLine - \exp curve is applied to all segments
Env([1, 0.00001], [1], \exp).plot;
// an ASR envelope - Attack, Sustain, Release (3 segment) - with all linear curves:
Env([0, 1, 0.2, 0], [0.1, 0.8, 0.1], \lin).plot;
// an ADSR - Attack, Decay, Sustain, Release (4 segment) with mixed curves
Env([0, 1, 0.6, 0.5, 0], [0.1, 0.1, 0.7, 0.1], [\lin, \exp, -10, \sin]).plot;

/*
You can then use these inside an EnvGen to shape your sound:
*** For added flexibility, I suggest trying to make the times values sum to 1... then you can use the timeScale argument to EnvGen to make the Env size to your note durations! ****
*/

(
var note, sd;
sd = CtkSynthDef(\note, {arg freq, amp, dur;
	var env, envGen;
	env = Env([0, 1, 0.6, 0.5, 0], [0.1, 0.1, 0.7, 0.1], [\lin, \exp, -10, \sin]);
	envGen = EnvGen.kr(env, timeScale: dur);
	Out.ar(0, Pan2.ar(
		// 'amp' is a value between 0 and 1. 
		SinOsc.ar(freq, 0, amp) * envGen
		)
	)
});

note = sd.note(0.2, 4).freq_(402).amp_(0.3).dur_(4.0);
note.play;
)

(
var note, sd;
sd = CtkSynthDef(\note, {arg freq, amp, dur;
	var env, envGen;
	env = Env([0, 1, 0.6, 0.5, 0], [0.1, 0.1, 0.7, 0.1], [\lin, \exp, -10, \sin]);
	envGen = EnvGen.kr(env, timeScale: dur);
	Out.ar(0, Pan2.ar(
		// 'amp' is a value between 0 and 1. 
		SinOsc.ar(freq, 0, amp) * envGen
		)
	)
});

note = sd.note(0.2, 1).freq_(402).amp_(0.3).dur_(1.0);
note.play;
)

/*

Table-lookup oscillators and SuperCollider.

A table lookup oscillator is made up of two parts - a table of data in memory to play through, and a index incrememtor that reads through that table for a given frequency. Like everything else digital, the number samples in a table is finite, so the accuracy with which we can output samples from a table-lookup weighs against a couple costs a) a larger table will yield less error and b) the computational costs of interpolating for values that aren't precisely accessible in the table (samples between samples). 

The basic sin oscillator in SuperCollider contains a table of 8192 samples for a single cycle of a sine wave, and linearly interpolates for values in between values in the table. For most sin tone generating purposes, this will give satisfactory results and will be fast. 

The table is sampled at the (starting phase (in radians) / 2pi) * 8192.
The first output of this UGen will be 0 (the first sample in the table, since the starting phase is 0). After a value is taken from the table, it is scaled by the 'mul' argument, and the 'add' argument is added to the value.

The pointer into the table will then increment as a function of frequency and the sample rate and the table size. 

SI = (freq / sampleRate) * tableSize
*/

Server.default = s = Server.internal.boot;
s.scope;

(
var note, sd;
sd = CtkSynthDef(\note, {arg freq, amp, dur;
	var env; // we'll put the Env into the EnvGen
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
		timeScale: dur);
	Out.ar(0, Pan2.ar(
		// 'amp' is a value between 0 and 1. The output of the table-lookup 
		// is multiplied by the amp value, THEN again by the EnvGen's output.
		SinOsc.ar(freq, 0, amp) * env
		)
	)
});

note = sd.note(0.2, 4).freq_(1).amp_(1).dur_(4);
note.play;
)

// using a higher frequency means we a) play through the table faster and b)
// 'hear' a different fundamental frequency as a result of the repetition of 
// the periodic nature of the data IN the table

(
var note, sd;
sd = CtkSynthDef(\note, {arg freq, amp, dur;
	var env;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
		timeScale: dur);
	Out.ar(0, Pan2.ar(
		SinOsc.ar(freq, 0, amp) * env
		)
	)
});

note = sd.note(0.2, 4).freq_(1000).amp_(0.3).dur_(4);
note.play;
)

/* 

Before we go onto the last part and the lab - a little more about Array's and assigning values to multiple values. 
Often, it is useful to pair data that will be used in a note into an Array - or, even within an Array of Arrays. Let's say we want to store note frequency and duration together in a single Array:

*/

a = [440, 0.5];

// we can grab these values using 'at' or []:
f = a.at(0);
d = a[1];

// OR - we can use the # symbol to assign values from an Array to multiple vars all
// at once:
a = [440, 0.5];
#f, d = a;
f;
d;

// This can be very helpful, for instance, in the creation of note lists:
(
var data, routine, sd;

sd = CtkSynthDef(\note, {arg freq, amp, dur;
	var env;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
		timeScale: dur);
	Out.ar(0, Pan2.ar(
		SinOsc.ar(freq, 0, amp) * env
		)
	)
});

data = [[440, 0.5], [405, 0.5], [440, 0.5], [523, 0.5], [440, 1.0]];
routine = Routine({
	data.do({arg thisData, i;
		var freq, dur;
		#freq, dur = thisData;
		// see how the data is iterated over and parsed!
		[thisData, freq, dur].postln;
		sd.note(0.2, dur).freq_(freq).dur_(dur).amp_(0.3).play;
		dur.wait;
	})
});

routine.play;
)

/*

For dealing with pitch directly, there are classes that are helpful as well! PitchClass lets you name musical, equal-tempered pitches:

*/
// PitchClass(\notename, octave);
a = PitchClass(\c, 4); // middle C
a.freq; // its frequency
a.keynum; // its MIDI representation

a = PitchClass(\cs, 4); // C-sharp
a.freq;

a = PitchClass(\df, 4); // D-flat;
a.freq;

// a melody:

(
var data, routine, sd;
var d, e, fs, g, a;

d = PitchClass(\d, 4);
e = PitchClass(\e, 4);
fs = PitchClass(\fs, 4);
g = PitchClass(\g, 4);
a = PitchClass(\a, 4);

sd = CtkSynthDef(\note, {arg freq, amp, dur;
	var env;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
		timeScale: dur);
	Out.ar(0, Pan2.ar(
		SinOsc.ar(freq, 0, amp) * env
		)
	)
});

data = [[fs, 0.5], [fs, 0.5], [g, 0.5], [a, 0.5], [a, 0.5], [g, 0.5], [fs, 0.5], 
	[e, 0.5], [d, 0.5], [d, 0.5], [e, 0.5], [fs, 0.5], [fs, 0.5], [e, 0.5], [e, 1.5]];
	
routine = Routine({
	data.do({arg thisData, i;
		var pc, freq, dur;
		#pc, dur = thisData;
		// ask the PitchClass for its freq
		freq = pc.freq;
		[thisData, pc, freq, dur].postln;
		sd.note(0.2, dur).freq_(freq).dur_(dur).amp_(0.3).play;
		dur.wait;
	})
});

routine.play;
)

