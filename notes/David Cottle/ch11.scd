/*
11 - Variables, Comments, Offset and Scale using Mul and Add
Variables and Comments

11.1. Variable declaration, assignment, and comments
*/

//First patch

{SinOsc.ar(LFNoise0.ar(10, mul: 400, add: 800), 0, 0.3)}.play

//First patch with variables

(
{

var freqRate, freqRange, lowValue;
freqRate = 10; //rate at which new values are chosen
freqRange = 1200; //the range of frequencies chosen
lowValue = 60; //the lowest frequency

SinOsc.ar(
 LFNoise0.ar(freqRate, freqRange/2, freqRange + lowValue),
 0, 0.3)
}.play
)

/*
Offset and Scale using Mul and Add

11.2. Offset and scale with mul and add
*/

{SinOsc.ar(SinOsc.ar(4, 100, 300), 0, 0.3)}.play

/*

11.3. Map a range
*/
{
SinOsc.ar(
 SinOsc.kr(4).range(300, 500), 
 )
}.play(s)
/*
Practice

11.4. Harmonic swimming from the examples folder, variable decay bells
*/
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


// Decay rates linked to frequency using a variable. (Low freq; long decay. High freq; 
short decay.)

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
 )
})*0.3
}.play
)

/*

11. Exercises
*/
