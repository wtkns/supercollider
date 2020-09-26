/*
15 - Noise, Subtractive Synthesis, Debugging, Modifying the Source
Noise

15.1. noise from scratch (rrand, exprand, Mix, fill, SinOsc)
*/

{rrand(1, 1000).round(1)}.dup(100).sort

{exprand(1, 1000).round(1)}.dup(100).sort

{Mix.fill(1000, {SinOsc.ar(rrand(1.0, 20000))})*0.01}.play

{Mix.fill(1000, {SinOsc.ar(exprand(1.0, 20000))})*0.01}.play

{PinkNoise.ar}.play // compare cpu

/*

15.2. Types of noise
*/

{WhiteNoise.ar}.scope(1)

{PinkNoise.ar}.scope(1)

{BrownNoise.ar}.scope(1)

{GrayNoise.ar}.scope(1)

{Dust.ar(12)}.scope(1)

/*
Subtractive Synthesis

15.3. Filtered noise 
*/

(
{
var signal, filter, cutoff, resonance;

signal = PinkNoise.ar(mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

RHPF.ar(signal, cutoff, resonance)}.scope(1)
)

(
{
var signal, filter, cutoff, resonance;

signal = PinkNoise.ar(mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

RLPF.ar(signal, cutoff, resonance)}.scope(1)
)

(
{
var signal, filter, cutoff, resonance;

signal = PinkNoise.ar(mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

BPF.ar(signal, cutoff, resonance)}.scope(1)
)

/*

15.4. Filtered saw
*/
 
(
{
var signal, filter, cutoff, resonance;

signal = Saw.ar([50, 75], mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

RLPF.ar(signal, cutoff, resonance)}.scope(2)
)

(
{
var signal, filter, cutoff, resonance;

signal = Saw.ar([50, 75], mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

BPF.ar(signal, cutoff, resonance)}.scope(2)
)

{RLPF.ar(Saw.ar([100,250],0.1), XLine.kr(8000,400,5), 0.05) }.play;
 
/*
Voltage Controlled Filter

15.5. Filter cuttoff as pitch
*/

// Frequency control (first patch)

{SinOsc.ar(LFNoise0.kr([12, 12], 500, 500), mul: 0.5)}.play

// Same control source applied to filter cutoff with narrow rq 

{RLPF.ar(PinkNoise.ar(0.3), LFNoise0.kr([12, 12], 500, 500), 0.02)}.play

// Wider rq does not result in a focused pitch

{RLPF.ar(PinkNoise.ar(0.9), LFNoise0.kr([12, 12], 500, 500), 1)}.play

/*

15.6. Resonant array 
*/

(
{
Klank.ar(
 `[[100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], //freq array
 [0.05, 0.2, 0.04, 0.06, 0.11, 0.01, 0.15, 0.03, 0.15, 0.2]],
 PinkNoise.ar(MouseX.kr(0.01, 0.1)))
}.scope(1)
)

(
{
Klank.ar(
 `[Array.series(10, 50, 50), 
 Array.series(10, 1.0, -0.1)],
 ClipNoise.ar(0.01)
)
}.scope(1)
)
 
(
{
Klank.ar(
 `[{exprand(60, 10000)}.dup(15)],
 PinkNoise.ar(0.005)
)
}.scope(1);
)

/*
Chimes

15.7. chime burst (Env, perc, PinkNoise, EnvGen, Spawn, scope)
*/

(
{
var burstEnv, att = 0, burstLength = 0.0001, signal; //Variables
burstEnv = Env.perc(0, burstLength); //envelope times
signal = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1))); //Noise burst
signal;
}.play
)

/*

15.8. chimes (normalizeSum, round, Klank, EnvGen, MouseY)
*/

(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;

freqSpecs = `[
 {rrand(100, 1200)}.dup(totalHarm), //freq array
 {rrand(0.3, 1.0)}.dup(totalHarm).normalizeSum.round(0.01), //amp array
 {rrand(2.0, 4.0)}.dup(totalHarm)]; //decay rate array

burstEnv = Env.perc(0, burstLength); //envelope times
burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1))); //Noise burst

Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.8)
}.scope(1)
)

/*

15.9. Tuned chime (or pluck?)
*/

(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;

freqSpecs = `[
 {rrand(1, 30)*100}.dup(totalHarm), 
 {rrand(0.1, 0.9)}.dup(totalHarm).normalizeSum,
 {rrand(1.0, 3.0)}.dup(totalHarm)];
burstEnv = Env.perc(0, burstLength);
burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1)));

Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.8)
}.scope(1)
)

/*
Debugging, commenting out, balancing enclosures, postln, postcln, postf, catArgs

15.10. running a selection of a line
*/

Array.fill(5, {exprand(10, 100)}).round(1) * ([1, 2, 5, 7].choose)
Array.fill(5, {exprand(10, 100)}).round(1) * ([1, 2, 5, 7].choose)
Array.fill(5, {exprand(10, 100)}).round(1) * ([1, 2, 5, 7].choose)
Array.fill(5, {exprand(10, 100)}).round(1) * ([1, 2, 5, 7].choose)

/*

15.11. running a selection of a line
*/

Array.fill(5, {exprand(10, 100)}).round(1) * ([1, 2, 5, 7].choose)
Array.fill(5, {exprand(10, 100)}) /* .round(1) * ([1, 2, 5, 7].choose) */

/*

15.12. commenting out
*/

(
a = "this is experimental";
// a = "this I know works";
a.postln
)

( // an example in real code
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;

freqSpecs = `[ //"experimental" collection
 {rrand(100, 1200)}.dup(totalHarm), //freq array
 {rrand(0.3, 1.0)}.dup(totalHarm).normalizeSum.round(0.01), //amp array
 {rrand(2.0, 4.0)}.dup(totalHarm)]; //decay rate array

//freqSpecs = `[ //"safe" collection
// [100, 200] //freq array
// [0.5, 0.5] //amp array
// [0.1, 0.1]]; //decay rate array

/*

15.13. debugging using postln
*/

(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength;

freqSpecs = `[
 rrand(100, 1200).dup(totalHarm).postln, 
 {rrand(0.3, 1.0)}.dup(totalHarm).normalizeSum.round(0.1).postln,
 {rrand(2.0, 4.0)}.dup(totalHarm).round(0.1).postln]; 

burstEnv = Env.perc(0, burstLength.postln); //envelope times
burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1))); 

Klank.ar(freqSpecs.postln, burst)*MouseX.kr(0.1, 0.8)
}.scope(1)
)

/*

15.14. debugging using postln in message chains
*/

(
[[60, 62, 68], [65, 67], [61, 63, 55, 23]]
.choose.postln
.midicps.postln
.round(0.1).postln
.reciprocal.postln
.round(0.0001).postln
)
/*

15.15. Formatting posted information
*/
(
// unintelligible
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose.post;
duration = 4.0.rand.round(0.1).post;
amplitude = 1.0.rand.round(0.1).post;
voice = 10.rand.post;
})
)

(
// too spread out
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose.postln;
duration = 4.0.rand.round(0.1).postln;
amplitude = 1.0.rand.round(0.1).postln;
voice = 10.rand.postln;
})
)


(
// cumbersome
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose.post;
" ".post;
duration = 4.0.rand.round(0.1).post;
" ".post;
amplitude = 1.0.rand.round(0.1).post;
" ".post;
voice = 10.rand.postln;
})
)


(
// adequate
var pitch, duration, amplitude, voice;
"pitch, duration, amplitude, voice".postln;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
[pitch, duration, amplitude, voice].postln;
})
)

(
// better?
var pitch, duration, amplitude, voice;
"pitch, duration, amplitude, voice".postln;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
"P, D, A, V ".catArgs(pitch, duration, amplitude, voice).postln
})
)

(
// useful
var pitch, duration, amplitude, voice;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
"pch %\tdur %\tamp %\tvce %\n".postf(pitch, duration, amplitude, voice)
})
)

(
// useful
var pitch, duration, amplitude, voice;
"pch\t\tdur\t\tamp\t\tvce".postln;
20.do({
pitch = [60, 62, 64, 65, 67, 69, 71].choose;
duration = 4.0.rand.round(0.1);
amplitude = 1.0.rand.round(0.1);
voice = 10.rand;
"%\t\t%\t\t%\t\t%\n".postf(pitch, duration, amplitude, voice)
})
)


/*
Modifying the source code

15.16. postn
*/

(
[[60, 62, 68], [65, 67], [61, 63, 55, 23]]
.choose.postn("choice")
.midicps.postn("midi conversion")
.round(0.1).postn("rounded value")
.reciprocal.postn("recip")
.round(0.0001).postn("rounded recip")
)
/*
Practice, Chimes and Cavern

15.17. Subtracitive Synthesis (Klank, Decay, Dust, PinkNoise, RLPF, LFSaw)
*/

(
{
var totalInst, totalPartials, baseFreq, ampControl, chimes, cavern;
totalInst = 5; //Total number of chimes
totalPartials = 12; //Number of partials in each chime
baseFreq = rrand(200, 1000); //Base frequency for chimes

chimes = 
 Mix.ar(
 {
 Pan2.ar(
 Klank.ar(`[
 {baseFreq*rrand(1.0, 12.0)}.dup(totalPartials),
 Array.rand(totalPartials, 0.3, 0.9),
 Array.rand(totalPartials, 0.5, 6.0)], 
 Decay.ar(
 Dust.ar(0.2, 0.02), //Times per second, amp
 0.001, //decay rate
 PinkNoise.ar //Noise
 )), 1.0.rand2) //Pan position
 }.dup(totalInst)
 );

cavern = 
 Mix.ar(
 {
 var base;
 base = exprand(50, 500);
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( [rrand(0.03, 0.1), rrand(0.03, 0.1)])
 )*max(0, LFNoise1.kr(3/rrand(5, 20), mul: 0.005))
 }.dup(5));
cavern + chimes
}.play
)

[New]

// Cavern variation
(
{
var totalPartials = 12;

 Mix.ar(
 {
 var base;
 base = exprand(50, 1000);
 Pan2.ar(
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( rrand(0.03, 0.1))
 )*max(0, LFNoise1.kr(6, mul: 0.005)),
 LFNoise0.kr(1))
 }.dup(5));
 
}.play
)

// Rotating wheels

{
var totalPartials = 4;

 Mix.ar(
 {
 var base;
 base = exprand(50, 10000);
 Pan2.ar(
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( rrand(0.03, 0.1))
 )*max(0, SinOsc.kr(6/rrand(1, 10), mul: 0.005)),
 LFNoise1.kr(1))
 }.dup(8));
 
}.play


// This one floats in and out, so if there is no
// sound let it run a while.
// Execute it four or five times to get a bunch
// of them going. 

{
var totalPartials = 3;

 Mix.ar(
 {
 var base;
 base = exprand(50, 100);
 Pan2.ar(
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( rrand(0.03, 0.1))
 )*max(0, SinOsc.kr(10/rrand(1, 5), mul: 0.005)),
 LFNoise1.kr(1))
 }.dup(8)) * max(0, LFNoise1.kr(1/10));
 
}.play

/*
15. Exercises
*/
