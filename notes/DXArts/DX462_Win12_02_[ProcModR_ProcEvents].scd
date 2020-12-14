s.boot;

/* SuperCollider in real-time */

// notes as a model of what kinds of things we may expect a real-time environment to be capable of

a = CtkSynthDef(\test, {arg gate = 1, outbus, freq, amp;
	var env, src, freqEnv;
	env = Control.names(\env).kr(Env.newClear(4).asArray);
	// here, we use doneAction: 2, since we don't know how long a note may be...
	// when the gate closes, and the Env is done executing, this will kill the synth
	env = EnvGen.kr(env, gate, doneAction: 2);
	src = SinOsc.ar(freq, 0, amp * env);
	Out.ar(outbus, src);
	});

// play the note
b = a.note.outbus_(0).freq_(440).amp_(0.1).env_(Env([0, 1, 0], [2, 4], [4, -4], 1)).play;

b.freq_(60)

// release it
b.release;

b.gate_(0);


/*
things you may want in real-time controls:
	- start things on the fly
	- stop things on the fly
	- overlap multiple events
	- envelope, group and otherwise control a number of events
	- probably DON'T want to use scores at this point, since you don't want to fix the number
		of events!
	
and possibly, take a single 'event' and record its output to disk!
*/

/*
ProcModR(env, amp, numChannels, procout, id, group, addAction, target, function, releaseFunc,
	onReleaseFunc, responder, timeScale, lag, clock, server);
	
BUT - usually you just create with:

ProcModR(env, amp, numChannels, procout, id)

'Process' - a single algorithmic idea or process - something to do
'Module' - it is modular
'Record' - able to record this processes output

(background) -> in SC2, Richard Karpen's pieces 'Sotto/Sopra' and 'Solo/Tutti', Juan Pampin's 'OID' and my 'Music for Bassoon' were made up of 'processes'. When re-writing some of these into SC3, the idea of making them modular and into classes led to 'ProcMod'
These 'processes' were then placed into an event list (a fixed event list) that a computer controller would advance as a player came to certain parts in the piece. (This event list became 'ProcEvents'). There HAD to be certain flexibilites. Flexibility with the performance was crucial, and is one of the more important aspects of the system.
ProcModR came about as a way to capture computer processing for recordings.

some of the things we needed to be able to do:
	start and stop a routine, free resources when a process is done, global envelopes, simple GUI controls to start and stop things...
*/

a = CtkSynthDef(\test, {arg gate = 1, outbus, freq, amp, pan;
	var env, src;
	env = Control.names(\env).kr(Env.newClear(4).asArray);
	// here, we use doneAction: 2, since we don't know how long a note may be...
	// when the gate closes, and the Env is done executing, this will kill the synth
	env = EnvGen.kr(env, gate, doneAction: 2);
	src = SinOsc.ar(freq, 0, amp * env);
	Out.ar(outbus, Pan2.ar(src, pan));
	});
	
p = ProcModR(Env([0, 1, 0], [2, 4], [4, -2], 1), 1, 2, 0, \test)
	// the unique Group id created by ProcModR is passed in to this function, 
	// as well as the unique routing bus and the server, as well as the ProcModR itself
	.function_({arg group, routebus, server, pm;
		var freqMask, task;
		freqMask = Tendency(Env([880, 440], [20]), Env([880, 1760], [20]));
		task = Task({
			var curFreq, curNote, freqScaler;
			inf.do({arg i;
				// grab a value for a freq, using the 'now' value from the ProcModR
				curFreq = freqMask.at(pm.now.postln);
				curNote = a.note(target: group) // !!!!!!
					.outbus_(routebus).freq_(curFreq).amp_(0.1).pan_(1.0.rand2)
					.env_(Env([0, 1, 0], [0.1, 4], [10, -4], 1)).play;
				curNote.release(4.rrand(12));
				(0.5 + 2.0.rand).wait;
				})
			});
		// return the task from the function. This tells ProcModR to manage it
		task;
		});
		
p.play;

s.queryAllNodes;

p.release; // when the global envelope is done, ALL running synths in this group are freed,
		  // and the Task / inf.do loop is stopped

s.queryAllNodes;

		  
p.play("~/Desktop/".standardizePath, true, "wav", "float");
p.release;

p.recordPM("~/Desktop/".standardizePath);
p.gui;

// you can use functions to create your ProcModRs to automate this process even more!
f = {arg globenv, id, freqMask;
	var procMod;
	freqMask = freqMask ?? {Tendency(Env([880, 440], [20]), Env([880, 1760], [20]))};
	procMod = ProcModR(globenv, 1, 2, 0, id)
		.function_({arg group, routebus, server, pm;
			var task;
			task = Task({
				var curFreq, curNote;
				inf.do({arg i;
					curFreq = freqMask.at(pm.now);
					curNote = a.note(target: group)
						.outbus_(routebus).freq_(curFreq).amp_(0.1).pan_(1.0.rand2)
						.env_(Env([0, 1, 0], [0.1, 4], [10, -4], 1)).play;
					curNote.release(4.rrand(12));
					(0.5 + 2.0.rand).wait;
					})
				});
			task;
			});
	procMod;
	};
	
y = f.value(Env([0, 1, 0], [10, 20], [4, 0], 1), \test1);
// no releaseNode in the Env - so the ProcModR will just stop when it's done
z = f.value(Env([0, 1, 1, 0], [0.1, 1, 10], [10, 0, -5]), \test2, Tendency(3000, 2000));

y.play("~/Desktop/".standardizePath, true, "wav", "float");

z.play("~/Desktop/".standardizePath, true, "wav", "float");	
y.release;

y.recordPM("~/Desktop/".standardizePath);
z.recordPM("~/Desktop/".standardizePath);
y.gui;
z.gui;
// z releases itself

/*
Now - for real-time pieces where you know that events will happen in a preset order, there is a class to help you manage these things so you don't have to execute code in order to move on to the next event. ProcEvents also has a GUI interface, so now we can go back to using full code blocks.

ProcEvents(eventsArray, amp, initmod, killmod, id, server)
*/
(
var sines, pevents, note, initmod, killmod, buffer;

note = CtkSynthDef(\test, {arg gate = 1, outbus, freq, amp, pan;
	var env, src;
	env = Control.names(\env).kr(Env.newClear(4).asArray);
	env = EnvGen.kr(env, gate, doneAction: 2);
	src = SinOsc.ar(freq, 0, amp * env);
	Out.ar(outbus, Pan2.ar(src, pan));
	});
	
sines = {arg globenv, id, freqMask, amp = 1;
	var procMod;
	freqMask = freqMask ?? {Tendency(Env([880, 440], [20]), Env([880, 1760], [20]))};
	procMod = ProcModR(globenv, amp, 2, 0, id)
		.function_({arg group, routebus, server, pm;
			var task;
			task = Task({
				var curFreq, curNote;
				// you can query how long it has been since the piece started
				pevents.now.postln;
				// or - if you give the below message to ProcEvents, you can find out
				// when a ProcMod with the given id was started ...
				// pevents.starttime(id)
				inf.do({arg i;
					curFreq = freqMask.at(pm.now);
					curNote = note.new(target: group)
						.outbus_(routebus).freq_(curFreq).amp_(0.1).pan_(1.0.rand2)
						.env_(Env([0, 1, 0], [0.1, 4], [10, -4], 1)).play;
					curNote.release(4.rrand(12));
					(0.5 + 2.0.rand).wait;
					})
				});
			task;
			});
	procMod;
	};

buffer = CtkBuffer.buffer(32768).load;
	
initmod = ProcMod.new.function_({
	"Something to do when you start".postln;
	});
	
killmod = ProcMod.new.function_({
	// the kill function is a good place to clean up - buffers, busses, etc.
	buffer.free;
	"Buffers freed!".postln;
	"Things to do when the piece is done".postln;
	});

pevents = ProcEvents([
	// the events array contains arrays of events to start and stop
	// [startEvents, stopEvents]
	// startEvents expects a ProcMod, OR an array of ProcMods. 
	// stopEvents can be a ProcMod to shut of, an array of ProcMods to shut off OR ids to stop.
	// I use ids
/* 0 */	[sines.value(Env([0, 1, 0], [1, 1], \sin, 1), \ev0, amp: -18.dbamp), nil],
/* 1 */	[nil, \ev0],
/* 2 */	[sines.value(Env([0, 1, 0], [1, 4], \sin, 1), \ev2, amp: -12.dbamp), nil],
/* 3 */	[sines.value(Env([0, 1, 0], [4, 1], \sin, 1), \ev3, Tendency(3000, 2000), -6.dbamp), \ev2],
/* 4 */	[
			[
				sines.value(Env([0, 1, 0], [10, 20], [4, -4], 1), \ev4a,
					Tendency(Env([3000, 4000], [30], \exp), Env([3000, 2500], [30], \exp)),
					-12.dbamp),
				sines.value(Env([0, 1, 0.3, 0], [0.1, 10, 20], [4, -4, -4], 2), \ev4b,
					Tendency(Env([4000, 3000], [30], \exp), Env([2500, 3000], [30], \exp)),
					-12.dbamp)
				], 
			\ev3
			],
/* 5 */	[sines.value(Env([0, 1, 0], [20, 1], [4, \sin], 1), \ev5, Tendency(120, 125), -6.dbamp), 
			nil],
/* 6 */	[nil, \ev5],
/* 7 */	[nil, [\ev4a, \ev4b]]		
	], 1, initmod, killmod, \myNicePiece);
	
pevents.perfGUI;
p = pevents;
pevents.record("~/Desktop/myNicePiece/".standardizePath);

)

/* 

For freer structures, organized improv or even just testing how some processing may work, ProcSink may work for you.

ProcSink(name, sinkBounds, bounds, columns, initmod, killmod, server, parent);

mostly - you'll use name, initmod and killmod

You can then add ProcMods using ProcSink.add, or simply drag them to the 'sink'

*/

(
var sines, psink, note, initmod, killmod, buffer;

note = CtkSynthDef(\test, {arg gate = 1, outbus, freq, amp, pan;
	var env, src;
	env = Control.names(\env).kr(Env.newClear(4).asArray);
	env = EnvGen.kr(env, gate, doneAction: 2);
	src = SinOsc.ar(freq, 0, amp * env);
	Out.ar(outbus, Pan2.ar(src, pan));
	});
	
sines = {arg globenv, id, freqMask, amp = 1;
	var procMod;
	freqMask = freqMask ?? {Tendency(Env([880, 440], [20]), Env([880, 1760], [20]))};
	procMod = ProcModR(globenv, amp, 2, 0, id)
		.function_({arg group, routebus, server, pm;
			var task;
			task = Task({
				var curFreq, curNote;
				inf.do({arg i;
					curFreq = freqMask.at(pm.now);
					curNote = note.note(target: group)
						.outbus_(routebus).freq_(curFreq).amp_(0.1).pan_(1.0.rand2)
						.env_(Env([0, 1, 0], [0.1, 4], [10, -4], 1)).play;
					curNote.release(4.rrand(12));
					(0.5 + 2.0.rand).wait;
					})
				});
			task;
			});
	procMod;
	};

buffer = CtkBuffer.buffer(32768).load;
	
initmod = ProcMod.new.function_({
	"Something to do when you start".postln;
	});
	
killmod = ProcMod.new.function_({
	// the kill function is a good place to clean up - buffers, busses, etc.
	buffer.free;
	"Buffers freed!".postln;
	"Things to do when the piece is done".postln;
	});

psink = ProcSink(\myRadPiece, initmod: initmod, killmod: killmod);

psink.add(sines.value(Env([0, 1, 0], [4, 4], \sin, 1), \medium, amp: -18.dbamp));
psink.add(sines.value(Env([0, 1, 0], [4, 4], \sin, 1), \high,
	Tendency(Env([3000, 4000], [30], \exp), Env([3000, 2500], [30], \exp)), -18.dbamp));
psink.add(sines.value(Env([0, 1, 0], [4, 4], \sin, 1), \low, Tendency(120, 125), -18.dbamp));
)


n = CtkSynthDef(\bindel, {arg dur, inbus, outbus, dels, fb;
	var in, chain, fftbuf, env;
	in = In.ar(inbus, 1);
	env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.6, 0.2], \sin), timeScale: dur, doneAction: 2);
	fftbuf = LocalBuf.new(1024);
	chain = FFT(fftbuf, in, 0.25);
	chain = PV_BinDelay(chain, 0.5, dels, fb, 0.25);
	Out.ar(outbus, IFFT(chain).dup * env);
	});
	
p = ProcModR(Env([0, 1, 0], [1, 1], \sin, 1), 1, 2, 0, \myFFT)
	.function_({arg group, routebus, server, pm;
		var fbbufs, delbufs, thisfb, thisdel;
		fbbufs = [];
		delbufs = [];
		pm.onReleaseFunc_({
			"Start releasing the proc!".postln;
			});
		pm.releaseFunc_({
			"This firest when the ProcMod is done".postln;
			(fbbufs ++ delbufs).do({arg thisbuf; thisbuf.free});
			});
		Task({
			loop({
				thisfb = CtkBuffer.buffer(512).load(sync: true);
				thisdel = CtkBuffer.buffer(512).load(sync: true);
				0.1.wait;	
				thisfb.set(0, 0, 512.collect({0.3.rrand(0.99)}));
				thisdel.set(0, 0, 512.collect({0.1.rrand(0.45)}));
				s.sync;
				// play the note:
				n.note(target: group).dur_(16).inbus_(server.options.numOutputBusChannels)
					.outbus_(routebus).dels_(thisdel).fb_(thisfb).play;
				fbbufs = fbbufs.add(thisfb);
				delbufs = delbufs.add(thisdel);
				SystemClock.sched(16.2, {
					fbbufs.removeAt(0).free;
					delbufs.removeAt(0).free;
					});
				6.0.rrand(9.0).wait;
				})
			})
		});
	p

p.gui;


p.release;


/* some other considerations, and a small template */
(
var rawInput, inSynth, tailSynth, inBus, routeBus, initMod, killMod;
var input, tail, pshift, pshiftMod, filts, filtsMod;
var pevents;

Server.default = s = Server.internal.boot;
s.scope;
s.waitForBoot({
	
	rawInput = CtkAudio.play(1, s.options.numOutputBusChannels, s);
	inBus = CtkAudio.play(1, server: s); // for routing the 'conditioned' input
	routeBus = CtkAudio.play(2, server: s); // for other routing (see below)

	// read raw input from your sound interface, limit and filter it, then send to a virtual bus
	input = CtkSynthDef(\input, {arg inbus, outbus;
		var in, out;
		in = In.ar(inbus, 1);
		in = LeakDC.ar(in);
		in = Limiter.ar(in, -3.dbamp);
		Out.ar(outbus, in);
	});
	
	tail = CtkSynthDef(\tail, {arg inbus;
		ReplaceOut.ar(inbus, Limiter.ar(LeakDC.ar(In.ar(inbus, 2))));
	});
	
	// a windowed pitchshift
	pshift = CtkSynthDef(\pshift, {arg inbus, outbus, ratio, duration, pan;
		var env, src, pshift;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.6, 0.2], \sin), timeScale: duration);
		src = In.ar(inbus, 1);
		pshift = PitchShift.ar(src, 0.11, ratio, 0.0, 0.02) * env; // multiply here - still mono!
		pshift = Pan2.ar(pshift, pan);
		Out.ar(outbus, pshift);
	});
	
	filts = CtkSynthDef(\filts, {arg inbus, outbus, freqStart, freqEnd, duration, pan;
		var env, src, filt, filtEnv;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.6, 0.2], \sin), timeScale: duration);
		src = In.ar(inbus, 1);
		filtEnv = XLine.kr(freqStart, freqEnd, duration);
		filt = Resonz.ar(src, filtEnv, 0.01, 3.dbamp) * env;
		filt = Limiter.ar(filt, -12.dbamp);
		filt = Pan2.ar(filt, pan);
		Out.ar(outbus, filt);
	});
		
	
	// starts the input synth
	initMod = ProcMod.new.function_({
		inSynth = input.note(target: 0).inbus_(rawInput).outbus_(inBus).play;
		tailSynth = tail.note(addAction: \tail, target: 0).inbus_(0).play;
	});
	
	// clean up!
	killMod = ProcMod.new.function_({
		inSynth.free;
		tailSynth.free;
		inBus.free;
		routeBus.free;
		rawInput.free;
	});
	
	pshiftMod = {arg id, amp = 1, env, inbus, outbus, addAction, target, noteDuration, 
			overlaps, ratio, pan;
		ProcModR(env, amp, 2, outbus, id, addAction: addAction, target: target)
			.function_({arg group, routebus, server, pm;
				Task({
					var thisDuration, thisOverlaps, thisRatio, thisPan;
					loop({
						thisDuration = noteDuration.value;
						thisRatio = ratio.value;
						thisPan = pan.value;
						thisOverlaps = overlaps.value;
						pshift.note(0.1, thisDuration, target: group)
							.inbus_(inbus).outbus_(routebus)
							.ratio_(thisRatio).duration_(thisDuration)
							.pan_(thisPan).play;
						(thisDuration / thisOverlaps).wait;
					})	
				})
			})
	};
	
	filtsMod = {arg id, amp = 1, env, inbus, outbus, addAction, target, noteDuration, 
			overlaps, freqLow, freqHigh, pan;
		ProcModR(env, amp, 2, outbus, id, addAction: addAction, target: target)
			.function_({arg group, routebus, server, pm;
				Task({
					var thisDuration, thisOverlaps, thisPan, thisFreqLow, thisFreqHigh, inc;
					inc = 0;
					loop({
						thisDuration = noteDuration.value(inc, pm.now);
						thisFreqLow = freqLow.value(inc, pm.now);
						thisFreqHigh = freqHigh.value(inc, pm.now);
						thisPan = pan.value(inc, pm.now);
						thisOverlaps = overlaps.value(inc, pm.now);
						filts.note(0.1, thisDuration, target: group)
							.inbus_(inbus).outbus_(routebus)
							.freqStart_(thisFreqLow.rrand(thisFreqHigh))
							.freqEnd_(thisFreqLow.rrand(thisFreqHigh))
							.duration_(thisDuration)
							.pan_(thisPan).play;
						(thisDuration / thisOverlaps).wait;
						inc = inc + 1;
					})	
				})
			})
	};

	pevents = ProcEvents([
	/* 1 */	[
				pshiftMod.value(\ev1, 0.dbamp, Env([0, 1, 0], [4, 4], \sin, 1),
					inbus: inBus,
					outbus: 0,
					addAction: \head,
					target: 1,
					noteDuration: 8,
					overlaps: 3,
					ratio: {[-3, 5, -7, -12, 3].choose.midiratio},
					pan: {1.0.rand2}),
				nil
			], [
	/* 2 */
				filtsMod.value(\ev2, 0.dbamp, Env([0, 1, 0], [4, 4], \sin, 1),
					inbus: inBus,
					outbus: 0,
					addAction: \head,
					target: 1,
					noteDuration: 8,
					overlaps: 3,
					freqLow: 1000,
					freqHigh: 6000,
					pan: {1.0.rand2}),
				\ev1 // stop ev1
			], [
	/* 3 */	
				[
					pshiftMod.value(\ev3a, 0.dbamp, Env([0, 1, 0], [4, 4], \sin, 1),
						inbus: inBus,
						outbus: routeBus,
						addAction: \head,
						target: 1,
						noteDuration: 8,
						overlaps: 3,
						ratio: Pseq([-5, 3, -12, 7, -7, 3], inf).asStream,
						pan: {1.0.rand2}),
					filtsMod.value(\ev3b, 0.dbamp, Env([0, 1, 0], [4, 4], \sin, 1),
						inbus: routeBus,
						outbus: 0,
						addAction: \tail,
						target: 1,
						noteDuration: 8,
						overlaps: 3,
						freqLow: 1000,
						freqHigh: 6000,
						pan: {arg inc, now; inc.postln; [-1, 0, 1].wrapAt(inc)})
					], 
				\ev2 // stop ev2
			], [
	/* 4 */
			nil, 
			[\ev3a, \ev3b]
			]
	], 1, initMod, killMod, "genius");
	
	pevents.perfGUI;
});
)