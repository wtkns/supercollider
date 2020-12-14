n = NetAddr("10.0.10.100", 57110)
Server.default = s = Server.remote(\mesher, n);
s.options.maxLogins = 16



(
// a SynthDef
SynthDef("test", { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1 |
    var audio = Blip.ar(freq, nharms, amp);
    var env = Linen.kr(gate, doneAction: Done.freeSelf);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).send(s);
)

Pdefn(\xfreq, Pseq([1,2,3,4,5,8], inf) );



~p1 = Pmono(\default, \dur, 0.2, \freq,  Pdefn(\xfreq) * 100, \detune, [0,2,5,1]).play

~p1.stop

x = {|freq=440, amp=0.6| MoogFF.ar(PinkNoise.ar(amp), freq).dup}.play;



~p2 = Pbind(\instrument, \test, \freq, Pdefn(\xWhite) * 100, \dur, 0.5).play

Pdefn(\xWhite, Pseq([1,2,3,4,5,8], inf) );
Pdefn(\xWhite, Pwhite(1,3));
Pdefn(\xWhite, Pwhite(1,8));

~p2.stop;















Pdefn(\xWhite, Pwhite(1,8));

Pdefn(\xWhite, Pwhite(1,8));


(
Pdefn(\xWhite, Pseq([
	Pseq([1,2,3], 2),
	Pseq([2,3,4], 2),
	Pseq([4,5,6], 2),
	Pseq([6,7,8], 2),
	], inf))
)


(
Pdefn(\xWhite, Pseq([
	Pseq([Prand([1,2], inf)], inf),
	Pseq([Prand([2,3], inf)], inf),
	Pseq([Prand([3,5], inf)], inf),
	Pseq([Prand([4,6], inf)], inf),
	], inf) );
)


Pdefn(\xWhite, Pseq([1,2,3,4,5,8], inf) );


Pdefn(\xWhite, Pwhite(1,3));
Pdefn(\xWhite, Pwhite(1,8));












/////////////////
Pdefn(\xWhite, Pseq([1,2,3,4,5,8], inf) );



Pdefn(\xWhite, Pwhite(1,3));
Pdefn(\xWhite, Pwhite(1,8));



Pbind(\note, Pdefn(\x), \dur, 0.3).play;
Pbind(\note, Pdefn(\x), \dur, 0.1, \ctranspose, 15).play;
// now change the definition
Pdefn(\x, Pseq([0, 3, 5, 7, 9, 11], inf));
Pdefn(\x, Pseq([0, 3, 3, 7], inf) + Pseq([0, [0, 3], [0, 5, 7]], inf));



~p1 = Pmono(\default, \dur, 0.2, \freq,  Pdefn(\xWhite)* 100, \detune, [0,2,5,1]).play

~p2 = Pmono(\default, \dur, 0.2, \freq, Pwhite(1,3) * 100, \detune, [0,2,5,1]).play

~p1.stop
~p2.stop





(
// a SynthDef
SynthDef("test", { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1 |
    var audio = Blip.ar(freq, nharms, amp);
    var env = Linen.kr(gate, doneAction: Done.freeSelf);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).send(s);
)

~p2 = Pbind(\instrument, \test, \freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * 200, \dur, 0.1).play

~p2.stop;






(
var winenv;
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\sin_grain_test, { |out, gate = 1, amp = 1, envbuf|
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    // use WhiteNoise and mouse y to control deviation from center pitch
    freqdev = WhiteNoise.kr(MouseY.kr(0, 400));
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf
    );
    Out.ar(out,
        GrainSin.ar(2, Impulse.kr(10), 0.1, 440 + freqdev, pan, envbuf) * env)
}).send(s);
)

s.scope
// use built-in env
x = Synth(\sin_grain_test, [\envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);