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
