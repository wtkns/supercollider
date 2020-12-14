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
