
(
var routebus1, routebus2, src1, src2, filter1, filter2, score;

score = CtkScore.new;

//routebus1 = CtkAudio.new(server: s);
//routebus1.bus.postln;
routebus2 = CtkAudio.new(server: s);
routebus2.bus.postln;
//
//src1 = CtkSynthDef(\src1, {arg outbus;
//	Out.ar(outbus, Blip.ar(LFNoise2.kr(0.5).range(10, 30), 400))
//});

src2 = CtkSynthDef(\src2, {arg outbus;
	Out.ar(outbus, Blip.ar(Line.kr(900, 30, 20), 100))
});

//filter1 = CtkSynthDef(\filter1, {arg inbus, pan, noteDur, filterFreq, filterRq, amp = 1;
//	var src, filter, env;
//	src = In.ar(inbus);
//	env = EnvGen.kr(
//		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin),
//		timeScale: noteDur);
//	filter = Resonz.ar(src, filterFreq, filterRq);
//	Out.ar(0, Pan2.ar(filter * env * amp, pan))
//});

filter2 = CtkSynthDef(\filter2, {arg inbus, pan, noteDur, filterFreq, delayTime, amp = 1;
	var src, filter, env;
	src = In.ar(inbus);
	env = EnvGen.kr(
			Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), timeScale: noteDur);
	filter = Ringz.ar(src, filterFreq, delayTime, 0.2);
	Out.ar(0, Pan2.ar(filter * env * amp, pan))
});



//// defaults to the \head of group 1
//score.add(src1.note(0.0, 20.0).outbus_(routebus1));
//
//20.do({
//	var thisDur;
//	thisDur = 12.0.rrand(10.0);
//	score.add(
//		filter1.note(0.0.rrand(8.0), thisDur , addAction: \tail, target: 1).inbus_(routebus1)
//			.pan_(0.5.rand2)
//			.noteDur_(thisDur)
//			.filterFreq_(
//				CtkControl.env(Env([2000.rrand(1000), 1000.rrand(500)], 
//					[thisDur], \exp)))
//			.filterRq_(0.01)
//			.amp_(18.dbamp)
//	)
//});
//
score.add(src2.note(0.0, 20.0).outbus_(routebus2));

score.add(
	filter2.note(0.0, 20.0, addAction: \tail, target: 1).inbus_(routebus2)
	.pan_(-0.5)
	.noteDur_(20)
	.filterFreq_(
		CtkControl.env(Env([1100, 700], [20], \exp)))
	.delayTime_(3)
	.amp(6.dbamp)
	);

//score.write("~/Desktop/test.aif".standardizePath, 
//	options: ServerOptions.new.numOutputBusChannels_(2));
score.play;
)

s.queryAllNodes;
