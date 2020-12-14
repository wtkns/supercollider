/*
18 - Busses and Nodes and Groups (oh my!); Linking Things Together
Disclaimer

18.1. Browsing Synth Definitions
*/

(
// a synthdef browswer
SynthDescLib.global.read;
SynthDescLib.global.browse;
)

/*
Synth definitions

18.2. First Patch (play, SinOsc, LFNoise0, .ar)
*/

{SinOsc.ar(LFNoise0.ar([10, 15], 400, 800), 0, 0.3)}.play

/*

18.3. First SynthDef
*/

//SynthDef (naming it) and arguments

(
SynthDef("RandSine", 
{
arg rate = 9, scale = 300, offset = 600, pan = 0, out;
out = Pan2.ar(SinOsc.ar(LFNoise0.ar(rate, scale, offset), mul: 0.3), pan);
DetectSilence.ar(out, doneAction:2);
Out.ar(0, out)
}).load(s)
)

// execute these separately
a = Synth("RandSine", [\pan, -1, \rate, 8]);
b = Synth("RandSine", [\pan, 1, \rate, 13]);
b.set(\offset, 2000);
a.set(\rate, 20);
b.set(\rate, 6);
a.set(\scale, 550);

/*
Audio and Control Busses

18.4. Audio and Control Busses 
*/

(
{
 [
 SinOsc.ar,
 PinkNoise.ar,
 LFNoise1.ar,
 LFNoise0.ar,
 LFTri.ar,
 WhiteNoise.ar
 ]*0.4
}.scope
)

// Control busses

(
{
 [
 SinOsc.kr(100),
 Dust.kr(50),
 Impulse.kr(78),
 LFNoise0.kr(100),
 LFNoise1.kr(100),
 WhiteNoise.kr
 ]*0.4
}.scope(zoom: 10)
)
/*

18.5. Assigning busses
*/

//Entire patch
{SinOsc.ar(LFNoise0.kr([10, 15]) * 400 + 800, 0, 0.3)}.scope

//Just the SinOsc
{SinOsc.ar(800, 0, 0.3)}.scope

//Just the LFNoise0
{LFNoise0.ar([10, 15])}.scope

//Just Sine patched to audio out 0
{Out.ar(0, SinOsc.ar(800, 0, 0.3))}.scope; 

//Just Sine patched to audio out 5
{Out.ar(5, SinOsc.ar(800, 0, 0.3))}.scope(16); 

//Just the LFNoise def
{Out.kr(9, LFNoise0.kr([10, 15], 1, 0))}.scope(16, zoom: 10)

/*

18.6. Patching synths together with a bus
*/

{Out.kr(20, LFNoise0.kr([8, 11], 500, 1000))}.scope

{Out.ar(0, SinOsc.ar(In.kr(20, 2), 0, 0.3))}.scope

/*

18.7. Patching synths together with a bus, dynamic control sources
*/

(
//Start all the synths
SynthDef("LFN0Control", 
 {Out.kr(20, LFNoise0.kr([8, 11], 500, 1000))}).play(s);


SynthDef("SineControl", 
 {Out.kr(22, SinOsc.kr([3, 3.124], mul: 500, add: 1000))}).play(s);


SynthDef("MouseControl", 
 {Out.kr(24, MouseX.kr([100, 200], 1000))}).play(s);


a = SynthDef("PatchableSine", {arg busInNum = 0;
 Out.ar(0, SinOsc.ar(In.kr(busInNum, 2), 0, 0.3))}).play(s);
)

a.set(\busInNum, 20); //set to LFNoise0
a.set(\busInNum, 22); //set to SineControl
a.set(\busInNum, 24); //set to MouseControl

/*

18.8. Patching synths together with a bus, dynamic control sources
*/

a = Synth("PatchableSine", [\busInNum, 20]); b = Synth("LFN0Control");

b.free; b = Synth("SineControl"); a.set(\busInNum, 22);
b.free; b = Synth("MouseControl"); a.set(\busInNum, 24);

/*
 
18.9. Several controls over a single bus
*/

(
SynthDef("SendControl1", {
 Out.kr(0, SinOsc.ar(0.3, mul: 1000, add: 1100))}).send(s);
SynthDef("SendControl2", {Out.kr(0, LFNoise0.ar(12, 200, 500))}).send(s);
SynthDef("Receive", {Out.ar(0, SinOsc.ar(In.kr(0)))}).send(s);
)

Synth("Receive");
Synth("SendControl1");
Synth("SendControl2");

//Or

Synth("Receive");
Synth("SendControl2");
Synth("SendControl1");

//Or

(
SynthDef("SendControl", {Out.kr(1275, LFNoise0.ar(12, 200, 500))}).send(s);
SynthDef("Receive1", {
 Out.ar(0, RLPF.ar(PinkNoise.ar, In.kr(1275), 0.05))}).send(s);
SynthDef("Receive2", {Out.ar(1, SinOsc.ar(In.kr(1275)))}).send(s);
)

Synth("Receive1");
Synth("Receive2");
Synth("SendControl");

//Stop all using command-. Then try executing them in reverse order 

// Open the browser and examine the bus assignments.

(
// a synthdef browswer
SynthDescLib.global.read;
SynthDescLib.global.browse;
)


/*
Nodes

18.10. node order, head, tail
*/

(
//The definitions can be any order
SynthDef("Saw", { arg filterBus = 16;
 Out.ar(filterBus, LFSaw.ar([60, 90]))
}).send(s);

SynthDef("Filter", {arg filterBus = 16;
 Out.ar(0, RLPF.ar(In.ar(filterBus, 2), LFNoise0.kr(12, 300, 350), 0.2))
}).send(s);
)

//won't work
Synth("Saw"); //source
Synth("Filter"); //filter

//works
Synth("Filter"); //filter
Synth("Saw"); //source

//or 
Synth("Filter"); Synth("Saw");

/*

18.11. Execution order, node order
*/

// This execution order

Synth("Receive");
Synth("SendControl1");
Synth("SendControl2");

// Results in these nodes printed to the post window

Synth("Receive" : 1000)
Synth("SendControl1" : 1001)
Synth("SendControl2" : 1002)


/*

18.12. node order, head, tail
*/

Synth.head(s, "Saw"); 
Synth.tail(s, "Filter");

//Same

Synth.tail(s, "Filter");
Synth.head(s, "Saw"); 

/*
Dynamic bus allocation

18.13. Bus allocation and reallocation
*/

b = Bus.audio;

b.index;

b.free;

c = Bus.audio(s, 2);
b = Bus.audio(s, 2);

{Out.ar(c.index, Saw.ar)}.play;
{Out.ar(b.index, SinOsc.ar([500, 1000])).scope(8)

b.free; c.free;

/*

18.14. Bus allocation and reallocation
*/

{Out.ar(4, SinOsc.ar([100, 200, 300, 400]))}.scope(8);

b = Bus.audio(s, 2);

b.index; // should still be 4 regardless of above code

{Out.ar(b.index, Saw.ar([800, 1000]))}.scope(8); // adds to sines

b.free;

/*

18.15. Bus allocation
*/

a = Bus.audio(s, 2) // Get the next available 2 channels
b = Bus.audio(s, 1) // Get next 1 channel
c = Bus.audio(s, 2) // Get two more
c.index // print c
a.index // print a
a.free // free a
b.free // free b
d = Bus.audio(s, 1) // a and b are now free, so these
e = Bus.audio(s, 2) // should take over those indexes
a = Bus.audio(s, 2) // reallocate a and b, will probably 
b = Bus.audio(s, 1) // 9 through 11
[a, b, c, d, e].postln; // print all of them
s.scope(14); // start a scope

// Now we start some synths. I'm going to mix them all
// down to bus 0, 1, so we have to start it first. Remember
// In first, Out second, receive first, send second. 

{Out.ar(0, Mix.ar(In.ar(2, 12))*0.1)}.play
{Out.ar(a.index, SinOsc.ar)}.play
{Out.ar(b.index, SinOsc.ar(1000))}.play
{Out.ar(c.index, Saw.ar([400, 800]))}.play
{Out.ar(d.index, Pulse.ar(200))}.play
{Out.ar(e.index, [Saw.ar(500), FSinOsc.ar(900)])}.play
// You can get a bus without assigning it to a variable,
// you just won't be able to free it later. 
{Out.ar(Bus.audio.index, Saw.ar(2000))}.play
// You can write two signals to a single bus
{Out.ar(a.index, Saw.ar(2000))}.play


[a, b, c, d, e].do({arg each; each.free}) // free all of them

/*
Using busses for efficiency

18.16. inefficient patch
*/

(
SynthDef("inefficient",
{
var out, delay;
out = 
 SinOsc.ar(LFNoise0.kr(15, 400, 800), mul: 0.2)
 *
 EnvGen.kr(
 Env.perc(0, 1), 
 gate: Dust.kr(1)
 );

delay = CombC.ar(out, 0.5, [0.35, 0.5]);
out = Pan2.ar(out, Rand(-1.0, 1.0));
Out.ar(0, (out + delay))
}).play;
)

// Type this into a new window with no return and keep pressing enter
Synth("inefficient")

/*

18.17. more efficient modular approach using busses
*/

(
//define all the synths in one pass
SynthDef("singleTrigger", {
 Out.kr(
 //output busses are 1560 through 1565 
 LFNoise0.kr(5, mul: 4.0, add: 1563).div(1), 
 Dust.kr(6)
 )
}).send(s);

SynthDef("source",
{ arg trigIn, rate;
var out, delay;
out = 
 SinOsc.ar(LFNoise0.kr(rate, 400, 800), mul: 0.1)
 *
 EnvGen.kr(
 Env.perc(0, 1), 
 gate: In.kr(trigIn)
 );

out = Pan2.ar(out, Rand(-1.0, 1.0));
Out.ar(16, out)
}).send(s);

SynthDef("singleReverb",
{
var signal; 
signal = In.ar(16, 2);
 Out.ar(0, (signal + CombC.ar(signal, 0.5, [0.35, 0.5])))
}).send(s);

)

// start the trigger
Synth("singleTrigger", [\rate, 1/4])

// start the reverb
Synth("singleReverb")

// start the sources "watching" trigger busses 4-9
// start 4 and 9 first to make sure they're working (with
// a slow and fast rate so you can keep track)

Synth("source", [\trigIn, 1560, \rate, 4]) 
Synth("source", [\trigIn, 1565, \rate, 25])
Synth("source", [\trigIn, 1561, \rate, 10])
Synth("source", [\trigIn, 1562, \rate, 8])
Synth("source", [\trigIn, 1563, \rate, 17])
Synth("source", [\trigIn, 1564, \rate, 7])

/*
Groups
Group Manipulation

18.18. Groups, group manipulation
*/

(
//Create a synth
SynthDef("ping",
{arg fund = 100, harm = 1, rate = 0.2, amp = 0.1;
a = Pan2.ar(SinOsc.ar(fund*harm, mul: amp) *
EnvGen.kr(Env.perc(0, 0.2), gate: Dust.kr(rate)), Rand(-1.0, 1.0));
Out.ar(0, a)
}).load(s);
)

// Define a group using a global variable (~)
~synthGroup = Group.head(s);

// Run this 8 or so times, adding a new ping to the group
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
Synth("ping", [\fund, rrand(100, 1000), \rate, 1], ~synthGroup);
//etc.

// Change all the rates of the group
~synthGroup.set(\rate, 3/5);
~synthGroup.set(\rate, 8);

// Change the amplitude
~synthGroup.set(\amp, 0.2);
~synthGroup.set(\amp, 0.01);

//Command-period stops the synths and the group, so use this so that the
//group still exists.
~synthGroup.freeAll;

/*

18.19. Automated node creation
*/

~all = Array.fill(12, 
 {arg i; Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],~synthGroup)});

~synthGroup.set(\rate, 0.8);
~synthGroup.set(\rate, 5);

Array.fill(12, {arg i; i/2+1})

// Change the amp of one node
~all.at(6).set(\amp, 1);
~all.at(6).set(\amp, 0.1);

// Change all the harmonics using a formula. I checked the formulas
// using this Array.fill(12, {arg i; i/2+1})

~all.do({arg node, count; node.set(\harm, count/2+1)}); //1, 1.5, 2, etc.
~all.do({arg node, count; node.set(\harm, count*2+1)}); //1, 3, 5, 7, etc.
~all.do({arg node, count; node.set(\harm, count*1.25+1)});
~all.do({arg node, count; node.set(\harm, count*1.138+1)});

// Change the fundamental
~synthGroup.set(\fund, 150);
~synthGroup.set(\fund, 250);
~synthGroup.set(\fund, 130);

// Stop the nodes but not the group
~synthGroup.freeAll;

// Create a task that adds new synths
r = Task({{Synth("ping", 
 [\fund, rrand(100, 2000), \rate, 2], ~synthGroup); 1.wait}.loop}).play

// Slow down the attacks when it gets to be too many
~synthGroup.set(\rate, 0.2);

// Turn them all down. Note that new ones still have the old volume
~synthGroup.set(\amp, 0.01);

// Stop everything but the task
~synthGroup.free;

// Stop the task
r.stop;

/*

18.20. Source Group, Fx Group
*/

(
SynthDef("ping",
{arg fund = 400, harm = 1, rate = 0.2, amp = 0.1;
a = Pan2.ar(SinOsc.ar(fund*harm, mul: amp) *
EnvGen.kr(Env.perc(0, 0.2), gate: Dust.kr(rate)), Rand(-1.0, 1.0));
Out.ar(16, a)
}).load(s);

SynthDef("dry",
{var signal; 
signal = In.ar(16, 2);
 Out.ar(0, signal);
}).load(s);

SynthDef("echo1",
{
var signal, echo; 
signal = In.ar(16, 2);
echo = CombC.ar(signal, 0.5, [0.35, 0.5]);
 Out.ar(0, echo);
}).load(s);


SynthDef("echo2",
{
var signal, echo; 
signal = In.ar(16, 2);
echo = Mix.arFill(3, { CombL.ar(signal, 1.0, LFNoise1.kr(Rand(0.1, 0.3), 0.4, 0.5), 
15) });
 Out.ar(0, echo*0.2)
}).load(s);
)


~synthGroup = Group.head(s);
~fxGroup = Group.tail(s);

// 12.do will not allow me to access each one, but it doesn't matter
(
12.do({arg i; 
 Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],
 ~synthGroup)});
)

// "ping" is playing on bus 16, so we don't hear it

// Start the echo1 (wet), echo2 (still wet), then dry
a = Synth("echo1", target: ~fxGroup);
b = Synth("echo2", target: ~fxGroup);
c = Synth("dry", target: ~fxGroup);

b.free; // remove each in a different order
a.free;
c.free;

// The original ping is still running, so stop it.
~synthGroup.freeAll;

// This also works
a = Synth("echo1", target: ~fxGroup);
b = Synth("echo2", target: ~fxGroup);
12.do({arg i; Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],~synthGroup)});
c = Synth("dry", target: ~fxGroup);

~synthGroup.freeAll; // Stop the source, but the echoes are still running

// Start the source again
12.do({arg i; Synth("ping", [\harm, i+1, \amp, (1/(i+1))*0.4],~synthGroup)});

~synthGroup.set(\rate, 0.8);
~synthGroup.set(\rate, 5);

~synthGroup.free;
~fxGroup.free;

/*
Practice: Bells and Echoes

18.21. Bells and echoes
*/

(
SynthDef("bells", 
{arg freq = 100;
var out, delay; 
out = SinOsc.ar(freq, mul: 0.1)
*
EnvGen.kr(Env.perc(0, 0.01), gate: Dust.kr(1/7));

out = Pan2.ar(Klank.ar(`[Array.fill(10, {Rand(100, 5000)}),
 Array.fill(10, {Rand(0.01, 0.1)}),
 Array.fill(10, {Rand(1.0, 6.0)})], out), Rand(-1.0, 1.0));

Out.ar(0, out*0.4); //send dry signal to main out
Out.ar(16, out*1.0); //and send louder dry signal to fx bus

}).load(s);

SynthDef("delay1", // first echo
{var dry, delay;
dry = In.ar(16, 2);
delay = AllpassN.ar(dry, 2.5, 
 [LFNoise1.kr(2, 1.5, 1.6), LFNoise1.kr(2, 1.5, 1.6)], 
 3, mul: 0.8);
Out.ar(0, delay);
}).load(s);

SynthDef("delay2", // second echo
{var delay, dry;
dry = In.ar(16, 2);
delay = CombC.ar(dry, 0.5, [Rand(0.2, 0.5), Rand(0.2, 0.5)], 3);
Out.ar(0, delay);
}).load(s);

SynthDef("delay3", // third echo
{
var signal, delay; 
signal = In.ar(16, 2);
delay = Mix.arFill(3, { CombL.ar(signal, 1.0, LFNoise1.kr(Rand([0.1, 0.1], 0.3), 0.4, 
0.5), 15) });
 Out.ar(0, delay*0.2)
}).load(s);
)

//define groups
~fxGroup = Group.tail;
~bellGroup = Group.head;

// start one of the echoes and 4 bells
f = Synth("delay3", target: ~fxGroup);
4.do({Synth("bells", [\freq, rrand(30, 1000)], target: ~bellGroup)})

// stop existing echo and change to another
f.free; f = Synth("delay1", target: ~fxGroup);
f.free; f = Synth("delay2", target: ~fxGroup);
f.free; f = Synth("delay3", target: ~fxGroup);
Synth("delay1", target: ~fxGroup); // add delay1 without removing delay3

/*


18. Exercises
*/
