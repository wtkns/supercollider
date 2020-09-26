/*


10 - Keyword Assignment, MouseX.kr, MouseY.kr, Linear and 
Exponential values
Keyword Assignment

10.1. Defaults
*/

{SinOsc.ar}.play

/*

10.2. Keywords
*/

{SinOsc.ar(freq: 440, phase: 0, mul: 0.4, add: 0)}.play;

{SinOsc.ar(phase: 0, freq: 440, add: 0, mul: 0.4)}.play;

{SinOsc.ar(freq: 440, mul: 0.4)}.play;

/*

10.3. First patch using keywords
*/


{SinOsc.ar(freq: LFNoise0.ar(freq: [10, 15], mul: 400, add: 800), mul: 0.3)}.play

{Saw.ar(freq: LFNoise0.ar(freq: [10, 15], mul: 400, add: 800), mul: 0.3)}.play

{SinOsc.ar(freq: LFNoise1.ar(freq: [10, 15], mul: 400, add: 800), mul: 0.3)}.play

{Pulse.ar(freq: LFNoise1.ar(freq: [10, 15], mul: 400, add: 800), mul: 0.3)}.play

{Pulse.ar(freq: LFSaw.ar(freq: [10, 15], mul: 400, add: 800), mul: 0.3)}.play

{LFTri.ar(freq: LFPulse.ar(freq: [10, 15], mul: 400, add: 800), mul: 0.3)}.play

{LFTri.ar(freq: LFTri.ar(freq: [10, 15], mul: 400, add: 800), mul: 0.3)}.play
/*

MouseX.kr and MouseY.kr

10.4. MouseX
*/

{SinOsc.ar(LFNoise0.ar(MouseX.kr(1, 50), 500, 600), mul: 0.5)}.play;

/* 

10.5. MouseY controlling amp and freq
*/

{SinOsc.ar(440, mul: MouseY.kr(0.9, 0))}.play;


{SinOsc.ar(MouseX.kr(220, 880), mul: 0.3)}.play;

/*

10.6. Exponential change
*/

{SinOsc.ar(MouseX.kr(220, 880, 'exponential'), mul: 0.3)}.play;

// or

{SinOsc.ar(MouseX.kr(220, 880, 1), mul: 0.3)}.play

/*
Discrete Pitch Control, MIDI [New]

10.7. Discrete values
*/

{SinOsc.ar(MouseX.kr(220, 880, 1).round(10), mul: 0.3)}.play

{SinOsc.ar(MouseX.kr(220, 880, 1).round(100), mul: 0.3)}.play

/*

10.8. MIDI conversion
*/

[57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71].midicps.round(0.1)

/*

10.9. MIDI MouseX.kr
*/

{SinOsc.ar(MouseX.kr(59.0, 81.0).midicps, mul: 0.3)}.play

{SinOsc.ar(MouseX.kr(59.0, 81.0).round(1.0).midicps, mul: 0.3)}.play

/*
Other External Controls
Practice

10.10. Practice sci-fi computer 
*/

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

(
// exponential random
{Mix.fill(12, // number of oscillators
 {arg i;
 Pan2.ar(SinOsc.ar(SinOsc.ar(
 freq: MouseX.kr(rrand(0.1, 5.0), rrand(3.0, 20.0)), // speed of vibrato 
 mul: MouseY.kr(10, 50), // width of vibrato
 add: exprand(200, 5000)), // freq of oscillators 
 mul: max(0, LFNoise0.kr(MouseX.kr(rrand(1, 6), rrand(6, 1))))), 1.0.rand2)
})*0.03
}.play
)

(
// linear random waves
{Mix.fill(12, // number of oscillators
 {arg i;
 Pan2.ar(SinOsc.ar(SinOsc.ar(
 freq: MouseX.kr(rrand(0.1, 5.0), rrand(3.0, 20.0)), // speed of vibrato 
 mul: MouseY.kr(10, 50), // width of vibrato
 add: rrand(200, 5000)), // freq of oscillators 
 mul: max(0, LFNoise0.kr(MouseX.kr(rrand(1, 6), rrand(6, 1))))), 1.0.rand2)
})*0.03
}.play
)


/*

10. Exercises
(
{
 SinOsc.ar(
 freq: SinOsc.ar(freq: 512, mul: 638, 
 add: LFNoise0.kr(freq: [13, 12], mul: 500, add: 600
 )), mul: 0.6)}.play
)

(
{
var out, delay;
out = SinOsc.ar(freq: 
 abs(LFNoise0.kr(freq: 0.5, mul: 600, 
 add: SinOsc.kr(freq: 1.5, mul: 50, add: 500
 ))), 
 mul: 0.1);
delay = CombN.ar(out, 3.0, [1.35, 0.7], 6);
Pan2.ar(out, 0) + delay
}.play
)

(
{
CombN.ar(
 SinOsc.ar(
 freq: LFNoise1.ar(freq: 4, mul: 24, 
 add: LFSaw.ar(freq: [8,7.23], mul: 3, add: 80)
 ).midicps, mul: 0.04), 0.2, 0.2, 4)}.play
)
*/
