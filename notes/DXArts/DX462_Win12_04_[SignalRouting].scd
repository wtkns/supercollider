/* Basic Signal Routing */

Server.default = s = Server.internal.boot;

a = s.options.numOutputBusChannels;
b = s.options.numInputBusChannels;
c = s.options.numAudioBusChannels;

c - a - b;

a = CtkAudio.new;
a.bus;

b = CtkAudio.new;
b.bus;

a.free;

c = CtkAudio.new;
c.bus;

c.free; b.free;


/* You can send sound out to ANY audio bus, and read from any bus, even the inputs */

// grab an index in the 'virtual' busses to route to:
a = CtkAudio.new(server: s);

b = CtkSynthDef(\src, {arg outbus;
	Out.ar(outbus, PinkNoise.ar(0.5))
});

s.scope;
a.bus;

c = b.note(0.0, 5.0).outbus_(a).play; // just give the argument the CtkAudio object... 

// now - any note can READ and use the routed sound in its own synthesis process:

d = CtkSynthDef(\filter, {arg inbus, pan, noteDur, filterFreq, filterRq, amp = 1;
	var src, filter, env;
	src = In.ar(inbus);
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin),
		timeScale: noteDur);
	filter = Resonz.ar(src, filterFreq, filterRq);
	Out.ar(0, Pan2.ar(filter * env * amp, pan))
});

(
// start the source
c = b.note(0.0, 5.0).outbus_(a).play; // just give the argument the CtkAudio object... 
// start the filter ...
d.note(0.0, 5).inbus_(a) // feed in a
	.pan_(0.5.rand2)
	.noteDur_(5)
	.filterFreq_(CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], [5])))
	.filterRq_(0.01)
	.amp_(12.dbamp)
	.play;
)

s.queryAllNodes;

// ????????
// Order of Execution
(
// start the source
c = b.note(0.0, 5.0).outbus_(a).play; // just give the argument the CtkAudio object... 
// start the filter ...
d.note(0.0, 5, addAction: \after, target: c).inbus_(a) // feed in a
	.pan_(0.5.rand2)
	.noteDur_(5)
	.filterFreq_(CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], [5])))
	.filterRq_(0.01)
	.amp_(12.dbamp)
	.play;
)
	
s.queryAllNodes;


(
// start the source
c = b.note(0.0, 5.0).outbus_(a).play; // just give the argument the CtkAudio object... 
// start the filter ...
d.note(0.0, 5, addAction: \tail, target: 1).inbus_(a) // feed in a
	.pan_(0.5.rand2)
	.noteDur_(5)
	.filterFreq_(CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], [5])))
	.filterRq_(0.01)
	.amp_(12.dbamp)
	.play;
d.note(0.0, 5, addAction: \tail, target: 1).inbus_(a) // feed in a
	.pan_(0.5.rand2)
	.noteDur_(5)
	.filterFreq_(CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], [5])))
	.filterRq_(0.01)
	.amp_(12.dbamp)
	.play;
d.note(0.0, 5, addAction: \tail, target: 1).inbus_(a) // feed in a
	.pan_(0.5.rand2)
	.noteDur_(5)
	.filterFreq_(CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], [5])))
	.filterRq_(0.01)
	.amp_(12.dbamp)
	.play;
)
	
s.queryAllNodes;

// clean up

a.free;

// Score examples that use multiple notes to read from one source
(
var routebus, src, filter, score;

score = CtkScore.new;

routebus = CtkAudio.new(server: s);

src = CtkSynthDef(\src, {arg outbus;
	Out.ar(outbus, PinkNoise.ar(0.5))
});

filter = CtkSynthDef(\filter, {arg inbus, pan, noteDur, filterFreq, filterRq, amp = 1;
	var src, filter, env;
	src = In.ar(inbus);
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin),
		timeScale: noteDur);
	filter = Resonz.ar(src, filterFreq, filterRq);
	Out.ar(0, Pan2.ar(filter * env * amp, pan))
});


// defaults to the \head of group 1
score.add(src.note(0.0, 20.0).outbus_(a));

20.do({
	var thisDur;
	thisDur = 12.0.rrand(10.0);
	score.add(
		filter.note(0.0.rrand(8.0), thisDur , addAction: \tail, target: 1).inbus_(a)
			.pan_(0.5.rand2)
			.noteDur_(thisDur)
			.filterFreq_(
				CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], 
					[thisDur], \exp)))
			.filterRq_(0.001)
			.amp_(12.dbamp)
	)
});

score.write("~/Desktop/test.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2));
)
	
	
// Score examples that use multiple notes to read from one source
(
var routebus, src, filter, score;

score = CtkScore.new;

routebus = CtkAudio.new(server: s);

src = CtkSynthDef(\src, {arg outbus;
	Out.ar(outbus, Blip.ar(LFNoise2.kr(0.5).range(10, 30), 400))
});

filter = CtkSynthDef(\filter, {arg inbus, pan, noteDur, filterFreq, filterRq, amp = 1;
	var src, filter, env;
	src = In.ar(inbus);
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin),
		timeScale: noteDur);
	filter = Resonz.ar(src, filterFreq, filterRq);
	Out.ar(0, Pan2.ar(filter * env * amp, pan))
});


// defaults to the \head of group 1
score.add(src.note(0.0, 20.0).outbus_(a));

20.do({
	var thisDur;
	thisDur = 12.0.rrand(10.0);
	score.add(
		filter.note(0.0.rrand(8.0), thisDur , addAction: \tail, target: 1).inbus_(a)
			.pan_(0.5.rand2)
			.noteDur_(thisDur)
			.filterFreq_(
				CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], 
					[thisDur], \exp)))
			.filterRq_(0.01)
			.amp_(18.dbamp)
	)
});

score.write("~/Desktop/test.aif".standardizePath, 
	options: ServerOptions.new.numOutputBusChannels_(2));
)
 
