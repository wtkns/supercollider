/* real-world input - buffers and sound input */

(
var soundfile, sndBuf, cmdPeriod;
var playBuffer;

Server.default = s = Server.internal.boot;

s.waitForBoot({	
	Routine.run({
	/* first - create a buffer and tell it that you want to read the whole sound 
	into memory with the *playbuf method: change the path point to a soundfile on 
	your computer */
	
	sndBuf = CtkBuffer.playbuf("~/SND/FluteMono.aif".standardizePath);
	
	cmdPeriod = {
		sndBuf.free;
		"Command Period freed buffers!".postln;
	};
	
	CmdPeriod.doOnce(cmdPeriod);
	
	sndBuf.load; // load the buffer to memory ...
	s.sync;		 // and pause execution until the buffer is loaded
	
	// POST some info about he sound if you want to...
	// the CtkBuffer object can be polled for different information that 
	// may be useful:
	("Info about soundfile at" + sndBuf.path + 
		"Duration:"+ sndBuf.duration +
		"SampleRate: " + sndBuf.sampleRate +
		"Num Channels" + sndBuf.numChannels).postln;
	
	/* now - using it. For our immediate purposes, PlayBuf is the way to go. You can 
	control start time and playback speed */
	
	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1;
		var src, env;
		env = EnvGen.kr(
			Env([0, 1, 1, 0], [0.1, BufDur.kr(buffer) - 0.2, 0.1], \sin));
		// PlayBuf expects the number of channels to match those in the buffer
		// this will ONLY play mono files!
		src = PlayBuf.ar(1, // mono
			buffer, // the buffer you created above
			rate * BufRateScale.kr(buffer), // the rate adjust for SR of file
			1, // a trigger... ignore for now
			startPos * BufSampleRate.kr(buffer), // adjust startPos in sec to samples
			1 // loop, 0 is no, 1 is yes
			);
		Out.ar(0, Pan2.ar(src * env));
	});

	playBuffer.note(0.1, sndBuf.duration).buffer_(sndBuf).startPos_(0).rate_(1).play;
	playBuffer.note(0.1, sndBuf.duration).buffer_(sndBuf).startPos_(0).rate_(2).play;
	

	})
})
)


/* simple CtkSynthDef to bring sound in and ring-modulate it */

// ~something is an Environment variable - kind of like a global. 

~noteDef = CtkSynthDef(\soundInAM, {arg inBus, modFreq, gate = 1;
	var src, out, env;
	src = In.ar(inBus); // get our first input bus
	out = src * SinOsc.ar(modFreq, 0, 0.707);
	// this envelope will HOLD at the releaseNode
	env = EnvGen.kr(
		Env([0, 1, 0], [0.2, 0.2], \sin, 1), gate, doneAction: 2);
	Out.ar(0, Pan2.ar(out * env));
});

// start the note - no duration!
~note = ~noteDef.note.inBus_(s.options.numOutputBusChannels).modFreq_(440).play;

// set gate to '0' ... envelope finishes, note frees
~note.gate_(0)

