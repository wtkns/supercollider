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
