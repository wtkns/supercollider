/*

17 - Karplus/Strong, Synthdef, Server commands
Karplus-Strong Pluck Instrument

17.1. noise burst
*/
 
(
{ 
 var burstEnv, att = 0, dec = 0.001; //Variable declarations
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1)); //envelope
 PinkNoise.ar(burstEnv); //Noise, amp controlled by burstEnv
}.play 
)

/*
Delays

17.2. Noise burst with delay 
*/

(
{ 
 var burstEnv, att = 0, dec = 0.001; 
 var out, delayTime = 0.5, delayDecay = 10;
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay)); 
 out = PinkNoise.ar(burstEnv); 
 out = out + CombL.ar(
 out, 
 delayTime, 
 delayTime, 
 delayDecay); //Echo chamber
 out
}.play //End Ugen function
)

/*
 
17.3. midi to cps to delay time
*/

// This will return the duration of each cycle of a wave 
// that is the frequency of midi value 69, or A 440

69.midicps.reciprocal; 

440.reciprocal; // same thing

// Insert this section into the pluck instrument.

( 
{ 
 var burstEnv, att = 0, dec = 0.001;
 var burst, delayTime, delayDecay = 0.5;
 var midiPitch = 69; // A 440
 delayTime = midiPitch.midicps.reciprocal;
// RandSeed.kr(Impulse.kr(1/delayDecay), 111);
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay)); 
 burst = PinkNoise.ar(burstEnv); 
 CombL.ar(burst, delayTime, delayTime, 
 delayDecay, add: burst); 
}.play 
)

/*
Delays for complexity 

17.4. Delay to add complexity
*/

(
{
t = Impulse.kr(5);
o = SinOsc.ar(TRand.kr(2000, 4000, t), mul: EnvGen.kr(Env.perc(0.001, 0.1), t))*0.1;
Mix.ar(Pan2.ar(
 CombL.ar(o, 2.0, 
 Array.fill(5, {rrand(0.2, 1.9)})
 ), 
 Array.fill(5, {1.0.rand2})
));
}.play
)

// Compare with

(
{
t = Impulse.kr(Array.fill(5, {rrand(4.0, 7.0)}));

Mix.ar(Pan2.ar(
SinOsc.ar(TRand.kr(2000, 4000, t), mul: EnvGen.kr(Env.perc(0.001, 0.1), t))*0.1,
 Array.fill(5, {1.0.rand2})
));
}.play
)

/*
Synth definitions

17.5. playing a synthDef
*/

//This first
{SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

//You will see something like this in the post window
//
//Synth("1967540257" : 1012)

//Then this, replacing 1967540257 with the number in your post window
Synth("1967540257");

/*

17.6. stopping a synthDef
*/

a = Synth("1967540257");

a.free;

/*

17.7. playing a synthDef
*/

//Run these one at a time
a = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

b = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

c = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

d = {SinOsc.ar(rrand(700, 1400), mul: 0.1)}.play

//Stop several

a.free; b.free; 

//or one at a time

c.free;

d.free

/*

17.8. SynthDef
*/

(//Original patch
{
var rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan; 
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay));
out = Pan2.ar(
 Blip.ar(LFNoise0.ar(rate, min(100, offset), offset), 
 (env)*12 + 1, 0.3),
 pan)*env;
out
}.play
)

//SynthDef (naming it) and arguments

(
SynthDef("SH", 
{
arg rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan; 
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay), doneAction: 2);
out = Pan2.ar(
 Blip.ar(LFNoise0.ar(rate, min(100, offset), offset), 
 (env)*12 + 1, 0.3),
 pan)*env;
Out.ar(0, out)
}).play
)
/*


17.9. Multiple nodes of SH
*/

//Three separate nodes of "SH" with different arugments. 
//Run these three lines in sequence then stop.
a = Synth("SH", [\rate, 10, \offset, 200]);
b = Synth("SH", [\offset, 400, \att, 3.0, \decay, 0]);
c = Synth("SH", [\rate, 30, \offset, 2000]);

//Let them die out or run these lines to stop them.
a.free; 
b.free; 
c.free;

//Changing a parameter of an existing node. Run these lines in sequence. 
a = Synth("SH", [\rate, 23, \offset, 30, \decay, 20]);
a.set(\offset, 1000)
a.set(\offset, 300)
a.set(\offset, 800)

a.free;

//Two nodes with arguments
a = Synth("SH", [\rate, 7, \offset, 200, \decay, 20]);
b = Synth("SH", [\rate, 23, \offset, 1200, \decay, 20]);
a.set(\offset, 40)
b.set(\offset, 1000)
a.set(\offset, 800)
b.set(\offset, 600)
a.set(\offset, 1200)
b.set(\offset, 50)

a.free; b.free

/*

17.10. Syntax for passing arguments
*/

//Same thing
a = Synth("SH", [\rate, 10, \offset, 200]);
a = Synth("SH", [0, 10, 3, 200]);
a = Synth("SH", ["rate", 10, "offset", 200]);

/*

17.11. Transition time between control changes
*/

//SynthDef, arguments, transition

(
SynthDef("SH", 
{
arg rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan; 
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay), doneAction: 2);
out = Pan2.ar(
 Blip.ar(LFNoise0.ar(rate, min(100, offset), offset), 
 (env)*12 + 1, 0.3),
 pan)*env;
Out.ar(0, out)
},
[0.5, 0.1, 0, 4] //transition for each argument above
).play
)

a = Synth("SH", [\rate, 6, \decay, 20, \offset, 200]);
a.set(\rate, 18);
a.set(\offset, 1000);

/*

17.12. Multiple nodes of SH
*/
 
(
r = Task({
 { 
 Synth("SH", [
 \rate, exprand(3.0, 22.0),
 \decay, rrand(0.5, 15.0),
 \att, [0, rrand(0, 3.0)].choose,
 \offset, rrand(100, 2000)]);
 rrand(1.0, 5.0).wait; //wait time between repetitions
 }.loop; //repeat this function
}).play
)

r.stop;

/*

17.13. Multiple nodes of SH
*/

(//Save to file and load in server "s"
SynthDef("SH", 
{
arg rate = 12, att = 0, decay = 5.0, offset = 400;
var env, out, pan; 
pan = LFNoise1.kr(1/3);
env = EnvGen.kr(Env.perc(att, decay), doneAction: 2);
out = Pan2.ar(
 Blip.ar(LFNoise0.ar(rate, min(100, offset), offset), 
 (env)*12 + 1, 0.3),
 pan)*env;
Out.ar(0, out)
}).load(s)
)

//Now quit SC, look in the synthdefs folder for "SH.scsyndef"

//Launch SC and run these lines

s = Server.internal; s.boot;

a = Synth("SH", [\rate, 10, \offset, 200], target: s);

/*

17.14. SynthDef Browser
*/

(
// a synthdef browswer
SynthDescLib.global.read;
SynthDescLib.global.browse;
)

/*

17.15. KSpluck SynthDef (EnvGen, Env, perc, PinkNoise, CombL, choose)
*/

(
//First load the synth and save to disk
SynthDef("KSpluck", 
 {
 arg midiPitch = 69, delayDecay = 1.0;
 var burstEnv, att = 0, dec = 0.001;
 var signalOut, delayTime;
 delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec)); 
 signalOut = PinkNoise.ar(burstEnv); 
 signalOut = CombL.ar(signalOut, delayTime, delayTime, 
 delayDecay, add: signalOut); 
 DetectSilence.ar(signalOut, doneAction:2);
 Out.ar(0, signalOut)
 }
).play;
)

(
//Then run this playback task
r = Task({
 {Synth("KSpluck", 
 [
 \midiPitch, rrand(30, 90), //Choose a pitch
 \delayDecay, rrand(0.1, 1.0) //Choose duration
 ]);
 //Choose a wait time before next event
 [0.125, 0.125, 0.25].choose.wait;
 }.loop;
}).play(SystemClock)
)

//Stop it

r.stop;

/*
Practice: Karplus-Strong Patch

17.16. Practice: K S pluck (EnvGen, PinkNoise, LFNoise1, Out, DetectSilence)
*/

//Load this definition
(
SynthDef.new("KSpluck3", 
 { //Beginning of Ugen function
 arg midiPitch, art;
 var burstEnv, att = 0, dec = 0.01, legalPitches; //Variable declarations
 var out, delayTime;
 delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec)); 
 out = PinkNoise.ar([burstEnv, burstEnv]); //Noise burst
 out = CombL.ar(out, delayTime, delayTime, 
 art, add: out); //Echo chamber
 out = RLPF.ar(out, LFNoise1.kr(2, 2000, 2100), 0.1); //Filter
 DetectSilence.ar(out, doneAction:2);
 Out.ar(0, out*0.8)
 }
).play;
)


//Then run this routine

(
r = Task({
 {Synth("KSpluck3",
 [
 \midiPitch, [0, 2, 4, 6, 8, 10].choose + [24, 36, 48, 60].choose,
 \art, [0.125, 0.25, 0.5, 1.0, 2.0].choose
 ]);
 //Choose a wait time before next event
 [0.125, 0.125, 0.125, 0.125, 0.125, 1].choose.wait;
 }.loop;
}).play(SystemClock)
)

/*
17. Exercise
*/
