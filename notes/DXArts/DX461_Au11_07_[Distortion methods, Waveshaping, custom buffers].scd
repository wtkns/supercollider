/*
===========
Time-domain signal operations: UGen distortion methods and Waveshaping
Also: Creating wavetables with custom buffers usin envelopes
===========
*/



/*
-----
Distortion methods
-----
*/

// –Êusing .distort
(
var sd;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\sineWEnvDist, {arg freq, envDurScale = 1, ampScale, distortAmt;
		var osc, env, envGen;
		env = Control.names([\env]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp);
		osc = ((distortAmt * osc).distort) * ampScale.dbamp;
		Out.ar(0, Pan2.ar(osc))
	});
	
	Routine.run({
		// now - we can pass in an Env with times scaled to 1 so envDurScale will scale the times
		// appropriately - and pass our Env in with the env_ method
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(1)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(10)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;	
	})
})
	
)


// – using .tanh: analog-like distortion 
(
var sd;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\sineWEnvSClip, {arg freq, envDurScale = 1, ampScale, distortAmt;
		var osc, env, envGen;
		env = Control.names([\env]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp);
		osc = ((distortAmt * osc).tanh) * ampScale.dbamp;
		Out.ar(0, Pan2.ar(osc))
	});
	
	Routine.run({
		// now - we can pass in an Env with times scaled to 1 so envDurScale will scale the times
		// appropriately - and pass our Env in with the env_ method
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(1)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(10)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;	
	})
})
	
)

///– Presenting Select: UGen that allow mixing of signals. This is handy for being able to choose from more than one methods, without having to create a new SynthDef for each of them
// ATTN: All signals will run all the time, so this can become costly CPU-wise if the UGens involved are expensive (not the case here)

(
var sd;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\sineWEnvDists, {arg freq, envDurScale = 1, ampScale, distortAmt, distortType;
		var osc, env, envGen, distortions, out;
		env = Control.names([\env]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp);
		osc = osc * distortAmt;
		distortions = [osc.distort, osc.softclip, osc.tanh, osc.clip(-1, 1), osc.fold(-1, 1), osc.wrap(-1, 1)];
		out = Select.ar(distortType, distortions) * ampScale.dbamp;
		Out.ar(0, Pan2.ar(out))
	});
	
	Routine.run({
		// now - we can pass in an Env with times scaled to 1 so envDurScale will scale the times
		// appropriately - and pass our Env in with the env_ method
		// – using .distort
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(0)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;	
		// – using .sofclip		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(1)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;
		// – using .tanh: analog-like distortion 
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(2)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		// – using .clip: turn a signal into a square wave
		5.0.wait;		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(3)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		// – using .fold: make a signal bounce back
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(4)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		// – using .wrap: treat the amplitude 'space' as a circular space
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(5)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;			
	
	})
})
	
)


(
var sd;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\sineWEnvDists, {arg freq, envDurScale = 1, ampScale, distortAmt, distortType;
		var osc, env, envGen, distortions, out;
		env = Control.names([\env]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0);
		osc = osc * distortAmt;
		distortions = [osc.distort, osc.softclip, osc.tanh, osc.clip(-1, 1), osc.fold(-1, 1), osc.wrap(-1, 1)];
		out = Select.ar(distortType, distortions) * ampScale.dbamp *  envGen.dbamp;
		Out.ar(0, Pan2.ar(out))
	});
	
	Routine.run({
		// now - we can pass in an Env with times scaled to 1 so envDurScale will scale the times
		// appropriately - and pass our Env in with the env_ method
		// – using .distort
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(0)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;	
		// – using .sofclip		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(1)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;
		// – using .tanh: analog-like distortion 
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(2)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		// – using .clip: turn a signal into a square wave
		5.0.wait;		
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(3)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		// – using .fold: make a signal bounce back
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(4)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;
		5.0.wait;		
		// – using .wrap: treat the amplitude 'space' as a circular space
		sd.note(0.1, 4.0).freq_(440).envDurScale_(4.0).ampScale_(-12)
			.distortAmt_(100).distortType_(5)
			.env_(Env([-90, -12, -24, -36, -90], [0.02, 0.08, 0.6, 0.3], \exp)).play;			
	
	})
})
	
)

// Also check out: SelectX and SelectXFocus



/*
-----
Basic Waveshaping - aka non-linear distortion, using a transfer function
-----
*/


// Wave shaping transfer functions often use Chevybeshev polynomials to generate harmonics
// from a sin tone input... below is a typical usage
// normalize, wavetable and clear all set to 1

// have a look at the transfer functions we'll use:
b = CtkBuffer.buffer(1024, 1, s).load;
b.cheby(0.0, 1, 1, 0, [1, 0.5, 0.1, 0.5, 0.7])
b.plot
b.cheby(0.0, 1, 0, 0, [1, 0.5, 0.1, 0.5, 0.7, 0.2, 0.8, 0.1, 0.05, 0.64]);
b.plot
b.free



(
Server.default = s = Server.internal.boot;
s.scope;

s.waitForBoot({
	Routine.run({
		var cond;
		var myBuffers, buffer1, buffer2;
		var sd;
		
		// set up a Condition for the sync. Server messages will tell this class 
		// if the Server is done loading memory
		cond = Condition.new;

		// declare and load the CtkBuffers
		buffer1 = CtkBuffer.buffer(1024, server: s).load;
		buffer2 = CtkBuffer.buffer(1024, server: s).load;

		// fill the with a transfer function:
		buffer1.cheby(0.0, 1, 1, 1, [1, 0.5, 0.1, 0.5, 0.7]);
		buffer2.cheby(0.0, 1, 1, 1, [1, 0.5, 0.1, 0.5, 0.7, 0.2, 0.8, 0.1, 0.05, 0.64]);
		
	
		// wait until the server confirms that the buffers where loaded
		s.sync(cond);
		
		// Post a message when we move onto the rest of the code ...
		"Buffers are loaded!".postln;
		
		// create myBuffers and initialize its data to the three CtkBuffers
		myBuffers = [buffer1, buffer2];
		
		// clean up with CmdPeriod
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})
		});
	
		sd = CtkSynthDef(\sineWEnvWShape, {arg buffer, freq, envDurScale = 1, ampScale;
			var source, outEnv, srcEnv, outEnvGen, srcEnvGen, shaper, out;
			// an envelope for the source sound, before the waveshaping process
			srcEnv = Control.names([\srcEnv]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
			srcEnvGen = EnvGen.kr(srcEnv, timeScale: envDurScale);
			// an envelope for after the waveshaping process
			outEnv = Control.names([\outEnv]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
			outEnvGen = EnvGen.kr(outEnv, timeScale: envDurScale);
			// multi-channel expansion to generate 2 sines
			source = SinOsc.ar([freq, freq * 1.1], 0, srcEnvGen.dbamp).sum * 0.5;
			// waveshaper
			shaper = Shaper.ar(buffer, source) ;
			// IMPORTANT: protect your speakers from DC offset!
			shaper = LeakDC.ar(shaper) * outEnvGen.dbamp * ampScale.dbamp;
			Out.ar(0, Pan2.ar(shaper))
		});
	
	
		// now, make some noise
		Routine.run({
			// now: we can pass in an Env with times scaled to 1 so envDurScale will scale the times
			// appropriately - and pass two Envs, one for pre-waveshaping, one for post-
			sd.note(0.1, 8.0).freq_(440).envDurScale_(8.0).ampScale_(-12)
				.buffer_(buffer1)
				.srcEnv_(Env([-90, -0.1, -12, -36, -90], [1, 100, 100, 50].normalizeSum, \exp))
				.outEnv_(Env([-90, -0.1, -6, -12, -90], [1, 100, 300, 50].normalizeSum, \exp))
				.play;
			9.wait;	
			sd.note(0.1, 8.0).freq_(440).envDurScale_(8.0).ampScale_(-12)
				.buffer_(buffer2)
				.srcEnv_(Env([-90, -0.1, -12, -36, -90], [1, 100, 100, 50].normalizeSum, \exp))
				.outEnv_(Env([-90, -0.1, -6, -12, -90], [1, 100, 300, 50].normalizeSum, \exp))
				.play;	
		});

	})
})
)



/*
-----
Custom buffers using Envelopes: wavetable synthesis
-----
*/

b = CtkBuffer.buffer(1024, 1, s).load;
// not quite a sinewave:
b.fillWithEnv(0.0, Env([0, 1, -1, 0], [1, 1, 1].normalizeSum, \sin)).plot
// square waves:
b.fillWithEnv(0.0, Env([0, 1, -1, 0], [1, 1, 1].normalizeSum, \step)).plot
// something else
b.fillWithEnv(0.0, Env([0, 1, 0.2, -0.5, 0.9, -1, 0], [1, 1, 10, 4, 2, 0.5].normalizeSum, \sin)).plot
b.free


// First, using a wavetable oscillator with a custom-made buffer
// this is a tweaked example from class 4
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
		// Note: you cannot create much longer wavetables using the .fillWithEnv method, as there are limitations as to how many numbers you can send to the server like that
		buffer1 = CtkBuffer.buffer(1024, server: s).load;
		buffer2 = CtkBuffer.buffer(1024, server: s).load;
		buffer3 = CtkBuffer.buffer(1024, server: s).load;
		
		
		// now, do something with the CtkBuffers, and sync again
		// the CtkBuffer has a very handy method, .fillWithEnv
		// args: (time, env, wavetable)
		buffer1.fillWithEnv(0.0, Env([0, 1, -1, 0], [1, 1, 1].normalizeSum, \sin), 1);
		buffer2.fillWithEnv(0.0, Env([0, 1, 0, -1, 0], [1, 1, 1, 1].normalizeSum, \step));
		buffer3.fillWithEnv(0.0, Env([0, 1, 0.2, -0.5, 0.9, -1, 0], [1, 1, 10, 4, 2, 0.5].normalizeSum, \sin), 1);
		
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
			sd.note(0.1, 6.0).buffer_(buffer3).freq_(558).dur_(6).play;
		})

	})
});
	
)



/*
-----
Waveshaping with custom buffers
-----
*/

// ATTN: it is quite easy to make nasty sounds like that which can hurt your ears, your speakers and which can create weird numbers that will make the server or your audio driver crash, possibly needing to restart the server, SC, even your computer - the joys of experimantal sounds! Use at your own risk!


(
Server.default = s = Server.internal.boot;
s.scope;

s.waitForBoot({
	Routine.run({
		var cond;
		var myBuffers, buffer1, buffer2, buffer3, buffer4;
		var sd;
		
		// set up a Condition for the sync. Server messages will tell this class 
		// if the Server is done loading memory
		cond = Condition.new;

		// declare and load the CtkBuffers
		// Note: you cannot create much longer wavetables using the .fillWithEnv method, as there are limitations as to how many numbers you can send to the server like that
		buffer1 = CtkBuffer.buffer(1024, server: s).load;
		buffer2 = CtkBuffer.buffer(1024, server: s).load;
		buffer3 = CtkBuffer.buffer(1024, server: s).load;
		buffer4 = CtkBuffer.buffer(1024, server: s).load;
		
		
		// now, do something with the CtkBuffers, and sync again
		// the CtkBuffer has a very handy method, .fillWithEnv
		// args: (time, env, wavetable)
		buffer1.fillWithEnv(0.0, Env([0, 1, -1, 0], [1, 1, 1].normalizeSum, \sin), 1);
		buffer2.fillWithEnv(0.0, Env([1, 0.2, -0.5, 0, 0.1, 0.9, -1], [1, 1, 10, 8, 2, 1].normalizeSum, \sin), 1);
		buffer3.fillWithEnv(0.0, Env([0, 1, -1, 0], [1, 1, 1].normalizeSum, \step), 1);
		buffer4.fillWithEnv(0.0, Env([0, 0.1, 0.5, 1, 0, -1, -0.5, -0.1, 0], [10, 1, 6, 1, 1, 6, 1, 10].normalizeSum, \wel), 1);		// NOTE: be careful with your transfer functions, keeping in mind, what they correspond to. It's usually a good practice to have the middle point of your buffer be 0, as then silences remain silent. For more on the effect of transfer function shapes, see Dodge 5.2		
		
		// wait until the server confirms that the buffers where loaded
		s.sync(cond);
		
		// Post a message when we move onto the rest of the code ...
		"Buffers are loaded!".postln;
		
		// create myBuffers and initialize its data to the three CtkBuffers
		myBuffers = [buffer1, buffer2, buffer3, buffer4];
		
		// clean up with CmdPeriod
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})
		});
	
		sd = CtkSynthDef(\sineWEnvWShape, {arg buffer, freq, envDurScale = 1, ampScale;
			var source, outEnv, srcEnv, outEnvGen, srcEnvGen, shaper, out;
			// an envelope for the source sound, before the waveshaping process
			srcEnv = Control.names([\srcEnv]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
			srcEnvGen = EnvGen.kr(srcEnv, timeScale: envDurScale);
			// an envelope for after the waveshaping process
			outEnv = Control.names([\outEnv]).kr(Env.newClear(8)); // space for an 8 breakpoint Env
			outEnvGen = EnvGen.kr(outEnv, timeScale: envDurScale);
			// multi-channel expansion to generate 2 sines
			source = SinOsc.ar([freq, freq * 1.1], 0, srcEnvGen.dbamp).sum * 0.5;
			// waveshaper
			shaper = Shaper.ar(buffer, source) ;
			// IMPORTANT: protect your speakers from DC offset!
			shaper = LeakDC.ar(shaper) * outEnvGen.dbamp * ampScale.dbamp;
			Out.ar(0, Pan2.ar(shaper))
		});
	
	
		// now, make some noise
		Routine.run({
			// now: we can pass in an Env with times scaled to 1 so envDurScale will scale the times
			// appropriately - and pass two Envs, one for pre-waveshaping, one for post-
			sd.note(0.1, 8.0).freq_(440).envDurScale_(8.0).ampScale_(-12)
				.buffer_(buffer1)
				.srcEnv_(Env([-90, -0.1, -12, -36, -90], [1, 100, 100, 50].normalizeSum, \exp))
				.outEnv_(Env([-90, -0.1, -6, -12, -90], [1, 100, 300, 50].normalizeSum, \exp))
				.play;
			9.wait;	
			sd.note(0.1, 8.0).freq_(440).envDurScale_(8.0).ampScale_(-12)
				.buffer_(buffer2)
				.srcEnv_(Env([-90, -0.1, -12, -36, -90], [1, 100, 100, 50].normalizeSum, \exp))
				.outEnv_(Env([-90, -0.1, -6, -12, -90], [1, 100, 300, 50].normalizeSum, \exp))
				.play;	
			9.wait;	
			// lo-fi!
			sd.note(0.1, 8.0).freq_(440).envDurScale_(8.0).ampScale_(-12)
				.buffer_(buffer3)
				.srcEnv_(Env([-90, -0.1, -12, -36, -90], [1, 100, 100, 50].normalizeSum, \exp))
				.outEnv_(Env([-90, -0.1, -6, -12, -90], [1, 100, 300, 50].normalizeSum, \exp))
				.play;		
			9.wait;	
			// softer parts become more distorted / richer harmonically
			sd.note(0.1, 8.0).freq_(440).envDurScale_(8.0).ampScale_(-12)
				.buffer_(buffer4)
				.srcEnv_(Env([-90, -0.1, -12, -36, -90], [1, 100, 100, 50].normalizeSum, \exp))
				.outEnv_(Env([-90, -0.1, -6, -12, -90], [1, 100, 300, 50].normalizeSum, \exp))
				.play;			
		});

	})
})
)




/* 
READING:
Dodge 5.2
*/

