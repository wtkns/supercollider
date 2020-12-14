/* 
Notes about the code file. 

This collection of files contains only the headings and code examples from Computer 
Music with examples in SuperCollider3. It is in rtf format, so it can be opened 
directly in SC3. 

The first few chapters have been omitted so that you can practice entering and 
debugging code on your own. 

All.rtf contains all the chapters. Each chapter has also been split into a separate 
file. 
*/
splithere
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
splithere
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
splithere
/*
12 - Voltage Control, LFO, Envelopes, Triggers, Gates, Reciprocals

Com-, Go to line number
Com-/ Make selected lines a comment
Opt-Com-/ Remove comment marks on selected lines
Shift-Com-B Balance enclosures
Com-] Shift code right
Com-[ Shift code left
Com-. Stop all playback
Shift-Com-/ (Com-?) Open help file for selected item
Com-' Syntax colorize
Double click enclosure Balance enclosures
Com-\ Bring post window to front
Shift-Com-K Clear post window
Shift-Com-\ Bring all windows to front

12.1. SinOsc as vibrato
*/

{SinOsc.ar(freq: 400, mul: 0.7)}.play

{SinOsc.ar(freq: Line.kr(200, 2000, 10), mul: Line.kr(0.9, 0.2, 10))}.play

/*
Vibrato

12.2. SinOsc as vibrato
*/

SinOsc.ar(freq: 5, mul: 5, add: 440)

/*

12.3. Vibrato
*/

(
{
 var vibrato;
 vibrato = SinOsc.ar(freq: 5, mul: 5, add: 440);
 SinOsc.ar(vibrato, mul: 0.5)
}.play
)

/*
Block Diagrams
Theremin

12.4. Theremin
*/



(
{ 
var vibrato;
vibrato = SinOsc.kr(6, mul: 0.02, add: 1);
 SinOsc.ar(
 freq: MouseY.kr(3200, 200, lag: 0.5, warp: 1) * 
 vibrato, //Vibrato 
 mul: abs(MouseX.kr(0.02, 1)) //Amplitude
 ) 
}.play
) 

/*

12.5. Better vibrato 


*/

(
//Vibrato
{
var depthChange, vibrato;
depthChange = Line.kr(0, 5, 3);
vibrato = SinOsc.ar(freq: 5, mul: depthChange, add: 440); 
SinOsc.ar(
 vibrato, 
 mul: 0.5)
}.play
)

/*

12.6. Other LFO controls 


*/
 
(
{ //SinOsc (sci-fi)
var lfo;
lfo = SinOsc.ar(freq: 10, mul: 100, add: 400); 
SinOsc.ar(lfo, mul: 0.5)
}.play
)



(
{ //Pulse (phone ring)
var lfo;
lfo = LFPulse.ar(freq: 15, mul: 200, add: 1000); 
SinOsc.ar(lfo, mul: 0.5)
}.play
)



(
{ //Saw
var lfo;
lfo = LFSaw.ar(freq: 2, mul: -100, add: 600); 
SinOsc.ar(lfo, mul: 0.5) 
}.play
)

(
{ //Noise (computer)
var lfo;
lfo = LFNoise0.ar(freq: [28, 27], mul: 1000, add: 2000); 


SinOsc.ar(lfo, mul: 0.5)
}.play
)

(
{ //Noise (manic birds)
var lfo;
lfo = LFNoise1.ar(freq: [28, 27], mul: 400, add: 2000); 
SinOsc.ar(lfo, mul: 0.5)
}.play
)

/*
Envelopes
Triggers, Gates, messages, ar (audio rate) and kr (control rate)

12.7. Trigger and envelope 
*/

{Impulse.ar(4, mul: 0.5)}.play

{Dust.ar(5)}.play



(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 1.0), Impulse.kr(2)) 
 )
}.play
)

(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 0.3), Dust.kr(2))
 )
}.play
) 

/*

12.8. Trigger with MouseX
*/



(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 0.3), SinOsc.ar(2)) 
 )
}.play
)

(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 0.3), MouseX.kr(-0.1, 0.1))
 )
}.play
)

/*



12.9. Envelope with trigger
*/

(
{
var triggerSpeed, trigger;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

SinOsc.ar( 
 TRand.kr(100, 2000, trigger),
 mul: EnvGen.kr(
 Env.perc(0.001, 1/triggerSpeed), 
 trigger
 )
)
}.play
)

/*
Duration and Frequency [New]
Synchronized LFO Control [New]

12.10. Synchronized LFOs and Triggers
*/

(
{
SinOsc.ar(SinOsc.ar(4/10, mul: 100, add: 1000), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/10, mul: 100, add: 1000), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/10, mul: 100, add: 1000), mul: 0.1)
}.play
)


(
{
var scale = 300, offset = 500;
SinOsc.ar(SinOsc.ar(4/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(7/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(8/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(6/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/3, mul: scale, add: offset), mul: 0.1)
}.play
)


(
{
var scale = 600, offset = 1000, synch = 10;
SinOsc.ar(SinOsc.ar(4/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(7/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(8/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(6/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/synch, mul: scale, add: offset), mul: 0.1)
}.play
)

( // synchronized triggers
{
var synch = 5;
SinOsc.ar(100, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(3/synch))) +
SinOsc.ar(300, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(7/synch))) +
SinOsc.ar(500, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(5/synch))) +
SinOsc.ar(700, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(2/synch))) +
SinOsc.ar(900, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(9/synch))) +
SinOsc.ar(1100, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(6/synch))) +
SinOsc.ar(1300, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(1/synch))) * 0.1
}.play
)


/*
Frequency and Duration Linked

12.11. Duration, attack, decay
*/

var dur, att, dec, trigFreq;

dur = 10; // ten seconds long
att = dur*0.1;
dec = dur*0.9;
trigFreq = 1/dur;

or

freq = 10; // ten in one second
att = 1/freq*0.1;
dec = 1/freq*0.9;
duration = 1/feq;
/*
Gates

12.12. Envelope using a gate
*/

(
{
 SinOsc.ar(440,
 mul: EnvGen.kr(
 //Envelope is attack, decay, sustain level, release
 Env.adsr(0.001, 0.3, 0.2, 0.1), 
 MouseX.kr(-0.1, 0.1) //gate
 )
 )
}.play
)

(
{
 SinOsc.ar(
 400 + EnvGen.kr(
 Env.adsr(0.3, 0.4, 0.2, 1), 
 MouseX.kr(-0.1, 0.1),
 1000
 ),
 mul: 0.5
 )
}.play
)

/*

12.13. Envelope with LFNoise as gate
*/

(
{
 SinOsc.ar(
 LFNoise0.kr(13, 1000, 1200),
 mul: EnvGen.kr(
 //Envelope is attack, decay, sustain level, release
 Env.adsr(0.001, 0.3, 0.2, 0.1), 
 LFNoise0.kr(3) //gate
 )
 )
}.play
)

/*

12.14. Complex envelope
*/

(
{
SinOsc.ar(
 EnvGen.kr(Env.new(
 [ 0, 0.5, 0, 0.3, 0.3, 0, 0.1, 0, 0.2, 0.3, 0.15, 0.5, 0.25 ],
 [1, 0.5, 0.5, 2, 0.7, 1, 0.3, 0.6, 0.5, 0.8, 0, 0.4])
 ) * 1000 + 200
)
}.play
)

// This will plot the array

[ 0, 0.5, 0, 0.3, 0.3, 0, 0.1, 0, 0.2, 0.3, 0.15, 0.5, 0.25 ].plot

/*
The Experimental Process
Practice, Bells
*/

12.15. Bells 

(
//frequency linked to envelope length
 //high notes short, low long
{
var frequency;
Mix.ar(
 {
 frequency = rrand(100, 5000);
 Pan2.ar(
 SinOsc.ar(
 frequency,
 mul: EnvGen.kr(
 Env.perc(0.001, 500/frequency), 
 Dust.kr(0.05),
 0.2
 )
 ), 
 rrand(-1.0, 1.0)
 ) 
 }.dup(100)
)
}.play
)


(
//frequency linked to decay length
 //basically the same code but more compact
 //low notes short, high long
{var frequency;
Mix.ar({
 frequency = rrand(100, 3000);
 Pan2.ar(SinOsc.ar(frequency,
 mul: EnvGen.kr(Env.perc(0.001, frequency/1000), 
 Dust.kr(0.05), 0.2)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

(//high notes short, low long
{var frequency;
Mix.ar({
 frequency = rrand(100, 3000);
 Pan2.ar(SinOsc.ar(frequency,
 mul: EnvGen.kr(Env.perc(200/frequency, 0.0001), 
 Dust.kr(0.05), 0.2)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

(//low notes short, high long
{var frequency;
Mix.ar({
 frequency = rrand(100, 1000);
 Pan2.ar(SinOsc.ar(frequency,
 mul: EnvGen.kr(Env.perc(frequency/500, 0001), 
 Dust.kr(0.05), 0.05)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

/*
12. Exercises

*/
splithere
/*

13 - Just and Equal Tempered Intervals, Multi-channel Expansion, 
Global Variables

 Harmonic series

13.1. Intervals 
*/

(
{
 f = 400; //fundamental
 r = 2/1; //ratio for second note in interval
 FSinOsc.ar([f, f*r], mul: 0.6)
}.scope(2)
)

/*

13.2. Multi-channel expansion
*/

//This code

(
{SinOsc.ar(
 LFNoise0.ar([10, 12, 14, 6], 400, [800, 1000]), 
 mul: [0.3, 0.5])}.scope(4)
)

//Becomes this in each channel:

(
//channel 1
{SinOsc.ar(
 LFNoise0.ar(10, 400, 800), 
 mul: 0.3)}.scope(1)
)

(
//channel 2
{SinOsc.ar(
 LFNoise0.ar(12, 400, 1000), 
 mul: 0.5)}.scope(1)
)

(
//channel 3
{SinOsc.ar(
 LFNoise0.ar(14, 400, 800), 
 mul: 0.3)}.scope(1)
)

(
//channel 4
{SinOsc.ar(
 LFNoise0.ar(6, 400, 1000), 
 mul: 0.5)}.scope(1)
)

/*

13.3. Intervals
*/

(
{
 f = 400; r = 2/1;
 a = FSinOsc.ar(f, 0.3);
 b = FSinOsc.ar(f*r, 0.3);
[a, b, a+b]*0.3
}.scope(3, zoom: 4)
)

/*

13.4. Function return: last line
*/

(
{
 a = FSinOsc.ar(200);
 b = FSinOsc.ar(1000);
 c = Pulse.ar(45);
 d = FSinOsc.ar(400);
c
}.scope(1)
)

/*

13.5. Audio frequencies
*/

{Saw.ar(MouseX.kr(1, 1200, 1), 0.5)}.scope(1)

/*

13.6. Ratios from LF to audio rate
*/

(

{
var freq, ratioNum, ratioDenum; //declare two variables
ratioNum = 3; //assign numerator
ratioDenum = 2; //assign denominator
freq = MouseX.kr(1,440, warp: 1); //freq is mouse control
LFSaw.ar(
 [freq, freq*(ratioNum/ratioDenum)], 0, 
 0.3)
}.scope(2)
)

/*

Just vs. Equal Intervals [New]

13.7. Equal Tempered compared to Pure Ratios
*/

(261.6 * [1, 9/8, 5/4, 4/3, 3/2, 5/3, 16/15, 2/1]).round(0.01)

[261.6, 294.3, 327, 348.8, 392.4, 436, 279.04, 523.2].cpsmidi.round(0.01)

/*


13.8. Ratios from LF to audio rate
*/

(
{
var midiNum, interval;
interval = 7; 
midiNum = MouseX.kr(0.1, 84); 
LFSaw.ar(
 [midiNum.midicps, (midiNum + interval).midicps], 0, 
 0.3)
}.scope(2)
)
/*

Practice, Free-Just, and Equal-Tempered Tuning 
*/

13.9. Tuning 

( //double click to select the entire example
SynthDef("PureTone",
{arg justFreq = 440, equalFreq = 440;
Out.ar(0, SinOsc.ar([justFreq, equalFreq], mul: 0.4)
 *EnvGen.kr(Env.perc(0, 1), doneAction:2));
}).load(s);

Task({
var jfreq = 440, efreq = 69, next = 6, equalInt, justInt;
equalInt = [-10, -8, -7, -5, -3, -1, 
 0, 2, 4, 5, 7, 9, 11];
justInt = [9/16, 5/8, 2/3, 3/4, 5/6, 15/16, 1/1, 
 9/8, 5/4, 4/3, 3/2, 5/3, 15/8];
 {
 [equalInt.at(next), justInt.at(next).round(0.01)].post;
 Synth("PureTone", [\justFreq, jfreq.round(0.01), 
 \equalFreq, efreq.midicps.round(0.01)].postln);
 next = 13.rand;
 jfreq = jfreq*justInt.at(next);
 efreq = efreq + equalInt.at(next);
 if(jfreq < 100, {jfreq = jfreq*2; efreq = efreq + 12});
 if(jfreq > 1000, {jfreq = jfreq/2; efreq = efreq - 12});
 [0.125, 0.125, 0.124, 0.25, 0.5, 1].choose.wait
 }.loop;
}).play(SystemClock);
)

// Same example with just a scale.

( //double click to select the entire example
SynthDef("PureTone",
{arg justFreq = 440, equalFreq = 440;
Out.ar(0, SinOsc.ar([justFreq, equalFreq], mul: 0.4)
 *EnvGen.kr(Env.perc(0, 1), doneAction:2));
}).load(s);

Task({
var jfreq = 440, efreq = 69, next = 0, equalInt, justInt;
equalInt = [-12, 2, 2, 1, 2, 2, 3];
justInt = [1/2, 9/8, 9/8, 16/15, 9/8, 9/8, 6/5];
 {
 [equalInt.wrapAt(next), justInt.wrapAt(next).round(0.01)].post;
 Synth("PureTone", [\justFreq, jfreq.round(0.01), 
 \equalFreq, efreq.midicps.round(0.01)].postln);
 next = next + 1;
 jfreq = jfreq*justInt.wrapAt(next);
 efreq = efreq + equalInt.wrapAt(next);
 0.25.wait
 }.loop;
}).play(SystemClock);
)

// Free just intonation only



/*
13. Exercises
*/
splithere
/*
14 - Additive Synthesis, Random Numbers, CPU usage
Harmonic Series and Wave Shape

14.1. String Vibration and Upper Harmonics



14.2. Vibrating Strings



14.3. Spectral Analysis of "Four Score"



Additive Synthesis

14.4. Adding sines together
*/

(
{
(
 SinOsc.ar(400) + SinOsc.ar(800) + SinOsc.ar(1200) + 
 SinOsc.ar(1600) + SinOsc.ar(2000) + SinOsc.ar(2400) + 
 SinOsc.ar(2800) + SinOsc.ar(3200) + SinOsc.ar(3600) + 
 SinOsc.ar(4000) + SinOsc.ar(4400) + SinOsc.ar(4800) 
)*0.1
}.scope
)

// Harmonics adjusted

(
{
(
 SinOsc.ar(400, mul: 1) + SinOsc.ar(800, mul: 1/2) + 
 SinOsc.ar(1200, mul: 1/3) + SinOsc.ar(1600, mul: 1/4) +
 SinOsc.ar(2000, mul: 1/5) + SinOsc.ar(2400, mul: 1/6) + 
 SinOsc.ar(2800, mul: 1/7) + SinOsc.ar(3200, mul: 1/8) + 
 SinOsc.ar(3600, mul: 1/9) + SinOsc.ar(4000, mul: 1/10) + 
 SinOsc.ar(4400, mul: 1/11) + SinOsc.ar(4800, mul: 1/12) 
)*0.1
}.scope
)
/*


14.5. Additive synthesis with a variable
*/

(
{
f = 100;
[
 SinOsc.ar(f*1, mul: 1), SinOsc.ar(f*2, mul: 1/2),
 SinOsc.ar(f*3, mul: 1/3), SinOsc.ar(f*4, mul: 1/4),
 SinOsc.ar(f*5, mul: 1/5), SinOsc.ar(f*6, mul: 1/6), 
 SinOsc.ar(f*7, mul: 1/7), SinOsc.ar(f*8, mul: 1/8), 
 SinOsc.ar(f*9, mul: 1/9), SinOsc.ar(f*10, mul: 1/10), 
 SinOsc.ar(f*11, mul: 1/11), SinOsc.ar(f*12, mul: 1/12) 
]
}.scope(12)
)
/*


14.6. Additive saw with modulation
*/

(
{
var speed = 14;
f = 300;
t = Impulse.kr(1/3);
Mix.ar([
 SinOsc.ar(f*1, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/1), 
 SinOsc.ar(f*2, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/2),
 SinOsc.ar(f*3, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/3), 
 SinOsc.ar(f*4, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/4),
 SinOsc.ar(f*5, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/5), 
 SinOsc.ar(f*6, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/6), 
 SinOsc.ar(f*7, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/7), 
 SinOsc.ar(f*8, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/8), 
 SinOsc.ar(f*9, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/9), 
 SinOsc.ar(f*10, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/10), 
 SinOsc.ar(f*11, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/11), 
 SinOsc.ar(f*12, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/12) 
])*0.5
}.scope(1)
)
 /*


14.7. Additive saw with independent envelopes
*/

(
{
f = 100;
t = Impulse.kr(1/3);
Mix.ar([
 SinOsc.ar(f*1, mul: EnvGen.kr(Env.perc(0, 1.4), t)/1), 
 SinOsc.ar(f*2, mul: EnvGen.kr(Env.perc(0, 1.1), t)/2),
 SinOsc.ar(f*3, mul: EnvGen.kr(Env.perc(0, 2), t)/3), 
 SinOsc.ar(f*4, mul: EnvGen.kr(Env.perc(0, 1), t)/4),
 SinOsc.ar(f*5, mul: EnvGen.kr(Env.perc(0, 1.8), t)/5), 
 SinOsc.ar(f*6, mul: EnvGen.kr(Env.perc(0, 2.9), t)/6), 
 SinOsc.ar(f*7, mul: EnvGen.kr(Env.perc(0, 4), t)/7), 
 SinOsc.ar(f*8, mul: EnvGen.kr(Env.perc(0, 0.3), t)/8), 
 SinOsc.ar(f*9, mul: EnvGen.kr(Env.perc(0, 1), t)/9), 
 SinOsc.ar(f*10, mul: EnvGen.kr(Env.perc(0, 3.6), t)/10), 
 SinOsc.ar(f*11, mul: EnvGen.kr(Env.perc(0, 2.3), t)/11), 
 SinOsc.ar(f*12, mul: EnvGen.kr(Env.perc(0, 1.1), t)/12) 
])*0.5
}.scope(1)
)

/*

Shortcuts

14.8. additive synthesis with array expansion 
*/

Mix.ar([SinOsc.ar(100), SinOsc.ar(200), SinOsc.ar(300)])

// The results are the same with this code

Mix.ar(SinOsc.ar([100, 200, 300]))

/*

14.9. additive synthesis with array expansion 
*/

midicps(60);

midicps([60, 62, 64, 65, 57, 69, 71]);

(1..12) // shortcut for [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

midicps((1..24)*60)

(1, 3..13) // means [1, 3, 5, 7, 9, 11, 13]

midicps((60, 63..72))

// additive synthesis with shortcuts

(
{
f = 100;
t = Impulse.kr(1/3);
Mix.ar(
 SinOsc.ar(
 f*(1..12),
 mul: EnvGen.kr(
 Env.perc(0, 1), 
 t, 
 levelScale: 1/(1..12),
 timeScale: [1.4, 1.1, 2, 1, 1.8, 2.9, 4, 0.3, 1, 3.6, 2.3, 1.1]
 )
 )
)*0.5
}.scope(1)
)
/*

14.10. additive synthesis with array expansion 
*/

(
{
t = Impulse.kr(1/3);
Mix.ar(
 SinOsc.ar(
 [60, 64, 67, 71, 74, 78].midicps,
 mul: EnvGen.kr(
 Env.perc(0, 1), 
 t, 
 levelScale: 1/(1..6),
 timeScale: rrand(1.0, 3.0).dup
 )
 )
)*[0.3, 0.3]
}.scope(1)
)

(
{
Mix.ar(
 Pan2.ar(
 SinOsc.ar(
 [60, 62, 63, 65, 67, 68, 71, 72].midicps,
 mul: LFNoise1.kr(rrand(0.1, 0.5).dup(8), 0.5, 0.5)
 ),
 1.0.rand2.dup(8)
 )
)*0.2
}.scope(1)
)
/*
Filling an array

14.11. Array.fill 
*/

Array.fill(16, {100.rand})

Array.fill(16, {SinOsc.ar(100.rand)})

/*

14.12. Array.fill with arg
*/

//fill an array with the number of this iteration
Array.fill(16, {arg counter; counter})

//fill an array with random numbers
Array.fill(16, {arg counter; [counter, rrand(20, 100)]})

//fill an array with multiples of counter
Array.fill(16, { |counter| counter*3})

//fill an array with SinOsc objects, each with a freq of the counter*100
Array.fill(16, { |counter| SinOsc.ar(counter*100)})

/*

14.13. Additive saw wave, separate decays 
*/

(
{
var gate, fund;
gate = Impulse.kr(1/3);
fund = MouseX.kr(50, 1000);
Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.adsr(0, 0, 1.0, TRand.kr(0.2, 2.0, gate)), 
 gate, 1/partial)
 })
 )*0.2 //overall volume
}.scope(1)
)

/*

14.14. Additive saw wave, same decays 
*/

(
{
var gate, fund, env;
gate = MouseButton.kr(0, 1, 0);
fund = MouseX.kr(50, 1000);
env = Env.adsr(0, 0, 1.0, 2.0);
Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(env, gate, 1/partial)
 })
 )*0.2 //overall volume
}.scope(1)
)

/*

14.15. Single sine with control
*/

{SinOsc.ar(400, mul: SinOsc.ar(1/3, mul: 0.5, add: 0.5))}.play

/*

14.16. Gaggle of sines
*/

(
{
 var harmonics = 16, fund = 50; 
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1), // calculates each harmonic
 mul: FSinOsc.kr(rrand(1/3, 1/6), mul: 0.5, add: 0.5 )),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

/*
Inharmonic spectra

14.17. Inharmonic spectrum
*/

{Mix.ar(
 SinOsc.ar(
 [72, 135, 173, 239, 267, 306, 355, 473, 512, 572, 626],
 0, //phase
 [0.25, 0.11, 0.12, 0.04, 0.1, 0.15, 0.05, 0.01, 0.03, 0.02, 0.12]
 ))}.scope(1)

/*
Random Numbers, Perception

14.18. rand
*/

10.rand;

10.0.rand;

/*

14.19. Test a random array
*/

{100.rand}.dup(20)

/*

14.20. Error from not using a function
*/

(100.rand).dup(20)

/*
 
14.21. Client random seed 
*/

{100.rand}.dup(20);

thisThread.randSeed = 5; {100.rand}.dup(20);

/*

14.22. Server random seed
*/

// different every time
{SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)}.play

// same every time
(
{
RandSeed.kr(1, 1956); 
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)

// resets every 5 seconds
(
{
RandSeed.kr(Impulse.kr(1/5), 1956); 
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)
/*

14.23. Post clock seed 
*/

thisThread.randSeed = Date.seed.postln; {100.rand}.dup(20);

(
{
RandSeed.kr(Impulse.kr(1/5), Date.seed.postln); 
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)
/*
Bells
 
14.24. random frequencies (Pan2, Mix, EnvGen, Env, fill)
*/

( // Let it run for a while, the strikes are random
{
var trigger, partials = 12;
trigger = Dust.kr(3/7);
Pan2.ar(
 Mix.ar(
 {
 SinOsc.ar(rrand(50.0, 4000)) * 
 EnvGen.kr(
 Env.perc(0, rrand(0.2, 3.0)), 
 trigger,
 1.0.rand
 )
 }.dup(partials)
 )/partials, 
 1.0.rand2
)
}.play
)

/*
 CPU Usage
Practice: flashing sines, gaggle of sines, diverging, converging, decaying gongs

14.25. flashing (MouseButton, Mix, Array.fill, Pan2, EnvGen, Env LFNoise1)
*/

(
{
var trigger, fund;
trigger = Dust.kr(3/7);
fund = rrand(100, 400);
Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 Pan2.ar(
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0), 
 trigger, 1/partial
 ) * max(0, LFNoise1.kr(rrand(5.0, 12.0))), 1.0.rand2)
 })
 )*0.5 //overall volume
}.play
)

//Several of the above mixed down

(
{
var trigger, fund, flashInst;
flashInst = Array.fill(5,
{
 trigger = Dust.kr(3/7);
 fund = rrand(100, 400);
 Pan2.ar(
 Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0), 
 trigger, 1/partial
 ) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
 })
 )*0.2,
 1.0.rand2)
});
Mix.ar(flashInst)*0.6
}.play
)

// Gaggle of sines varations

(
{
 var harmonics = 16, fund = 50, speeds;
 speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/5;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(speeds.wrapAt(count)))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

(
{
 var harmonics = 16, fund, speeds;
 speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/20;
 fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(speeds.choose))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

// Use mouse to change fundamental 

(
{
 var harmonics = 16, fund;
 fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(rrand(1, 1/3), mul: 20).softclip)),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

(
{
 var harmonics = 16;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 exprand(100, 2000),
 mul: max(0, FSinOsc.kr(rrand(1/3, 1/6))*rrand(0.1, 0.9))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)



// Dissipating and converging gongs illustrates how a patch can be built
// from duplicating one idea; classic additive synthesis. It also shows
// how additive synthesis can be used to control each harmonic.
// Listen in stereo to hear the harmonics diverge.

(

{
var dur = 6, base, aenv, fenv, out, trig;
base = Rand(40, 100);
trig = SinOsc.ar(1/10);
out = Mix.fill(15,{
 var thisDur;
 thisDur = dur * rrand(0.5, 1.0);
 aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
 fenv = EnvGen.kr(Env.new([0, 0, 1, 0], [0.25*thisDur, 0.75*thisDur, 0]), trig);
 Pan2.ar(SinOsc.ar( Rand(base, base * 12) * 
 LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
 mul: aenv // amp
 ), ([1, -1].choose) * fenv)
}) * 0.05;
out
}.play(s);


{
var dur = 6, base, aenv, fenv, out, trig, detune;
base = Rand(40, 60);
detune = 0.1; // increase this number to detune the second bell
trig = SinOsc.ar(1/10, pi);
out = Mix.fill(15,
{ arg count;
 var thisDur;
 thisDur = dur * rrand(0.5, 1.0);
 aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
 fenv = EnvGen.kr(Env.new([1, 1, 0, 1], [0.05*thisDur, 0.95*thisDur, 0]), trig);
 Pan2.ar(SinOsc.ar( base*(count+1+ detune.rand) * 
 LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
 mul: aenv // amp
 ), ([1, -1].choose) * fenv)
}) * 0.05;
out
}.play(s);
)

// Decaying bell

(
{
var aenv, fenv, out, trig, dur, base;
dur = rrand(1.0, 6.0);
base = exprand(100, 1000);
trig = Impulse.kr(1/6);
out = Mix.ar(
 Array.fill(15,{
 arg count;
 var thisDur;
 thisDur = dur * rrand(0.5, 1.0);
 aenv = EnvGen.kr(
 Env.new([0, 1, 0.4, 1, 0], [0, 0.5, 0.5, 0]), trig, 
 timeScale: thisDur);
 fenv = EnvGen.kr(
 Env.new([0, 0, 0.5, 0.5, 0], [0.25, 0.5, 0.25, 0]), 
 trig, timeScale: thisDur);
 Pan2.ar(SinOsc.ar( Rand(base, base * 12) * 
 LFNoise1.kr(10, mul: 0.1 * fenv, add: 1), // freq
 mul: aenv // amp
 ), ([1, -1].choose) * fenv)
 })
) * EnvGen.kr(Env.linen(0, dur, 0), Impulse.kr(6), timeScale: dur, 
 levelScale: 0.05, doneAction: 2);
out*0.3;
}.play;
)

/*
14. Exercises
*/
splithere
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
splithere
/*
16 - FM/AM Synthesis, Phase Modulation, Sequencer, Sample and 
Hold
AM and FM synthesis or "Ring" Modulation

16.1. From LFO to FM
*/

{SinOsc.ar(SinOsc.ar(MouseX.kr(1, 500), mul: 300, add: 800))}.play

/*

16.2. AM Synthesis (SinOsc, scope, mul, Saw)
*/

{SinOsc.ar(500, mul: SinOsc.ar(50, mul: 0.5))}.scope(1)

{Saw.ar(500, mul: SinOsc.ar(50, mul: 0.5))}.scope(1)

/*

16.3. FM Synthesis 
*/

{SinOsc.ar(400 + SinOsc.ar(124, mul: 100), mul: 0.5)}.scope(1)

/*
Phase Modulation

16.4. PM Synthesis 
*/

{PMOsc.ar(400, 124, 1, mul: 0.5)}.scope(1)

/*

16.5. Controls for carrier, modulator, and index
*/

(
{PMOsc.ar(LFNoise0.kr(5, 300, 700),// carrier
 134, 4, mul: 0.4)
 }.scope(1)
)

(
{PMOsc.ar(700,
 LFNoise0.kr(5, 500, 700),//modulator
 12, mul: 0.4
 )}.scope(1)
)
 
(
{PMOsc.ar(700, 567,
 LFNoise0.kr(5, 6, 12), //index
 mul: 0.4
 )}.scope(1)
)
 
(
// All three. This is the type of sound that
// got me hooked on synthesis in the first place.

{PMOsc.ar(LFNoise0.kr([9, 9], 300, 700),
 LFNoise0.kr([9, 9], 500, 700),
 LFNoise0.kr([9, 9], 6, 12),
 mul: 0.5
 )}.scope(1)
)

/*

16.6. Efficiency of PM
*/

{PMOsc.ar(1000, 1367, 12, mul: EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))}.play

(
{
Mix.ar(
 SinOsc.ar(abs((-20..20)*1367 + 1000), 
 mul: 0.1*EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))
)}.play
)

/*
 
16.7. Carrier and modulator ratio
*/

(
{var freq, ratio;
freq = LFNoise0.kr(4, 20, 60).round(1).midicps;
ratio = 2/1;
PMOsc.ar(
 freq, //carrier
 freq*ratio, //modulator
 MouseY.kr(0.1, 10), //index
 Mul: [0.4, 0.4]
)}.play
)

/*

16.8. Envelope applied to amplitude and modulation index
*/
 
(
{var freq, ratio, env, rate = 5, trig;
trig = Impulse.kr(5);
freq = TRand.kr([36, 60], [72, 86], trig).midicps;
ratio = 2;
env = EnvGen.kr(Env.perc(0, 1/rate), gate: trig);
PMOsc.ar(
 freq,
 freq*ratio,
 3 + env*4, 
 mul: env
)}.play
)

/*
Sequencer

16.9. Sequencer (array, midicps, SinOsc, Sequencer, Impulse, kr)
*/

(
var pitchArray; //Declare a variable to hold the array
 //load the array with midi pitches
pitchArray = [60, 62, 64, 65, 67, 69, 71, 72].midicps; 
{
 SinOsc.ar(
 Select.kr(
 Stepper.kr(Impulse.kr(8), max: pitchArray.size-1),
 pitchArray),
 mul: 0.5)
}.play
)

(
var pitchArray; //Declare a variable to hold the array
 //load the array with midi pitches
pitchArray = Array.rand(24, 100, 2000); 
{
 SinOsc.ar(
 Select.kr(
 Stepper.kr(Impulse.kr(8), max: pitchArray.size-1),
 pitchArray),
 mul: 0.5)
}.play
)

/*

16.10. scramble, reverse (Array.rand, postln, scramble, reverse)
*/

(
var pitchArray;
pitchArray = Array.rand(10, 60, 84);
pitchArray.postln.scramble.postln.reverse.postln;
(pitchArray + 12).postln
)

/*

16.11. sequencer variations
*/

(
var pitchArray; 
pitchArray = [60, 62, 64, 65, 67, 69, 71, 72]; 
pitchArray = [ //pick one of the following
 (pitchArray + rrand(1, 12)).midicps, //transpose
 pitchArray.reverse.midicps, //reverse
 pitchArray.scramble.midicps, //scramble
 Array.rand(12, 36, 72).midicps, //random midi
 Array.rand(12, 100, 1200) //random frequency
 ].choose;
{
 SinOsc.ar(
 Select.kr(
 Stepper.kr(Impulse.kr(7), pitchArray.size-1),
 pitchArray),
 mul: 0.5)
}.play
)

// [New] a more interesting example using PM

(
{
var freq, freqArray, ratioArray, indexArray, 
 env, rate = 5, trig;
trig = Impulse.kr(rate);
freqArray = [48, 50, 52, 53, 55, 57, 59, 60,
 62, 64, 65, 67, 69, 71, 72].scramble.midicps;
ratioArray = {rrand(1.0, 3.0)}.dup(20);
indexArray = {rrand(1.0, 4.0)}.dup(20);
env = EnvGen.kr(Env.perc(0, 1/rate), gate: trig);
freq = Select.kr(Stepper.kr(trig, freqArray.size-1), freqArray);
PMOsc.ar(
 freq,
 freq*Select.kr(Stepper.kr(trig, ratioArray.size-1), ratioArray),
 Select.kr(Stepper.kr(trig, indexArray.size-1), indexArray)
 + env*4, 
 mul: env
)}.play
)


/*
Sample and Hold

16.12. Latch 
*/

(
{
SinOsc.ar(
 Latch.kr(
 LFSaw.kr(MouseX.kr(0.1, 20), 0, 500, 600), 
 Impulse.kr(10)),
 mul: 0.3 //Volume of Blip
)
}.scope(1)
)

(
{
SinOsc.ar(
 Latch.kr(
 LFSaw.kr(Line.kr(0.1, 20, 60), 0, 500, 600), 
 Impulse.kr(10)),
 mul: 0.3 //Volume of Blip
)
}.scope(1)
)

/*
 
16.13. Latch 
*/

(
{ // controlling modulator and carrier freq 
f = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 1000, 1100), 
 Impulse.kr(10));
PMOsc.ar(f, f*2, 12, mul: 0.3)
}.scope(1)
)

(
{ // controlling index
i = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 5, 5), 
 Impulse.kr(10));
PMOsc.ar(300, 356, i, mul: 0.3)
}.scope(1)
)

(
{ // controlling ratio
r = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 2.0, 3.0), 
 Impulse.kr(10));
PMOsc.ar(300, 300*r, 12, mul: 0.3)
}.scope(1)
)

(
{ // and of course, scaled to control all three
c = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 0.5, 0.5), 
 Impulse.kr(10));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

/*

16.14. Latch sample and speed ratio (Blip, Latch, LFSaw, Impulse, mul)
*/
 
(
{ 
var rate, speed, ratio;
rate = MouseX.kr(1, 24); 
ratio = 1.61803399;
c = Latch.kr(
 LFSaw.kr(rate*ratio, 0, 0.5, 0.5), 
 Impulse.kr(rate));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

(
{ 
var rate, speed, ratio;
rate = MouseX.kr(1, 24); 
ratio = SinOsc.ar(2/7, mul: 0.2, add: 1.75);
c = Latch.kr(
 LFSaw.kr(rate*ratio, 0, 0.5, 0.5), 
 Impulse.kr(rate));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

/*

16.15. Complex Wave as Sample Source (Mix, SinOsc, Blip, Latch, Mix, Impulse)
*/

{Mix.ar(SinOsc.ar([100, 200, 300, 550], mul: 0.1))}.scope(1)

(
//Used in a sample and hold
{
f = Latch.kr(
 Mix.ar(SinOsc.ar([100, 200, 300, 550], mul: 100, add: 110)), 
 Impulse.kr(7));
e = EnvGen.kr(Env.perc(0, 0.2), Impulse.kr(7));
PMOsc.ar(f, f*1.25, e*5, mul: e*0.3)
}.play
)

/*
Practice S&H FM

16.16. Practice, Sample and Hold, FM
*/

(
{var freq, latchrate, index, ratio, env, rate;
rate = 9;
latchrate = rate*1.61803399;
// latchrate = rate*LFNoise1.kr(1/7, mul: 0.03, add: 1.6);
// latchrate = rate*LFNoise0.kr(1/3, mul: 0.03, add: 1.6);

index = Latch.kr(
 LFSaw.kr(latchrate, mul: 4, add: 8),
 Impulse.kr(rate)
 );
freq = Latch.kr(
 LFSaw.kr(latchrate, mul: 36, add: 60),
 Impulse.kr(rate)
 ).round(1).midicps;
// freq = 200; //uncomment this line to hear just the index

ratio = 2.01; 
// ratio = LFNoise1.kr(1, mul: 2.3, add: 3.0);
// ratio = LFNoise0.kr(1, mul: 2.3, add: 3.0);
// ratio = LFNoise1.kr(1/5, mul: 2.0, add: 5.0);

env = EnvGen.kr(Env.perc(0, 2/rate), gate: Impulse.kr(rate));

PMOsc.ar([freq, freq * 1.5],
 [freq*ratio, freq*1.5*ratio], 
 index, 
 mul: env*0.5
)}.play
)

// Variation

(
{var freq, latchrate, index, ratio, env, rate;
rate = 9;
latchrate = rate*LFNoise0.kr(1/10, mul: 0.03, add: 1.6);
index = Latch.kr(
 LFSaw.kr(latchrate, mul: 5, add: 6),
 Impulse.kr(rate)
 );
freq = Latch.kr(
 LFSaw.kr(latchrate, 
 mul: max(0, LFNoise1.kr(1/5, 24, 10)), 
 add: LFNoise0.kr(1/7, 12, 60)),
 Impulse.kr(rate)
 ).round(1).midicps;
ratio = LFNoise1.kr(1/10, mul: 2.0, add: 5.0);

env = EnvGen.kr(Env.perc(0, LFNoise0.kr(rate, 1, 1.5)/rate), Impulse.kr(rate), 
LFNoise1.kr([5, 5], 2, 1).max(0).min(0.8));
PMOsc.ar(
 [freq, freq * 1.5],
 freq*ratio,
 index,
 mul: env //overall volume
)}.play
)


// Crotale
// Run this code first to define the instrument, 
// then execute the "task" below as many times
// as you want.

(
SynthDef("crotale", {
arg param = #[500, 3, 2, 0, 6, 5, 0, 0.9]; 
var factor, env, out, freq, index, dur;
var bus, ratioa, ratiob, attack, decay, panCont;
freq = param.at(0); index = param.at(1); dur = param.at(2);
bus = param.at(3); ratioa = param.at(4); ratiob = param.at(5);
attack = param.at(6); decay = param.at(7);

env = Env.perc(attack, decay);
factor = gcd(ratioa, ratiob);
ratioa = div(ratioa, factor); 
ratiob = div(ratiob, factor);

panCont = (EnvGen.kr(env, timeScale: dur*1.1, 
 levelBias: -1, levelScale: 2))
 * (IRand(0, 1) * 2 - 1); // 0*2-1 = -1, 1*2-1 = 1

out = PMOsc.ar(
 ratioa*freq, //or try ratioa*freqCont,
 ratiob*freq, //or try ratioa*freqCont,
 pmindex: EnvGen.kr(env, timeScale: dur, 
 levelBias: 1, levelScale: index), 
 mul: EnvGen.kr(env, timeScale: dur, levelScale: 0.3));

out = Pan2.ar(out, panCont);

out = out * EnvGen.kr(env, timeScale: 1.3*dur, 
 levelScale: Rand(0.1, 0.5), doneAction:2); 
Out.ar(0, out); //Out.ar(bus, out);

}).play;
)

// Define the instrument by running the code
// above, then run this task to actually play 
// the instrument. 

(
r = Task({
 var freq, indexDepth, indexRange, synthIndex, dur, repeat;
 var next, count, countDown, offset, ratioa, ratiob, envs, env;
 var range = 60, outBus = 0;
 count = 0; countDown = 0; offset = 0;
 envs = [[0, 0.9], [0.01, 0.9], [0.1, 0.8], [0.8, 0.01]];
 repeat = Array.fill(10, 
 {[rrand(range, range+24).round(1).midicps, 3, 
 2.1 - exprand(0.1, 2.0), 0, 1, 1, 0, 0.9]});
 next = Array.fill(10, {[3, 0.75, 0.5, 0.25, 0.125].choose});
 freq = rrand(range, range*2); // these two are just starting points
 indexDepth = 1;
 
 inf.do({
 if(countDown <= 0,
 {
 env = envs.choose;
 next.put(count%10, [3, 0.5, 0.25, 0.125, 0.125].choose); 
 repeat.put(count%10, [
 rrand(range, range + 24).round(1).midicps, 
 rrand(0.1, 12.0),
 2.1 - exprand(0.1, 2.0), outBus, rrand(1, 12), 
 rrand(1, 12), env.at(0), env.at(1)]);
 });
 
 Synth("crotale").setn(\param, repeat.wrapAt(count));
 next.wrapAt(count).wait; 
 if((count > 10).and(countDown <= 0), 
 {offset = countDown = [0, 3.rand, 6.rand].choose; 
 count = count - offset});
 count = count + 1;
 countDown = countDown - 1;
 });
}).play(SystemClock);
)

/*
16. Exercises
*/
splithere
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
splithere
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
splithere
/*
Section III: Computer Assisted Composition 
19 - Operators, Precedence, Arguments, Expressions, and User 
Defined Functions
Operators, Precedence

19.1. Operators (+, /, -, *)
*/

1 + 4

5/4

8*9-5

9-5*8 

9-(5*8)

/*

19.2. More operators
*/

1 + 2 / 4 * 6

2 / 4 + 2 * 6

(2 * 6) - 5

2 * (6 - 5)

/*

19.3. Binary operators (>, <, ==, %)
*/

10 > 5

5 < 1

12 == (6*2)

106%30

/*

19.4. Predict
*/

(8+27)%6

((22 + 61) * 10 )%5

/*
Messages, Arguments, Receivers

19.5. Music related messages 
*/

cos(34) //returns cosine

abs(-12) //returns absolute value

sqrt(3) //square root

midicps(56) //given a midi number, this returns 
//the cycles per second in an equal tempered scale

cpsmidi(345) //given cps, returns midi

midiratio(7) //given a midi interval, returns ratio

ratiomidi(1.25) //given a ratio, returns midi number

rand(30) //returns a random value between 0 and 29

rand2(20) //returns a random value between -30 and 30

rrand(20, 100) //returns a random value between 20 and 100

// Here are examples in receiver notation.

30.cos //same as cos(30)

0.7.coin //same as coin(0.7)

20.rand //same as rand(20)

7.midiratio

// Binary functions have two arguments. 

min(6, 5) //returns the minimum of two values

max(10, 100) //returns maximum

round(23.162, 0.1) //rounds first argument to second argument

// Arguments can be expressions

min(5*6, 35)

max(34 - 10, 4) //returns the maximum of two values

/*
Practice, Music Calculator

19.6. Music calculator
*/

// Major scale frequencies
([0, 2, 4, 5, 7, 9, 11, 12] + 60).midicps.round(0.01)

// Major scale interval ratios
[0, 2, 4, 5, 7, 9, 11, 12].midiratio.round(0.001)

// Phrygian scale frequencies
([0, 1, 3, 5, 7, 8, 10, 12] + 60).midicps.round(0.01)

// Phrygian scale interval ratios
[0, 1, 3, 5, 7, 8, 10, 12].midiratio.round(0.001)

// Equal and Just Mixolydian scale compared
[0, 2, 3, 4, 5, 7, 9, 10, 12].midiratio.round(0.001)

[1/1, 9/8, 6/5, 5/4, 4/3, 3/2, 8/5, 7/4, 2/1].round(0.001)

// Just ratios (mixolydian) in equal tempered cents 
// (and therefor their deviation from equal temperament)
[1/1, 9/8, 6/5, 5/4, 4/3, 3/2, 8/5, 7/4, 2/1].ratiomidi.round(0.01)

// Retrograde of a 12-tone set
[0, 11, 10, 1, 9, 8, 2, 3, 7, 4, 6, 5].reverse

// Inversion of a 12-tone set
12 - [0, 11, 10, 1, 9, 8, 2, 3, 7, 4, 6, 5]

// And of course, retrograde inversion (see where I'm heading?)
(12 - [0, 11, 10, 1, 9, 8, 2, 3, 7, 4, 6, 5]).reverse

// Random transpositions of a 12-tone set
([0, 11, 10, 1, 9, 8, 2, 3, 7, 4, 6, 5] + 12.rand)%12

// Random permutation of a 12-tone set (out of 479,001,600)
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].permute(479001600.rand) + 60

/*
Functions, Arguments, Scope

19.7. Function
*/

(
var myFunc;

myFunc = {100 * 20};

myFunc.value.postln;
)

/*

19.8. Function with arguments
*/

(
var func;
func = { arg a, b;
 var r;
 r = (b * 20)%a;
 r.postln;
 };
func.value(15, 5);
)

/*

19.9. Function with array arguments
*/

(
var func;
func = { arg a = 1, b = 2, c = 4;
 [a, b, c].sum;
 };
func.value(15, 5, 100);
)


(
var func;
func = { arg ... a;
 a.postln;
 a.sum.postln;
 (a + 1.0.rand).sum
 };
func.value(15, 5, 100);
func.value(15, 5, 100, 3, 78, 18, 367);
func.value(1, 2);
)

// Combine both syntaxes

(
var func;
func = { arg a = 0, b = 0 ... c;
 [a, b, c].postln;
 c.sum.postln;
 (c + 3.0.rand).sum.postln;
 (a/b*c).postln;
 };
func.value(15, 5, 100, 45);
func.value(15, 5, 100, 3, 99, 754, 78, 18, 367);
func.value(1, 2, 3, 4, 5);
)

/*

19.10. Function with arguments and variables
*/

var func, outside = 60;
~myGlobal = 22;
func = { arg first = 5, second = 9; 
 var inside = 10;
 inside = (first * 11)%second; 
 [first, second, inside, outside, ~myGlobal].postln; // all of these work
 (outside/inside).postln; //works
 };
//inside.postln; // uncomment this, it will not work
func.value(15, 6); // arguments passed to the function.

/*

19.11. Function calls
*/

(//line 1
var myFunc;
myFunc = { arg a = 10, b = 2;
 b = (b * 100)%a;
 b.postln;
 };
myFunc.value; //line 7
myFunc.value(15); //line 8
myFunc.value(11, 30); //line 9
)

/*

19.12. Keywords
*/

(
var myFunc;
myFunc = { arg firstValue = 10, secondValue = 2;
 firstValue = (firstValue * 100)%secondValue;
 firstValue.postln;
 };
myFunc.value;
myFunc.value(firstValue: 15);
myFunc.value(firstValue: 30, secondValue: 11);
myFunc.value(secondValue: 30, firstValue: 11);
myFunc.value(secondValue: 23);
)

/*

19.13. Return
*/

(
var octaveAndScale;
octaveAndScale = { arg oct = 4, scale = 0;
 var scales, choice;
 oct = (oct + 1)*12; //translate "4" (as in C4) to MIDI octave (60) 
 scales = [
 [0, 2, 4, 5, 7, 9, 11], //major
 [0, 2, 3, 5, 6, 8, 9, 11], //octatonic
 [0, 2, 4, 6, 8, 10] //whole tone
 ];
 scale = scales.at(scale); //more on the "at" message below
 choice = scale.choose; //choose a pitch
 choice = choice + oct; //add the octave
 choice //return the final result
 };

octaveAndScale.value; //choose from major scale, C4 octave
octaveAndScale.value(3); //choose from C3 octave, major scale
octaveAndScale.value(7, 2); //choose from C7 octave, whole tone scale
octaveAndScale.value(scale: 1); //choose from C4 octave, octatonic scale
)

/*
Practice, just flashing

19.14. Function practice, free, just tempered flashing
*/

(
//run this first
SynthDef("Flash", 
{
arg fund = 400, decay = 4, filter = 1;
var out, harm;

out = Mix.ar(
 Array.fill(7,
 {
 arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.linen(0, 0, decay + 2), 
 levelScale: 1/(partial*filter)
 ) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
 })
 )*0.3; //overall volume
out = Pan2.ar(out, Rand(-1.0, 1.0));
DetectSilence.ar(out, doneAction:2);
Out.ar(0, out)
}
).play(s);
)

(
//then this
r = Task({
var freqFunc, pitch = 440, nextEvent;

freqFunc = {arg previousPitch;
 var nextPitch, nextInterval;
 nextInterval = [3/2, 2/3, 4/3, 3/4, 5/4, 4/5, 6/5, 5/6].choose;
 nextPitch = (previousPitch*nextInterval).wrap(100, 1000);
 nextPitch.round(0.01).post; " != ".post; 
 nextPitch.cpsmidi.round(1).midicps.round(0.01).postln;
 nextPitch
};

{
 nextEvent = [0.5, 0.25, 5, 4, 1].choose;
 pitch = freqFunc.value(pitch);
 Synth("Flash", 
 [\fund, pitch, \decay, nextEvent, \filter, rrand(1.0, 4.0)]);
 //Choose a wait time before next event
 nextEvent.wait;
}.loop;
}).play
)

/*
Practice: Example Functions

19.15. Pitch functions
*/
pitches = [60, 61, 62, 63, 64]; //declare an array of pitches
freqFunc = {
 midiNote = pitches.choose; //pick a pitch from the array
 midiNote.midicps; // return the cps for that pitch 
}; 
pitches = [60, 62, 64, 67, 69, 72, 74, 76]; //declare an array of pitches 
count = 0; //initialize count 
freqFunc = {
 midiNote = pitches.wrapAt(count); // wrapped index of count
 if(count%30 == 29, //every ninth time
 {pitches = pitches.scramble} //reset "pitches" to a scrambled 
 //verion of itself
 );
 count = count + 1; //increment count
 midiNote.midicps; //return cps 
};


// My favorite:
var freqFunc, pitches, pitch = 440, count, midiNote, nextEvent;
pitches = [60, 62, 64, 67, 69, 72, 74, 76].scramble; 
freqFunc = {
 midiNote = pitches.wrapAt(count); // wrap index of count
 if(count%10 == 9, //every tenth time
 {pitches.put(5.rand, (rrand(60, 76)))}//put a new pitch between
 //65 and 75 into the array pitches
 //at a random index
 );
 count = count + 1; //increment count
 midiNote.midicps; //return cps 
};

/*
19. Exercises
*/
splithere
/*
20 - Iteration Using do, MIDIOut

20.1. function passed as argument
*/

// function passed as variable

var myFunc;

myFunc = {
 (10*22).rand
};

max(45, myFunc.value); 
// function nested

max(45, {(10*22.rand)})

/*

20.2. do example
*/

do(["this", "is", "a", "list", "of", "strings"], {arg eachItem; eachItem.postln;})

// or

do([46, 8, 109, 45.8, 78, 100], {arg whatever; whatever.postln;})


/*

20.3. do example
*/

do(5, {arg theNumber; theNumber.postln;})

/*

20.4. do in receiver
*/

do(5, {"boing".postln})
//same result
5.do({"boing".postln;})

/*


20.5. do(10) with arguments
*/

do(10, {arg eachItem, counter; eachItem.postln; counter.postln})
/*


20.6. array.do with arguments
*/

[10, "hi", 12.56, [10, 6]].do({arg eachItem, counter; [counter, eachItem].postln})

[10, "hi", 12.56, [10, 6]].do({arg count, list; [count, list].postln}) //wrong

[10, 576, 829, 777].do({arg count, items; (items*1000).postln});

[10, 576, 829, 777].do({arg items, count; (items*1000).postln});

inf.do({arg i; i.postln}) //this will, of course, crash SC

/*

MIDIOut

20.7. MIDI out
*/

(
MIDIClient.init;
m = MIDIOut(0, MIDIClient.destinations.at(0).uid);
)

m.noteOn(1, 60, 100); //channel, MIDI note, velocity (max 127)

m.noteOff(1, 60); //channel, MIDI note, velocity (max 127)

// Same thing:

m.noteOn(1, 60, 100); //channel, MIDI note, velocity (max 127)

m.noteOn(1, 60, 0); //channel, MIDI note, velocity (max 127)

// Or if you don't have MIDI

(
SynthDef("SimpleTone", 
 { //Beginning of Ugen function
 arg midiPitch = 60, dur = 0.125, amp = 0.9;
 var out;
 out = SinOsc.ar(midiPitch.midicps, mul: amp);
 out = out*EnvGen.kr(Env.perc(0, dur), doneAction:2);
 Out.ar(0, out)
 }
).play(s);
)

//Then in the examples replace this

m.noteOn(arguments)

//with

Synth("SimpleTone", arguments)
/*

Practice, do, MIDIOut, Every 12-Tone Row

20.8. Every row
*/

// Permute

25.do({arg count; 
 postf("Permutation %: %\n", count, [1, 2, 3, 4].permute(count));})

//Every row 

(
//run this first
var original, total, begin, next, art;
original = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
total = 479001600;
begin = total.rand;
next = 0.125;
art = 0.9;
("Total playback time = " ++ (total*next/3600).asString ++ " hours.").postln;
r = Task({
 total.do({arg count;
 var thisVar;
 thisVar = original.permute(count+begin);
 thisVar.postln;
 (thisVar + 60).do({arg note;
 m.noteOn(1, note, 100);
 thisThread.clock.sched(next*art, {m.noteOff(1, note, 100); nil});
 (next).wait
 });
 })
})
)

//then these
r.start;
r.stop; 127.do({arg i; m.noteOff(1, i, 0)})

/*

20.9. Every random row
*/
 
(
var original, total, begin, next, art;
original = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
total = 479001600;
next = 0.125;
art = 0.9;
("Total playback time = " ++ (total*next/3600).asString ++ " hours.").postln;
r = Task({
 total.do({
 var thisVar;
 thisVar = original.permute(total.rand);
 thisVar.postln;
 (thisVar + 60).do({arg note;
 m.noteOn(1, note, 100);
 thisThread.clock.sched(next*art, {m.noteOff(1, note, 100); nil});
 (next).wait
 });
 })
})
)

r.start;
r.stop; 127.do({arg i; m.noteOff(1, i, 0)})

/*
20. Exercises
*/
splithere
/*
21 - Control Using if, do continued, Arrays, MIDIIn, Computer 
Assisted Analysis 
Control message "if" 

21.1. if examples
*/

if(1 == 1, {"true statement";},{"false statement";})

if(1 == 4, {"true statement";},{"false statement";})

// Commented:

if( 
 1 == 1, //expression to be evaluated; "1 is equal to 1" true or false?
 {"true statement";}, //if the statement is true run this code
 {"false statement";} //if it is false run this code
)

/*

21.2. if examples
*/

if((1 == 1).and(5 < 7), {"both are true"},{"maybe only one is true";})

if((1 == 20).and(5 < 7), {"both are true";},{"one or both are false";})

if((1 == 20).and(24 < 7), {"both are true";},{"one or both are false";})

if((1 == 4).or(true), {"true is always true";},{"1 does not equal 4";})

if(false.or(true), {"true is always true";},{"true wins with or";})

if(false.and(true), {"true is always true";},{"but false wins with and";})

if(or(10 > 0, 10 < 0), {34},{78})

if((1 == 1).and((10 > 0).or((5 < 0).or(100 < 200))), {78},{88})

/*

21.3. do 50 MIDI intervals
*/

(
m = 60;
50.do(
 {
 m = m + [6, 7, 4, 2, 11, 8, -2, -6, -1, -3].choose;
 m.postln;
 }
)
)

/*

21.4. do 50 MIDI intervals
*/

(
m = 60;
50.do(
 {
 var next;
 next = [6, 17, 14, 2, 11, 8, -12, -16, -1, -3].choose;
 "next interval is : ".post; next.postln;
 m = m + next;
 "before being fixed: ".post; m.post;
 if(m > 72, {m = m - 24});
 if(m < 48, {m = m + 24});
 " after being fixed: ".post; m.postln;
 }
)
)

/*

21.5. pitch class do
*/

(
["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"].do(
 {arg item, count;
 if((item == "C").or(item == "E").or(item == "G"), //Boolean test
 {item.post; " is part of a C chord.".postln;}, //True function
 {item.post; " is not part of a C chord".postln;} //False function
 )
 }
 )
)

/*

21.6. Mouse Area Trigger
*/
(
{
var aenv, fenv, mgate, mx, my;
mx = MouseX.kr(0, 1);
my = MouseY.kr(0, 1);
mgate = if((mx>0.3) * (mx<0.5) * (my>0.3) * (my<0.7), 1, 0);
aenv = EnvGen.kr(Env.asr(0.1, 0.5, 2), mgate);
fenv = EnvGen.kr(Env.asr(1, 1, 2), mgate, 1000, 100);
RLPF.ar(Saw.ar(100)*aenv, fenv, 0.1)
}.play
)
/*

21.7. new line
*/

(
100.do(
 {
 arg count; 
 100.rand.post;
 if(count%10 == 9, //Every 9th time 
 {" new line: ".postln;}, //print a carriage return
 {" : ".post;} //just " * " without a return
 );
 }
)
)

/*
while 

21.8. while
*/

a = 0; while({a != 10}, {a = 10.rand}) // save before doing this

// Safer?

c = 0; a = 0; 
while({and(a != 10, c < 100)}, {a = 10.rand; c = c + 1;})


(
a = 0; c = 0; 
while({(a != 13).and(c < 10000)}, {a = 100.rand; c = c + 1;});
c
)

/*
for, forBy 

21.9. for, forBy
*/

34.for(84, {|i| i.midicps.postln});

34.forBy(84, 5, {|i| [i, i.midicps].postln});

1.forBy(24, 2, {|i| [i, i*500].postln}); // odd harmonics

( // additive square wave
{
o = 0;
1.forBy(24, 2, {|i| o = o + SinOsc.ar(i*500, mul: 1/i)});
o*0.4
}.scope
)

/*
MIDIIn 

21.10. MIDI input to trigger SynthDef
*/

(
// First define this instrument
SynthDef("simpleInst", 
{
arg midi = 60, vel = 60, inst;
inst = {
 SinOsc.ar(
 freq: (midi.midicps)*(LFNoise0.kr(12) + 2).round(1), 
 mul: vel/256)
 }.dup(5) *
 EnvGen.kr(Env.perc(0, 3), doneAction: 2);
Out.ar(0, inst)
}
).play
)

(
// Then link it to MIDI input

MIDIIn.noteOn = {
arg src, chan, midiNum, midiVelo; 
Synth("simpleInst", [\midi, midiNum, \vel, midiVelo]);
};

)

/*
Real-Time Interpolation 

21.11. MIDI input interpolation with if() filter
*/

// Simple delay for velocities above 60
(
MIDIIn.noteOn = {arg src, chan, num, vel;
var delay = 0.5;
thisThread.clock.sched(delay, {m.noteOn(1, num, vel)});
};
MIDIIn.noteOff = {arg src, chan, num, vel;
var delay = 0.5;
thisThread.clock.sched(delay, {m.noteOff(1, num, vel)});
};
)


// Interpolation: inversion of white keys only

(
var white;
white = [0, 2, 4, 5, 7, 9, 11];

MIDIIn.noteOn = {arg src, chan, num, vel;

if(white.includes(num%12), 
 {m.noteOn(1, (60 - num) + 60, vel);},
 {m.noteOn(1, num, vel)});
};

MIDIIn.noteOff = {arg src, chan, num, vel;

if(white.includes(num%12), 
 {m.noteOff(1, (60 - num) + 60, vel);},
 {m.noteOff(1, num, vel)});
};
)

/*
Analysis 

21.12. MIDI input interpolation with if() filter
*/

(
// Run this to start reading input

var previousPitch = 62, thisInterval;
~intervals = Array.fill(12, {0});

MIDIIn.noteOn = {arg src, chan, num;
// Counts inversions as the same
thisInterval = (12 - (previousPitch - num))%12;
// Counts intervals up or down as the same
// thisInterval = abs(previousPitch - num);

// uncomment to monitor values
// [previousPitch, num, thisInterval].postln;

~intervals.put(thisInterval, ~intervals.at(thisInterval) + 1);
previousPitch = num;

// uncomment to watch in real time
// ~intervals.postln;

};
)

// When done, run this line

~intervals;

/*
Practice

21.13. Example

Example

21. Exercises
*/
splithere
/*

22 - Collections, Arrays, Index Referencing, Array Messages

22.1. array math
*/

(
a = [1, 2, 3, 4]; //declare an array
b = (a + 12)*10; //add 12 to every item in the array, then multiply them
 //all by 10 and store the resulting array in b
b.postln;
)

/*

22.2. array.do and math
*/

(
a = [60, 45, 68, 33, 90, 25, 10];
5.do(
 {
 a = a + 3;
 a.postln;
 }
)
)

22.3. array + each item

(
a = [60, 45, 68, 33, 90, 25, 10];
5.do(
 {arg item;
 a = a + item;
 a.postln;
 }
)
)

/*

22.4. two arrays
*/

(
a = [60, 45, 68, 33, 90, 25, 10];
b = [2, 14, 19, 42, 3, 6, 31, 9];
b.do(
 {arg item;
 item.post; " plus ".post; a.post; " = ".post;
 a = a + item;
 a.postln;
 }
)
)

/*

22.5. testing an array
*/

(
a = [60, 45, 68, 33, 90, 25, 10];
b = [25, 14, 19, 42, 33, 6, 31, 9];

100.do(
 {arg item;
 if(a.includes(item), {item.post; " is in a ".postln});
 if(b.includes(item), {item.post; " is in b ".postln});
 }
)
)

/*

22.6. referencing an item in an array
*/

[12, 4, 871, 9, 23].at(3) //index 3 is "9"

[12, 4, 871, 9, 23].at(124) //wild pointer, will return nil

[12, 4, 871, 9, 23].wrapAt(124) //will wrap around and return 23


/*
Array messages

22.7. arrays messages
*/

a = [1, 2, 3, 4]; //assigns the array to the variable "a"

a.post; //prints the array 

a + 5; //adds five to each item in the array

a*3; //multiplies it, etc. 

a.do({arg item; function}) //iterates over each item passing each item
 //to the function

a.at(index) //refers to item at index number

// Here are some new ones. Run each of them to see what they do:

[1, 2, 3, 4].reverse.postln; //reverses the array

[1, 2, 3, 4].rand.postln;

[1, 2, 3, 4].scramble.postln; //scrambles the array

[1, 2, 3, 4].size.postln;// returns the size (number of items)

Array.fill(size, function); //fills an array with "size" _//number of arguments using 
function

a = Array.fill(5, {10.rand}); a.postln;

a = Array.rand(12, 0, 12)

[1, 2, 3, 4].add(34).postln; //adds an item to the array

//Note about add. You have to pass it to another array variable to _//make sure the 
item is added. So the code would have to be:

a = [1, 2, 3]; _b = a.add(10); _a = b;

[1, 2, 3, 4].choose; //chooses one of the values

[1, 2, 3, 4].put(2, 34).postln; //puts second argument at _//index of first argument

[1, 2, 3, 4].wrapAt(index) //returns item at index with a wrap

//example:

30.do({arg item; [1, 2, 3, 4].wrapAt(item).postln});

/*

22.8. array of legal pitches
*/

20.do({12.rand.postln;}) // random numbers 0 through 11

// random numbers chosen, but array reference returns only pitches
// from a major scale

20.do({[0, 2, 4, 5, 7, 9, 11].at(6.rand).postln}) 

// Be sure the rand range is not too large

20.do({[0, 2, 4, 5, 7, 9, 11].at(12.rand).postln}) 

// To protect against this, use array.size or wrapAt

a = [0, 2, 4, 5, 7, 9, 11];
20.do({a.at((a.size).rand).postln})

/*


22.9. Array index shorthand
*/

[45, 37, 99, 367, 9] @ 3 // "at" index 3

[45, 37, 99, 367, 9] @@ 25 // "wrapAt" index 25

[45, 37, 99, 367, 9] @|@ 25 // fold at index 25

[45, 37, 99, 367, 9] |@| 25 // clip at index 25

30.do({[0, 2, 4, 5, 7, 9, 11] @ (12.rand).postln}) 

30.do({ |i| ([0, 2, 4, 5, 7, 9, 11] @@ i).postln}) 

30.do({ |i| ([0, 2, 4, 5, 7, 9, 11] @|@ i).postln}) 

30.do({ |i| ([0, 2, 4, 5, 7, 9, 11] |@| i).postln}) 

/*

Practice, Bach Mutation

22.10. array of legal pitches
*/

// (engage midi)
(
var pitch;

r = Task({
// Try other versions
pitch = [12, 0, 2, 4, 2, 0, 7, 4, 12, 7, 4, 7, 5, 4, 5, 7, 0, 4, 7, 11] + 60;
inf.do({arg h, i;
 pitch.size.do({arg j;
 var n;
 //every one, then every other one, then every third, etc.
 n = pitch.wrapAt(j*(i+1));
 if((j%20 == 19), {n.postln}, {n.post; " ".post});
 m.noteOn(1, n, 100);
 thisThread.clock.sched(0.1, {m.noteOff(1, n, 100); nil});
 0.1.wait;
 });
});
})
)

r.start;
r.stop; 127.do({arg i; m.noteOff(1, i)});

/*
22. Exercises
*/
splithere
/*
23 - Strings, String Collections

23.1. String as array
*/

"CharacterArray".at(0) // change the index to numbers between 0 and 13

"CharacterArray".at(0).ascii

"This is a string that is actually an array".do(
 {arg each, count;
 [count, each.ascii, each].postln;
 })
/*

23.2. "C" + 5?
*/

("C#" + 5)

(
a = ["C#", "D", "Eb", "F", "G"];
a = a + 5;
a.postln;
)

/*

23.3. pitch array index
*/

(
a = ["C", "D", "E", "F", "G"];
a.at(3).postln; //post item at index position 3 in the array a
)

(
a = ["C", "D", "E", "F", "G"];
a.at(5.rand).postln;
)

(
a = ["C", "D", "E", "F", "G", "A", "B"]; //pitch class array
"count\trandom\tpitch at index:".postln; //header
10.do( //do 10 items
 {arg item, count; //use arguments item and count
 var pick; 
 pick = a.size.rand;
 count.post; "\t\t".post; //print the number of this iteration
 pick.post; "\t\t".post; //print the number I picked
 a.at(pick).postln; //print the item at that array position
 })
)

/*

23.4. concatenated string
*/

(
a = ["C", "D", "E", "F", "G", "A", "B"];
10.do(
 {arg item, count; var b;
 b = a.size.rand;
 ("Item " ++ count ++ " : " ++ b ++ " = " ++ a.at(b)).postln;
 // or
 // postf("Item % : % = %\n", count, b, a.at(b))
 })
)

// More concise 

do(10, { ["C", "D", "E", "F", "G", "A", "B"].wrapAt(100.rand).postln;})

/*

23.5. Every 12-tone row with pitch class strings
*/

(
//Initiate MIDI, run this first
var original, total, begin, next, art, pcstrings, count;
original = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
pcstrings = ["C ", "C# ", "D ", "Eb ", 
 "E ", "F ", "F# ", "G ", "Ab ", "A ", "Bb ", "B "];
total = 479001600;
count = 0;
begin = total.rand;
next = 0.125;
art = 0.6;
("Total playback time = " ++ (total*next/3600).asString ++ " hours.").postln;
r = Task({
 inf.do({
 var thisVar;
 thisVar = original.permute(begin + count);
 thisVar.do({arg e; pcstrings.at(e).post});
 "".postln;
 (thisVar + 60).do({arg note;
 m.noteOn(1, note, 100);
 thisThread.clock.sched(next*art, {m.noteOff(1, note, 100); nil});
 next.wait
 });
 count = count + 1;
 })
})
)

//then these
r.start;
r.stop; 127.do({arg i; m.noteOff(1, i, 0)})

/*
A Moment of Perspective.

23.6. Illiac suite?
*/

60.do({[8.rand, 8.rand, (rrand(36, 72)), 10.rand].postln;})

/*
Practice, Random Study

23.7. (Biased) random study
*/

(

a = Task({
 inf.do({arg i;
 var note, dur, next, amp, inst;
 note = rrand(24, 84);
 dur = rrand(0.1, 0.5);
 amp = rrand(30, 127);
 next = rrand(0.1, 0.5);
 m.noteOn(1, note, amp);
 thisThread.clock.sched(dur, {m.noteOff(1, note); nil});
 next.wait
 })
});

b = Task({
 inf.do({arg i;
 var note, dur, next, amp, inst;
 note = rrand(24, 84);
 dur = rrand(0.1, 0.5);
 amp = rrand(30, 127);
 next = rrand(0.1, 0.5);
 m.noteOn(2, note, amp);
 thisThread.clock.sched(dur, {m.noteOff(2, note); nil});
 next.wait
 })
});

c = Task({
 inf.do({arg i;
 var note, dur, next, amp, inst;
 note = rrand(24, 84);
 dur = rrand(0.1, 0.5);
 amp = rrand(30, 127);
 next = rrand(0.1, 0.5);
 m.noteOn(3, note, amp);
 thisThread.clock.sched(dur, {m.noteOff(3, note); nil});
 next.wait
 })
});
)

a.start;
b.start;
c.start;
a.stop; 127.do({arg i; m.noteOff(1, i)})
b.stop; 127.do({arg i; m.noteOff(2, i)})
c.stop; 127.do({arg i; m.noteOff(3, i)})

/*
23. Exercises
*/
splithere
/*
24 - More Random Numbers
Biased Random Choices

24.1. loaded dice
*/

[60, 60, 65, 69, 54].choose

/*

24.2. high bias calculation
*/

n = 100; n.do({arg i; i = i + 1; ((i*2-1)/(n.squared)).postln})

/*

24.3. bias float
*/

max(6.0.rand.round(0.01), 6.0.rand.round(0.01));

/*

24.4. bias
*/

min(100.0.rand, 100.0.rand);

/*

24.5. bias
*/

max(200.0.rand, 100.rand);

/*

24.6. bias
*/

(100.rand + 100.rand)/2

/*

24.7. test bias
*/

[0, 1, 0.5, 0.178, 0.9, 0].plot; // plots an array

(
a = Array.fill(100, {0}); //fill an array with 0s
1000.do( //do 1000 iterations; more choices, smoother graph
 {
 b = 100.rand; //pick a random number between 0 and 999
 a.put(b, a.at(b) + 1); //increment that position
 //in the array
 }
);
a.plot; //plot the results.
)

/*

24.8. Test float bias
*/

(
a = Array.fill(100, {0}); //fill an array with 0s
1000.do( //do 1000 iterations
 {
 b = (100.rand + 100.rand)/2.div(1);
 a.put(b, a.at(b) + 1); 
 }
);
a.plot; //plot the results.
)

/*

24.9. rand tests
*/

(
a = Array.fill(100, {0}); 
1000.do({
b = 100.rand; // 0 and this, rand2 does negative values (-this to this)
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = 100.linrand; // linear distribution, bilinrand adds - values
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = rrand(30, 75); // random range
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = 100.exprand(1).div(1); 
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = max(100.rand, 100.rand) 
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = max(100.rand, 100.rand, 100.rand); 
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
//this.coin returns true this percent of the time
b = if(0.2.coin, {max(20.rand, 20.rand)}, {min(80.rand, 80.rand) + 20});
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

/*

24. Exercises
*/
splithere
/*

25 - Aesthetics of Computer Music
Why Computers?
Fast
Accurate 
Complex and Thorough: I Dig You Don't Work

25.1. I Dig You Don't Work
*/

var text;
text = ["I", "DON'T", "DIG", "YOU", "WORK"];
121.do({arg i; i.post; text.permute(i).postln;})

// Or


Task({
i = 0; t = ["i ", "don't ", "dig ", "you ", "work"];
{
u = ""; 
t.permute(i).do({|e| u = u ++ e}); 
u.speak; 
i = i + 1; 
3.0.wait
}.loop
}).play


/*
Obedient and Obtuse
Escaping Human Bias
"The key to real freedom and emancipation from local dependence [human bias] is 
through scientific method. . . . Originality is the product of knowledge, not 
guesswork. Scientific method in the arts provides an inconceivable number of ideas, 
technical ease, perfection and, ultimately, a feeling of real freedom, satisfaction and 
accomplishment." Joseph Schillinger from the Scientific Basis for the Arts
Integrity to the System
25. Exercises

*/
splithere
/*
26 - Pbind, Mutation, Pfunc, Prand, Pwrand, Pseries, Pseq, 
Serialization

Pbind

26.1. Read global library
*/
 
SynthDescLib.global.read

/*

26.2. Basic Pbind
*/

Pbind(\freq, 600).play

/*

26.3. Pbind with frequency function
*/

Pbind(\freq, Pfunc({rrand(100, 900)})).play;

Pbind(
 \freq, Pfunc({rrand(100, 900)}), 
 \dur, Pfunc({rrand(0.1, 1.5)})).play

Pbind(
 \degree, Pfunc({8.rand}), 
 \oct, Pfunc({rrand(3, 7)}), //or try \octave?
 \dur, 0.2).play

Pbind(
 \scale, [0, 2, 4, 6, 8, 10],
 \degree, Pfunc({6.rand}), 
 \oct, Pfunc({rrand(3, 7)}), //or try \octave
 \dur, 0.2).play

Pbind(
 \scale, [0, 2, 3, 5, 6, 8, 10, 11],
 \degree, Pfunc({8.rand}), 
 \oct, Pfunc({rrand(3, 7)}), //or try \octave
 \dur, 0.2).play

/*

26.4. Pbind with Previous Instrument Definitions
*/

Pbind(
 \instrument, "KSpluck3",
 \midiPitch, Pfunc({rrand(34, 72)}), 
 \art, Pfunc({rrand(1.0, 2.0)}),
 \dur, 0.1
).play

/*
dur, legato, nextEvent

26.5. Pbind with previous fx
*/

Synth("delay1");

Pbind(
 \instrument, "bells",
 \freq, Pseq([100, 400, 1000, 1500, 2000])
).play;

/*

26.6. Simple serial instrument
*/

(
SynthDef("SimpleTone",
{arg midinote = 60, amp = 0.9, dur = 1, pan = 0, legato = 0.8;
 Out.ar(0, 
 Pan2.ar(
 SinOsc.ar(midinote.midicps, mul: amp)
 *
 EnvGen.kr(Env.perc(0, dur*legato), doneAction: 2),
 pan
 )
 )
}).load(s);

SynthDescLib.global.read
)

/*

26.7. Pitch Model for Mutation
*/

(
var degreeSeq, nextPitch, scale; 

scale = [0, 2, 3, 5, 7, 8, 11];

degreeSeq = [1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 
 3, 3, 5, 5, 1, 1, 4, 4, 7, 7, 2, 2] - 1;


nextPitch = Routine({
 inf.do({arg count; 
 scale.wrapAt(degreeSeq.wrapAt(count)).yield;
 })
});

Pbind(
 \instrument, "SimpleTone",
 \midinote, nextPitch + 60,
 \dur, 0.1
 ).play
)

/*

26.8. Experiment
*/

// increasing multiples
 var mul = 1;
 inf.do({arg count; 
 if(count%20 == 19, {mul = mul + 1});

// occasional random values

 inf.do({arg count; 
 if(count%6 == 5, {12.rand.yield},
 {(scale.wrapAt(degreeSeq.wrapAt(count*mul))).yield});

// occasionally dodge sequence

 if(count%6 == 5, {scale.choose.yield},
 {(scale.wrapAt(degreeSeq.wrapAt(count*mul))).yield});

// gradually change scale

 if(count%6 == 5, {scale.put(scale.size.rand, 12.rand)});
 (scale.wrapAt(degreeSeq.wrapAt(count))).yield;

/*

Prand, Pseries, Pseq

26.9. Patterns
*/

(
f = 100;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pfunc({
 f = ([3/2, 4/3].choose) * f;
 if(f > 1000, {f = f/8}); //.fold or .wrap didn't do what I wanted
 f.cpsmidi
 }),
 \dur, 0.2
 ).play
 
)

(
Pbind(
 \instrument, "SimpleTone",
 \midinote, Prand([60, 62, 64, 65, 67, 69, 70], inf),
 \dur, 0.1
 ).play
 
)

(
// The dur array is 1s and 2s, representing eighth notes. 

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2] * 0.2, inf)
 ).play
)

/*

26.10. Parallel Pbinds
*/

(
a = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2] * 0.1, inf),
 \pan, -1
 ).play;

b = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69, 0], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2] * 0.1, inf),
 \pan, 0
 ).play;

c = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69, 0, 0], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2] * 0.1, inf), 
 \pan, 1
 ).play;
)

a.mute;
b.mute;
a.unmute;
c.mute;
b.unmute;
c.unmute;

// Riley?

(

p = Array.fill(20, {[0, 2, 4, 7, 9].choose + [60, 72].choose}).postln;
q = p.copyRange(0, p.size - 2).postln;
Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([Pseq(p), Pseq(p), Pseq(p)], inf),
 \dur, 0.1,
 \pan, -1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([Pseq(p), Pseq(p), Pseq(q)], inf),
 \dur, 0.1,
 \pan, 1
 ).play;
)

// Or gradual phase
(

p = Array.fill(20, {[0, 2, 4, 7, 9].choose + [60, 72].choose}).postln;
Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.1,
 \pan, -1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.101,
 \pan, 1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.102,
 \pan, 0
 ).play;
)

/*

26.11. Serialism
*/

(

a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.1, 0.1, 1.0, 0.2, 0.3, 0.166, 0.166];
o = [48, 60, 72]; 

Pbind(
 \instrument, "SimpleTone",
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;
)

(

// And of course, three at once.

// If seed is any number other than 0 that seed will be used. 
// If 0, a random seed will be picked and posted. Use it to 
// repeat a performance. 

var seed = 0;

if(seed !=0, {thisThread.randSeed = seed},
 {thisThread.randSeed = Date.seed.postln});

a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.1, 0.1, 1.0, 0.2, 0.3, 0.166, 0.166];
o = [48, 60, 72]; 

Pbind(
 \instrument, "SimpleTone",
 \pan, -1,
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;

Pbind(
 \instrument, "SimpleTone",
 \pan, 0,
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;

Pbind(
 \instrument, "SimpleTone",
 \pan, 1,
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;

)

/*
Serialization Without Synthesis or Server using MIDIout
Practice: Total Serialization using MIDI only

26.12. Babbitt: Total Serialization (sort of)
*/

(
MIDIClient.init;
m = MIDIOut(0, MIDIClient.destinations.at(0).uid);
)

(
var pitchSeries, octaveSeries, durationSeries, nextSeries, dynSeries, instSeries;
pitchSeries = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
octaveSeries = Array.fill(6, {[36, 48, 60, 72].choose}).postln;
durationSeries = Array.fill(23, {rrand(0.1, 3.0).round(0.1)}).postln;
nextSeries = Array.fill(30, {[0, 0, 0.1, 0.1, 0.1, 0.2, 0.2, 0.2, 0.4, 0.4, 
2.0].choose}).postln;
dynSeries = Array.fill(24, {rrand(40, 120).round(0.1)}).postln;
instSeries = Array.fill(20, {4.rand}).postln;

r = Task({
 inf.do({arg count;
 var note; 
 note = pitchSeries.wrapAt(count) + octaveSeries.wrapAt(count);
 if(count%12 == 0, {
 pitchSeries = // choose a new version of the row
 [pitchSeries.reverse, // retrograde
 (12 - pitchSeries).reverse, // retrograde inversion
 12 - pitchSeries, // inversion
 pitchSeries // prime
 ].choose;
 // choose a transposition of the row
 pitchSeries = (pitchSeries + 12.rand)%12;
 pitchSeries.postln;});
 if(0.1.coin, {
 durationSeries = durationSeries.scramble.postln;
 nextSeries = nextSeries.scramble.postln;
 dynSeries = dynSeries.scramble.postln;
 instSeries = instSeries.scramble.postln;
 });
 m.noteOn(instSeries.wrapAt(count), note, dynSeries.wrapAt(count));
 thisThread.clock.sched(durationSeries.wrapAt(count), 
 {m.noteOff(instSeries.wrapAt(count), note); nil});
 nextSeries.wrapAt(count).wait
 })
});

r.start;
)

r.stop; 4.do({arg j; 127.do({arg i; m.noteOff(j, i, 0)})})

/*
MIDI Using Pbind

26.13. Pbind and MIDI, by Julian Rohrhuber
*/

(
var f;
f = (
 noteOn: #{ arg chan, midinote, amp;
 [chan, midinote, asInteger((amp * 255).clip(0, 255))]
 },
 noteOff:#{ arg chan, midinote, amp;
 [ chan, midinote, asInteger((amp * 255).clip(0, 255))]
 },
 polyTouch: #{ arg chan, midinote, polyTouch=125;
 [ chan, midinote, polyTouch]
 },
 control: #{ arg chan, ctlNum, control=125;
 [chan, ctlNum, control]
 },
 program: #{ arg chan, progNum=1;
 [ chan, progNum]
 }
 /*
 touch ( chan, val )
 bend ( chan, val )
 allNotesOff ( chan )
 smpte ( frames, seconds, minutes, hours, frameRate )
 songPtr ( songPtr )
 songSelect ( song )
 midiClock ( )
 startClock ( )
 continueClock ( )
 stopClock ( )
 reset ( )
 sysex ( uid, Int8Array )
 
 */ 
 
 );

~midiEnv = ( 
 chan: 1,
 msgFuncs: f,
 hasGate: true,
 midicmd: \noteOn,
 play: #{
 var freqs, lag, dur, sustain, strum;
 var tempo, bndl, midiout, hasHate, midicmd;
 
 freqs = ~freq = ~freq.value + ~detune;
 
 tempo = ~tempo;
 if (tempo.notNil) {
 thisThread.clock.tempo = tempo;
 };
 
 if (freqs.isKindOf(Symbol).not) {
 ~finish.value;
 ~amp = ~amp.value;
 strum = ~strum;
 lag = ~lag;
 sustain = ~sustain = ~sustain.value;
 midiout = ~midiout;
 hasHate = ~hasGate;
 midicmd = ~midicmd;
 bndl = ~msgFuncs[midicmd].valueEnvir;
 
 bndl = bndl.flop;
 
 bndl.do {|msgArgs, i|
 var latency;
 
 latency = i * strum + lag;
 
 
 midiout.performList(midicmd, msgArgs);
 if(hasHate and: { midicmd === \noteOn }) {
 thisThread.clock.sched(sustain) { 
 midiout.noteOff(*msgArgs)
 };
 };
 };
 }
 }
 
 ).putAll(
 Event.partialEvents.pitchEvent, 
 Event.partialEvents.ampEvent, 
 Event.partialEvents.durEvent 
 )
);


// initialize midiout
(
MIDIClient.init;
m = MIDIOut(0, MIDIClient.destinations.at(0).uid);
)


// I've modified the Pbind to show more values [they aren't very good]

(
Pbind(
 \parent, ~midiEnv,
 \midiout, m,
 \chan, Pseq([0, 1, 2, 3], 60), //total number of events
 \amp, Prand([
 Pseq([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]),
 Pseq([0.8, 0.7, 0.5, 0.3, 0.1]),
 Prand([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], 10)
 ], inf),
 \dur, Prand([0.1, 0.1, 0.1, 0.2, 0.2,1.0, 2.0], inf),
 \sustain, Pfunc({rrand(0.1, 2.0)}),
 \midinote, Prand([36, 38, 40, 42, 43, 45, 47, 49, //synthetic scale
 50, 52, 54, 56, 57, 59, 61, 63, 64, 66, 68, 70], inf)
).play;
)

/*

26. Exercises
*/
splithere
/*
27 - Total Serialization Continued, Special Considerations 
Absolute vs. Proportional Values, Rhythmic Inversion 
Pitch

27.1. Proportional MIDI inversion
*/

// If used as MIDI intervals this is unison, 4th up, M3rd up,
// 5th up, M2 down, M6th down, 2nd up, ttone down
 
o = [0, 5, 4, 7, -2, -9, 2, -6];

o.neg;
// Results in unison, 4th down, M3rd down, etc.
[ 0, -5, -4, -7, 2, 9, -2, 6 ]

/*
Duration and next event
Next Event
Non-Sequential Events
Amplitude
Rhythmic Inversion

Ex. 21.1
*/

var rhythmArray, orLength, inversion;

rhythmArray = [1, 1.5, 2, 1.25, 0.25, 0.25, 1.5, 0.333];
orLength = rhythmArray.sum;
inversion = rhythmArray.reciprocal.normalizeSum*orLength;
inversion.postln;
rhythmArray.sum.postln;
inversion.sum.postln;

/*
27. Exercises
*/
splithere
/*
28 - Music Driven by Extra-Musical Criteria, Data Files
Extra Musical Criteria
Text Conversion

28.1. ascii values
*/

a = "Test string";
a.at(2).ascii.postln;
a.at(2).digit.postln;_a.do({arg each; each.post; " ".post; each.ascii.postln;})

/*
Mapping

28.2. pitchMap
*/

pitchMap = IdentityDictionary[
 $H -> 6, $x -> 6, $b -> 6, $T -> 6, $W -> 6,
 $e -> 11, $o -> 11, $c -> 11, $, -> 11, $. -> 11,
 $n -> 3, $y -> 3, 
 $m -> 4, $p -> 8, $l -> 9
 ]; 

/*

28.3. mapping array
*/

var mappedValue, intervMap;

intervMap = [ 
 ["ae", 2], ["io", 4], [" pst", 5], ["Hrn", -2],
 ["xmp", -1], ["lfg", -4], ["Th", -5], [".bdvu", 1]
];

intervMap.do({arg item; 
 if(item.at(0).includes($o),
 {mappedValue = item.at(1)})
 });

/*

28.4. Extra-Musical Criteria, Pitch Only
*/

(
var noteFunc, blipInst, midiInst, channel = 0, port = 0, prog = 0,
 intervMap, count = 0, ifNilInt = 0, midin = 0, inputString; 

//The input stream. 

inputString = "Here is an example of mapping. The, them, there, these,"
 "there, then, that, should have similar musical interpretations."
 "Exact repetition; thatthatthatthatthatthat will also"
 "be similar.";

//intervMap is filled with arrays containing a collection of 
//characters and a value. In the functions below the character
//strings are associated with the numbers.

intervMap = [ 
 ["ae", 2], ["io", 4], [" pst", 5], ["Hrn", 7],
 ["xmp", 1], ["lfg", 3], ["Th", 6], [".bdvu", 11]
];


"// [Char, Interval, ifNilInt, midi interval, octave, midi]".postln;

noteFunc = Pfunc({var parseInt, octave;

 //Each array in the intervMap is checked to see if the
 //character (inputString.wrapAt(count)) is included. If
 //it is then parseInt is set to the value at item.at(1)
 
 intervMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseInt = item.at(1)})
 });

 //If parseInt is notNil, midin is set to that. 
 //ifNilInt is for storing each parseInt to be used if
 //no match is found and parseInt is nil the next time around.

 if(parseInt.notNil,
 {midin = parseInt; ifNilInt = parseInt},
 {midin = ifNilInt}
 );

 octave = 60;

 "//".post; [inputString.wrapAt(count), parseInt, 
 ifNilInt, midin, octave/12, midin + octave].postln;

 count = count + 1; 
 
 midin + octave
});

Pbind(
 \midinote, noteFunc,
 \dur, 0.125,
 \amp, 0.8,
 \instrument, "SimpleTone"
).play;

)

/*

28.5. Extra-Musical Criteria, Total Control
*/

(
var noteFunc, blipInst, midiInst, channel = 0, port = 0, prog = 0,
 intervMap, count = 0, ifNilInt = 0, midin = 0, ifNilDur = 1,
 durMap, durFunc, ifNilSus = 1, susMap, susFunc, ifNilAmp = 0.5, 
 curAmp = 0.5, ampMap, ampFunc, inputString; 

//The input stream. 

inputString = "Here is an example of mapping. The, them, there, these,"
 "there, then, that, should have similar musical interpretations."
 "Exact repetition; thatthatthatthatthatthat will also"
 "be similar.";

//intervMap is filled with arrays containing a collection of 
//characters and a value. In the functions below the character
//strings are associated with the numbers.

intervMap = [ 
 ["ae", 6], ["io", 9], [" pst", 1], ["Hrn", -3],
 ["xmp", -1], ["lfg", -4], ["Th", -5], [".bdvu", 1]
];

durMap = [ 
 ["aeiouHhrsnx", 0.125], ["mplf", 0.5], ["g.T,t", 0.25],
 ["dvc", 2], [" ", 0]
];

susMap = [ 
 ["aei ", 1.0], ["ouHh", 2.0], ["rsnx", 0.5], ["mplf", 2.0], ["g.T,t", 4.0],
 ["dvc", 1.0]
];

ampMap = [ 
 ["aeHhrsnx ", 0.8], ["ioumplfg.T,tdvc", 1.25]
];

noteFunc = Pfunc({var parseInt, octave = 48;

 //Each array in the intervMap is checked to see if the
 //character (inputString.wrapAt(count)) is included. If
 //it is then parseInt is set to the value at item.at(1)
 
 intervMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseInt = item.at(1)})
 });

 //If parseInt is notNil, midin is set to that plus previous
 //midin. ifNilInt is for storing each parseInt to be used if
 //no match is found and parseInt is nil.

 if(parseInt.notNil,
 {midin = parseInt + midin%48; ifNilInt = parseInt},
 {midin = ifNilInt + midin%48}
 );

 [inputString.wrapAt(count)].post; 
 ["pitch", parseInt, midin, octave/12, midin + octave].post;
 
 midin + octave
});

durFunc = Pfunc({var parseDur, nextDur;

 durMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseDur = item.at(1)})
 });

 if(parseDur.notNil,
 {nextDur = parseDur; ifNilDur = parseDur},
 {nextDur = ifNilDur}
 );
 ["dur", nextDur].post;
 nextDur
});

susFunc = Pfunc({var parseSus, nextSus;

 susMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseSus = item.at(1)})
 });

 if(parseSus.notNil,
 {nextSus = parseSus; ifNilSus = parseSus},
 {nextSus = ifNilSus}
 );
 ["sustain", nextSus.round(0.01)].post;
 nextSus
});

ampFunc = Pfunc({var parseAmp;

 ampMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseAmp = item.at(1)})
 });

 if(parseAmp.notNil,
 {curAmp = curAmp*parseAmp; ifNilAmp = parseAmp},
 {curAmp = curAmp*ifNilAmp}
 );
 
 count = count + 1;
 if(0.5.coin, {curAmp = rrand(0.2, 0.9)});
 ["amp", curAmp.round(0.01)].postln;

 curAmp.wrap(0.4, 0.9)
});


Pbind(
 \midinote, noteFunc,
 \dur, durFunc,
 \legato, susFunc,
 \amp, ampFunc,
 \instrument, "SimpleTone"
).play;
)

/*
Working With Files

28.6. reading a file
*/

(
var input, filePointer; //declare variables
filePointer = File("Test File", "r"); 
input = filePointer.readAllString;
filePointer.close;
input.postln;
)

/*

28.7. reading a file
*/

// Print any pathname for later use

File.openDialog("", { arg pathName; pathName.postln});

// Open using a dialog
(
var input, filePointer; //declare variables
File.openDialog("", {arg pathname;
 filePointer = File(pathname, "r"); 
 input = filePointer.readAllString;
 input.postln;
 // Everything has to be inside this function
},
{"File not found".postln});

)

// Or open file and store in global

(
var filePointer; //declare variables
File.openDialog("", {arg pathname;
 filePointer = File(pathname, "r"); 
 ~input = filePointer.readAllString;
},
{"File not found".postln});
)

// Then

~input.postln;

// Or include ~input in the patch.

/*

28. Exercises
*/
splithere
/*
29 - Markov Chains, Numerical Data Files


29.1. transTable
*/

//A collection of the pitches used

legalPitches = [60, 62, 64, 65, 67, 69];

//An array of arrays, representing every possible previous pair.

transTable = [
 [0, 0], //C, C
 [0, 1], //C, D
 [0, 2], //C, E
 [0, 4], //C, G
 [1, 2], //D, E
 [2, 0], //E, C
 [2, 3], //E, F
 [3, 2], //F, E
 [3, 4], //F, G
 [4, 0], //G, C
 [4, 2], //G, E
 [4, 3], //G, F
 [4, 4], //G, G
 [4, 5], //G, A
 [5, 4] //A, G 
]; 

/*

29.2. Parsing the transTable
*/

transTable.do({arg index, i; if(index == currentPair, 
 {nextIndex = i; true;}, {false})});

/*

29.3. Probability chart
*/

nPitchProb = 
[
 //C D E F G A
 [0.00, 0.33, 0.00, 0.00, 0.66, 0.00], //C, C
 [0.00, 0.00, 1.00, 0.00, 0.00, 0.00], //C, D
 [0.00, 0.00, 0.00, 1.00, 0.00, 0.00], //C, E
 [0.66, 0.00, 0.00, 0.00, 0.00, 0.33], //C, G
 [1.00, 0.00, 0.00, 0.00, 0.00, 0.00], //D, E
 [0.50, 0.00, 0.25, 0.00, 0.25, 0.00], //E, C
 [0.00, 0.00, 0.00, 0.00, 1.00, 0.00], //E, F
 [1.00, 0.00, 0.00, 0.00, 0.00, 0.00], //F, E
 [0.00, 0.00, 0.50, 0.00, 0.50, 0.00], //F, G
 [1.00, 0.00, 0.00, 0.00, 0.00, 0.00], //G, C
 [0.00, 0.00, 0.00, 1.00, 0.00, 0.00], //G, E
 [0.00, 0.00, 1.00, 0.00, 0.00, 0.00], //G, F
 [0.00, 0.00, 0.00, 0.00, 0.00, 1.00], //G, G
 [0.00, 0.00, 0.00, 0.00, 1.00, 0.00], //G, A
 [0.00, 0.00, 0.00, 1.00, 0.00, 0.00] //A, G
 
];

/*
currentPair.put(0, currentPair.at(1));_currentPair.put(1, nextPitch);

29.4. Foster Markov
*/

(
 
var wchoose, legalPitches, previousIndex, prevPitch, 
currentPitch, nextIndex, nextPitch, nPitchProb, 
pchoose, blipInst, envelope, pClass, count, resopluck; 

prevPitch = 3;
currentPitch = 1;
count = 1;
pClass = #["A3", "B3", "C4", "D4", "E4", "F4", "F#4", 
 "G4", "A4", "B4", "C5", "D5"];

//pchoose is the mechanism for picking the next value. 

pchoose = 
{
legalPitches = [57, 59, 60, 62, 64, 65, 66, 67, 69, 71, 72, 74];

//Both prevPitch and nextPitch are not pitches, but array positions.

previousIndex = [
 [2], //previous is 0 or A3
 [2], //1 or B3
 [0, 1, 2, 3, 4, 5, 7, 9, 10], //2: C4
 [1, 2, 3, 4, 7, 10], //3: D4
 [2, 3, 4, 5, 7, 8], //4: E4
 [4, 5, 7, 8], //5: F4
 [7], //6: F#4
 [2, 4, 5, 6, 7, 8, 10], //7: G4
 [2, 4, 5, 6, 7, 8, 10], //8: A4
 [8, 10], //9: B5
 [7, 8, 9, 10, 11], //10: C5
 [7, 9] //11: D5
];

previousIndex.at(prevPitch).do({arg index, i; if(index == currentPitch, 
 {nextIndex = i; true;}, {false})});

nPitchProb = 
[
// [00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11] array position
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for A3
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00] // one array: C4
],
[ //arrays for B3
 [00, 00, 05, 06, 00, 00, 00, 05, 00, 00, 00, 00] // C4 only
],
[ //arrays for C4
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // A3
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // B3
// [00, 02, 02, 09, 02, 10, 00, 00, 00, 00, 00, 00], original C4
 [00, 06, 02, 09, 02, 06, 00, 00, 00, 00, 00, 00], // C4
 [00, 00, 03, 04, 08, 00, 00, 01, 00, 00, 00, 00], // D4
 [00, 00, 00, 07, 03, 02, 00, 04, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 11, 00, 00, 00, 05, 00, 00, 00], // F4
 [00, 00, 00, 00, 04, 00, 00, 12, 00, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 16, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 02, 11, 03, 00, 00] // C5
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for D4
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // B4
// [01, 00, 01, 04, 05, 00, 00, 01, 00, 01, 03, 00], original C4
 [05, 00, 01, 04, 01, 00, 00, 01, 00, 01, 03, 00], // C4
// [00, 01, 12, 01, 02, 00, 00, 00, 00, 00, 00, 00], original D4
 [00, 06, 07, 01, 02, 00, 00, 00, 00, 00, 00, 00], // D4
 [00, 00, 01, 03, 06, 04, 00, 01, 01, 00, 00, 00], // E4
 [00, 00, 00, 00, 00, 00, 05, 08, 03, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00] // C5
],
[ //arrays for E4
 [00, 00, 00, 12, 03, 01, 00, 00, 00, 00, 00, 00], // C4
// [00, 02, 07, 03, 02, 00, 00, 01, 00, 01, 00, 00], original D4
 [00, 05, 04, 03, 02, 00, 00, 01, 00, 01, 00, 00], // D4
 [00, 00, 03, 04, 06, 02, 00, 01, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 04, 03, 00, 06, 03, 00, 00, 00], // F4
 [00, 00, 00, 00, 02, 00, 00, 10, 03, 00, 01, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00] // A4,
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for F4
 [00, 00, 00, 08, 00, 08, 00, 00, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 00, 08, 00, 08, 00, 00, 00, 00], // F4
 [00, 00, 02, 00, 00, 00, 00, 10, 00, 00, 04, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00] // A4, 
],
[ //arrays for F#4
 [00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00] // G4,
],
[ //arrays for G4
 [00, 00, 00, 11, 05, 00, 00, 00, 00, 00, 00, 00], // C4
 [00, 00, 05, 04, 03, 01, 00, 02, 01, 00, 00, 00], // E4
 [00, 00, 00, 00, 16, 00, 00, 00, 00, 00, 00, 00], // F4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // F#4
 [00, 00, 00, 00, 04, 01, 04, 04, 03, 00, 00, 00], // G4
 [00, 00, 01, 00, 01, 00, 05, 07, 01, 00, 01, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 06, 05, 03, 02, 00] // C5
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for A4
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // C4
 [00, 00, 00, 11, 05, 00, 00, 00, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00], // F4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // F#4
 [00, 00, 01, 00, 09, 01, 00, 02, 01, 00, 02, 00], // G4
 [00, 00, 00, 00, 02, 00, 00, 12, 00, 00, 02, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 09, 02, 05, 00, 00] // C5
],
[ //arrays for B5
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 00, 06, 00, 00, 10] // C5
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for C5
 [00, 00, 00, 00, 14, 00, 00, 02, 00, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 01, 00, 05, 06, 00, 04, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 00, 12, 00, 04, 00], // B4
 [00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00], // C5
 [00, 00, 00, 00, 00, 00, 00, 05, 00, 11, 00, 00] //D5
],
[ //arrays for D5
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 16, 00] // B4
]
];

nextPitch = (nPitchProb.at(prevPitch).at(nextIndex).normalizeSum).windex;

//current is set to previous, next is current for next run. The actual pitch 
//is returned from legal pitch at nextPitch.

[pClass.at(nextPitch), legalPitches.at(nextPitch)].post; 
// if((count%10) == 0, {"".postln};);
count = count + 1;
prevPitch = currentPitch;
currentPitch = nextPitch;
legalPitches.at(nextPitch)
};

Pbind(

 \dur, 0.125,
 \dur, Prand([
 Pseq(#[1]),
 Pseq(#[0.5, 0.5]),
 Pseq(#[0.5, 0.5]),
 Pseq(#[0.25, 0.25, 0.25, 0.25]),
 Pseq(#[0.5, 0.25, 0.25]),
 Pseq(#[0.25, 0.25, 0.5]),
 Pseq(#[0.25, 0.5, 0.25])
 ], inf),
 \midinote, Pfunc(pchoose),
 \db, -10,
// \instrument, "SimpleTone",
 \pan, 0.5
).play

)


/*
Data Files, Data Types

29.5. test ascii
*/

var fp;
fp = File("Testascii.rtf", "r"); //open a text file
fp.length.do({a = fp.getInt8; [a, a.ascii.postln}); //read file as integers

/*

29.6. data files
*/

var fp, data;
fp = File("TestInt", "w"); //open a file
data = [65, 66, 67, 68, 69, 70, 71];
data.do({arg eachInt; fp.putInt16(eachInt)}); //place each int in file
fp.close;

var fp, data;
fp = File("TestInt", "r"); //open a file
data = fp.readAllInt16; //read all as Int array
data.postln;
fp.close;

var fp, data;
fp = File("TestFloat", "w"); //open a file
data = [6.5, 6.6, 6.7, 6.8, 6.9, 7.0, 7.1];
data.do({arg eachFloat; fp.putFloat(eachFloat)}); 
fp.close;

var fp, data;
fp = File("TestFloat", "r"); //open a file
data = fp.readAllFloat; //read all as array
data.postln;
fp.close;

/*
Interpreting Strings

29.7. interpreting a string
*/

var fp, array;
fp = File("arrayfile", "r");
array = fp.readAllString; //read the file into a string 
array.postln; //print to confirm it is a string
array = array.interpret; //interpret it and store it again
array.at(0).postln; //confirm it is code not a string
array.at(1).sum.postln;
array.at(2).at(0).postln;
array.at(3).postln;

/*
29. Exercises
*/
splithere
/*
30 - Concrète, Audio Files, Live Audio DSP
Music Concrète
Buffers

30.1. Loading Audio into and Playing From a Buffer
*/
b = Buffer.read(s, "sounds/africa2");

c = Buffer.read(s, "sounds/africa1", numFrames: 44100); // one second

// check data: 
[b.bufnum, b.numChannels, b.path, b.numFrames].postln;

[c.bufnum, c.numChannels, c.path, c.numFrames].postln;

{PlayBuf.ar(1, 0)}.play(s); // Your buffer number may differ

{PlayBuf.ar(1, 1)}.play(s);
/*

30.2. Loading Audio into a Buffer from Live Audio Source
*/
d = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer

{RecordBuf.ar(In.ar(2), d.bufnum, loop: 0)}.play;
d
{PlayBuf.ar(1, d.bufnum)}.play(s);
/*

30.3. Playback with Mouse
*/
b.free; b = Buffer.read(s,"sounds/africa2", 0, 4*44100);

{BufRd.ar(1, b.bufnum, K2A.ar(MouseX.kr(0, 4*44100)))}.play
/*

30.4. LinLin, LFSaw for Sweeping Through Audio File
*/

// Same thing:

{SinOsc.ar(LinLin.kr(SinOsc.kr(5), -1, 1, 700, 1000))}.play

{SinOsc.ar(SinOsc.kr(5, mul: 150, add: 850))}.play

// Will sweep through 66150 110250, or 1.5" to 2.5" of audio file

LinLin.ar(LFSaw.ar(1), -1, 1, 1.5, 2.5)*44100

/*


30.5. Looping a Section of a File
*/

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1;
// Use these lines for proportional lengths
// var bufNum = 0, srate = 44100, start = 0.21, end = 0.74, 
// rate = 1, duration, total;
// total = BufFrames.kr(bufNum)/44100;
// end = end*total; start = start*total;
duration = abs(end - start); 
BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 
}.play
)
/*


30.6. Looper 
*/

(
{
var bufNum = 0, srate = 44100, start = 0.21, end = 0.74, 
 rate = 1, totalDur = 20, pan = 0;
var out, duration, total;
start = [0.3, 0.2]; end = [0.2, 0.3]; 
total = BufFrames.kr(bufNum)/44100;
end = end*total; start = start*total;
duration = abs(end - start); 
BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration));
}.play
)

/*
 forward and backward loops of the same material as shown above (start = [0.2, 0.3]; end = 
[0.3, 0.2];)

30.7. Modulating Audio Buffers
*/

// FM Modulation

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
duration = abs(end - start); 
// or
// end = [2.3, 3.5];
signal = BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 

SinOsc.ar(LFNoise1.kr([0.4, 0.43], mul: 200, add: 200))*signal;
// or
// SinOsc.ar(LFNoise0.kr([12, 15], mul: 300, add: 600))*signal;
// or 
// SinOsc.ar(LFNoise1.kr([0.4, 0.43], mul: 500, add: 1000))*signal; 

}.play(s)
)


// Pulsing in and out

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1;
var pulse;
pulse = [6, 10];
duration = abs(end - start); 
BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.3, 0.01), timeScale: duration/pulse,
 gate: Impulse.kr(pulse/duration)); 
}.play(s)
)

// Filtered

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
duration = abs(end - start); 
signal = BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 
RLPF.ar(signal, LFNoise1.kr([12, 5], mul: 700, add: 1000), rq: 0.05)*0.2;
}.play(s)
)

// Modulating one with another, dry in left, dry in right, modulated center
// Listen for a while for full effect

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
end = [2.5, 2.9];
duration = abs(end - start); 
signal = BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 
(signal*0.1) + (signal.at(0) * signal.at(1)) 
}.play(s)
)
/*
*/
splithere
/*

31 - Graphic User Interface Starter Kit
Display

31.1. Display window
*/
(
Display.make({arg thisWindow, a, b, c;
 thisWindow.name_("Example");
}).show;
)
/*

31.2. header 
*/
(
Display.make({arg thisWindow, a, b, c, d;
 a.sp(5, 0, 10, 1); //start, low, high, increment, warp
 b.sp(400, 0, 4000, 0.1, 1);
 c.sp(0, -500, 500);
 d.sp(0.3, 0, 0.9);
 thisWindow.name_("Example");
}).show;
)
/*

31.3. Display with synthDef
*/
(
Display.make({arg thisWindow, sawFreq, sawOffset, sawScale, volume;
 sawFreq.sp(5, 0, 10, 1);
 sawOffset.sp(400, 10, 1000, 0.1, 1);
 sawScale.sp(0, -500, 500);
 volume.sp(0.3, 0, 0.9);
 thisWindow.name_("Example");
 thisWindow.synthDef_({arg sawFreq, sawOffset, sawScale, volume;
 Out.ar(0, 
 SinOsc.ar(
 abs(LFSaw.kr(sawFreq, mul: sawScale, add: sawOffset)), 
 mul: volume
 )
 )},
 [\sawFreq, sawFreq, \sawOffset, sawOffset, \sawScale, 
 sawScale, \volume, volume]
 );
}).show;
)
/*

31.4. Display shell
*/
(
Display.make({arg thisWindow, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
 // [Your variable defaults go here], e.g.
 a.sp(440, 100, 1000, 1, 1);
 thisWindow.synthDef_({arg a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
 Out.ar(0, 
 // [Your patch goes here with variables a, b, c, etc.], e.g.
 SinOsc.ar(a);
 )},
 [\a, a, \b, b, \c, c, \d, d, \e, e, \f, f, \g, g, \h, h, 
 \i, i, \j, j, \k, k, \l, l, \m, m, \n, n, \o, o, \p, p]
 );
 thisWindow.name_("Example");
}).show;
)
/*
Document
 
31.5. This Document
*/

d = Document.current;

d.title; // get the title
d.bounds; // get the bounds

d.title_("new title"); // set the title
d.bounds_(Rect(100, 100, 500, 500)); // set the bounds
d.background_(Color(0.5, 0.2, 0.7, 0.3)); // set color and visibility
d.background_(Color(0.9, 0.7, 0.7, 1)); // set color and visibility

/*

31.6. Flashing alpha
*/

~doc = Document.current;

Task({
100.do({
 ~doc.background_(Color(
 0.2, // red
 0.1, // green
 0.9, // blue 
 rrand(0.3, 0.9) // alpha, or transparancy
 ));
 0.1.wait;
})
}).play(AppClock)

// Each open document has an index number:

Document.allDocuments.at(1).front;

(
Document.new("Test one", "test text");
Document.new("Test two", "more text");
Document.new("Test three", "three");
Document.new("Four", "four");
 Task({
 Document.allDocuments.do({arg thisOne;
 // random
 thisOne.front;
 thisOne.background_(
 Color(rrand(0.1, 0.9), rrand(0.1, 0.9), rrand(0.1, 0.9)));
 0.4.wait;
 });

 }).play(AppClock)
)


/*

31.7. This Document to Front Action
*/

(
~doc.toFrontAction_({"bong".postln});
~doc.endFrontAction_({"bing".postln});
)

~doc.toFrontAction_({nil}); //turn action off
~doc.endFrontAction_({nil}); 

/*

31.8. This Document to front
*/

~randSineDoc = Document.current;
~randSineDoc.toFrontAction_({
 ~sine = {Mix.ar({SinOsc.ar(rrand(200, 900))}.dup(20))*0.01}.play
})

~randSineDoc.endFrontAction_({~sine.free})

/*

31.9. Mouse and Key Down
*/

(
~doc.keyDownAction_({arg thisDoc, key, mod, num;
 if(key == $j, /* or num == 106 */ {
 ~mySine = {SinOsc.ar(
 LFNoise0.kr(rrand(8, 15), mul: 500, add: 1000),
 mul: 0.2)*
 EnvGen.kr(Env.perc(0, 3))
 }.play;
 });
 if(key == $h, {
 ~randSine = {
 Mix.ar({SinOsc.ar(rrand(200, 900))}.dup(20))*0.01
 }.play
 });
 if(key == $k, {~randSine.free});
 if(num == 32, {s.freeAll}); // space bar
});
)

~doc.mouseDownAction_({s.freeAll});

/*
Keyboard Window

31.10. Keyboard Window From Examples (by JM?)

*/
(
var w; // window object
var courier; // font object

// an Array of Strings representing the key layout.
var keyboard = #["`1234567890-=", "QWERTYUIOP[]\\", 
 "ASDFGHJKL;'", "ZXCVBNM,./"];

// horizontal offsets for keys.
var offsets = #[42, 48, 57, 117];

var actions; // an IdentityDictionary mapping keys to action functions.
var makeKey; // function to create an SCDragSink for a key.

courier = Font("Courier-Bold", 14);

// an IdentityDictionary is used to map keys to functions so that
// we can look up the action for a key
actions = IdentityDictionary.new; // create actions dictionary

// define a function that will create an SCDragSink for a key.
makeKey = {|char, keyname, bounds|
 var v;

 keyname = keyname ? char.asString;
 bounds = bounds ? (24 @ 24);

 v = SCDragBoth(w, bounds);
 v.font = courier;
 v.string = keyname;
 v.align = \center;
 v.setBoth = false;
 v.acceptDrag = {
 SCView.currentDrag.isKindOf(Function)
 };
 v.action = { 
 ("added key action : " ++ keyname).postln;
 if (char.isAlpha) {
 actions[char.toUpper] = v.object;
 actions[char.toLower] = v.object;
 }{
 actions[char] = v.object;
 };
 w.front;
 };
};

w = SCWindow("keyboard", Rect(128, 320, 420, 150));

w.view.decorator = FlowLayout(w.view.bounds);

// define a function to handle key downs.
w.view.keyDownAction = {|view, char, modifiers, unicode, keycode|
 var result;
 
 // call the function
 result = actions[char].value(char, modifiers);
 
 // if the result is a function, that function becomes the 
 // new action for the key
 if (result.isKindOf(Function)) {
 actions[char] = result;
 };
};

// make the rows of the keyboard
keyboard.do {|row, i| 
 row.do {|key| makeKey.(key) };
 if (i==0) { makeKey.(127.asAscii, "del", 38 @ 24) };
 if (i==2) { makeKey.($\r, "retrn", 46 @ 24) };
 w.view.decorator.nextLine;
 w.view.decorator.shift(offsets[i]);
};

// make the last row
makeKey.($ , "space", 150 @ 24);
makeKey.(3.asAscii, "enter", 48 @ 24);

w.front;
)




////////////////////

// Drag these things to the keyboard to test it.

(
{
 var synth, original;
 original = thisFunction;
 synth = { SinOsc.ar(exprand(500,1200),0,0.2) }.play;
 { synth.free; original }
}
)


(
{
 { 
 Pan2.ar(
 SinOsc.ar(
 ExpRand(300,3000), 
 0,
 SinOsc.kr(ExpRand(1,15),0,0.05).max(0)), 
 Rand(-1,1)) 
 }.play;
}
)

{ s.sendMsg(\n_free, \h, 0); } // kill head

{ s.sendMsg(\n_free, \t, 0); } // kill tail

(
{{
 var eg, o, freq, noise;
 eg = EnvGen.kr(Env.linen(0.1,2,0.4,0.2), doneAction: 2);
 freq = Rand(600,1200);
 noise = {LFNoise2.ar(freq*0.1, eg)}.dup;
 o = SinOsc.ar(freq,0,noise);
 Out.ar(0, o);
}.play})


(
{{
 var in, sr;
 in = LFSaw.ar([21000,21001], 0, LFPulse.kr(ExpRand(0.1,1),0,0.3,0.2,0.02));
 sr = ExpRand(300,3000) + [-0.6,0.6];
 Out.ar(0, RLPF.ar(in * LFPulse.ar(sr, 0, MouseY.kr(0.01, 0.99)), sr * 
(LFPulse.kr(ExpRand(0.1,12),0,0.4,0.2,0.2) + LFPulse.kr(ExpRand(0.1,12),0,0.7,0.2)), 
0.1));
}.play;})

(
{{ var in;
 in = In.ar(0,2);
 ReplaceOut.ar(0, CombN.ar(in, 0.24, 0.24, 8, 1, in.reverse).distort);
}.play})

(
{{ var in;
 in = In.ar(0,2);
 ReplaceOut.ar(0, in * SinOsc.ar(MouseX.kr(2,2000,1)));
}.play})


/*

Windows and Buttons

31.11. Windows and Buttons
*/

(
v = SCWindow("Window v", Rect(20, 400, 400, 100));
v.front;
w = SCWindow("Window w", Rect(460, 400, 400, 100));
w.front; 

b = SCButton(v, Rect(20, 20, 340, 30));
b.states = [["Button b"]];
c = SCButton(w, Rect(20, 20, 340, 30));
c.states = [["Button c on", Color.black, Color.red], ["Button c off"]];
)

// When finished experimenting, close both:

v.close; w.close;

/*

31.12. States and Actions of Buttons
*/

(
v = SCWindow("Window v", Rect(20, 400, 400, 100));
v.front;
w = SCWindow("Window w", Rect(460, 400, 400, 100));
w.front; 

b = SCButton(v, Rect(20, 20, 340, 30));
b.states = [["Button b"]];
c = SCButton(w, Rect(20, 20, 340, 30));
c.states = 
 [["Start (State 0)", Color.black, Color.red], ["Stop (State 1)"]];

b.action = {w.view.background = Color(0.8, 0.2, rrand(0.2, 0.9))};
c.action = { | state | // shorthand for arg state;
 if(state.value == 0, {s.freeAll});
 if(state.value == 1, {{SinOsc.ar}.play})
};
)
 
// When finished experimenting, close both:

v.close; w.close;

/*
Slider

31.13. Slider
*/

(

SynthDef("WindowSine",
 {arg freq = 440, amp = 0.9;
 Out.ar(0, SinOsc.ar(freq, mul: amp))
 }).load(s);
 
w = SCWindow("Window w", Rect(460, 400, 600, 200));
w.front; 

w.view.decorator = FlowLayout(w.view.bounds);

c = SCButton(w, 500 @ 24);
c.states = [["Start (State 0)"], ["Stop (State 1)"]];

c.action = { | state | // shorthand for arg state;
 if(state.value == 0, {a.free});
 if(state.value == 1, {a = Synth("WindowSine")})
};
w.view.decorator.nextLine;
EZSlider(w, 500 @ 24, 
 "Frequency", ControlSpec(200, 1000, \exponential, 1), 
 {|ez| a.set(\freq, ez.value) });
w.view.decorator.nextLine;
EZSlider(w, 500 @ 24, 
 "Volume", ControlSpec(0.1, 1.0, \exponential, 0.01), 
 {|ez| a.set(\amp, ez.value) });

)
 
// When finished experimenting, close both:

v.close; w.close;

/*
30. Exercises
*/
splithere
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


B. Cast of Characters, in Order of Appearance
C. OSC
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
