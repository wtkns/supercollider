/*

Buffers

While the lookup table for SinOsc is pre-loaded into SuperCollider, you can allocate memory from RAM yourself and fill it with data to use in lookup oscillators. Using buffers of memory introduces some new complexity to the program however. Memory allocation takes time on the server. Also - uncompressed audio can take a lot of memory, so you need to be careful to also free memory when you are done using it. CtkBuffer is our main interface to allocating, setting and using memory.
There are many class methods for creating memory, but for now we will use the *buffer class method.
*/

Server.default = s = Server.internal.boot;
s.scope;
// allocate a buffer with a size of 2048 samples, 1 channel and the server variable
// also - use powers of 2 for table sizes!
a = CtkBuffer.buffer(2048, 1, s);
a.load; // load it to the Server

/*
  fill the buffer with a sine table 
	sine1(time, normalize, wavetable, clear ... args)
	
	time is when in the future to fill the table
	normalize is a flag that tells the algortihm whether or not to scale values between -1 and 1
		(0 is false, 1 is true)
	wavetable is a flag that specifies whether the data should be in wavetable format (0 or 1)
	clear says whether to overdub the new data with old, or to clear data first
	args ... any number of floats that refer to the overall strength of harmonic partials, where
		the 1st slot is the fundamental of the table, the second is the second partial, etc.
*/
// first - fill WITHOUT setting Wavetable to true so we can see the data in the Buffer
a.sine1(0.0, 1, 0, 1, 1);
a.plot;

// fill with a single sine period as a Wavetable
a.sine1(0.0, 1, 1, 1, 1);
a.plot;

// now, we can use the Wavetable Oscillator Osc to play it.

z = CtkSynthDef(\osc, {arg buffer, freq, dur = 1;
	var env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
		timeScale: dur);
	Out.ar(0, Pan2.ar(
		// Osc.ar(table, freq, phase, mul, add)
		Osc.ar(buffer, freq, 0, 0.2) * env)
	)
});

y = z.note(0.1, 5.0).buffer_(a).freq_(440).dur_(5.0).play
y.free;

// when you are done with the memory, free it
a.free;

// notice the difference in sound with different buffer sizes!
a = CtkBuffer.buffer(8, 1, s); // really storing just 4 points of data because of the Wavetable
						   // data structure (sample, distanceToNextSample, sample, distance...) 
a.load; 

a.sine1(0.0, 1, 0, 1, 1).plot;

// now, as a Wavetable
a.sine1(0.0, 1, 1, 1, 1).plot;

y = z.note(0.1, 5.0).buffer_(a).freq_(440).dur_(5.0).play
y.free;
a.free;

// using a table with more harmonics. Also a larger table size (less noise in the interpolation)
a = CtkBuffer.buffer(16384, server: s).load;
// without the Wavetable flag set, so you can see what the waveform looks like
a.sine1(0.0, 1, 0, 1, 1, 0.5, 0.7, 0.8, 0.2, 0.9).plot;

// redo - with Wavetable set to 1 so Osc can use it
a.sine1(0.0, 1, 1, 1, 1, 0.5, 0.7, 0.8, 0.2, 0.9).plot;

y = z.note(0.1, 5.0).buffer_(a).freq_(440).dur_(5).play
// you can also update the table data in real-time
a.sine1(0.0, 1, 1, 1, 1);
// NOTE! There is no cross-fade in this change - it is abrupt
a.sine1(0.0, 1, 1, 1, 1, 0.5, 0.7, 0.8, 0.2, 0.9);

y.free;
a.free;

/* 

Handling the time to allocate memory and the need to destroy memory within a code-block.

First - we should have a handy way to destroy memory, especially since our work up to this point involves creating a code-block and running the program. This means there is a potential for memory to be allocated over and over again. Later in the course there will be classes that handle some of this for you, but for now we will use Cmd-. Cmd-., we've already seen, is a way to stop sound in case of emergency, but there is also a class that lets you store Functions to be executed when you hit Cmd-. called CmdPeriod. 

*/

CmdPeriod.doOnce({"You hit command period!".postln}); // now, hit Cmd-. 
											   // press it a few times - notice that
											   // the Function only fired once!
											   
/*

We can now store CtkBuffers in an Array as we create them, then give CmdPeriod a Function to iterate over those CtkBuffers and free their memory. If you hit Cmd-. after each running of your code, you will prevent memory from building up.

*/

(
var myBuffers;
var buffer1, buffer2, buffer3;

Server.default = s = Server.internal.boot;

buffer1 = CtkBuffer.buffer(8192, server: s).load;
buffer2 = CtkBuffer.buffer(8192, server: s).load;
buffer3 = CtkBuffer.buffer(8192, server: s).load;

// create myBuffers and initialize its data to the three CtkBuffers
myBuffers = [buffer1, buffer2, buffer3];

CmdPeriod.doOnce({
	"Freeing Buffers".postln;
	myBuffers.do({arg thisBuffer;
		thisBuffer.free;
	})
});

)

/* 

if you run the code above, then hit command period, you should see this post to the post window:

	CmdPeriod
	CtkBuffer with bufnum id 0 loaded
	CtkBuffer with bufnum id 1 loaded
	CtkBuffer with bufnum id 2 loaded

press Cmd-. to run the cleanup Function, and you should see:

	Freeing Buffers

Now - run the code above again... notice the same CtkBuffer numbers are allocated! This shows that
the memory was properly cleared, and can be used again.

So this takes care of freeing memory after it is used, but there are two other considerations to take in creating larger code blocks that can be run all at one time, and both have to do with whether or not the Server is ready. In the code above, if the Server wasn't already booted, then the CtkBuffers won't load properly. Second, it takes time for CtkBuffers to load, and if you ask a note to play before the CtkBuffer is ready the note won't play properly. 

For the first problem, we will wrap all code that needs to run AFTER the Server has booted within the Server:waitForBoot method.

For the second problem, we will wrap all our code that might need to wait for a CtkBuffer inside a Routine, and ask for a sync message from the Server. This also requires the use of an instance of Condition... see below.

*/

(

Server.default = s = Server.internal.boot;

s.waitForBoot({
	Routine.run({
		var cond;
		var myBuffers, buffer1, buffer2, buffer3;
		var sd;
		
		// set up a Condition for the sync. Server messages will tell this class 
		// if the Server is done loading memory
		cond = Condition.new;

		// declare and load the CtkBuffers
		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer2 = CtkBuffer.buffer(8192, server: s).load;
		buffer3 = CtkBuffer.buffer(8192, server: s).load;
		
		// now, do something with the CtkBuffers, and sync again
		buffer1.sine1(0.0, 1, 1, 1, 1);
		buffer2.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		buffer3.sine1(0.0, 1, 1, 1, 1.0, 0.2, 0.7, 0.1, 0.6, 0.1, 0.8);
		
		// wait until the server confirms that the buffers where loaded
		s.sync(cond);
		
		// Post a message when we move onto the rest of the code ...
		"Buffers are loaded!".postln;
		
		// create myBuffers and initialize its data to the three CtkBuffers
		myBuffers = [buffer1, buffer2, buffer3];
		
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})
		});
		
		sd = CtkSynthDef(\osc, {arg buffer, freq, dur = 1;
			var env;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				// Osc.ar(table, freq, phase, mul, add)
				Osc.ar(buffer, freq, 0, 0.2) * env)
			)
		});
		
		// now - play some notes
		Routine.run({
			sd.note(0.1, 6.0).buffer_(buffer1).freq_(550).dur_(6).play;
			2.wait;
			sd.note(0.1, 8.0).buffer_(buffer2).freq_(350).dur_(8).play;
			3.2.wait;
			sd.note(0.1, 3.0).buffer_(buffer3).freq_(558).dur_(3).play;
		})

	})
});
	
)

/*

Playing multiple streams of musical material in multiple Routines

*/

(

Server.default = s = Server.internal.boot;

s.waitForBoot({
	Routine.run({
		var cond;
		var myBuffers, buffer1, buffer2, buffer3;
		var sd;
		var routine1, routine2, routine3;
		
		// set up a Condition for the sync. Server messages will tell this class 
		// if the Server is done loading memory
		cond = Condition.new;

		// declare and load the CtkBuffers
		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer2 = CtkBuffer.buffer(8192, server: s).load;
		buffer3 = CtkBuffer.buffer(8192, server: s).load;
		
		// now, do something with the CtkBuffers, and sync again
		buffer1.sine1(0.0, 1, 1, 1, 1);
		buffer2.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		buffer3.sine1(0.0, 1, 1, 1, 1.0, 0.2, 0.7, 0.1, 0.6, 0.1, 0.8);
		
		// wait until the server confirms that the buffers where loaded
		s.sync(cond);
		
		// Post a message when we move onto the rest of the code ...
		"Buffers are loaded!".postln;
		
		// create myBuffers and initialize its data to the three CtkBuffers
		myBuffers = [buffer1, buffer2, buffer3];
		
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})
		});
		
		sd = CtkSynthDef(\osc, {arg buffer, freq, dur = 1;
			var env;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				// Osc.ar(table, freq, phase, mul, add)
				Osc.ar(buffer, freq, 0, 0.2) * env)
			)
		});
		
		routine1 = Routine({
			var pitches;
			// PC is a shortcut for PitchClass
			pitches = [PC(\c, 4), PC(\d, 4), PC(\ef, 4), PC(\f, 4), PC(\g, 4), PC(\af, 4), 
				PC(\b, 4), PC(\c, 5)];
			pitches.do({arg pc;
					sd.note(0.1, 1).buffer_(buffer1).freq_(pc.freq).dur_(1).play;
					0.5.wait;
				});
		});

		routine2 = Routine({
			var pitches;
			pitches = [PC(\c, 4), PC(\d, 4), PC(\ef, 4), PC(\f, 4), PC(\g, 4), PC(\af, 4), 
				PC(\b, 4), PC(\c, 5)];
			pitches.do({arg pc;
					sd.note(0.1, 1).buffer_(buffer2).freq_(pc.freq).dur_(1).play;
					0.5.wait;
				});
		});
		
		routine3 = Routine({
			var pitches;
			pitches = [PC(\c, 4), PC(\d, 4), PC(\ef, 4), PC(\f, 4), PC(\g, 4), PC(\af, 4), 
				PC(\b, 4), PC(\c, 5)];
			pitches.do({arg pc;
					sd.note(0.1, 1).buffer_(buffer3).freq_(pc.freq).dur_(1).play;
					0.5.wait;
				});
		});
		
		// now - play some notes
		Routine.run({
			routine1.play;
			2.wait;
			routine2.play;
			2.wait;
			routine3.play;
		})

	})
});
	
)

/*

Notice that the above three Routine are pretty similar. They all play the same scale, have the same waittimes and note durations. The only thing really different is the buffer that is used. This is an EXCELLENT case where we should use a Function to create our Routines for us.

*/

(

Server.default = s = Server.internal.boot;

s.waitForBoot({
	Routine.run({
		var cond;
		var myBuffers, buffer1, buffer2, buffer3;
		var sd;
		var routFunction, routine1, routine2, routine3;
		
		// set up a Condition for the sync. Server messages will tell this class 
		// if the Server is done loading memory
		cond = Condition.new;

		// declare and load the CtkBuffers
		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer2 = CtkBuffer.buffer(8192, server: s).load;
		buffer3 = CtkBuffer.buffer(8192, server: s).load;
		
		// now, do something with the CtkBuffers, and sync again
		buffer1.sine1(0.0, 1, 1, 1, 1);
		buffer2.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		buffer3.sine1(0.0, 1, 1, 1, 1.0, 0.2, 0.7, 0.1, 0.6, 0.1, 0.8);
		
		// wait until the server confirms that the buffers where loaded
		s.sync(cond);
		
		// Post a message when we move onto the rest of the code ...
		"Buffers are loaded!".postln;
		
		// create myBuffers and initialize its data to the three CtkBuffers
		myBuffers = [buffer1, buffer2, buffer3];
		
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})
		});
		
		sd = CtkSynthDef(\osc, {arg buffer, freq, dur = 1;
			var env;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				// Osc.ar(table, freq, phase, mul, add)
				Osc.ar(buffer, freq, 0, 0.2) * env)
			)
		});
		
		routFunction = {arg buffer;
			var routine;
			// create a Routine and return it from the Function. 'buffer' is an argument
			// that is passed in.
			routine = Routine({
				[PC(\c, 4), PC(\d, 4), PC(\ef, 4), PC(\f, 4), PC(\g, 4), PC(\af, 4), 
					PC(\b, 4), PC(\c, 5)].do({arg pc;
						sd.note(0.1, 1).buffer_(buffer).freq_(pc.freq).dur_(1).play;
						0.5.wait;
					})
			});
			routine;
		};
		
		routine1 = routFunction.value(buffer1);
		routine2 = routFunction.value(buffer2);
		routine3 = routFunction.value(buffer3);
				
		// now - play some notes
		Routine.run({
			routine1.play;
			2.wait;
			routine2.play;
			2.wait;
			routine3.play;
		})

	})
});	
)

/* 

going this route, adding more arguments to the Function, we can also make the resulting Routines more flexible.. we'll add arguments for note durations, waittime and a frequency scaler

*/
(

Server.default = s = Server.internal.boot;

s.waitForBoot({
	Routine.run({
		var cond;
		var myBuffers, buffer1, buffer2, buffer3;
		var sd;
		var routFunction, routine1, routine2, routine3;
		
		// set up a Condition for the sync. Server messages will tell this class 
		// if the Server is done loading memory
		cond = Condition.new;

		// declare and load the CtkBuffers
		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer2 = CtkBuffer.buffer(8192, server: s).load;
		buffer3 = CtkBuffer.buffer(8192, server: s).load;
		
		// now, do something with the CtkBuffers, and sync again
		buffer1.sine1(0.0, 1, 1, 1, 1);
		buffer2.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		buffer3.sine1(0.0, 1, 1, 1, 1.0, 0.2, 0.7, 0.1, 0.6, 0.1, 0.8);
		
		// wait until the server confirms that the buffers where loaded
		s.sync(cond);
		
		// Post a message when we move onto the rest of the code ...
		"Buffers are loaded!".postln;
		
		// create myBuffers and initialize its data to the three CtkBuffers
		myBuffers = [buffer1, buffer2, buffer3];
		
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})
		});
		
		sd = CtkSynthDef(\osc, {arg buffer, freq, dur = 1;
			var env;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				// Osc.ar(table, freq, phase, mul, add)
				Osc.ar(buffer, freq, 0, 0.2) * env)
			)
		});
		
		routFunction = {arg buffer, duration = 1, waitTime = 0.5, freqScaler = 1;
			var routine;
			// create a Routine and return it from the Function. 'buffer' is an argument
			// that is passed in.
			routine = Routine({
				[PC(\c, 4), PC(\d, 4), PC(\ef, 4), PC(\f, 4), PC(\g, 4), PC(\af, 4), 
					PC(\b, 4), PC(\c, 5)].do({arg pc;
						sd.note(0.1, duration).buffer_(buffer).freq_(pc.freq * freqScaler)
							.dur_(duration).play;
						waitTime.wait;
					})
			});
			routine;
		};
		
		// use the defaults
		routine1 = routFunction.value(buffer1);
		// change the arg values
		routine2 = routFunction.value(buffer2, 2.2, 0.7, 2.0);
		// use keywords to change JUST specific args. Once you use keywords, you need to keep
		// using keywords after that. BUT - they don't need to be in order
		routine3 = routFunction.value(buffer3, freqScaler: 0.7, waitTime: 0.3);
				
		// now - play some notes
		Routine.run({
			routine1.play;
			2.wait;
			routine2.play;
			2.wait;
			routine3.play;
		})

	})
});	
)


/*

Reading - 
	Help file for Architecture => Client versus Server
	Help file for CtkBuffer
*/	
