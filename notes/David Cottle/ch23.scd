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
