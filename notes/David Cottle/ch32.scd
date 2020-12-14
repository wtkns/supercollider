/*
APPENDIX
A. Converting SC2 Patches to SC3
Converting a simple patch

31.14. Converting a simple patch to SC3
*/

// SC2 patch

(
Synth.play(
 {
 SinOsc.ar(LFNoise0.kr(12, mul: 500, add: 600))
 }
)
)

// SC3 backward compatible version

s = Server.internal.boot;

(
 {
 SinOsc.ar(LFNoise0.kr(12, mul: 500, add: 600})
 }.play(s)
)

/*

31.15. SynthDef
*/

// SC2 patch

(
Synth.play(
 {
 SinOsc.ar(LFNoise0.kr(12, mul: 500, add: 600))
 }
)
)

// SC3 method

s = Server.internal.boot;

(
SynthDef("MySine",
 {
 var out;
 out = SinOsc.ar(LFNoise0.kr(12, mul: 500, add: 600));
 Out.ar(0, out);
 }).load(s) // or .play(s) or .send(s)
)

// Prototype

Synth.play({oldUgenFunc})

SynthDef("Name", 
{
var out; 
out = oldUgenFunc;
Out.ar(0, out);
}).load(s)

/*


31.16. SynthDef
*/

// After the synth has been sent to the server, play it

a = Synth("MySine")

// And stop it

a.free;

/*

31.17. SynthDef with arguments
*/

(
SynthDef("MySine",
 { arg rate = 12;
 var out;
 out = SinOsc.ar(LFNoise0.kr(rate, mul: 500, add: 600));
 Out.ar(0, out);
 }).load(s) // or .play(s) or .send(s)
)


a = Synth("MySine") // or a = Synth("MySine", [\rate, 15]);

// And stop it

a.set(\rate, 22);
a.set(\rate, 3);
a.free;

/*
iphase
rrand, rand, choose, Rand, TRand, TChoose
Spawning Events

31.18. Spawn
*/

(
SynthDef("MySine",
 { arg rate = 12, offset = 1000, scale = 900;
 var out;
 out = SinOsc.ar(LFNoise0.kr(rate, mul: scale, add: offset}
 *
 EnvGen.kr(Env.perc(0, 2), doneAction: 2);
 Out.ar(0, out)
 }).load(s) // or .play(s) or .send(s)
)

// Run this line several times. 
// Each one is equivalent to a spawned event. 
Synth("MySine", [\rate, rrand(4, 16), \offset, 600, \scale, 400])

/*

31.19. Spawning events with Task
*/

(
//run a task to play the synth 
r = Task({
 {Synth("MySine", 
 [\rate, rrand(5, 20),
 \offset, rrand(400, 800),
 \scale, rrand(100, 300)]);
 //Choose a wait time before next event
 rrand(0, 3.0).wait;
 }.loop;
}).play
)

/*

