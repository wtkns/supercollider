
-----------------
Scheduling in SuperCollider

some relevant help files:

[SystemClock]
[TempoClock]
[AppClock]

s = Server.local; 
s.boot;






















//load me first - this sound is going to be used for the scheduling demoes
//it's important we now use SynthDef and Synth, and notice the doneAction!
(
SynthDef(\bleep,{ arg out=0, note=60, amp=0.5, pan=0.0;
 var freq, env; 
 freq = note.midicps;
 env = EnvGen.ar(
 Env([0,1,1,0],[0.01, 0.1, 0.2]),
 levelScale:amp, 
 doneAction:2
 );
 Out.ar(out,
 Pan2.ar(Blip.ar(freq) * env, pan)
 )
}).load(s);
)

// This SynthDef uses an envelope with a doneAction of 2 to force a synth made
// from the definition to deallocate (free) itself when the envelope finishes. 
// This is vital, for else when we spawn events they'd hang around forever!


















You can set up a repeating function over time very easily
There is one global SystemClock which schedules in seconds
The SystemClock is the most reliable clock

// start a process 0 seconds from now then repeat every 0.25 seconds

(
SystemClock.sched(0.0,//start at 0.0 sec from now, i.e. immediately
 {//a function which states what you wish to schedule
 Synth(\bleep);
 1 //repeat every 0.25sec
 }
)
)

(the last thing returned from the function is the time until that function is called again; you should either return a number, or nil; nil will stop the scheduling)

Any scheduling will also stop when pressing CMD + period





















The same with more jerky attack times and passing arguments to each new Synth: 

(
SystemClock.sched(1.0,//start in 1.0 sec
 {
 Synth(\bleep, 
 [ //passing in arguments to the Synth
 \note, (#[0,2,4,5,7,9] + 48).choose, 
 \pan, 1.0.rand2
 ]
 );
 // random choice of repeat time:
 [0.25,0.3,0.7,0.1].choose 
 
})
)

#[0,2,4,5,7,9] makes a fixed (non-dynamic) Array and is therefore slightly cheaper


If you're happy to schedule everything in seconds, and work any rhythmic representations out for yourself, you're set to go. 














To get the current SystemClock time you can use this code:

Main.elapsedTime; //gives a time since the application started

And in scheduling schedAbs schedules with respect to an absolute time

(
SystemClock.schedAbs(Main.elapsedTime+1.0,//start at absolute system clock time now + 1 second
 {
 Synth(\bleep, 
 [ //passing in arguments to the Synth
 \note, (#[0,2,4,5,7,9] + 48).choose, 
 \pan, 1.0.rand2
 ]
 );
 // random choice of repeat time:
 [0.25,0.3,0.7,0.1].choose 
 
})
)








In many cases you'd prefer to work relative to some tempo, (for instance, if you want to schedule events in terms of beats and measures)

SuperCollider measures tempi in beats per second (bps) rather than beats per minute, i.e

1 bps = 60 bpm

1.6666667 bps = 100 bpm

2 bps = 120 bpm

2.4 bps = 144 bpm

3 bps = 180 bpm



(multiply by 60 to go from bps to bpm, divide by 60 in the other direction)



















For beat-based scheduling we use TempoClock:

(
var t;

t = TempoClock(2); // make a new tempoclock at tempo 120 bpm = 2 beats per second

t.schedAbs(0, { arg ... args; // start at absolute beat 0 immediately
 args.postln; // post the input arguments to our event function 
 // (will post logical time in beats, elapsed time 
 // in seconds of enclosing thread and this clock)

 Synth(\bleep);// make a bleep
 1.0 // reschedules every beat
})

)

TempoClock is set up to react appropriately to changes of tempo and timesig. 




















There is an automatically available TempoClock

t= TempoClock.default; 


You can ask a tempoclock where it is; this default clock might have been running for a long time already


t.elapsedBeats; //what exact logical beat time are we at

t.bar; //which bar are we in (default assumption is 4/4)

t.elapsedBeats.ceil; //find next beat

t.elapsedBeats.floor; //find last beat
















(
var t;

t = TempoClock.default; // the default TempoClock might have been running 
 // for a very long time already, so you should start at the next beat.

t.schedAbs(t.elapsedBeats.ceil, // start at next whole beat
 {
 Synth(\bleep, [\note, [36,40,43].choose, \pan, 1.0.rand2]);
 [0.25,0.5,1.0, nil].wchoose([0.5,0.4,0.05,0.05]); //weighted choice // repeat at some number of beats from the array- nil means stop
 })
)


[1,2,3,4].wchoose([0.8,0.1,0.07,0.03]); //wchoose allows a weighted choice of values in one array with respect to the weights in a second array (which must add up to 1 and there must be as many weights as items to pick from)
















If you ask for a beat that has already occured, the scheduler will try to catch up with the queue of events as quickly as possible:

(
var u;

u = TempoClock(1.2); // make our own Tempoclock at a tempo of 1.2 bps

// should have started 5 beats ago!
u.schedAbs(-5.0, { Synth(\bleep); 0.5 });
// you'll get a loud burst of events as it catches up
SystemClock.sched(5.0, {u.clear}); // schedule a stop for 5 seconds from now.
)

















// If you change tempo at some point, the transition is fine:

(
var u;

u = TempoClock(3.5);

u.schedAbs(0.0, { arg beat, sec; 
 [beat,sec].postln; 
 Synth(\bleep, [\note, rrand(60.0,67.0)]); 
 0.5
});

u.schedAbs(8.0, { u.tempo_(2); nil }); // just schedule tempo change

u.schedAbs(12.0, { u.tempo_(7); nil }); // just schedule tempo change

u.schedAbs(17.2, { u.tempo_(1); nil }); // just schedule tempo change

SystemClock.sched(7.0, { u.clear; }); // schedule a stop for 7 seconds from now.
)













Run these lines one at a time:

t=TempoClock(2);

t.tempo; //gets current tempo

t.tempo_(4); //sets current tempo (only the underscore character is different)

t.tempo;

t.tempo= 2.3; //also assigns new tempo, same as last line

t.tempo;















// Changing Tempo via a UI control:

// slider range is always 0.0-1.0, so mapped in the code
(
 var w,u,slid, button;

 w = SCWindow("tempo control test", Rect(100,100,200,40));
 slid = SCSlider(w, Rect(0,0,200,20));

 button = SCButton(w, Rect(60,20,40,20)); 
 button.states_([["kill"]]);

 w.front;

 slid.action_({u.tempo_(2*(slid.value)+1)});
 button.action_({u.clear; w.close;});

 u = TempoClock(1);
 
 u.schedAbs(0.0, { arg beat,sec; 
 [beat,sec].postln; 
 Synth(\bleep, [\note, rrand(60, 100)]); 
 1.0
 });
)











// You can do multiple Tempi by creating two clocks at once
// Here's a tempo ratio of 12:13 

(
var u,v;

u = TempoClock(1.2);
v = TempoClock(1.3);

u.schedAbs(0, { Synth(\bleep, [\note, rrand(41.8,47.5), \pan, -0.5]); 1.0 });
v.schedAbs(0, { Synth(\bleep,[\pan, 0.5]); 1.0 });

SystemClock.sched(10.9, { u.clear; v.clear; }); // schedule a stop for 10.9 seconds from now.
)


























A note about GUIs and Clocks


UIs can't be updated by direct call from the SystemClock - the operating system's AppClock must be used. Here is a quick programmatic demonstration of moving a window around:

// When running it always press cmd + period before attempting to close the window

(
var w, i;

 i = 0;

 w = SCWindow("My Window", Rect(100, 0, 200, 50)); 
 // A 200 by 200 window appears at screen co-ordinates (100, 0)
 w.front;

 //schedule moves and resizes for the window
 AppClock.sched(0.0, { 
 w.bounds_(Rect(100, (10 * i) % 500, rrand(200,400), 50)); 
 i=i+1; 
 0.125
 });
)

// this would have failed:
// SystemClock.sched(0.0,{w.bounds_(Rect(100, (10*i)%500, 200,200)); i=i+1; 0.125});






There is one helpful shortcut trick; if you are within a SystemClock, you can wrap any GUI calls in function brackets like so:

{
//GUI code
}.defer 

In the background, this reassigns the command to the AppClock.


// this will be OK, by using defer to pass the command to an AppClock:

(
var w, i;

 i = 0;

 w = SCWindow("My Window", Rect(100, 0, 200, 200)); 
 // A 200 by 200 window appears at screen co-ordinates (100, 500)
 w.front;

 SystemClock.sched(0.0, {

 { w.bounds_(Rect(100, (10*i)%500, 200, 200)) }.defer; // defer acts as a bridge between SystemClock and AppClock
 i=i+1; 
 0.125
 });

)


































