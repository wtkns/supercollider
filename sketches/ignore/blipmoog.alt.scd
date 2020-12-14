

(
var routebus1, routebus2, src1, src2, filter1, filter2, score;

score = CtkScore.new;

routebus2 = CtkAudio.new(server: s);
routebus2.bus.postln;

src2 = CtkSynthDef(\src2, {arg outbus;
Out.ar(outbus, Blip.ar(Line.kr(900, 30, 20), 100))
});


filter2 = CtkSynthDef(\filter2, {arg inbus, pan, noteDur, filterFreq, delayTime, amp = 1;
var src, filter, env;
src = In.ar(inbus);
env = EnvGen.kr(
Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), timeScale: noteDur);
filter = Ringz.ar(src, filterFreq, delayTime, 0.2);
Out.ar(0, Pan2.ar(filter * env * amp, pan))
});

score.add(src2.note(0.0, 20.0).outbus_(routebus2));

score.add(
filter2.note(0.0, 20.0, addAction: \tail, target: 1).inbus_(routebus2)
.pan_(-0.5)
.noteDur_(20)
.filterFreq_(
CtkControl.env(Env([1100, 700], [20], \exp)))
.delayTime_(3)
.amp_(3.dbamp)
);

//score.write("~/Desktop/test.aif".standardizePath,
// options: ServerOptions.new.numOutputBusChannels_(2));
score.play;
)
)