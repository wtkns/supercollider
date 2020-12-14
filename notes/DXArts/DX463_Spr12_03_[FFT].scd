/* Intro to SuperCollider's FFT capabilities */
s = Server.internal;
Server.default = s;
s.boot;

// Basic FFT/IFFT analysis / resynth
// all based on default soundfile
(
a = CtkSynthDef(\fft1, {arg gate = 1, playbuf, fftbuf, hop = 0.5, 
		wintype = 0, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	// chain will equal the fftbuf number whenever an
	// FFT frame is ready. Otherwise, it will be -1
	// these examples use the default Welch window
	// and 2 overlaps.
	// Do the analysis
	chain = FFT(fftbuf, play, hop, wintype);
	// IFFT to resynthesize
	out = IFFT(chain);
	Out.ar(0, out.dup * env); // send out stereo
	});
)
	
b = CtkBuffer.buffer(2048).load; // will have 1024 bins
c = CtkBuffer.playbuf("~/SND/a11wlk01.wav".standardizePath).load;

// test it out... it works!
z = a.note(duration: c.duration).playbuf_(c).fftbuf_(b).play;
// test with different windows
// Rectangular window: noisy (avoid!)
z = a.note(duration: c.duration).playbuf_(c).fftbuf_(b).wintype_(-1).play; 
// Hanning window: fluttery
z = a.note(duration: c.duration).playbuf_(c).fftbuf_(b).wintype_(1).play; 
// a lot better if hop size is 1/4 of the window
z = a.note(duration: c.duration).playbuf_(c).fftbuf_(b).wintype_(1).hop_(0.25).play; 

b.free; c.free;

/* The basis of most SuperCollider FFT processing is done between the FFT and IFFT steps in a processing chain (which is why the variable 'chain' is often used in the examples). Here are a few of the capabilities. ALL of these processes can be mixed and combined together to create more and more complex transformations. */

// look at spectral results
FreqScope.new(800, 400, 0);

// PV_BrickWall - zeros out bins. A basic FFT filter. 'wipe'
// values > 0 creates a high pass effect (clearing bins from the
// bottom up). < 0 is a low pass (clearin bins from the top 
// down)
(
a = CtkSynthDef(\fft2a, {arg gate = 1, playbuf, fftbuf, wipe = 0.0,
		amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_BrickWall(chain, wipe);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)

// window size (FFT size) will be 2048
// will have 1024 frequency bins between 0Hz and Nyquist
b = CtkBuffer.buffer(2048).load; 
c = CtkBuffer.playbuf("~/SND/mozart.aiff".standardizePath).load;

// use as a high pass filter
// cutoff of 0.5 of "nyquist"
// s.sampleRate * 0.5 * 0.5
// or could calculate the value as:
f =  { arg freq; 2 * freq/s.sampleRate };
// 10KHz cutoff
z = a.note.playbuf_(c).fftbuf_(b).wipe_(f.value(10000)).play; 
// 5KHz cutoff
z.wipe_(f.value(5000)); 
// 2500Hz cutoff
z.wipe_(f.value(2500)); 
// 1250Hz cutoff
z.wipe_(f.value(1250)); 
// 625Hz cutoff
z.wipe_(f.value(625)); 
// 300Hz cutoff
z.wipe_(f.value(300)); 
// 150Hz cutoff
z.wipe_(f.value(150)); 
// 75Hz cutoff
z.wipe_(f.value(75)); 
// 30Hz cutoff
z.wipe_(f.value(30)); 
// 0Hz cutoff
z.wipe_(f.value(0)); 
z.release;

// as a low pass filter
// note that you we have to use negative values
// in a scale where -1 corresponds to 0Hz and -0.5 to Nyquist
// 10000Hz
z = a.note.playbuf_(c).fftbuf_(b).wipe_(f.value(10000)-1).play; 
// 1000Hz
z.wipe_(f.value(1000)-1); 
// 100Hz
z.wipe_(f.value(100)-1); 
z.release;

// combine two of them, to act as a bandpass or bandreject
(
a = CtkSynthDef(\fft2b, {arg gate = 1, playbuf, fftbuf, 
		hp = 0.0, lp = 0.0, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_BrickWall(chain, hp);
	chain = PV_BrickWall(chain, lp);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)
// high pass, then low pass
// band 6KHz to 8KHz
z = a.note.playbuf_(c).fftbuf_(b).hp_(f.value(6000)).lp_(f.value(8000)-1).play; 
z.amp_(24.dbamp);
z.release;

// let's say you want an 80Hz band around 440 Hz:
z = a.note.playbuf_(c).fftbuf_(b).hp_(f.value(440-40)).lp_(f.value(440+40)-1).play; 

// let's make the band wider
z.hp_(f.value(440-100)).lp_(f.value(440+100)-1); 
// and even wider
z.hp_(f.value(440-200)).lp_(f.value(440+200)-1); 
z.release;

/* PV_MagAbove and PV_MagBelow do a similar thing in the magnitude realm */
(
a = CtkSynthDef(\fft3a, {arg gate = 1, playbuf, fftbuf, mag = 0.0, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_MagAbove(chain, mag);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)

// Passes only bins whose magnitude is above the mag threshold
z = a.note.playbuf_(c).fftbuf_(b).mag_(10).play; 
z.mag_(50); 
z.mag_(150); 
z.release;

// PV_MagBelow (probably more usable) */
(
a = CtkSynthDef(\fft3b, {arg gate = 1, playbuf, fftbuf, 
		mag = 0.0, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_MagBelow(chain, mag);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)	
// Passes only bins whose magnitude is below the mag threshold
z = a.note.playbuf_(c).fftbuf_(b).mag_(150).play;
z.mag_(50);
z.mag_(20);
z.mag_(2).amp_(6.dbamp);
z.mag_(0.2).amp_(24.dbamp);

z.release;

/* PV_BinShift - doesn't sound very good on its own, but not bad as part of a chain where bins have been narrowed down */
(
a = CtkSynthDef(\fft3c, {arg gate = 1, playbuf, fftbuf, hp = 0.0,
		lp = 0.0, stretch = 1, shift = 0, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_BrickWall(chain, hp);
	chain = PV_BrickWall(chain, lp);
	chain = PV_BinShift(chain, stretch, shift);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)	

// 5KHz to 6KHz band
z = a.note.playbuf_(c).fftbuf_(b).hp_(f.value(5000)).lp_(f.value(6000)-1).amp_(6.dbamp).play; 

// stretch the bins
// scale them by 1/4 of their location (frequency)
z.stretch_(0.25).amp_(18.dbamp); 
// up
z.stretch_(1.5);
z.stretch_(2.5);
// wider band with both stretching and shifting
z.hp_(f.value(3000)).lp_(f.value(8000)-1).stretch_(0.25).shift_(100);
// twice their location 
z.stretch_(2).shift_(0);
// 1.2 times and shifted 50 bins down 
z.stretch_(1.2).shift_(-50);
// half their location and shifted 50 bins up
z.stretch_(0.25).shift_(50);
z.release;

// PV_MagSmear averages a bin's magnitude with its neighbors (spectral distrotion)
(
a = CtkSynthDef(\fft4a, {arg gate = 1, playbuf, fftbuf, 
		nBins = 0, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_MagSmear(chain, nBins);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)	

// play back as is
z = a.note(duration: c.duration).playbuf_(c).fftbuf_(b).play;
// average 1 bin around each bin
z = a.note(duration: c.duration).playbuf_(c).fftbuf_(b).nBins_(1).play;
// 	average 10 bins around each bin
z = a.note(duration: c.duration).playbuf_(c).fftbuf_(b).nBins_(10).play;
	
// again - can be more intersting with bands of frequency
(
a = CtkSynthDef(\fft4b, {arg gate = 1, playbuf, fftbuf, hp = 0.0,
		lp = 0.0, nBins = 0, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_BrickWall(chain, hp);
	chain = PV_BrickWall(chain, lp);
	chain = PV_MagSmear(chain, nBins);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)

// 1KHz to 2KHz band	
z = a.note.playbuf_(c).fftbuf_(b).hp_(f.value(1000)).lp_(f.value(2000)-1).play; 
// average over 10 bins
z.nBins_(10); 
// 500Hz to 4KHz band	
z.hp_(f.value(500)).lp_(f.value(4000)-1);
// average over 30 bins
z.nBins_(30);
z.release;

// Some FFT process with randomness

// PV_BinScramble: Randomizes the order of the bins
// wipe - scrambles more bins as wipe moves from zero to one.
// width - a value from zero to one, indicating the maximum randomized distance of a bin from its
// original location in the spectrum.
// trig - a trigger selects a new random ordering.
(
a = CtkSynthDef(\fft5a, {arg gate = 1, playbuf, fftbuf, wipe = 0.0,
		width = 0, t_trig = 1, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_BinScramble(chain, wipe, width, t_trig);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)
	
// original with no processing
z = a.note.playbuf_(c).fftbuf_(b).wipe_(0.0).width_(0.0).t_trig_(1).play;
// start with 0.5 for both wipe and width, 
// trig forces a new random order of the bins
z.wipe_(0.5).width_(0.5).t_trig_(1);
z.t_trig_(1);
z.t_trig_(1);
z.t_trig_(1);
// less random bins, but spread wider
z.wipe_(0.1).width_(0.8).t_trig_(1);
z.t_trig_(1);
// more random bins, smaller width
z.wipe_(0.8).width_(0.1).t_trig_(1);
z.t_trig_(1);

// all out
z.wipe_(1.0).width_(1.0).t_trig_(1);
z.t_trig_(1);

z.release;

// PV_RandComb: Randomly clear bins
// wipe - clears bins from input in a random order as wipe goes from 0 to 1.
// trig - a trigger selects a new random ordering.
(
a = CtkSynthDef(\fft5b, {arg gate = 1, playbuf, fftbuf, wipe = 0.0,
		t_trig = 1, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_RandComb(chain, wipe, t_trig);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)	

// original sound
z = a.note.playbuf_(c).fftbuf_(b).wipe_(0.0).t_trig_(1).play;

z.wipe_(0.5).t_trig_(1);
z.t_trig_(1);
z.t_trig_(1);
z.wipe_(0.9).t_trig_(1);
z.t_trig_(1);
z.t_trig_(1);

z.release;

// free the buffers
b.free; c.free;

// for more of the standard PV UGens - see here
FFT Overview

/* Extension libraries */

// PV_PartialSynthP: return only bins that are stable
// threshold - a phase value (in radians) with which to allow values to pass through or be zeroed out (pi leaves bins unchanged)
// numFrames - the number of FFT frames needed to make the above decision
//	initflag - if 0, all bins are zeroed out while the initial is calculated, if 1, all bins pass through.
(
a = CtkSynthDef(\fft6a, {arg gate = 1, playbuf, fftbuf, thresh = pi, 
		numFrames = 2, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_PartialSynthP(chain, thresh, numFrames);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)
	
b = CtkBuffer.buffer(2048).load; 
c = CtkBuffer.playbuf("~/SND/femvoice.wav".standardizePath).load;

// using 4 frames
z = a.note.playbuf_(c).fftbuf_(b).numFrames_(4).play;
// move gradually to transients in frequency
z.thresh_(0.5pi);
z.thresh_(0.25pi);
z.thresh_(0.125pi);
z.thresh_(0.0625pi);
z.thresh_(0.01pi).amp_(6.dbamp);
z.thresh_(0.001pi).amp_(12.dbamp);

z.release;

// same using 16 frames
z = a.new.playbuf_(c).fftbuf_(b).numFrames_(16).play;
z.thresh_(0.5pi);
z.thresh_(0.25pi);
z.thresh_(0.125pi);
z.thresh_(0.0625pi);
z.thresh_(0.01pi).amp_(6.dbamp);
z.thresh_(0.001pi).amp_(12.dbamp);

z.release;

// PV_NoiseSynthP: complementary of the previous one (pi is full cut)
(
a = CtkSynthDef(\fft6b, {arg gate = 1, playbuf, fftbuf, thresh = pi, 
		numFrames = 2, amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_NoiseSynthP(chain, thresh);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)

z = a.note.playbuf_(c).fftbuf_(b).numFrames_(4).play;
z.thresh_(0.25pi);
z.thresh_(0.01pi);
z.thresh_(0.75pi);
z.thresh_(0.9pi).amp_(6.dbamp);

z.release;

// PV_MaxMagN: return the N bins with higher magnitude
// range is 	0 through (FFTsize / 2) - 2
(
a = CtkSynthDef(\fft7a, {arg gate = 1, playbuf, fftbuf, nBins = 1,
		amp = 1;
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_MaxMagN(chain, nBins);
	out = IFFT(chain);
	Out.ar(0, out.dup * amp); 
	});
)
	
z = a.note.playbuf_(c).fftbuf_(b).nBins_(1022).play;
z.nBins_(512);
// less noise!
z.nBins_(256); 
// only a few
z.nBins_(16);
// only one
z.nBins_(1);

z.release;

// PV_MinMagN: return the N bins with lower magnitude
// range is 	0 through (FFTsize / 2) - 2
(
a = CtkSynthDef(\fft7b, {arg gate = 1, playbuf, fftbuf, nBins = 1,
		amp = 1;	
	var play, chain, out, env;
	env = EnvGen.kr(Env([0, 1, 0], [0.1, 0.1], \sin, 1), 
		gate, doneAction: 2) * amp;
	play = PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), 
		loop: 1);
	chain = FFT(fftbuf, play);
	chain = PV_MinMagN(chain, nBins);
	out = IFFT(chain);
	Out.ar(0, out.dup * env); 
	});
)
	
z = a.note.playbuf_(c).fftbuf_(b).nBins_(1022).play;
z.nBins_(1000);
z.nBins_(900).amp_(12.dbamp);
z.free;

// free buffers
b.free; c.free;

// PV_BinDelay - 'Spectral Delay' plugin for SuperCollider. 
// delay times and feedback amounts are read from buffers!

(
var fftbuf, deltimebuf, fbbuf, playbuf;
var score, fftnote, bufwriters, maxdel;

score = CtkScore.new;

// the max delay time in seconds

maxdel = 0.5;

// prepare buffers and add to score

fftbuf = CtkBuffer.buffer(512);
deltimebuf = CtkBuffer.buffer(256); // half the FFT size
fbbuf = CtkBuffer.buffer(256);
playbuf = CtkBuffer.playbuf("~/SND/femvoice.wav".standardizePath);

score.add(fftbuf, deltimebuf, fbbuf, playbuf);

// we'll process a simple looping sample. This synth will have the sample and the base FFT process
fftnote = CtkSynthDef(\bindel, {arg fftbuf, delbuf, fbbuf, playbuf, maxdel, notedur;
	var play, chain, out;
	play = PlayBuf.ar(1, playbuf, loop: 1);
	chain = FFT(fftbuf, play, 0.5); 
	//chain, maxdel, delbuf, fbbuf, overlaps
	chain = PV_BinDelay(chain, maxdel, delbuf, fbbuf, 0.5);
	Out.ar(0, Pan2.ar(IFFT(chain) * EnvGen.kr(Env([0, 1, 1, 0], [0.02, 0.96, 0.02]), timeScale: notedur)));
});

// this synth will write data for one bin - one value to a slot in delbuf, another to fb 
bufwriters = CtkSynthDef(\bufwrite, {arg maxdel, bin, delbuf, fbbuf;
	// first - write out delay values 
	BufWr.kr(
		// the signal that will write values to the buffer... it is enveloped to 
		// have no effect at first, slowly bring the effect in over 20 seconds...
		// it will run for 10, then shut off again
		LFNoise1.kr(0.2).range(0, maxdel) * 
			EnvGen.kr(Env([0, 0, 1, 1, 0, 0], [2, 20, 10, 2, 2], [0, 4, 0, -4, 0])),
		delbuf, 
		bin);
	// for feedback values - do a similar thing, but modulate the bounds of the range 
	BufWr.kr(
		LFNoise1.kr(0.2).range(
			EnvGen.kr(Env([0, 0, 0.8, 0.8, 0, 0], [2, 20, 10, 2, 2], [0, 4, 0, -4, 0])),
			EnvGen.kr(Env([0, 0, 1.0, 1.0, 0, 0], [2, 20, 10, 2, 2], [0, 4, 0, -4, 0]))),
		fbbuf, 
		bin);
});

// add the base note to the score
score.add(
	fftnote.note(1.0, 36).fftbuf_(fftbuf).delbuf_(deltimebuf).fbbuf_(fbbuf)
		.playbuf_(playbuf).maxdel_(maxdel).notedur_(36));

// now - add in 256 buf writers (one for each bin)
256.do({arg thisBin;
	score.add(
		bufwriters.note(1.0, 36).maxdel_(maxdel).bin_(thisBin).delbuf_(deltimebuf).fbbuf_(fbbuf)
	)
});

// write it out!
score.write("~/Desktop/test.aif".standardizePath, options: ServerOptions.new.numOutputBusChannels_(2));
)
	
	
// listen to it
SFPlayer.new("~/Desktop/test.aif".standardizePath).gui;


/* MY fun GUI example - old OSC style messaging though... just fun to play with */


(	
Routine.run({	
	// use as multislider - del time vals on top, feedback on the bottom
	// max delay time is 1 second, delaytime and fb are initialized to 0.0
	// and are controlled by the GUI. The multi-slider on the top controlsÊ
	// each bins delay time, the bottom controls FB.
	
	var size, awin, bsl, car, dar, fsl, maxdel, synth, cond;
	
	size = 128;
	maxdel = 0.5;
	cond = Condition.new;
	s.sendMsg(\b_alloc, b=s.bufferAllocator.alloc(1), size * 2);
	s.sendMsg(\b_alloc, c=s.bufferAllocator.alloc(1), size);
	s.sendMsg(\b_alloc, d=s.bufferAllocator.alloc(1), size);
	s.sendMsg(\b_allocRead, e = s.bufferAllocator.alloc(1), "~/SND/femvoice.wav".standardizePath);
	
	y = Array.fill(size, {0.0});
	s.sendBundle(0.1, [\b_setn, d, 0, size] ++ y);
	
	z = Array.fill(size, {arg i; 0.0});
	s.sendBundle(0.1, [\b_setn, c, 0, size] ++ z);
	s.sync(cond);
	
	synth = SynthDef("help-noopFFT", { arg inbus, out=0, playbuf, bufnum=0, dels=0, fb=0;
		var in, chain;
		in = Impulse.ar(0.33);
		in = PlayBuf.ar(1, playbuf, loop: 1);
		chain = FFT(bufnum, in, 0.25);
		chain = PV_BinDelay(chain, maxdel, dels, fb, 0.25);
		Out.ar(out,Ê
			in + IFFT(chain) // inverse FFT
		);
	}).play(s,[\out,0,\bufnum,b,\dels, c, \fb, d, \inbus, s.options.numOutputBusChannels,
		\playbuf, e]);
	{
	awin = GUI.window.new("test", Rect(200 , 450, 10 + (size * 1), 10 + (size * 2)));
	awin.view.decorator =Ê FlowLayout(awin.view.bounds);
	
	bsl = GUI.multiSliderView.new(awin, Rect(0, 0, size * 1, size * 1));
	bsl.action = {arg xb; ("Deltime index: " ++ xb.index ++" value: " ++Ê
			(xb.currentvalue * maxdel)).postln;
		s.sendMsg(\b_set, c, xb.index, xb.currentvalue * maxdel);
		};
	
	fsl = GUI.multiSliderView.new(awin, Rect(0, 0, size * 1, size * 1));
	fsl.action = {arg xb; ("FB index: " ++ xb.index ++" value: " ++ xb.currentvalue).postln;
		s.sendMsg(\b_set, d, xb.index, xb.currentvalue);
		};
	
	car = Array.new;
	size.do({arg i;
		car = car.add(0);
	});
	bsl.value_(car);
	
	dar = Array.new;
	size.do({arg i;
		dar = dar.add(0);
	});
	fsl.value_(car);
	
	bsl.xOffset_(5);
	bsl.thumbSize_(12.0);
	fsl.xOffset_(5);
	fsl.thumbSize_(12.0);
	
	// value axis size of each blip in pixels
	bsl.valueThumbSize_(15.0);
	// index axis size of each blip in pixels
	bsl.indexThumbSize_( bsl.bounds.width / car.size );
	bsl.gap = 0;
	
	// value axis size of each blip in pixels
	fsl.valueThumbSize_(15.0);
	// index axis size of each blip in pixels
	fsl.indexThumbSize_( fsl.bounds.width / dar.size );
	fsl.gap = 0;
	
	awin.front;
	
	awin.onClose_({
		synth.free;
		s.sendMsg(\b_free, b);
		s.sendMsg(\b_free, c);
		s.sendMsg(\b_free, d);
		s.sendMsg(\b_free, e);
		})
	}.defer;
	})
)

// PV_BinBufRd and PVAna

// PVAna is a class that will run a NRT analysis of a mono soundfile for you
a = PVAna("~/SND/femvoice.wav".standardizePath); // give it the soundfile to analyze
// ana(pathToSaveTo.scpv, fftSize, winType, hop)
a.ana("~/SND/femvoice.scpv".standardizePath, 1024, 1, 0.25); // hanning, 0.25 hop tends to work better here

(
var note;
var anabuf, playbuf;

anabuf = CtkBuffer.playbuf("~/SND/femvoice.scpv".standardizePath).load;

playbuf = CtkBuffer.playbuf("~/SND/femvoice.wav".standardizePath).load;


note = CtkSynthDef("pvplay", { arg out=0, anabuf=1, playbuf, dur, clear = 0.0;
	var in, chain, bufnum, point;
	bufnum = LocalBuf.new(1024);
	point = LFNoise2.kr(0.2).range(0, 1);
	// FFT of the original
	chain = FFT(bufnum, PlayBuf.ar(1, playbuf, BufRateScale.kr(playbuf), loop: 1), 0.25, 1);
	// replaces every other bin with data from the random time pointer... 
	// start at bin 1, skip 2, grab 500 bins
	chain = PV_BinBufRd(chain, anabuf, point, 1, 2, 500);
	// IFFT
	Out.ar(out, Pan2.ar(
		IFFT(chain, 1) * EnvGen.kr(Env([0, 1, 1, 0], [0.02, 0.96, 0.02], \sin), timeScale: dur)));
	});

note.note(1, 20).anabuf_(anabuf).playbuf_(playbuf).clear_(0).dur_(20).play;
CmdPeriod.doOnce({anabuf.free; playbuf.free; "Buffers freed".postln;});
)

