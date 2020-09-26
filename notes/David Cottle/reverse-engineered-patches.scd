/*
D. Step by Step (Reverse Engineered) Patches

*/
Server.default = s = Server.internal.boot
// Rising Sine Waves

(
{
SinOsc.ar(440, mul: 0.4) //SinOsc
}.play(s)
)

(
{
var cont2;
//control frequency with LFSaw
//midi values are converted to frequency
cont2 = LFSaw.kr(2/5, 0, 24, 80).midicps;
SinOsc.ar(cont2, mul: 0.4)
}.play(s)
)

(
{
var cont1;
cont1 = LFSaw.kr(8, 0, 3, 80).midicps; //second control for offset
SinOsc.ar(cont1, mul: 0.4)
}.play(s)
)

(
{ //combine the two, but do the midicps only once
var cont1, cont2;
cont1 = LFSaw.kr(8, 0, 3, 80);
cont2 = LFSaw.kr(2/5, 0, 24, cont1).midicps;
SinOsc.ar(cont2, mul: 0.4)
}.play(s)
)

(
{
var cont1, cont2; //add random values and stereo
cont1 = LFSaw.kr([rrand(6.0, 8.0), rrand(6.0, 8.0)], 0, 3, 80);
cont2 = LFSaw.kr(2/5, 0, 24, cont1).midicps;
SinOsc.ar(cont2, mul: 0.4)
}.play(s)
)

(
{
var cont1, cont2, out;
cont1 = LFSaw.kr([rrand(6.0, 8.0), rrand(6.0, 8.0)], 0, 3, 80);
cont2 = LFSaw.kr(2/5, 0, 24, cont1).midicps;
out = SinOsc.ar(cont2, mul: 0.1);
out = CombN.ar(out, 0.2, 0.2, 4); //add echo
out
}.play(s)
)

(
SynthDef("RisingSines",
{ arg busOut = 3, sweep = 3, rate = 0.4, offset = 80, range = 24;
 var cont1, cont2, out;
 cont1 = LFSaw.kr([rrand(6.0, 8.0), rrand(6.0, 8.0)], 0, sweep, offset);
 cont2 = LFSaw.kr(rate, 0, range, cont1).midicps;
 out = SinOsc.ar(cont2, mul: 0.1);
 Out.ar(busOut, out);
}).send(s);
SynthDef("Echo",
{ arg busIn = 3, delay = 0.2;
 var out;
 out = CombN.ar(In.ar(busIn, 2), delay, delay, 4);
 Out.ar(0, out);
}).send(s)
)

Synth("Echo");
Synth("RisingSines");
Synth("RisingSines", [\rate, 1/7, \offset, 60, \range, 32]);

// Random Sine Waves


(
{
FSinOsc.ar(exprand(700, 2000)) //single random Sine
}.play(s)
)

(
{
FSinOsc.ar(exprand(700, 2000), 0,
 //Random envelopes using LFNoise1
 //Let it run for a while
 max(0, LFNoise1.kr(3/5, 0.9)))
}.play(s)
)

(
{

Pan2.ar( //pan position
 FSinOsc.ar(exprand(700, 2000), 0,
 max(0, LFNoise1.kr(3/5, 0.9))),
 //random moving pan, let it run for a while
 LFNoise1.kr(1/3))
}.play(s)
)

(
{
var sines;
sines = 60;
//Mix a bunch of them down and decrease frequency of LF env
Mix.ar({Pan2.ar(
 FSinOsc.ar(exprand(700, 2000), 0,
 max(0, LFNoise1.kr(1/9, 0.7))),
 LFNoise1.kr(1/3))}.dup(sines))*0.2
}.play(s)
)

(
{
var sines;
sines = 60;
//Increase frequency of env
Mix.ar({Pan2.ar(
 FSinOsc.ar(exprand(700, 2000), 0,
 max(0, LFNoise1.kr(9, 0.7))),
 LFNoise1.kr(1/3))}.dup(sines))*0.2
}.play(s)
)

Sync Saw

(
{
SyncSaw.ar(440, mul: 0.2) //simple Saw
}.play(s)
)

(
{
SyncSaw.ar(
 100, //Saw frequency
 MouseX.kr(50, 1000), //Sync frequency
 mul: 0.2)
}.scope(1)
)

(
{
SyncSaw.ar(
 100, //Saw frequency
 //Sync controlled by SinOsc
 SinOsc.ar(1/5, 0, mul: 200, add: 300),
 mul: 0.2)
}.scope(1)
)

(
{
SyncSaw.ar(
 100, //Saw frequency
 //Separate phase for left and right channel
 SinOsc.ar(1/5, [0, 3.0.rand], mul: 200, add: 300),
 mul: 0.2)
}.scope(2)
)

(
{
SyncSaw.ar(
 [100, 100*1.02], //Separate freq for L, R
 SinOsc.ar(1/5, [0, 3.0.rand], mul: 200, add: 300),
 mul: 0.2)
}.scope(2)
)

(
{
var freq;
freq = rrand(30, 80).midicps; //choose freq
SyncSaw.ar(
 [freq, freq*1.02], //freq variable replaces static values
 SinOsc.ar(1/5, [0, 3.0.rand], mul: freq*2, add: freq*3),
 mul: 0.2)
}.scope(2)
)


(//add an envelope
{
var freq, sig, env;
freq = rrand(30, 80).midicps;
env = EnvGen.kr(Env.linen(rrand(1.0, 3.0), rrand(4.0, 7.0), rrand(2.0, 3.0)));
sig = SyncSaw.ar(
 [freq, freq*1.002], //Saw frequency
 SinOsc.ar(1/5, [0, 3.0.rand], mul: freq*2, add: freq*3),
 mul: 0.1);
sig = CombN.ar(sig, 0.3, 0.3, 4, 1); //Add echo
sig*env
}.scope(2)
)

(//Send synth def to server with freq argument
SynthDef("SyncSaw-Ex",
{
arg freq;
var sig, env;
env = EnvGen.kr(Env.linen(rrand(1.0, 3.0), rrand(4.0, 7.0), rrand(2.0, 3.0)),
doneAction: 2);
sig = SyncSaw.ar(
 [freq, freq*1.002], //Saw frequency
 SinOsc.ar(1/5, [0, 3.0.rand], mul: freq*2, add: freq*3),
 mul: 0.1);
sig = CombN.ar(sig, 0.3, 0.3, 4, 1); //Add echo
sig = sig*env;
Out.ar(0, sig*0.8)
}).play(s)
)

(
//run a task to play the synth
r = Task({
 {Synth("SyncSaw-Ex", [\freq, rrand(30, 80).midicps]);
 //Choose a wait time before next event
 rrand(2.0, 5.0).wait;
 }.loop;
}).play
)

// Uplink

(
{
LFPulse.ar(200, 0, 0.5, 0.4) //simple pulse
}.play(s)
)

(
{
var freq;
freq = LFPulse.kr(10, 0, 0.3, 2000, 200); //freq control
LFPulse.ar(freq, 0, 0.5, 0.4)
}.play(s)
)

(
{
var freq;
//add random values and additional control for add
freq = LFPulse.kr(rrand(10, 20), 0, rrand(0.1, 0.8),
 LFPulse.kr(1, 0, 0.5, 4000, 700));
LFPulse.ar(freq, 0, 0.5, 0.4)
}.play(s)
)

(
{
var freq;
//duplicate and add the two together
freq = LFPulse.kr(20.rand, 0, rrand(0.1, 0.8),
 LFPulse.kr(rrand(1.0, 5.0), 0,
 rrand(0.1, 0.8),
 8000.rand,
 2000.rand));
freq = freq + LFPulse.kr(20.rand, 0, rrand(0.1, 0.8),
 LFPulse.kr(rrand(1.0, 5.0), 0,
 rrand(0.1, 0.8),
 8000.rand,
 2000.rand));
LFPulse.ar(freq, 0.5, 0.1)

}.play(s)
)

(
{
var freq, out, env;
//add an envelope
env = EnvGen.kr(Env.linen(rrand(4.0, 7.0), 5.0, rrand(2.0, 5.0)));
freq = LFPulse.kr(20.rand, 0, rrand(0.1, 0.8),
 LFPulse.kr(rrand(1.0, 5.0), 0,
 rrand(0.1, 0.8),
 8000.rand,
 2000.rand));
freq = freq + LFPulse.kr(20.rand, 0, rrand(0.1, 0.8),
 LFPulse.kr(rrand(1.0, 5.0), 0,
 rrand(0.1, 0.8),
 8000.rand,
 2000.rand));
//pan and echo
out = Pan2.ar(LFPulse.ar(freq, 0.5, 0.1), 1.0.rand2);
2.do(out = AllpassN.ar(out,
 [rrand(0.1, 0.01), rrand(0.1, 0.01)]));
out*env
}.play(s)
)

(
//Send synth def to server with freq argument
SynthDef("Uplink-Ex",
{
var freq, out, env;
//add an envelope
env = EnvGen.kr(Env.linen(rrand(4.0, 7.0), 5.0, rrand(2.0, 5.0)), doneAction: 2);
freq = LFPulse.kr(20.rand, 0, rrand(0.1, 0.8),
 LFPulse.kr(rrand(1.0, 5.0), 0,
 rrand(0.1, 0.8),
 8000.rand,
 2000.rand));
freq = freq + LFPulse.kr(20.rand, 0, rrand(0.1, 0.8),
 LFPulse.kr(rrand(1.0, 5.0), 0,
 rrand(0.1, 0.8),
 8000.rand,
 2000.rand));
//pan and echo
out = Pan2.ar(LFPulse.ar(freq, 0.5, 0.1), 1.0.rand2);
2.do(out = AllpassN.ar(out,
 [rrand(0.1, 0.01), rrand(0.1, 0.01)]));
out*env;
Out.ar(0, out*0.8)
}).play(s)
)

(
//run a task to play the synth
r = Task({
 {Synth("Uplink-Ex");
 //Choose a wait time before next event
 rrand(4.0, 9.0).wait;
 }.loop;
}).play
)



// Ring and Klank

(
{
 Dust.ar(20, 0.2) //noise bursts
}.play(s)
)

(
{
var partials;
partials = 8;
Klank.ar( //fill klank with random partials and amplitudes
 `[Array.rand(partials, 100, 10000), nil,
 Array.rand(partials, 0.2, 0.9)],
 Dust.ar(20, 0.2))
}.play(s)
)

(
{ //ring element
SinOsc.ar(LFNoise2.kr(1.0, 200, 300), mul: 0.5)
}.play(s)
)

(
{
var partials, out, filter, bell;
partials = 8;
filter = SinOsc.ar(LFNoise2.kr(1.0, 200, 300), mul: 0.3);
bell = Klank.ar(
 `[Array.rand(partials, 100, 10000), nil,
 Array.rand(partials, 0.2, 0.9)],
 Dust.ar(20, 0.2))*filter; //ring klank with filter
bell
}.play(s)
)

(
{
var partials, out, filter, bell;
partials = 8;
filter = SinOsc.ar(
 LFNoise2.kr(rrand(0.7, 1.3),
 rrand(200, 400), //add random choices
 rrand(500, 1000)),
 mul: 0.2);
Mix.ar({ //insert inside Mix
 bell = Klank.ar(
 `[Array.rand(partials, 100, 10000), nil,
 Array.rand(partials, 0.2, 0.9)],
 Dust.ar(12, 0.2))*filter;
 bell = Pan2.ar(bell, LFNoise2.kr(2/3));
 bell}.dup(4))*0.4
}.play(s)
)


// Tremulate

{FSinOsc.ar(440)}.play //Sine oscillator

//Amp control begins with LFNoise2
{LFNoise2.ar(20, 0.9)}.scope(1)

//Max removes negative values (makes them 0)
{max(0, LFNoise2.ar(20, 0.9))}.scope(1)

(
{
var ampCont;
//Amp controlled by LFNoise
ampCont = max(0, LFNoise2.ar(20, 0.4));
FSinOsc.ar(440, mul: ampCont)}.play
)

(
{
var ampCont;
ampCont = max(0, LFNoise2.ar([20, 30], 0.1));
FSinOsc.ar([400, 500], mul: ampCont)}.play
)

(
{
var ampCont, rate, freq, chord;
rate = rrand(30, 70);
freq = 500;
chord = [1, 5/4, 3/2, 15/8];
ampCont = max(0, LFNoise2.ar([rate, rate, rate, rate], 0.1));
//create a bunch of these then mix them down
Mix.ar(FSinOsc.ar(freq*chord, mul: ampCont))}.play
)

(
({
var ampCont, rate, freq, chord;
rate = rrand(30, 70);
freq = rrand(300, 1000);
chord = [
 [1, 5/4, 3/2, 15/8],
 [1, 6/5, 3/2, 9/5],
 [1, 4/3, 3/2, 9/5],
 [1, 9/8, 3/2, 5/3]];
ampCont = max(0, LFNoise2.ar([rate, rate, rate, rate], 0.1));
//choose a chord
Mix.ar(FSinOsc.ar(freq*chord.choose, mul: ampCont))}).play
)

(
{ //Add pan and env
var ampCont, rate, freq, chord, env, panp, out;
rate = rrand(30, 70);
freq = rrand(300, 1000);
panp = 1.0.rand2;
env = EnvGen.kr(Env.linen(0.1, 2.0, 5.0));
chord = [
 [1, 5/4, 3/2, 15/8],
 [1, 6/5, 3/2, 9/5],
 [1, 4/3, 3/2, 9/5],
 [1, 9/8, 3/2, 5/3]];
ampCont = max(0, LFNoise2.ar([rate, rate, rate, rate], 0.1));
//choose a chord
out = Mix.ar(
 Pan2.ar(FSinOsc.ar(freq*chord.choose, mul: ampCont), panp)
);
out*env;
}.play
)
Harmonic Swimming and Tumbling

(
{
 FSinOsc.ar(500, mul: 0.3) //Sine oscillator
}.play(s)
)

(
{
 FSinOsc.ar(500,
 //amp control same as tremulate
 mul: max(0, LFNoise1.kr(rrand(6.0, 12.0), mul: 0.6)))
}.play(s)
)

(
{
 FSinOsc.ar(500,
 mul: max(0, LFNoise1.kr(rrand(6.0, 12.0), mul: 0.6,
 add: Line.kr(0, -0.2, 20)))) //slow fade
}.play(s)
)

(
{
var freq;
freq = 500;
 //two frequencies a fifth apart
 FSinOsc.ar(freq*[1, 3/2],
 mul: max(0, LFNoise1.kr(rrand([6.0, 6.0], 12.0), mul: 0.6,
 add: Line.kr(0, -0.2, 20))))
}.play(s)
)

(
{
var signal, partials, freq;
signal = 0;
partials = 8;
//Begin with low fundamental
freq = 50;

//duplicate and sum frequencies at harmonic intervals
partials.do({arg harm;
harm = harm + 1;
signal = signal +
 FSinOsc.ar(freq * [harm, harm*3/2],
 mul: max(0, LFNoise1.kr(rrand([6.0, 6.0], 12.0),
 mul: 1/(harm + 1) * 0.6,
 add: Line.kr(0, -0.2, 20))))
 });
signal
}.play(s)
)

(
SynthDef("Tumbling",
{arg freq = 50;
var signal, partials;
signal = 0;
partials = 8;
partials.do({arg harm;
harm = harm + 1;
signal = signal +
 FSinOsc.ar(freq * [harm, harm*3/2],
 mul: max(0, LFNoise1.kr(Rand([6.0, 6.0], 12.0), mul: 1/(harm + 1) * 0.6)
 ))
 });
signal = signal*EnvGen.kr(Env.perc(0.2,20.0), doneAction: 2);
Out.ar(0, signal*0.8)
}
).send(s)
)

(
//run a task to play the synth
r = Task({
 {Synth("Tumbling", [\freq, rrand(30, 80)]);
 //Choose a wait time before next event
 rrand(12.0, 20.0).wait;
 }.loop;
}).play
)

// Police State

(
{
//single siren
SinOsc.ar(
 SinOsc.kr(0.1, 0, 600, 1000),
 0,
 0.2)

}.play(s)
)

(
{
SinOsc.ar(//random frequencies and phase
 SinOsc.kr(Rand(0.1, 0.12),
 2pi.rand, Rand(200, 600), Rand(1000, 1300)),
 mul: 0.2)

}.play(s)
)

(
{
SinOsc.ar(
 SinOsc.kr(Rand(0.1, 0.12),
 6.0.rand, Rand(200, 600), Rand(1000, 1300)),
 //conrol scale
 mul: LFNoise2.ar(Rand(100, 120), 0.2))

}.play(s)
)

(
{
//pan and mix several
Mix.arFill(4, {
 Pan2.ar(
 SinOsc.ar(
 SinOsc.kr(Rand(0.1, 0.12),
 6.0.rand, Rand(200, 600), Rand(1000, 1300)),
 mul: LFNoise2.ar(Rand(100, 120), 0.1)),
 1.0.rand2)
})

}.play(s)
)

(
{
LFNoise2.ar(600, 0.1) //second component
}.play(s)
)

(
{
//ring modulate?
LFNoise2.ar(LFNoise2.kr(2/5, 100, 600), LFNoise2.kr(1/3, 0.1, 0.06))
}.play(s)
)

(
{
//stereo
LFNoise2.ar(LFNoise2.kr([2/5, 2/5], 100, 600), LFNoise2.kr([1/3, 1/3], 0.1, 0.06))
}.play(s)
)

(
{
//add the two and add echo
CombL.ar(
 Mix.arFill(4, {
 Pan2.ar(
 SinOsc.ar(
 SinOsc.kr(Rand(0.1, 0.12),
 6.0.rand, Rand(200, 600), Rand(1000, 1300)),
 mul: LFNoise2.ar(Rand(100, 120), 0.1)),
 1.0.rand2)
 }) + LFNoise2.ar(
 LFNoise2.kr([2/5, 2/5], 90, 620),
 LFNoise2.kr([1/3, 1/3], 0.15, 0.18)),
 0.3, 0.3, 3)
}.play(s)
)

Latch or Sample and Hold

//Simple Oscillator
(
{
 SinOsc.ar(
 freq: 440,
 mul: 0.5
 );
}.play(s)
)

//Add a frequency control using a Saw
(
{
 SinOsc.ar(
 freq: LFSaw.ar(freq: 1, mul: 200, add: 600), //Saw controlled freq
 mul: 0.5
 );
}.play(s)
)

//Place the LFSaw inside a latch, add a trigger
(
{
 SinOsc.ar(
 freq: Latch.ar( //Using a latch to sample the LFSaw
 LFSaw.ar(1, 0, 200, 600), //Input wave
 Impulse.ar(10) //Trigger (rate of sample)
 ),
 mul: 0.5
 );
}.play(s)
)

//SinOsc is replaced by Blip, try replacing
//the 1.1 with a MouseX
(
{
 Blip.ar( //Audio Ugen
 Latch.kr( //Freq control Ugen
 LFSaw.kr(1.1, 0, 500, 700), //Input for Latch
 Impulse.kr(10)), //Sample trigger rate
 3, //Number of harmonics in Blip
 mul: 0.3 //Volume of Blip
 )
}.play(s)
)

//Freq of the Saw is controlled by a Saw
(
{
 Blip.ar( //Audio Ugen
 Latch.kr( //Freq control Ugen
 LFSaw.kr( //input for Latch
 Line.kr(0.01, 10, 100), //Freq of input wave, was 1.1
 0, 300, 500), //Mul. and Add for input wave
 Impulse.kr(10)), //Sample trigger rate
 3, //Number of harmonics in Blip
 mul: 0.3 //Volume of Blip
 )
}.play(s)
)

//A variable is added for clarity.
(
{
 var signal;
 signal = Blip.ar( //Audio Ugen
 Latch.kr( //Freq control Ugen
 LFSaw.kr( 6.18, 0,//Freq of input wave (Golden Mean)
 300, 500), //Mul. and Add for input wave
 Impulse.kr(10)), //Sample trigger rate
 3, //Number of harmonics in Blip
 mul: 0.3 //Volume of Blip
 );
 //reverb
 2.do({ signal = AllpassN.ar(signal, 0.05, [0.05.rand, 0.05.rand], 4) });
 signal //return the variable signal
}.play(s)
)


//Add a Pan2
(
{
 var signal;
 signal = Blip.ar( //Audio Ugen
 Latch.kr( //Freq control Ugen
 LFSaw.kr( 6.18, 0,//Freq of input wave
 300, 500), //Mul. and Add for input wave
 Impulse.kr(10)), //Sample trigger rate
 3, //Number of harmonics in Blip
 mul: 0.3 //Volume of Blip
 );
 signal = Pan2.ar(
 signal, //input for the pan,
 LFNoise1.kr(1) //Pan position. -1 and 1, of 1 time per second
 );
 //reverb
 4.do({ signal = AllpassN.ar(signal, 0.05, [0.05.rand, 0.05.rand], 4,
 mul: 0.3, add: signal) });
 signal //return the variable signal
}.play(s)
)


//Control the number of harmonics
(
{
 var signal;
 signal = Blip.ar( //Audio Ugen
 Latch.kr( //Freq control Ugen
 LFSaw.kr( 6.18, 0, //Freq of input wave
 300, 500), //Mul. and Add for input wave
 Impulse.kr(10)), //Sample trigger rate
 LFNoise1.kr(0.3, 13, 14), //Number of harmonics in Blip
 mul: 0.3 //Volume of Blip
 );
 signal = Pan2.ar(
 signal, //input for the pan
 LFNoise1.kr(1) //Pan position.
 );
 //reverb
 4.do({ signal = AllpassN.ar(signal, 0.05, [0.05.rand, 0.05.rand], 4,
 mul: 0.3, add: signal) });
 signal //return the variable signal
}.play(s)
)


//Add an envelope
(
{
 var signal, env1;
 env1 = Env.perc(
 0.001, //attack of envelope
 2.0 //decay of envelope
 );
 signal = Blip.ar( //Audio Ugen
 Latch.kr( //Freq control Ugen
 LFSaw.kr( 6.18, 0,//Freq of input wave
 300, 500), //Mul. and Add for input wave
 Impulse.kr(10)), //Sample trigger rate
 LFNoise1.kr(0.3, 13, 14), //Number of harmonics in Blip
 mul: 0.3 //Volume of Blip
 );
 signal = Pan2.ar(
 signal, //input for the pan
 LFNoise1.kr(1) //Pan position.
 );
 //reverb
 4.do({ signal = AllpassN.ar(signal, 0.05, [0.05.rand, 0.05.rand], 4,
 mul: 0.3, add: signal) });
 signal*EnvGen.kr(env1) //return the variable signal
}.play(s)
)

//Place it in a Pbind
(
SynthDef("S_H",
{

 var signal, env1;
 env1 = Env.perc(
 0.001, //attack of envelope
 2.0 //decay of envelope
 );
 signal = Blip.ar( //Audio Ugen
 Latch.kr( //Freq control Ugen
 LFSaw.kr( Rand(6.0, 7.0), 0,//Freq of input wave
 Rand(300, 600), Rand(650, 800)), //Mul. and Add for input wave
 Impulse.kr(Rand(10, 12))), //Sample trigger rate
 LFNoise1.kr(0.3, 13, 14), //Number of harmonics in Blip
 mul: 0.3 //Volume of Blip
 );
 signal = Pan2.ar(
 signal, //input for the pan
 LFNoise1.kr(1) //Pan position.
 );
 //reverb
 4.do({ signal = AllpassN.ar(signal, 0.05, [0.05.rand, 0.05.rand], 4,
 mul: 0.3, add: signal) });
 signal = signal*EnvGen.kr(env1, doneAction:2); //return the variable signal

Out.ar(0, signal*0.9)

}).load(s);

SynthDescLib.global.read;

e = Pbind(
 \server, Server.internal,
 \dur, 0.3,
 \instrument, "S_H"
).play;
)

e.mute;
e.reset;
e.pause;
e.play;
e.stop;

//Add random values for each event

e = Pbind(
 \server, Server.internal,
 \dur, Prand([0, 0.1, 0.25, 0.5, 0.75, 1], inf),
 \instrument, "S_H"
).play;

e.stop;

// Pulse


(
{
 var out;
 out = Pulse.ar(
 200, //Frequency.
 0.5, //Pulse width. Change with MouseX
 0.5
 );
 out
}.play(s)
)


//Add a control for frequency
(
{
 var out;
 out = Pulse.ar(
 LFNoise1.kr(
 0.1, //Freq of LFNoise change
 mul: 20, //mul = (-20, to 20)
 add: 60 //add = (40, 80)
 ),
 0.5, 0.5);
 out
}.play(s)
)

//Control pulse
(
{
 var out;
 out = Pulse.ar(
 LFNoise1.kr(0.1, 20, 60),
 SinOsc.kr(
 0.2, //Freq of SinOsc control
 mul: 0.45,
 add: 0.46
 ),
 0.5);
 out
}.play(s)
)

//Expand to Stereo
(
{
 var out;
 out = Pulse.ar(
 LFNoise1.kr([0.1, 0.15], 20, 60),
 SinOsc.kr( 0.2, mul: 0.45, add: 0.46),
 0.5);
 out
}.play(s)
)

//Add reverb
(
{
 var out;
 out = Pulse.ar(LFNoise1.kr([0.1, 0.12], 20, 60),
 SinOsc.kr( 0.2, mul: 0.45, add: 0.46),0.5);
 4.do({out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4,
 mul: 0.4, add: out)});
 out
}.play(s)
)

//Smaller pulse widths
(
{
 var out;
 out = Pulse.ar(LFNoise1.kr([0.1, 0.12], 20, 60),
 SinOsc.kr( 0.2, mul: 0.05, add: 0.051),0.5);
 4.do({out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4,
 mul: 0.4, add: out)});
 out
}.play(s)
)

//Add an envelope
(
{
 var out, env;
 env = Env.linen([0.0001, 1.0].choose, 2.0.rand, [0.0001, 1.0].choose);
 out = Pulse.ar(LFNoise1.kr([0.1, 0.12], 20, 60),
 SinOsc.kr( 0.2, mul: 0.05, add: 0.051),0.5);
 4.do({out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4,
 mul: 0.4, add: out)});
 out*EnvGen.kr(env)
}.play(s)
)


//Define an instrument
(
SynthDef("Pulse1",
{arg att = 0.4, decay = 0.4;
 var out, env;
 env = Env.linen(att, Rand(0.1, 2.0), decay);
 out = Pulse.ar(LFNoise1.kr([0.1, 0.12], 20, 60),
 SinOsc.kr( 0.2, mul: 0.05, add: 0.051),0.5);
 4.do({out = AllpassN.ar(out, 0.05, [Rand(0.01, 0.05), Rand(0.01, 0.05)], 4,
 mul: 0.4, add: out)});
 out = out*EnvGen.kr(env, doneAction:2);
 Out.ar(0, out*0.4);
}).load(s);

SynthDescLib.global.read;

e = Pbind(
 \server, Server.internal,
 \dur, 3,
 \instrument, "Pulse1"
).play;
)

e.stop;

//Add another instrument and random values
(

e = Pbind(
 \server, Server.internal,
 \att, Pfunc({rrand(2.0, 5.0)}),
 \decay, Pfunc({rrand(4.0, 6.0)}),
 \dur, Prand([0, 1.0, 2.0, 2.5, 5], inf),
 \instrument, Prand(["S_H", "Pulse1"], inf)
).play;
)

e.stop;

//Add more structure, more instruments, nest Pseq, Prand, Pfunc, etc.

// FM

//Begin with LFO control
(
{
 var out;
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 5, //freq of control
 mul: 10, //amp of contrul
 add: 800), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play(s)
)

//Add a control to move into audio range. The MouseX represents
//the control frequency, the add is the carrier. Mul is the index.
(
{
 var out;
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 MouseX.kr(5, 240), //freq of control
 mul: 10, //amp of contrul
 add: 800), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play(s)
)


//Control of amp, or index.
(
{
 var out;
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 131, //freq of control
 mul: MouseX.kr(10, 700), //amp of contrul
 add: 800), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play(s)
)

//Both
(
{
 var out;
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 MouseY.kr(10, 230), //freq of control
 mul: MouseX.kr(10, 700), //amp of contrul
 add: 800), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play(s)
)


//Add must be higher than mul, so a variable is added to
//make sure it changes in relation to mul.
(
{
 var out, mulControl;
 mulControl = MouseX.kr(10, 700);
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 MouseY.kr(10, 230), //freq of control
 mul: mulControl, //amp of control
 add: mulControl + 100), //add will be 100 greater than mulControl
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play(s)
)


//Replace Mouse with LFNoise control
(
{
 var out, mulControl;
 mulControl = LFNoise1.kr(0.2, 300, 600); //store control in variable
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 LFNoise1.kr(0.4, 120, 130), //freq of control
 mul: mulControl, //amp of contrul
 add: mulControl + 100), //add will be 100 greater than mulControl
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play(s)
)

//Another control
(
{
 var out, mulControl;
 mulControl = LFNoise1.kr(0.2, 300, 600);
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 LFNoise1.kr(0.4, 120, 130), //freq of control
 mul: mulControl, //amp of contrul
 add: mulControl + LFNoise1.kr(0.1, 500, 600)), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play
)

//Multichannel expansion
(
{
 var out, mulControl;
 mulControl = LFNoise1.kr([0.2, 0.5], 300, 600);
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 LFNoise1.kr(0.4, 120, 130), //freq of control
 mul: mulControl, //amp of contrul
 add: mulControl + LFNoise1.kr(0.1, 500, 600)), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out
}.play
)


//Reverb and envelope
(
{
 var out, mulControl, env, effectEnv;
// effectEnv = Env.perc(0.001, 3);
 env = Env.linen(0.01.rand, 0.3.rand, rrand(0.1, 3.0));
 mulControl = LFNoise1.kr([0.2, 0.5], 300, 600);
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 LFNoise1.kr(0.4, 120, 130), //freq of control
 mul: mulControl, //amp of contrul
 add: mulControl + LFNoise1.kr(0.1, 500, 600)), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out*EnvGen.kr(env, doneAction:2);
}.play
)

(
SynthDef("FMinst",
{
 var out, mulControl, env, effectEnv;
 env = Env.linen(Rand(0.01, 1.0), Rand(0.03, 0.09), Rand(0.01, 1.0));
 mulControl = LFNoise1.kr([0.2, 0.5], 300, 600);
 out = SinOsc.ar(
 SinOsc.ar( //control Osc
 LFNoise1.kr(0.4, 120, 130), //freq of control
 mul: mulControl, //amp of contrul
 add: mulControl + LFNoise1.kr(0.1, 500, 600)), //add of control
 mul: 0.3 //amp of audio SinOsc
 );
 out = out*EnvGen.kr(env, doneAction:2);
 Out.ar(0, out)
}).load(s)
)
SynthDescLib.global.read;

//Note that this is not a very interesting composition. But you get the idea. Also be
aware that there
//are probably more efficient ways to do these using busses. For now I'm just trying
to get them
//to work.

(

e = Pbind(
 \server, Server.internal,
 \att, Pfunc({rrand(2.0, 5.0)}),
 \decay, Pfunc({rrand(4.0, 6.0)}),
 \dur, Prand([0, 1.0, 2.0, 2.5, 5], inf),
 \instrument, Prand(["S_H", "Pulse1", "FMinst"], inf)
).play;
)

e.stop;

// Filter

//Saw and filter
(
{
 RLPF.ar( //resonant low pass filter
 Saw.ar(100, 0.2), //input wave at 100 Hz
 MouseX.kr(100, 10000) //cutoff frequency
 )}.play
)

//Control with SinOsc
(
{
 RLPF.ar(
 Saw.ar(100, 0.2),
 SinOsc.ar(0.2, 0, 900, 1100)
 )
}.play
)

//Control resonance
(
{
 RLPF.ar(
 Saw.ar(100, 0.2),
 SinOsc.kr(0.2, 0, 900, 1100),
 MouseX.kr(1.0, 0.001) //resonance, or "Q"
 )}.play(s)
)

//Two controls
(
{
 RLPF.ar(
 Saw.ar(//input wave
 LFNoise1.kr(0.3, 50, 100),//freq of input
 0.1
 ),
 LFNoise1.kr(0.1, 4000, 4400), //cutoff freq
 0.04 //resonance
 )}.play(s)
)


//Add a pulse
(

{
var freq;
freq = LFNoise1.kr(0.3, 50, 100);
 RLPF.ar(
 Pulse.ar( //input wave
 freq,//freq of input
 0.1, //pulse width
 0.1 //add, or volume of pulse
 ),
 LFNoise1.kr(0.1, 4000, 4400), //cutoff freq
 0.04 //resonance
 )}.play(s)
)

// Wind and Metal

{LFNoise1.ar}.scope // random wave

{max(0, LFNoise1.ar)}.scope // random wave with max

{min(0, LFNoise1.ar)}.scope // random wave with min

{PinkNoise.ar(max(0, LFNoise1.ar(10)))}.scope // used as amp control

{PinkNoise.ar(max(0, LFNoise1.ar(1)))}.play // let this one run a while

{PinkNoise.ar * max(0, LFNoise1.ar([10, 1]))}.play //expanded to two channels

{PinkNoise.ar * max(0, LFNoise1.ar([10, 10]))}.play

// Scale and offest controls how often LFNoise moves to positive values
// Use the mouse to experiment:

{max(0, LFNoise1.ar(100, 0.75, MouseX.kr(-0.5, 0.5)))}.scope(zoom: 10)

(
{
PinkNoise.ar *
max(0, LFNoise1.ar([10, 10], 0.75, 0.25))
}.play
)

//Klank with one frequency.

{Klank.ar(`[[500], [1], [1]], PinkNoise.ar(0.05))}.play

//An array of freqs

{Klank.ar(`[[100, 200, 300, 400, 500, 600, 700, 800]], PinkNoise.ar(0.01))}.play

//Add amplitudes. Try each of these and notice the difference.

(
{Klank.ar(`[
 [100, 200, 300, 400, 500, 600, 700, 800], //freq
 [0.1, 0.54, 0.2, 0.9, 0.76, 0.3, 0.5, 0.1] //amp
 ], PinkNoise.ar(0.01))}.play
)

(
{Klank.ar(`[
 [100, 200, 300, 400, 500, 600, 700, 800], //freq
 [0.54, 0.2, 0.9, 0.76, 0.3, 0.5, 0.1, 0.3] //amp
 ], PinkNoise.ar(0.01))}.play
)

(
{Klank.ar(`[
 [100, 200, 300, 400, 500, 600, 700, 800], //freq
 [0.9, 0.76, 0.3, 0.5, 0.1, 0.3, 0.6, 0.2] //amp
 ], PinkNoise.ar(0.01))}.play
)

//Using enharmonic frequencies.

{Klank.ar(`[[111, 167, 367, 492, 543, 657, 782, 899]], PinkNoise.ar(0.01))}.play

//Use Array.fill to fill an array with exponential values. (biased toward 100)

Array.fill(20, {exprand(100, 1000).round(0.1)})

//compare with (even distribution)

Array.fill(20, {rrand(100.0, 1000).round(0.1)})

//Added to the patch. Run this several times. The postln will print
//the freq array.

(
{Klank.ar(
 `[Array.fill(10, {exprand(100, 1000)}).round(0.1).postln],
 PinkNoise.ar(0.01))}.play
)

//Add LFNoise for amp control.

(
{Klank.ar(
 `[Array.fill(10, {exprand(100, 1000)}).round(0.1).postln],
 PinkNoise.ar(0.01) * max(0, LFNoise1.ar([10, 10], 0.75, 0.25)))}.play
)

//Same thing with variables.

(
{
var excitation, speed, filters, range;
range = {exprand(100, 1000)};
filters = 10;
excitation = PinkNoise.ar(0.01) * max(0, LFNoise1.ar([10, 10], 0.75, 0.25));

Klank.ar(`[Array.fill(filters, range).round(0.1).postln], excitation)}.play
)

//With ring times and amplitudes.

(
{
var excitation, speed, filters, range, freqBank, ampBank, ringBank;
range = {exprand(100, 1000)};
filters = 10;
excitation = PinkNoise.ar(0.01) * max(0, LFNoise1.ar([10, 10], 0.75, 0.25));
freqBank = Array.fill(filters, range).round(0.1).postln;
ampBank = Array.fill(filters, {rrand(0.1, 0.9)}).round(0.1).postln;
ringBank = Array.fill(filters, {rrand(1.0, 4.0)}).round(0.1).postln;
Klank.ar(`[freqBank, ampBank, ringBank], excitation)
}.play
)

//Finally, slow down the excitation:

(
{
var excitation, speed, filters, range, freqBank, ampBank, ringBank;
range = {exprand(100, 1000)};
filters = 10;
excitation = PinkNoise.ar(0.01) * max(0, LFNoise1.ar([0.1, 0.1], 0.75, 0.25));
freqBank = Array.fill(filters, range).round(0.1).postln;
ampBank = Array.fill(filters, {rrand(0.1, 0.9)}).round(0.1).postln;
ringBank = Array.fill(filters, {rrand(1.0, 4.0)}).round(0.1).postln;
Klank.ar(`[freqBank, ampBank, ringBank], excitation)
}.play
)


// Sci-Fi Computer

(
{
PMOsc.ar(
 MouseX.kr(700, 1300),
 MouseY.kr(700, 1300),
 3)
}.play
)

(
{
PMOsc.ar(
 MouseX.kr(700, 1300),
 LFNoise0.kr(10, 1000, 1000),
 MouseY.kr(0.1, 5.0),
 mul: 0.3)
}.play
)

(
{
PMOsc.ar(
 LFNoise1.kr(10, 1000, 1000),
 LFNoise0.kr(10, 1000, 1000),
 MouseY.kr(0.1, 5.0),
 mul: 0.3)
}.play
)

(
{
PMOsc.ar(
 LFNoise1.kr([10, 10], 1000, 1000),
 LFNoise0.kr([10, 10], 1000, 1000),
 MouseY.kr(0.1, 5.0),
 mul: 0.3)
}.play
)

(
{
PMOsc.ar(
 LFNoise1.kr(
 MouseX.kr([1, 1], 12),
 mul: 1000,
 add: 1000),
 LFNoise0.kr(
 MouseX.kr([1, 1], 12),
 mul: 1000,
 add: 1000),
 MouseY.kr(0.1, 5.0),
 mul: 0.3)
}.play
)

(
{
PMOsc.ar(
 LFNoise1.kr(
 MouseX.kr([1, 1], 12),
 mul: MouseY.kr(10, 1000),
 add: 1000),
 LFNoise0.kr(
 MouseX.kr([1, 1], 12),
 mul: MouseY.kr(30, 1000),
 add: 1000),
 MouseY.kr(0.1, 5.0),
 mul: 0.3)
}.play
)



// Harmonic Swimming


(
// harmonic swimming
play({
 var fundamental, partials, out, offset;
 fundamental = 50; // fundamental frequency
 partials = 20; // number of partials per channel
 out = 0.0; // start of oscil daisy chain
 offset = Line.kr(0, -0.02, 60); // causes sound to separate and fade
 partials.do({ arg i;
 out = FSinOsc.ar(
 fundamental * (i+1), // freq of partial
 0,
 max(0, // clip negative amplitudes to zero
 LFNoise1.kr(
 6 + [4.0.rand2, 4.0.rand2], // amplitude rate
 0.02, // amplitude scale
 offset // amplitude offset
 )
 ),
 out
 )
 });
 out
})
)


(
{
var out = 0;
2.do({ |i|
 out = out + FSinOsc.ar(400 * (i + 1),
 mul: max(0, LFNoise1.kr(rrand(6.0, 10.0))))
});
out
}.play
)


(
{
var out = 0;
4.do({ |i|
 out = out + FSinOsc.ar(400 * (i + 1),
 mul: max(0,
 LFNoise1.kr(
 rrand(6.0, 10.0),
 0.2
 ))
 )
});
out
}.play
)

(
{
var out = 0;
20.do({ |i|
 out = out + FSinOsc.ar(400 * (i + 1),
 mul: max(0,
 LFNoise1.kr(
 rrand(6.0, 10.0),
 0.2
 ))
 )
});
out
}.play
)


(
{
var out = 0, fundamental = 50, partials = 20;
partials.do({ |i|
 out = out + FSinOsc.ar(fundamental * (i + 1),
 mul: max(0,
 LFNoise1.kr(
 rrand(6.0, 10.0),
 0.2
 ))
 )
});
out
}.play
)

(
{
var out = 0, fundamental = 50, partials = 20;
partials.do({ |i|
 out = out + FSinOsc.ar(fundamental * (i + 1),
 mul: max(0,
 LFNoise1.kr(
 rrand(6.0, 10.0),
 0.2,
 MouseX.kr(0, -0.2)
 ))
 )
});
out
}.play
)

(
{
var out = 0, fundamental = 50, partials = 20;
partials.do({ |i|
 out = out + FSinOsc.ar(fundamental * (i + 1),
 mul: max(0,
 LFNoise1.kr(
 rrand(6.0, [10.0, 10.0]),
 0.2,
 Line.kr(0, -0.2, 60)
 ))
 )
});
out
}.play
)


// Variable decay bell



{SinOsc.ar(400 * LFNoise1.kr(1/6, 0.4, 1))}.play


(
{
SinOsc.ar(
 400 * LFNoise1.kr(1/6, 0.4, 1),
 mul: EnvGen.kr(Env.perc(0, 0.5), Dust.kr(1))
)
}.play
)

// add formula so that low has long decay, high has short
(
{
SinOsc.ar(
 100 * LFNoise1.kr(1/6, 0.4, 1),
 mul: EnvGen.kr(
 Env.perc(0, (100**(-0.7))*100), Dust.kr(1))
)
}.play
)


(
{
SinOsc.ar(
 3000 * LFNoise1.kr(1/6, 0.4, 1),
 mul: EnvGen.kr(
 Env.perc(0, (3000**(-0.7))*100), Dust.kr(1))
)
}.play
)

(
{
Pan2.ar(
 SinOsc.ar(
 3000 * LFNoise1.kr(1/6, 0.4, 1),
 mul: EnvGen.kr(
 Env.perc(0, (3000**(-0.7))*100), Dust.kr(1))
 ), LFNoise1.kr(1/8)
)
}.play
)

(
{
Mix.fill(15,
{
var freq;
freq = exprand(100, 3000);
 Pan2.ar(
 SinOsc.ar(
 freq * LFNoise1.kr(1/6, 0.4, 1),
 mul: EnvGen.kr(
 Env.perc(0, (freq**(-0.7))*100), Dust.kr(1/5))
 ), LFNoise1.kr(1/8)
 )*0.2
})
}.play
)



// Gaggle of sine variation

{SinOsc.ar(400, mul: max(0, FSinOsc.kr(2)))}.play

{SinOsc.ar(400, mul: max(0, FSinOsc.kr([2, 4])))}.play

{SinOsc.ar([400, 800], mul: max(0, FSinOsc.kr([2, 3])))}.play

(
{Mix.ar(SinOsc.ar([400, 800, 1200],
 mul: max(0, FSinOsc.kr([1, 2, 3]))))*0.1}.play
)

(
{
var harmonics = 4, fund = 400;

Mix.fill(harmonics,
 {arg count;
 SinOsc.ar(fund * (count+1),
 mul: max(0, FSinOsc.kr(count))
 )
 }
)*0.1}.play
)

(
{
var harmonics = 4, fund = 400;

Mix.fill(harmonics,
 {arg count;
 SinOsc.ar(fund * (count+1),
 mul: max(0, FSinOsc.kr(count/5))
 )
 }
)*0.1}.play
)


(
{
var harmonics = 16, fund = 400;

Mix.fill(harmonics,
 {arg count;
 SinOsc.ar(fund * (count+1),
 mul: max(0, FSinOsc.kr(count/5))
 )
 }
)*0.1}.play
)

(
{
var harmonics = 16, fund = 50;

Mix.fill(harmonics,
 {arg count;
 Pan2.ar(
 SinOsc.ar(fund * (count+1),
 mul: max(0, FSinOsc.kr(count/5))
 ),
 1.0.rand2
 )
 }
)*0.07}.play
)

// KSPluck


// More

{max(0, LFNoise1.ar)}.scope // random wave with max

E. Pitch Chart, MIDI, Pitch Class, Frequency, Hex, Binary Converter:

31.20. Pitch class, MIDI number, Frequency, Hex, Binary conversion GUI
 (
Sheet({ arg l; var pcstring;
pcstring = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
SCStaticText(l, l.layRight(70, 30)).string_("MIDI");
SCStaticText(l, l.layRight(70, 30)).string_("Pitch");
SCStaticText(l, l.layRight(70, 30)).string_("Frequency");
SCStaticText(l, l.layRight(70, 30)).string_("Hex");
SCStaticText(l, l.layRight(70, 30)).string_("Binary");
l.view.decorator.nextLine;
m = SCNumberBox(l,l.layRight(70,30)); p = SCTextField(l,l.layRight(70,30));
f = SCNumberBox(l,l.layRight(70,30)); h = SCTextField(l,l.layRight(70,30));
b = SCTextField(l, l.layRight(70, 30));
p.value = "C4"; f.value = 60.midicps.round(0.01);
m.value = 60; h.value = "0000003C"; b.value = "00111100";
m.action = {
 arg numb; var array;
 numb.value.asInteger.asBinaryDigits.do({arg e, i; array = array ++ e.asString});
 p.value = pcstring.wrapAt(numb.value) ++ (numb.value/12 - 1).round(1).asString;
 f.value = numb.value.midicps.round(0.001);
 h.value = numb.value.asInteger.asHexString;
 b.value = array;
};
//p.defaultKeyDownAction = {arg a, b, c, d, e; [a, b, c, d, e].value.postln;};
}, "Conversions");
)

