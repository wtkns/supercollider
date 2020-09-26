/*

James Watkins
Partner: Bennett Lin


Lab 1: Psycho acoustic tests. 
 
Harmonic fusion:

A harmonic sound has harmonics or harmonic partials with frequencies that are related as whole-number multiples. Our perception fuses all partials of a harmonic sound into a single pitch at the fundamental frequency.

a) Using the following CtkSynthDef, create a sound with a fundamental frequency of 440 Hz and the first 9 harmonic partials (fundamental + 9 harmonics = 10 partials total): 
*/

(
Server.default = s = Server.internal.boot;
s.scope
)

(
// synthdef'



var sd, fundamental, numPartials;

fundamental = 440;
numPartials = 10;

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

numPartials.do({arg i;
	sd.note(0.2, 5).freq_(i+1*fundamental).amp_(0.05).dur_(5).play;
});
)

/*
write a block of code that will play the same harmonic sound from the previous problem but now with durations should be proportional to the number of partials: partial 1 (the fundamental) will be 1 second long, partial 10 will
be 10 seconds long. All partials (notes) should start together at time 0.2 so that you will gradually lose the fundamental, then lose the second partial, then the third, and so on.
*/

(
// synthdef

var sd, fundamental, numPartials;

fundamental = 440;
numPartials = 10;

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

numPartials.do({arg i;
	sd.note(0.2, i+1).freq_(i+1*fundamental).amp_(0.05).dur_(i+1).play;
});
)

/*
c) re-write the solution to problem b), using a forBy loop, rather then 10.do.
*/

(
// synthdef

var sd;

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

440.forBy(4400, 440, {arg partFreq, i;
	sd.note(0.2, i+1).freq_(partFreq).amp_(0.05).dur_(i+1).play;
});
)

/*
Question: Question: How many partials do you   have to take out to lose the perception of the fundamental?

5 or 6



d) write a Routine for your CtkSynthDef used above that will play seven separate pairs of tones with frequency differences of: 3, 5, 7, 9, 11, 13, and 15 Hz respectively.
Use the frequency of middle C on the piano as the stationary reference frequency for the experiment. Each tone pair (middle C plus the higher tone) should last three seconds. .5 seconds of silence should be placed between each tone pair. Use an amplitude of 0.1 for each note.
*/

(
	var sd, rout, c;
	c = PitchClass(\c, 4);

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

	rout = Routine({
		3.forBy(15, 2, {arg incr, i;
				sd.note(0.2, 3.0).freq_(c.freq).amp_(0.1).dur_(3.0).play;
				sd.note(0.2, 3.0).freq_(c.freq + incr).amp_(0.1).dur_(3.0).play;				// wait for 3.5 seconds
				3.5.wait;
			});
	});

rout.play;
)

/*
e) Repeat problem d) now with frequency differences of: 15, 17, 19, 21, 23, 25, and 27 Hz respectively. Use the same reference frequency (middle C).
Question: How do you perceive these sets of pairs? How do explain this? 

faster beats or as polyphonic: When two sinusoidal tones reach our ears, our ability to discriminate between the frequency of each tone depends on the difference between those frequencies. 

*/

(
	var sd, rout, c;
	c = PitchClass(\c, 4);

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

	rout = Routine({
		15.forBy(27, 2, {arg incr, i;
				sd.note(0.2, 3.0).freq_(c.freq).amp_(0.1).dur_(3.0).play;
				sd.note(0.2, 3.0).freq_(c.freq + incr).amp_(0.1).dur_(3.0).play;				// wait for 3.5 seconds
				3.5.wait;
			});
	});

rout.play;
s.scope;

)

/*
Play a musical snippet. 

Using the 'Ode to Joy' sample above, create a code block that will play the musical snippet on the webpage here:

http://wiki.dxarts.washington.edu/groups/general/wiki/e63c6/Digital_Sound_Resources.html

Use a tempo of 60 beats per minute. This will make an eighth note have a duration of 0.5 seconds, sixteenth notes 0.25 seconds. You can use PitchClass and the piano roll chart in the Dodge on page 34 to figure out the notes (note the key signature - F is sharp!)
*/

(
var data, routine, sd;
var do, re, mi, fa, sol, la, ti, hiDo;

do = PitchClass(\g, 4);
re = PitchClass(\a, 4);
mi = PitchClass(\b, 4);
fa = PitchClass(\c, 5);
sol = PitchClass(\d, 5);
la = PitchClass(\e, 5);
ti = PitchClass(\fs, 5);
hiDo = PitchClass(\g, 5);

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

data = [[hiDo, 0.5, 0.3], [hiDo, 0.5, 0.3], [ti, 0.5, 0.3], [ti, 0.5, 0.3], [la, 0.5, 0.3], [la, 0.5, 0.3], [sol, 0.5, 0.3], [sol, 0.5, 0.3], [fa, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.35], [sol, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.35], [sol, 0.25, 0.35], [la, 0.25, 0.25], [sol, 0.25, 0.35], [fa, 0.25, 0.35], [mi, 0.25, 0.35], [re, 0.25, 0.25], [do, 2.0, 2.1], [mi, 0.5, 0.5]];

routine = Routine({
	data.do({arg eachNote, i;
		var pc, noteFreq, noteDur, noteArtic;
		// noteDur is duration in meter
		// noteArtic is actual duration due to staccatos and slurs
		#pc, noteDur, noteArtic = eachNote;
		noteFreq = pc.freq;
		[noteFreq.round(0.1), noteDur, noteArtic].postln; // for reference
		sd.note(0.2, noteDur).freq_(noteFreq).dur_(noteArtic).amp_(0.3).play;
		noteDur.wait;
	})
});

routine.play;
)
