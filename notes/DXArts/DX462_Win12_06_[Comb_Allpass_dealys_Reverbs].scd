(
var buffer, playBuffer;

a = CtkSynthDef(\comb, {arg dur, buffer, playbuffer, amp, freq, gain;
	var env, sig, tap, feedin, delaytime;
	env = EnvGen.kr(
		Env([0, amp, amp, 0], [0.05, dur - 0.1, 0.05]));
	feedin = LocalIn.ar(1);
	delaytime = freq.reciprocal;
	sig = PlayBuf.ar(1, playbuffer);
	RecordBuf.ar(sig + (feedin * gain), buffer);
	tap = Tap.ar(buffer, 1, delaytime - ControlRate.ir.reciprocal);
	LocalOut.ar(tap);
	Out.ar(0, tap * env);
	});

b = CtkSynthDef(\combvar, {arg dur, buffer, playbuffer, amp, freq, gain, skiptime;
	var env, sig, comb, maxdeltime, decaytime, delaytime;
	env = EnvGen.kr(
		Env([0, amp, amp, 0], [0.05, dur - 0.1, 0.05]));
	delaytime = freq.reciprocal; // turn freq into delaytimes
	maxdeltime = 0.25; // allow up to 1/4 of a second of delay 
	//turn gain vals into ringtimes
	decaytime = (0.001.log2 * delaytime) / gain.log2;
	sig = PlayBuf.ar(1, playbuffer, loop: 1, startPos: skiptime * 
		BufSampleRate.kr(playbuffer));
	comb = CombC.ar(sig, maxdeltime, delaytime, decaytime);
	Out.ar(0, comb * env);
	});
	
	
// once again, NRT needs to be used to show how the theory works 
// (since the control period needs to be 1) in the first example.Ê The Comb UGens 
// can be used without this constraint.Ê

playBuffer = CtkBuffer("/users/jameswatkins/samples/TrevorWishart.wav");
buffer = CtkBuffer(size: 32768);

z = CtkScore.new;
z.add(buffer, playBuffer);
z.add(
	a.note(1.0, 10).dur_(10).buffer_(buffer).playbuffer_(playBuffer).amp_(0.25)
		.freq_(400).gain_(0.895),
	b.note(12.0, 10).dur_(10).buffer_(buffer).playbuffer_(playBuffer).amp_(0.25)
		.freq_(CtkControl.env(Env([1000, 500], [10], \exp)))
		.gain_(0.99).skiptime_(0),
	b.note(23.0, 10).dur_(10).buffer_(buffer).playbuffer_(playBuffer).amp_(0.25)
		.freq_(500).gain_(CtkControl.env(Env([0.55, 0.99], [10]))).skiptime_(0),
	b.note(34.0, 10).dur_(10).buffer_(buffer).playbuffer_(playBuffer).amp_(0.25)
		.freq_(5).gain_(CtkControl.lfo(SinOsc, 0.3, 0.7, 0.9)).skiptime_(0)
	);
	
z.write("~/Desktop/test.aif".standardizePath, options: ServerOptions.new.numOutputBusChannels_(1).blockSize_(1));
)
/*
x = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui;
*/

/* Allpass delays */

(
var score, note1, note2, note3, buffer, playBuffer;

note1 = CtkSynthDef(\allpass, {arg dur, buffer, playbuffer, amp, delaytime, gain;
	var env, sig, tap, feedin;
	env = EnvGen.kr(
		Env([0, amp, amp, 0], [0.05, dur - 0.1, 0.05]));
	feedin = LocalIn.ar(1);
	sig = PlayBuf.ar(1, playbuffer);
	RecordBuf.ar(sig + (feedin * gain), buffer);
	tap = Tap.ar(buffer, 1, delaytime - ControlRate.ir.reciprocal);
	LocalOut.ar(tap);
	Out.ar(0, LeakDC.ar([((sig * (gain.neg)) + tap), sig] * env));
	});
	
note2 = CtkSynthDef(\allpass2, {arg dur, playbuffer, amp, delaytime, decaytime;
	var env, sig, delay;
	env = EnvGen.kr(
		Env([0, amp, amp, 0], [0.05, dur - 0.1, 0.05]));
	sig = PlayBuf.ar(1, playbuffer);
	delay = AllpassC.ar(sig, delaytime, delaytime, decaytime);
	Out.ar(0, [delay, sig] * env);
	});

note3 = CtkSynthDef(\allpass3, {arg dur, playbuffer, amp, delaytime, decaytime;
	var env, sig, delay;
	env = EnvGen.kr(
		Env([0, amp, amp, 0], [0.05, dur - 0.1, 0.05]));
	sig = PlayBuf.ar(1, playbuffer);
	delay = AllpassC.ar(sig, delaytime, delaytime, decaytime);
	Out.ar(0, (delay + sig).dup * env);
	});

	
// once again, NRT needs to be used to show how the theory works since the control 
// period needs to be 1

score = CtkScore.new;

buffer = CtkBuffer.buffer(32768);
playBuffer = CtkBuffer("/Users/jameswatkins/samples/TrevorWishart.wav");
score.add(buffer, playBuffer);

score.add(
	note1.note(1.0, 10.0).dur_(10).buffer_(buffer).playbuffer_(playBuffer).amp_(0.5)
		.delaytime_(0.001).gain_(0.5),
	note2.note(12.0, 10.0).dur_(10).playbuffer_(playBuffer).amp_(0.5)
		.delaytime_(0.001).decaytime_(3),
	note3.note(23.0, 10.0).dur_(10).playbuffer_(playBuffer).amp_(0.5)
		.delaytime_(1).decaytime_(3),
	note3.note(34.0, 10.0).dur_(10).playbuffer_(playBuffer).amp_(0.5)
		.delaytime_(0.001).decaytime_(3)
	);
					
o = ServerOptions.new.numOutputBusChannels_(2).blockSize_(1);

score.write("~/Desktop/test2.aif".standardizePath, options: o)

)

/*
x = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui;
*/

/* Reverbs */

(
var score, rev, player, clicks;
var ferry, revbus, makeChirps;

/* A simple reverb */

/* This example shows a couple of new concepts.  First of all, you'll notice that there is no fixed duration for this note... It will run until we tell it to stop.  To do this, we will use a gate argument in the envelope.  Second, the sound needs to be routed into this SynthDef using the In UGen.  To insure that all sound gets into the reverb, the note call for the reverb and the notes playing into it need to coordinated in a different way, which you will see in the score. */

rev = CtkSynthDef(\simprev, {arg revtime = 3, inbus = 99, gate = 1;
	var in, comb1, comb2, comb3, comb4, allcombs, apass1, apass2, out, env;
	/* below is an envelope that will take 0.1 seconds to rise to 1, then revtime to decay to 0. The shape of the curves will be based on the sin function, and it will hold at releaseNode 1.  This corresponds to the level value at position 1 in the levels array of the Env. This mean that the envelope will execute up to the first level value (because arrays are zero based, this is level 1) and will hold.  To complete the envelope (and turn the note off) the gate argument in EnvGen is used.  When the gate is set to 0, the envelope will stop holding, and finish from where it was held.
	env = EnvGen.kr(Env([0, 1, 0], [0.1, revtime], \sin, 1), gate);
In.ar will read in audio data from a given audio bus.  This audio bus will correspond with the output channel used in other SynthDefs. 
*/
	in = In.ar(inbus, 2); // reads in stereo
	comb1 = CombC.ar(in, 0.0297, 0.0297, revtime);
	comb2 = CombC.ar(in, 0.0371, 0.0371, revtime);
	comb3 = CombC.ar(in, 0.0411, 0.0411, revtime);
	comb4 = CombC.ar(in, 0.0437, 0.0437, revtime);
	allcombs = comb1 + comb2 + comb3 + comb4;
	apass1 = AllpassC.ar(allcombs, 0.09683, 0.09683, 0.005);
	apass2 = AllpassC.ar(apass1, 0.03292, 0.03292, 0.0017);
	Out.ar(0, apass2)
	});

player = CtkSynthDef(\player, {arg buffer, dur = 1, amp = 1, revbus = 99, revsend = 0.1;
	var env, playbuf, out;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	playbuf = PlayBuf.ar(1, buffer, 1, loop: 1);
	out = playbuf * env;
	Out.ar(0, [out, out]); // send the output straight out
	Out.ar(revbus, [out, out] * revsend); // and send it out the the reverb
	});

clicks = CtkSynthDef(\clicks, {arg revbus, pan, amp, dur, freq, revsend;
	var env, src;
	env = EnvGen.kr(
		Env([0, 1, 0], [dur * 0.5, dur * 0.5], \sin));
	src = SinOsc.ar(freq, 0, amp) * env;
	src = Pan2.ar(src, pan);
	OffsetOut.ar(0, src);
	OffsetOut.ar(revbus, src * revsend);
	});

	
score = CtkScore.new;
ferry = CtkBuffer.playbuf("/Users/jameswatkins/samples/TrevorWishart.wav");
score.add(ferry);

revbus = CtkAudio.new(2); // allocates two virtual busses for sound routing. 

// some functions for creating notes (clicks)
// note - 'tend' vars can be Tendency instances OR Envs
makeChirps = {arg starttime, duration, panTend, ampTend, noteDurTend, 
		freqTend, revSendTend;
	var now = 0.0, ratio, curPan, curAmp, curNoteDur, curFreq, curRevSend;
	while({
		ratio = now / duration;
		curPan = panTend.at(ratio);
		curAmp = ampTend.at(ratio);
		curNoteDur = noteDurTend.at(ratio);
		curFreq = freqTend.at(ratio);
		curRevSend = revSendTend.at(ratio);
		score.add(
			clicks.note(now + starttime, curNoteDur, \head)
				.revbus_(revbus).pan_(curPan).amp_(curAmp)
				.dur_(curNoteDur).freq_(curFreq).revsend_(curRevSend)
			);
		now = now + 0.25;
		now < duration;
		})
	};
	
// Then, play your note at the head of group 0 (addaction 0)

score.add(
	player.note(1.0, 2, \head).buffer_(ferry).dur_(2).amp_(1).revbus_(revbus).revsend_(0.1));
	
// play many clicks into the system

makeChirps.value(5.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 0.0);

makeChirps.value(10.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 0.5);

makeChirps.value(15.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 1.0);

makeChirps.value(20.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), Env([0, 1.0], [1], -5));
			
// now - add the reverb to the score, using the current duration of the score + 
// a few seconds.
score.add(
	rev.note(0.0, score.endtime + 6, \tail).inbus_(revbus)
		.release(score.endtime + 5)
);
	
score.write("~/Desktop/test.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2))
)

a = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui

// using FreeVerb
(

var score, rev, player, clicks;
var ferry, revbus, makeChirps;

rev = CtkSynthDef(\freeverb, {arg roomsize = 0.7, gain = 0.1, damp = 0.5, inbus = 99, gate = 1;
	var in, rev, out, env;
	env = EnvGen.kr(
		Env([0, 1, 0], [0.1, 1.0], \sin, 1), gate);
	in = In.ar(inbus, 2);
	rev = FreeVerb.ar(in, 1.0, roomsize, damp);
	Out.ar(0, rev * env)
	});

player = CtkSynthDef(\player, {arg buffer, dur = 1, amp = 1, revbus = 99;
	var env, playbuf, out;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	playbuf = PlayBuf.ar(1, buffer, 1, loop: 1);
	out = playbuf * env;
	OffsetOut.ar(0, [out, out]); // send the output straight out
	OffsetOut.ar(revbus, [out, out]); // and send it out the the reverb
	});
 
clicks = CtkSynthDef(\clicks, {arg revbus, pan, amp, dur, freq, revsend;
	var env, src;
	env = EnvGen.kr(
		Env([0, 1, 0], [dur * 0.5, dur * 0.5], \sin));
	src = SinOsc.ar(freq, 0, amp) * env;
	src = Pan2.ar(src, pan);
	Out.ar(0, src);
	Out.ar(revbus, src * revsend);
	});

	
score = CtkScore.new;
ferry = CtkBuffer.playbuf("/Users/jameswatkins/samples/TrevorWishart.wav");
score.add(ferry);

revbus = CtkAudio.new(2); // allocates two virtual busses for sound routing. 

// some functions for creating notes (clicks)

makeChirps = {arg starttime, duration, panTend, ampTend, noteDurTend, 
		freqTend, revSendTend;
	var now = 0.0, ratio, curPan, curAmp, curNoteDur, curFreq, curRevSend;
	while({
		ratio = now / duration;
		curPan = panTend.at(ratio);
		curAmp = ampTend.at(ratio);
		curNoteDur = noteDurTend.at(ratio);
		curFreq = freqTend.at(ratio);
		curRevSend = revSendTend.at(ratio);
		score.add(
			clicks.note(now + starttime, curNoteDur, \head)
				.revbus_(revbus).pan_(curPan)
				.amp_(curAmp).dur_(curNoteDur).freq_(curFreq)
				.revsend_(curRevSend)
			);
		now = now + 0.25;
		now < duration;
		})
	};
	
// Then, play your note at the head of group 0 (addaction 0)

score.add(
	player.note(1.0, 2).buffer_(ferry).dur_(2).amp_(1).revbus_(revbus));
	
// play many clicks into the system

makeChirps.value(5.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 0.0);

makeChirps.value(10.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 0.1);

makeChirps.value(15.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 0.5);

makeChirps.value(20.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 1.0);

makeChirps.value(25.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), Env([0, 1.0], [1], -5));
		
// now - add the reverb to the score, using the current duration of the score + a few seconds.
score.add(
	rev.note(0.0, score.endtime + 6, \tail).inbus_(revbus).roomsize_(0.7).damp_(0.7)
		.release(score.endtime + 5));
	
score.write("~/Desktop/test.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2))

)

a = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui

/* GVerb */
( 
var score, rev, player, clicks;
var ferry, revbus, makeChirps;
var revTime; // use a variable for revTime!

rev = CtkSynthDef(\gverb, {arg roomsize = 120, revtime = 3, damp = 0.5, inputbw = 0.5,
		spread = 15, inbus = 99, gate = 1;
	var in, rev, out, env;
	env = EnvGen.kr(
		Env([0, 1, 0], [0.1, 1.0], \sin, 1), gate);
	in = In.ar(inbus, 2);
	// GVerb reads in mono - outputs stereo. Mix our signal before sending it in
	rev = GVerb.ar(in.sum, roomsize, revtime, damp, inputbw, spread, 0,
		maxroomsize: roomsize + 1);
	Out.ar(0, rev * env)
	});

player = CtkSynthDef(\player, {arg buffer, dur = 1, amp = 1, revbus = 99;
	var env, playbuf, out;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
	playbuf = PlayBuf.ar(1, buffer, 1, loop: 1);
	out = playbuf * env * amp;
	OffsetOut.ar(0, [out, out]); // send the output straight out
	OffsetOut.ar(revbus, [out, out]); // and send it out the the reverb
	});
 
clicks = CtkSynthDef(\clicks, {arg revbus, pan, amp, dur, freq, revsend;
	var env, src;
	env = EnvGen.kr(
		Env([0, 1, 0], [dur * 0.5, dur * 0.5], \sin));
	src = SinOsc.ar(freq, 0, amp) * env;
	src = Pan2.ar(src, pan);
	Out.ar(0, src);
	Out.ar(revbus, src * revsend);
	});

	
score = CtkScore.new;
ferry = CtkBuffer.playbuf("/Users/jameswatkins/samples/TrevorWishart.wav");
score.add(ferry);

revbus = CtkAudio.new(2); // allocates two virtual busses for sound routing. 

// some functions for creating notes (clicks)

makeChirps = {arg starttime, duration, panTend, ampTend, noteDurTend, freqTend, revSendTend;
	var now = 0.0, ratio, curPan, curAmp, curNoteDur, curFreq, curRevSend;
	while({
		ratio = now / duration;
		curPan = panTend.at(ratio);
		curAmp = ampTend.at(ratio);
		curNoteDur = noteDurTend.at(ratio);
		curFreq = freqTend.at(ratio);
		curRevSend = revSendTend.at(ratio);
		score.add(
			clicks.note(now + starttime, curNoteDur, \head)
				.revbus_(revbus).pan_(curPan)
				.amp_(curAmp).dur_(curNoteDur).freq_(curFreq)
				.revsend_(curRevSend)
			);
		now = now + 0.25;
		now < duration;
		})
	};
	
// Then, play your note at the head of group 0 (addaction 0)

score.add(
	player.note(1.0, 2).buffer_(ferry).dur_(2).amp_(0.5).revbus_(revbus));
	
// play many clicks into the system

makeChirps.value(5.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 0.0);

makeChirps.value(10.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 0.5);

makeChirps.value(15.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), 1.0);

makeChirps.value(20.0, 2.0, Tendency(-1.0, 1.0, defDist: \uniform), 
	Env([0, -24.dbamp, -24.dbamp, 0], [0.1, 0.8, 0.1]), 0.1, 
	Tendency(440, 880, defDist: \uniform), Env([0, 1.0], [1], -5));
		
// now - add the reverb to the score, using the current duration of the score + a few seconds.
revTime = 3;
score.add(
	rev.note(0.0, score.endtime + revTime, \tail)
		.inbus_(revbus).roomsize_(120).damp_(0.9)
		.inputbw_(0.9).spread_(30).revtime_(revTime)
		.release(score.endtime + revTime)
//	rev.note(0.0, score.endtime + revTime, \tail)
//		.inbus_(revbus).roomsize_(90).damp_(0.5)
//		.inputbw_(0.5).spread_(30).revtime_(revTime)
//		.release(score.endtime + revTime)	
	);
	
score.write("~/Desktop/test3.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2))

)

a = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui


/* Other spatial cues - filtering + reverb + decorrelation + doppler */

(
var score, sf, play, reverb, revbus;

score = CtkScore.new;

sf = CtkBuffer.playbuf("/Users/jameswatkins/samples/TrevorWishart.wav");
score.add(sf);

revbus = CtkAudio.new(2);

reverb = CtkSynthDef(\gverb, {arg roomsize = 120, revtime = 3, damp = 0.5, inputbw = 0.5,
		spread = 15, inbus = 99, gate = 1;
	var in, rev, out, env;
	env = EnvGen.kr(
		Env([0, 1, 0], [0.1, 1.0], \sin, 1), gate);
	in = In.ar(inbus, 2);
	// GVerb reads in mono - outputs stereo. Mix our signal before sending it in
	rev = GVerb.ar(in.sum, roomsize, revtime, damp, inputbw, spread, 
		drylevel: 0, maxroomsize: roomsize + 1);
	Out.ar(0, rev * env)
});
	
play = CtkSynthDef(\play, {arg dur, buffer, distance, loc, outbus, revsend, decor = 0;
	var src, filt, delay, env, envGen, distRatio;
	// a value between 0 and 1, to calculate delays and filter 
	// parameters... 340 meters is the speed of sound
	distRatio = (340 - distance) / 340;
	env = Control.names(\env).kr(Env.newClear(8).asArray);
	envGen = EnvGen.kr(env, timeScale: dur);
	src = PlayBuf.ar(1, buffer, loop: 1);
	// delay by 1 second - the distRatio number... a distance of 340
	// meters gives us a 1 second delay... 0 is no delay
	delay = DelayC.ar(src, 1.0, 1 - distRatio);
	// use the ratio to control a low pass filter. Sounds farther away
	// a filtered more - use an exponent of the distRatio to shape the curve
	filt = LPF.ar(delay, (distRatio ** 5) * 10000);
	filt = Pan2.ar(filt, loc);
	filt = [filt[0], DelayN.ar(filt[1], 0.005, decor)];
	Out.ar(outbus, filt * (distRatio ** 2));
	Out.ar(revsend, filt * (1 - (distRatio ** 2)) * 0.1);
});

score.add(
//	play.note(0, 20).dur_(20).buffer_(sf).distance_(1).loc_(0).outbus_(0)
//		.revsend_(revbus).decor_(0),
//	play.note(0, 20).dur_(20).buffer_(sf).distance_(1).loc_(0).outbus_(0)
//		.revsend_(revbus).decor_(0.005.rand),
//	play.note(0, 20).dur_(20).buffer_(sf).distance_(120).loc_(0).outbus_(0)
//		.revsend_(revbus),
//	play.note(0, 20).dur_(20).buffer_(sf).distance_(200).loc_(0).outbus_(0)
//		.revsend_(revbus),
//	play.note(0, 20).dur_(20).buffer_(sf)
//		.distance_(CtkControl.env(Env([10, 1, 10], [10, 10], \lin)))
//		.loc_(CtkControl.env(Env([-1, 1], [20]))).outbus_(0).revsend_(revbus),
	play.note(0, 20).dur_(20).buffer_(sf),
		.distance_(CtkControl.env(Env([200, 1, 200], [10, 10], \lin)))
		.loc_(CtkControl.env(Env([-1, 1], [20]))).outbus_(0).revsend_(revbus),
	reverb.note(0, 25, addAction: \tail).inbus_(revbus)
	);

score.write("~/Desktop/test.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2))
	
)

a = SFPlayer.new("~/Desktop/test.aif".standardizePath).gui;
a.window.front



/* an aside - the Karplus-Strong */
(
a = CtkSynthDef(\ks, {arg dur, freq, amp, damp;
	var env, env2, feedin, noise, fbdelay, deltime, delay, delay1;
	// this allows sound to be feedback within the synth
	feedin = LocalIn.ar(1); 
	// delaytime equals 1 / freq
	// the feedback loop will have a delay of 1 control period. 
	// Adjust for it here.
	deltime = freq.reciprocal - ControlRate.ir.reciprocal;
	damp = 0.5-(damp*0.01);
	// The noiseburst should last for deltime;
	env = EnvGen.kr(
		Env([1, 1, 0], [deltime, 0], \lin));
	env2 = EnvGen.kr(
		Env([0.0001, 1, 1, 0.0001], [0.001, dur - 0.002, 0.001], \exp));
	noise = WhiteNoise.ar(amp.dbamp) * env;
	delay = DelayC.ar(noise + feedin, deltime, deltime);
	delay1 = Delay1.ar(delay);
	LocalOut.ar((delay + delay1) * damp);
	Out.ar(0, LeakDC.ar(delay) * env2);
	});
	
//For this to work properly, this example needs to be run in NRT with a 
// control period of 1

z = CtkScore.new;
z.add(a.note(0.0, 15.0).dur_(15).freq_(489).amp_(-3).damp_(0.01));
o = ServerOptions.new.numOutputBusChannels_(1).blockSize_(1);
z.write("~/Desktop/test.aif".standardizePath, options: o);
)


/* Inside SC is the UGen 'Pluck', which provides this algorithm */

a = CtkSynthDef(\ks, {arg dur, freq, amp, damp;
	var pluck, env;
	env = EnvGen.kr(
		Env([0.0001, 1, 1, 0.0001], [0.001, dur - 0.002, 0.001], \exp));
	pluck = Pluck.ar(WhiteNoise.ar(amp.dbamp), 
		Impulse.ar(dur.reciprocal), 0.1, freq.reciprocal,
		dur, damp);
	Out.ar(0, pluck * env);
	});
	
b = a.note(0.0, 15.0).dur_(15).freq_(489).amp_(-3).damp_(0.3).play

