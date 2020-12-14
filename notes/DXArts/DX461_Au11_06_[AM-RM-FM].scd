// Amplitude Modulation and Ring Modulation
(
Server.default = s = Server.internal.boot;
s.waitForBoot({
	s.scope;
	f = FreqScope.new(400, 200, 0);
	})
)


// Simple AM instrument as it appears in Dodge's book
// The instrument might clip for high amplitude values
// and modulation index close to 1.0

(
var noteObject, note;

Server.default = s = Server.internal.boot;

noteObject = CtkSynthDef(\simpleam, {arg dur = 1, amp = -6, carfreq = 440, 
		modfreq = 2, modindex = 0.7;
	var car, mod, env;
	env = EnvGen.kr(
		Env([0.001, 1, 1, 0.001], [0.1, 0.8, 0.1], 
		\exp), timeScale: dur);
	amp = amp.dbamp; // convert the value of the amp arg with .dbamp
	mod = SinOsc.ar(modfreq, 0, amp * modindex);
	car = SinOsc.ar(carfreq, 0, amp + mod);
	Out.ar(0, car * env);
	});
	
note = noteObject.note(1.0, 5.0).dur_(5.0).carfreq_(440).modfreq_(2).modindex_(0.5); 
//note = noteObject.note(1.0, 5.0).dur_(5.0).carfreq_(440).modfreq_(30).modindex_(0.5); 
//note = noteObject.note(1.0, 5.0).dur_(5.0).carfreq_(440).modfreq_(310).modindex_(0.5); 
note.play; 
)
	
// Simple AM instrument with amplitude normalized to 1.0
// to avoid clipping (samples out of range).
// We scale amplitude just before sending the carrier signal
// to the output. The instrument doesn't clip for modulation
// indexes between 0.0 and 1.0
(
var noteObject, note;
noteObject = CtkSynthDef(\simpleam2, {arg dur = 1, amp = -6, carfreq = 440, 
		modfreq = 2, modindex = 0.7;
	var car, mod, env;
	env = EnvGen.kr(
			Env([0.001, 1, 1, 0.001], [0.1, 0.8, 0.1], 
			\exp), timeScale: dur);
	amp = amp.dbamp; // convert the value of the amp arg with .dbamp
	mod = SinOsc.ar(modfreq, 0, amp * modindex);
	car = SinOsc.ar(carfreq, 0, (amp + mod) / 2.0 ); // prevent clipping
	Out.ar(0, car * amp * env);
	});
	
note = noteObject.note(1.0, 5.0).dur_(5.0).amp_(-3).carfreq_(440)
	.modfreq_(430).modindex_(1.0); 

note.play; 
)



// Simple Ring Modulation instrument as appears on Dodge's book
// We add the feature of using a harmonic signal as modulator 
// instead of a sinusoid.  To obtain this harmonic signal, we
// will store a complex waveform in a memory buffer, and read it
// with the Osc UGen.
(
var noteObject, note, buffer1, buffer2, freeFunc;

Server.default = s = Server.internal.boot;

noteObject = CtkSynthDef(\simplerm, {arg dur = 1, amp = -6, carfreq = 440,
		modfreq = 200, modamp = 0.7, buffer = 1;
	var car, mod, env;
	env = EnvGen.kr(
		Env([0.001, 1, 1, 0.001], [dur * 0.1, dur * 0.8, dur * 0.1], 
		\exp));
	mod = Osc.ar(buffer, modfreq, 0, modamp);
	car = SinOsc.ar(carfreq, 0, amp.dbamp);
	Out.ar(0, mod * car * env);
	});

// first we need to create the waveforms in the memory buffers.  
// We will create 2 different buffers.
// This buffer will have 512 frames (or sampled values)
// .. we can fill the buffer with information about individual 
// partials using the sine3 method
// here is what the message looks like:
// the command creates a sine wave with a one partial.  That partial 
// will cycle over the duration of the buffer, with an amplitude of 1, 
// and no phase offset.

s.waitForBoot({
	Routine.run({
		//one partial - frequency (in relation to buffer length) amp and phase
		buffer1 = CtkBuffer.buffer(8192).sine3(0.0, 1, 1, 1, 1, 1, 0); 

		// now we will create a more complex wavetable for buffer 2
		// this spectrum will have 6 partials with different amplitudes and 
		// phase offsets
		buffer2 = CtkBuffer.buffer(8192).sine3(0.0, 1, 1, 1,
			1, 0.75, 0, // partial 1, strength 0.75, phase offset of 0
			2, 0.5, 0.5, // partial 2, strength 0.5, phase offset of 0.5 
			3, 0.25, 0, // partial 3, strength 0.25, phase offset of 0 
			4, 0.25, 0.0972, // partial 4, strength 0.25, phase offset of 0.0972
			5, 0.65, 0, // partial 5, strength 0.65, phase offset of 0 
			6, 0.06, 0 // partial 6, strength 0.06, phase offset of 0
			); 

		buffer1.load;
		buffer2.load;
		CmdPeriod.add(freeFunc = {
			"Freeing Buffers".postln;
			[buffer1, buffer2].do({arg thisBuffer; 
				thisBuffer.free});
		});
		
		s.sync;
		1.wait;	
		noteObject.note(0.1, 5.0).dur_(5.0).buffer_(buffer1)
			.carfreq_(440).modfreq_(200).play;
		6.wait;
		noteObject.note(0.1, 5.0).dur_(5.0).buffer_(buffer2)
			.carfreq_(440).modfreq_(205).play;
		6.wait;
		freeFunc.value;
		CmdPeriod.remove(freeFunc);
		})
	})
)



// Same Ring Modulation instrument implemented as signal multiplication
// in this case we modulate two harmonic spectra
(
var noteObject, note, buffer, freeFunc;

Server.default = s = Server.internal.boot;

noteObject = CtkSynthDef(\simplerm2, {arg dur = 1, amp = -6, carfreq = 440,
		modfreq = 200, modamp = 0.7, buffer = 1;
	var car, mod, env;
	env = EnvGen.kr(
			Env([0.001, 1, 1, 0.001], [dur * 0.1, dur * 0.8, dur * 0.1], 
			\exp));
	mod = Osc.ar(buffer, modfreq, 0, modamp);
	car = Osc.ar(buffer, carfreq, 0, amp.dbamp);
	Out.ar(0, mod * car * env);
	});

s.waitForBoot({
	Routine.run({
		buffer = CtkBuffer.buffer(512).sine3(0.0, 1, 1, 1,
			1, 0.75, 0, // partial 1, strength 0.75, phase offset of 0
			2, 0.5, 0.5, // partial 2, strength 0.5, phase offset of 0.5 
			3, 0.25, 0, // partial 3, strength 0.25, phase offset of 0 
			4, 0.25, 0.0972, // partial 4, strength 0.25, phase offset of 0.0972
			5, 0.65, 0, // partial 5, strength 0.65, phase offset of 0 
			6, 0.06, 0 // partial 6, strength 0.06, phase offset of 0
			); 
		
		buffer.load;
		CmdPeriod.add(freeFunc = {
			"Freeing Buffers".postln;
			buffer.free;
		});
		s.sync;
		
		noteObject.note(0.1, 5.0).dur_(5.0).buffer_(buffer)
			.carfreq_(440).modfreq_(440.3).play;
		6.wait;
		freeFunc.value;
		CmdPeriod.remove(freeFunc);
	});
})
)


/*
Read Dodge 4.8
*/

// Simple Frequency Modulation instrument as it appears in Dodge's book,
// Page 95.
// Conceived as a "vibrato" instrument.
// Vibrato width is a ratio applied to the carrier frequency.
// Example: vibwidth = .01 = 1% vibrato width.

(
var noteObject;

Server.default = s = Server.internal.boot;

noteObject = CtkSynthDef(\simplefm, {arg dur = 1, amp = -6, 
		carfreq = 440, vibwidth = 0.015, vibrate = 2.0;
	var env, mod, car;
	env = EnvGen.kr(
			Env([0.01, 1, 1, 0.01], [0.01, dur - 0.02, 0.01], \exp));
	vibwidth = vibwidth * carfreq; // vibwidth is a pct of the carfreq
	mod = SinOsc.ar(vibrate, 0, vibwidth);
	car = SinOsc.ar(carfreq + mod, 0, amp.dbamp);
	Out.ar(0, car * env);
	});

s.waitForBoot({
	Routine.run({
		// vibwidth ratio (0 - 1), vibrate (0-20 Hz)
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(440)
			.vibrate_(2.0).vibwidth_(0.06).play;
		4.0.wait;
		// 1.5% vib width, 2 Hz rate
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(440)
			.vibrate_(2.0).vibwidth_(0.015).play;
		4.0.wait;
		// 1.5% vib width, 0.5 Hz rate
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(440)
			.vibrate_(0.5).vibwidth_(0.015).play;
		4.0.wait;		
		// 0.75% vib width, 8 Hz rate
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(440)
			.vibrate_(8.0).vibwidth_(0.0075).play;
	})
})
)	


// Frequency Modulation instrument which accepts Index
// as a parameter and derives the appropriate deviation
(
var noteObject;

Server.default = s = Server.internal.boot;

noteObject = CtkSynthDef(\simplefm2, {arg dur = 1, amp = -6, 
		carfreq = 440, modfreq = 200, index = 1;
	var env, mod, car, deviation;
	env = EnvGen.kr(
			Env([0.01, 1, 1, 0.01], [0.01, dur - 0.02, 0.01], \exp));
	deviation = index * modfreq;
	mod = SinOsc.ar(modfreq, 0, deviation);
	car = SinOsc.ar(carfreq + mod, 0, amp.dbamp);
	Out.ar(0, car * env);
	});	

s.waitForBoot({
	Routine.run({
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(400).modfreq_(100)
			.index_(2.5).play;
		4.wait;
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(800).modfreq_(200)
			.index_(2.5).play;
		4.wait;
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(1200).modfreq_(300)
			.index_(2.5).play;
		4.wait;
		noteObject.note(0.1, 3.0).dur_(3.0).carfreq_(1600).modfreq_(400)
			.index_(2.5).play;
	});
})
)


// Frequency Modulation instrument which accepts Index
// as a parameter and derives the appropriate deviation.
// Also accepts C:M Ratio as a parameter and derives fm.

(
var noteObject, note;
Server.default = s = Server.internal.boot;

noteObject = CtkSynthDef(\simplefm3, {arg dur = 1, amp = -6, carfreq = 440, 
		cmratio = 0.25, index = 1;
	var env, mod, car, modfreq, deviation;
	env = EnvGen.kr(
			Env([0.01, 1, 1, 0.01], [0.01, dur - 0.02, 0.01], \exp));
	modfreq = carfreq * cmratio;
	deviation = index * modfreq;
	mod = SinOsc.ar(modfreq, 0, deviation);
	car = SinOsc.ar(carfreq + mod, 0, amp.dbamp);
	Out.ar(0, car * env);
	});
	
s.waitForBoot({
	Routine.run({
		1.0.wait;
		// FM with index and ratio
		note = noteObject.note(0.1, 6.0).dur_(6.0).carfreq_(400)
			.cmratio_(0.25).index_(4).play; 
	})
})
)



// Introducing XLine.
//
//	XLine.kr(start, end, dur, mul, add, doneAction);
// 
// If the envelope you want to use only has two values, XLine (for 
// exponential line) or Line are useful UGens. Remember that, with XLine,
// the line dexcribed cannot cross 0.

(
var noteObject, note;

Server.default = s = Server.internal.boot;

noteObject = CtkSynthDef(\simplefm4, {arg dur = 1, amp = -6, modfreq = 220,
		index = 1, carfreq = 440;
	var env, mod, car, deviation;
	env = XLine.kr(1, 0.0001, dur);
	deviation = index * modfreq;
	// envelope the modulating SinOsc to create a change of timbre
	mod = SinOsc.ar(modfreq, 0, deviation * env);
	car = SinOsc.ar(carfreq + mod, 0, amp.dbamp);
	Out.ar(0, car * env);
	});	

s.waitForBoot({
	Routine.run({
		// FM with index
		1.0.wait;
		note = noteObject.note(0.1, 6.0).dur_(6.0).carfreq_(400)
			.modfreq_(200).index_(5).play; 
	})
})
)


/* Read Dodge 5.1 */
