/*

Lab assignment! 

For this assignment, you will pair up with someone else in the class. For part f) - some knowledge of how to read music is needed. If you don't know how to read music at a basic level, partner up with someone in the class who can. This can be a good chance to get to know your other class mates!

Turn in - one .scd file for each pair of students working to Stelios by Thursday at the end of class.

*/

/*

Psycho acoustic tests. 

*/

/* 
Harmonic fusion:

A harmonic sound has harmonics or harmonic partials with frequencies that are related as whole-number multiples. Our perception fuses all partials of a harmonic sound into a single pitch at the fundamental frequency.

a) Using the following CtkSynthDef, create a sound with a fundamental frequency of 440 Hz and the first 9 harmonic partials (fundamental + 9 harmonics = 10 partials total):

CtkSynthDef(\note, {arg freq, amp, dur;
	var env;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
		timeScale: dur);
	Out.ar(0, Pan2.ar(
		SinOsc.ar(freq, 0, amp) * env
		)
	)
});

Use an amplitude of 0.05 for each partial, and a duration of 5 seconds for each. Create each partial as its own note, either through a listing of 10 notes, or with a 'do' loop. All 10 should start at the same time. 

*/

// template code:

(
var sd;
// add more variables if needed
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

// create your notes... give them a starttime of 0.2 seconds and a duration of
// 5 seconds... e.g.:
// sd.note(0.2, 5).freq_(440) ... etc.

)

/*

b) In the region of approximately 20 Hz to 2 kHz the fusion of harmonic partials into the sensation of a single pitch operates even when the fundamental frequency is absent.

write a block of code that will play the same harmonic sound from the previous problem but now with durations should be proportional to the number of partials: partial 1 (the fundamental) will be 1 second long, partial 10 will
be 10 seconds long. All partials (notes) should start together at time 0.2 so that you will gradually lose the fundamental, then lose the second partial, then the third, and so on.  

For this problem - you MUST use a 'do' loop to create your notes. Use the increment argument in your loop to calculate frequency and duration:

*/

(
var sd;
// add more variables if needed
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

// create your notes... give them a starttime of 0.2 seconds and a duration of
// 5 seconds... e.g.:
// sd.note(0.2, 5).freq_(440) ... etc.
10.do({arg i;
	var dur, freq;
	dur =  // calculate duration
	freq = // calculate freq 
	sd.note(0.2, dur).freq_(freq).amp_(0.05).dur_(dur).play; 
});

)

/*

c) re-write the solution to problem b), using a forBy loop, rather then 10.do.

Question: How many partials do you   have to take out to lose the perception of the fundamental?

*/


/*

Beating Tones: 

d) When two sinusoidal tones reach our ears, our ability to discriminate between the frequency of each tone depends on the difference between those frequencies.   Closely tuned pure tones (within 10 to 15 Hz difference) will result in a beating sensation.
To demonstrate this, write a Routine for your CtkSynthDef used above that will play seven separate pairs of tones with frequency differences of: 3, 5, 7, 9, 11, 13, and 15 Hz respectively.
Use the frequency of middle C on the piano as the stationary reference frequency for the experiment. Each tone pair (middle C plus the higher tone) should last three seconds. .5 seconds of silence should be placed between each tone pair. Use an amplitude of 0.1 for each note.

*/

(
var sd, rout, c;

c = PitchClass(\c, 4);

// add more variables if needed
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
	// figure out a way to iterate... Integer:do? forBy? Collection:do?
	 ...({
		sd.note.new(0.2, 3.0).freq_(c.freq).amp_(0.1).dur_(3.0);
		... create your second note with a frequency offset  ...
		// wait for 3.5 seconds
		3.5.wait;
	 })
});

rout.play;
);

/*

e) Repeat problem d) now with frequency differences of: 15, 17, 19, 21, 23, 25, and 27 Hz respectively. Use the same reference frequency (middle C).
Question: How do you perceive these sets of pairs? How do explain this?

*/

/*

f) Play a musical snippet. 

Using the 'Ode to Joy' sample above, create a code block that will play the musical snippet on the webpage here:

http://wiki.dxarts.washington.edu/groups/general/wiki/e63c6/Digital_Sound_Resources.html

Use a tempo of 60 beats per minute. This will make an eighth note have a duration of 0.5 seconds, sixteenth notes 0.25 seconds. You can use PitchClass and the piano roll chart in the Dodge on page 34 to figure out the notes (note the key signature - F is sharp!).

*/
