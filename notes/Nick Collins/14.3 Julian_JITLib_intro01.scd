
-----------------
//This is Julian's JITLib intro, improvised during a presentation. He goes through Tdef, Pdef and Ndef. 

(
SynthDef("finesine", { arg out, freq=440, amp=0.1, pan, sustain=0.01, x=0.5;
 var e, u;
 e = EnvGen.ar(Env.perc(0.001, sustain, amp), doneAction:2);
 u = SinOsc.ar(freq * [1.0, 5/6, 17/8] * XLine.ar(1 + x, 1, sustain)).sum * amp;
 Out.ar(out, u)
}).store;
)

Synth(\finesine);

Tdef(\x).play;

(
Tdef(\x, {
 inf.do { "hello friend!".postln; 0.2.wait }
}
)
)


(
Tdef(\x, {
 inf.do { "hello my friend!".postln; 0.2.wait }
}
)
)

(
Tdef(\x, {
 inf.do {
 Synth(\finesine, [\freq, exprand(800, 10000), \x, 0]);
 [0.2, 0.1, 0.05].choose.wait 
 }
}
)
)
Tdef(\x).quant










(
a = Pbind(
 \instrument, \finesine,
 \dur, Pseq([1, 2, 3, 4, 5]) * 0.05,
 \sustain, 0.01,
 \amp, 0.3
)
);

Pn(a, inf).play
a.play;

(
Pdef(\x,
 Pseq([
 Pbind(
 \instrument, \finesine,
 \dur, Pseq([1, 2, 3, 4, 5]) * 0.1,
 \freq, Pshuf([1, 3, 2, 4, 2]) * 800 + 1000,
 \sustain, 0.01,
 \amp, 0.1,
 \x, 0.3
 ),
 Pbind(\freq, \rest, \dur, Pn(1, 1))
 ], inf)
);
)

Pdef(\x).fadeTime = 10;

Ndef(\x, { SinOsc.ar(100 * [1, 1.2]) * 0.1 }).play;

Ndef(\x).fadeTime = 2;

Ndef(\x).quant


Pdef(\y, 
 Ppar([
 Pdef(\x),
 Pbindf(
 Pdef(\x),
 \sustain, Pfunc({ rrand(0.001, 0.1) }),
 \freq, 100
 )
 
 ])
)

Pdef(\y).play;


Ndef(\x, { SinOsc.ar(ExpRand(200,1000) * [1, 1.2] * (Ndef(\freqMod).ar)) * 0.1 }).play;
Ndef(\freqMod, { SinOsc.ar([1, 1.2] * 1, 0, 0.5, 1.5) })

Ndef(\freqMod).fadeTime = 1;
Ndef(\x).fadeTime = 1;
64 / 48000



a = { Ndef(\freqMod, { SinOsc.ar([1, 1.2] * rrand(1, 15), 0, 0.5, 1.5) }) };

a.value

Ndef(\freqMod, { arg fmul=1; SinOsc.ar([1, 1.2] * fmul, 1, 0.5, 1.5) });
Ndef(\freqMod).set(\fmul, 2);

Ndef(\k, { MouseX.kr(0, 10) });
Ndef(\freqMod).map(\fmul, Ndef(\k));

Ndef(\x, \default).play;

Ndef(\fx, { arg wet=0;
 var in, filtered;
 in = Ndef(\x).ar; 
 filtered = CombN.ar(Ndef(\x).ar, 1, 0.02, 3);
 XFade2.ar(in, filtered, wet)
}).play;


Ndef(\fx).set(\wet, 0);

a = { arg val; Ndef(\fx).set(\wet, val) };
a.value(0.5)
