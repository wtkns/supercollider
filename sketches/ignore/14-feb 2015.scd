{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;

UGen.browse;




{ FBSineN.ar(LFNoise2.kr([1, 1], 1e4, 1e4), LFNoise2.kr(1,16,17), 1, 1.005, 0.7) * 0.2 }.play(s);

(
{ HenonN.ar(
    SampleRate.ir/8,
    LFNoise2.kr(1, 0.2, 1.2),
    LFNoise2.kr(1, 0.15, 0.15)
) * 0.2 }.play(s);
)

{ Blip.ar((GbmanL.ar(100)+exp(GbmanL.ar(300))))*0.4 }.play(s);

{ Blip.ar((GbmanL.ar(100)+exp(GbmanL.ar(400))))*0.4 }.plot;


{Blip.ar((GbmanL.ar(100)*400)*0.4)}.plot;

(
SynthDef("help-Dust", { arg out=0;
    Out.ar(out,
        Dust.ar(XLine.kr(20000, 2, 5), 0.5)
    )
}).play;
)

(
SynthDef("help-Dust", { arg out=0;
    Out.ar(out,
        Dust.ar((GbmanL.ar(100)*400, 0.5)
    )
}).play;
)

(
{
	var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
	Saw.ar((GbmanL.ar(100)*400)*0.4)* EnvGen.kr(env, doneAction: 2)
}.play
)


({
var sd, sin, env, envGen;
env = Env([100, 400, 30], [0.75, 0.25], [\sin, \sin]);
envGen = EnvGen.kr(env, doneAction: 0, timeScale: 5);
Saw.ar(envGen)*0.4 }.play;
)
