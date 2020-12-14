(
var routebus1, routebus2, src1, src2, filter1, filter2, score;
score = CtkScore.new;
routebus2 = CtkAudio.new(server: s);
routebus2.bus.postln;
src2 = CtkSynthDef(\src2, {arg outbus;
Out.ar(outbus, Blip.ar(200, Line.kr(1,100,20), 0.8))
});

filter1 = CtkSynthDef(\filter1, {arg inbus, pan, noteDur, filterFreq, filterRq, amp = 1;
 var src, filter, env;
 src = In.ar(inbus);
 pan = 1;
 env = EnvGen.kr(
 Env([0, 1, 1, 0], [0.1, 0.6, 0.1], \sin),
 timeScale: noteDur);
 filter = MoogFF.ar(src,SinOsc.kr(LFNoise0.kr(0.42).range(0.001,2.2)).range(30,4200), 0.83 * 4);
 Out.ar(0, Pan2.ar(filter * env * amp, pan))
});

filter2 = CtkSynthDef(\filter2, {arg inbus, pan, noteDur, filterFreq, delayTime, amp = 1;
var src, filter, env;
src = In.ar(inbus);
pan = -1;
env = EnvGen.kr(
Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), timeScale: noteDur);
filter = MoogFF.ar(src,SinOsc.kr(LFNoise0.kr(0.42).range(0.001,2.2)).range(30,4200), 0.83 * 4);
Out.ar(0, Pan2.ar(filter * env * amp, pan))
});



score.add(src2.note(0.0, 20.0).outbus_(routebus2));

score.add(
filter2.note(0.0, 20.0, addAction: \tail, target: 1).inbus_(routebus2)
.noteDur_(20)
);

//score.write("~/Desktop/test.aif".standardizePath,Ê
// options: ServerOptions.new.numOutputBusChannels_(2));
score.play;
)

