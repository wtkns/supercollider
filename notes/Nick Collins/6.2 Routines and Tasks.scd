
-----------------
Scheduling with Routines and Tasks

some relevant help files:

[Routine]
[Task]


s = Server.local; 
s.boot;


//make sure you have already loaded the \bleep SynthDef from 6.1 Scheduling 




























So far, scheduling was always achieved by scheduling a function for a specific time. In order to be able to step through different stages of a program, it is helpful to have a special type of function that can have a number of execution stages. It is not evaluated all at once with .value, but can "yield" its current value at each of multiple stages.

This is a Routine:

(
r=Routine({

1.yield; 

2.yield;

3.yield;

})
)

r.value; //run this line four times












//another example with more going on
(
var r;
r = Routine({
 var x;
 x = 1.0.rand;
 2.yield;
 x.yield;
 1000.yield;
 x.yield;
 x = 1.0.rand;
 x.yield;
 });
 
10.do({ r.value.postln });
)



















// a routine can also have side effects

(
r = Routine({
 1.yield;
 Synth(\bleep);
 2.yield;
 1.yield;
 Synth(\bleep);
 1.yield;
 });
)

r.next; // btw. r.next is a synonym. r.value or r.next both return the "yield value".
r.next;
r.next;
r.next;






















// we can now simply use the routine by playing it on a certain Clock

(
r = Routine({
 0.5.yield;
 Synth(\bleep);
 1.yield;
 0.5.yield;
 Synth(\bleep, [\note, 43]);
 0.5.yield;
 });
 
SystemClock.sched(0, r); 
)















However, best practice is usually just to "play" the Routine, passing in the Clock

r.reset; // reset transforms the routine back into its original state
r.play(SystemClock); 

r.reset;
r.play(TempoClock(3));





















Yield can return any kind of object. 
Nevertheless, a meaningful time period value needs to be a float or an integer. 
To make clear that we mean a relative time, wait is used instead of yield (.wait just means the same as .yield);


TempoClock.default.tempo_(1); //just making sure default is sensible. In actual fact, for a tempoclock going at 1 bps, time in beats is the same as time in seconds 

(
var r;
r = Routine.new({
 "I just began!".postln;
 1.0.wait;
 "1 second later".postln;
 2.0.wait;
 "finished".postln;
});

r.play; //defaults to TempoClock.default;
)
 





















(
var r;
r = Routine.new({
 16.do({ arg i; 
 
 Synth(\bleep, [ \note, 36+(3*i) ]);
 0.25.yield; // yield and wait mean the same thing 
 
 });
});

r.play;
)


















inf.do can be used to keep going forever; but you must be very careful never to miss out some positive time .wait command. Because otherwise, the loop will go infinitely fast and SuperCollider (and possibly also your computer) will crash. 

(
var r;
r = Routine.new({
 inf.do({ arg i; 
 
 Synth(\bleep, [ \note, 36+(3*(i%10)) ]); //added %10 to stop it going up forever
 0.25.wait; //do not miss me out!
 
 });
});

r.play;
)





















// a Task is a Routine that can be paused and resumed:

(
t = Task.new({
 inf.do({ arg i; // keep going forever (until stopped externally)
 Synth(\bleep, [\note, 36+(2.3*(i%17))]);
 0.25.wait; 
 });
}); 
)

t.play(TempoClock(1.4)); //start the Task going

t.pause; //pause

t.resume; //unpause




















There is a special shortcut for a Routine that can be useful:

{}.fork


This will automatically wrap your function in a routine and play it; you pass in the clock as an argument to fork:



{5.do{"hello".postln; 1.0.wait} }.fork(TempoClock(1))


(
{16.do{arg i; Synth(\bleep, [\note,rrand(48,84) ,\amp, rrand(0.0,0.125)]); 0.125.wait} }.fork(TempoClock(2))
)













