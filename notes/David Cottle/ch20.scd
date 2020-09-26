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
