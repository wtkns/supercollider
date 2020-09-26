
-----------------
Time varying sounds

We have been making sounds so far that go on forever until we press a key to stop synthesising. 

Most of the time, we'll want to make sounds that go on for a limited time, and stop of their own accord. 

Listen to the difference between these two:

{SinOsc.ar(440,0,0.1)}.scope //Sine Oscillator goes on forever

{SinOsc.ar(440,0,Line.kr(0.1,0.0,1.0))}.scope //One second for the sine to disappear entirely


In the second example, I multiplied the sine wave by a line generator that started at 0.1 but went 
to zero over the course of a second.














Envelopes

In general, we want total control over how parameters of a sound (like volume or frequency) vary over time. 
This is often done by using envelopes. 

 //help files- [Env] [EnvGen]

Env.new([1,0,1],[1.0,0.5]).plot //This makes an Envelope with three control points, at y positions given by the first array, and separated in x by the values in the second (see the Env help file)

The .plot gives a quick way of seeing the envelope- we won't need it for synthesis but it helps for you to see some envelope shapes

//various types of envelope demonstrated:
 
Env.new([0,1,0],[1.0,0.5]).plot //one second 0 to 1 then half a second 1 to 0

Env.linen(0.03,0.5,0.1).plot //linen has arguments attack, sustain, release, level, curve

Env.adsr(0.01, 0.5, 0.5, 0.1).plot //attack, decay, sustain level, release, level, curve

Here's another type of Envelope, good for making percussion sounds:

Env.perc(0.05,0.5,1.0,0).plot //arguments attack, release, level, curve- good for percussive hit envelopes

There are many more types of Envelope to discover and utilise


















Let's start using Envelopes for synthesis. We use EnvGen to run the desired Envelope over time.

This is the envelope we'll run:

Env.new([1,0],[1.0]).plot 

This is just running the Envelope- its too slow to hear any sounds (your ears only pick frequencies over 16-20Hz)

{EnvGen.ar(Env.new([1,0],[1.0]))}.scope

This is multiplying a simple sine tone at 440Hz by the envelope over time, to make a limited duration sound

{SinOsc.ar(440,0,0.1)*EnvGen.kr(Env.new([1,0],[1.0]))}.scope




















Let's try a slightly more complex example-

I'm going to use an envelope for frequency:

Env.new([1000,20],[1.0]).plot 

The EnvGen gets plugged into the frequency input of the Saw wave:

{Saw.ar(EnvGen.ar(Env.new([1000,20],[1.0])),0.1)}.scope 


















Now even more complex, I'll change the frequency of Saw over 0.5 second and have its amplitude go to zero over 2 seconds:

{Saw.ar(EnvGen.ar(Env.new([10000,20],[0.5])),EnvGen.ar(Env.new([0.1,0],[2.0])))}.scope 


You can see how the nesting can get more and more complex, and its now very difficult to read 
the code to see what's going on. This should really be neatened up by writing over a few lines-

({
 Saw.ar(
 EnvGen.kr(Env.new([10000,20],[0.5])), //frequency input
 EnvGen.kr(Env.new([0.1,0],[2.0])) //amplitude input
 )
}.play
)

In SuperCollider you can find yourself having to work out what is plugged into what for complex networks,
all written as text. Remember that it may help you if you draw a diagram on paper of the connections. 












I made one subtle difference when I rewrote it- I ran the EnvGen ar control rate (.kr) rather than audio rate (.ar). 

We've tried both .kr or .ar and there's no real difference to our ears.

We often use .kr when possible, because it means a lower CPU load and ultimately we can run many more
oscillators at once. 





















Envelopes have a further use of prime importance- they can cause a running collection of UGens to be deallocated once a multiplier envelope has run through its course. 

Peeking ahead, you will see virtues of this when we look at spawning events live- you don't want completed voices hanging around and wasting your CPU when you could be synthesising new voices.

//FM sound
({
SinOsc.ar(
 SinOsc.ar(10,0,10,440),
 0.0,
 EnvGen.kr(Env.new([0.5,0.0],[1.0]), doneAction:2)
 )
}.scope
)

The doneAction argument means that the envelope on completion causes its enclosing synthesiser to be freed.

The only thing that matters is how long the envelope lasts in time: the following also deallocates 
when the envelope ends 

{Saw.ar(EnvGen.kr(Env.new([500,100],[1.0]),doneAction:2),0.1)}.scope

Note how the internal server status GUI shows no running Synths once this is deallocated. 
















We already saw some UGens that can be used like Envelopes, without the two stage 
Env/EnvGen construction. They work in deallocation too- here are examples:

Line //straight line generator 

XLine //exponential line generator


{Saw.ar(SinOsc.ar(1,0,10,440),Line.kr(0,1,1,doneAction:2))}.scope

{Saw.ar(SinOsc.ar(1,0,10,440),XLine.kr(0.0001,1,1,doneAction:2))}.scope


