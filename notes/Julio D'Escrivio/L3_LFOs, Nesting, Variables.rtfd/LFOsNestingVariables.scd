
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 4
Lesson 3 


In Class we will have covered the following topics: Audio hearing range, control and audio rate, Low Freqyuency Oscillators. Nesting (which has been covered since the first lesson) and the declaration and use of variables.


CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)


Low Frequency Oscillators, Nesting, Variables.


The 'Almost There' lesson !!

Slowly we have been introducing many synthesis ideas but so far we have not begun to create music using any particular style. This is because before we look at synthesis techniques like additive, subtractive or F.M. we need to be able to do the following things:

1. understand the concepts of frequency, phase and amplitude
2. create oscillators, including noise generators.
3. create and program envelopes for these oscillators
4. apply these envelopes to the frequency or amplitude of the oscillators you create
5. trigger these envelopes with a controller such as a mouse or automatically with ugens.

and...

6. control any value of an oscillator by nesting another oscillator into 
that value.

We're almost done with the basics we need in order to do some fancy synthesis, but as it is, we could do some creative work to allow us to better understand the use of envelopes and waveforms. Before we do that, let's go into topic number 6. We have already put some ugens into the slots where fixed numbers go, for example, we have put the EnvGen ugen in the 'mul' slot to get an amplitude
envelope. We have also nested a ugen into frequency. Let's just do that last thing again in a more considered manner, because it forms the basis for frequency, amplitude and ring modulation synthesis, It is also an opportunity to work on our nesting :)

In music there are natural ocurrences of nesting. Think about vibrato, for example. When you sing a note, you can choose to sing it straight or you can "wobble" the note when you sing it by varying the pressure that you're diaphragm muscle places on the column of air coming out through your vocal chords. This wobbling doesn't change the note; It is still the same note. But it could add expression (or cheesiness !). The note you sing is still the basic note (frequency) you are trying to hit but your attempt at vibrato can change the volume level or even the intonation itself. What is happening is that your vocal chords are not receiving a 'simple' steady column of air but rather a "prepared" column of air, one that already has fluctuations. A "wobbling" air column is in the place where there used to be a steady one; we are physically nesting one process into another: the wobbling air column through the vocal chords.

ok, let's do it in synthesis first our old friend the steady sinewave:

{SinOsc.ar(freq: 216, phase: 0, mul: 0.5, add: 0)}.play;

now let's look at a sinewave with a frequency below 20hz, in fact let's give it a really low freauency:

{SinOsc.ar(freq: 0.5, phase: 0, mul: 100, add: 440)}.play

can you hear anything?

Why?

ok, now let's try nesting the low frequency one into the normal one we already know, i'm going to dispense with the keywords inside the nested one, you know the names of the arguments...

{SinOsc.ar(freq: SinOsc.ar(0.5, 0, 100, 440), phase: 0, mul: 0.5, add: 0)}.scope;

3.1.jpg 

what does it sound like? 

try altering, one at a time, the values of the nested sinewave to see how they affect the sound and answer the following questions ( hint: you will be quizzed on this !):

1. Which parameter controls how fast the sound "wobbles" ? i.e., the vibrato rate.
2. Which parameter determines the center pitch, i.e., the frequency from which the sound deviates up and down.
3. Which parameter controls how far the pitch goes up or down.
4. Can you explain what is happening? Take a wild guess or think about it for a while !

Now that we are nesting low frequency waves into the frequency slot of high frequency waves, lets look at some special ugens that are specially designed for nesting...


noise is a very useful audio source, because noise is random frequencies distributed in different ways over the spectrum, as we described earlier in the course, instead of listening to it directly we could work with the values contained in it...

first try these three different types of noise and move the mouse around, then look at the scope to see the shapes they make:

{ LFNoise0.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1);

3.2.jpg 

{ LFNoise1.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1);

{ LFNoise2.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1);


ok, now lets use these noise sources BUT instead of listening to them let's use them as controls, for this we will send them the message 'kr' (or control rate) instead of 'ar' (audio rate) and we will nest them into our little ol' sinewave:


{SinOsc.ar(freq: LFNoise0.kr(5, 300, 440), phase: 0, mul: 0.5, add: 0)}.scope;

3.3.jpg 


{SinOsc.ar(freq: LFNoise1.kr(5, 300, 440), phase: 0, mul: 0.5, add: 0)}.scope;

{SinOsc.ar(freq: LFNoise2.kr(5, 300, 440), phase: 0, mul: 0.5, add: 0)}.scope;

ok, again... the questions:

1. Which parameter controls how fast the pitch changes ? i.e., the vibrato rate.
2. Which parameter determines the center pitch, i.e., the frequency from which the sound deviates up and down.
3. Which parameter controls how far the pitch goes up or down.
4. How is each noise UGen different?
5. Can you explain what is happening?


since we're at it, let's get to know some new useful ugens:


The triangle Wave:

This one is defined as a "low Frequency" triangle wave, presumably because its main use will be as a controller, but we can play it at audio rate:

{ LFTri.ar(500, 0, 0.1) }.scope;

compare with a sinewave:

{ SinOsc.ar(500, 0, 0.1) }.scope;

you must be able to tell them apart !

so, what is happening here?:

A.

{ LFTri.ar(XLine.kr(100,15000,6),0,0.1) }.scope(zoom: 4);

and here?

B.

{ LFTri.ar(LFTri.kr(0.2, 0, 400,800),0,0.1) }.scope(zoom: 4);

how about here?

C.

{ LFTri.ar(LFTri.kr(LFTri.kr(0.2,0,8,10),0, 400,800),0,0.1) }.scope(zoom: 4);





to understand the previous questions, if you haven't worked it out yet, then just look at what is nested where...
Here it is:
A. the frequency of LFTri is raised steadily between 100hz and 15000hz in 6 seconds, all of this is done at low volume(0.1) and then it is scoped in 1 channel and zoomed to a value of 4, try using 24 as a zoom value to see the difference, now try a zoom of 2. Get it?

B. the frequency of LFTri is raised 400 hz and then lowered 400hz and then raised 400hz and then lowered 400hz, etc. etc. from a center value of 800hz because it is modulated by a triangle wave itself so the shape of raising and falling of the frequency is itself a triangle !

C. the frequency of the nested LFTri which was previously wondering about in a triangular shape, is now itself the object of wobble because it has a further LFTri nested where it should have a frequency value... think about it !!

LFTri is recognizable as a modulator because when it pushes up a frequency, say in a playe like example B, once it reaches the top, it goes down really quickly and the same thing will happen at the bottom. It's a sharp turn, like an edge, givbing us the apex of the triangle.

 
The Impulse wave

This one will be an excellent trigger later on, for now, we can make some clicks with it which can be fun...
so far all our sounds have been in mono, if you want two channels (stereo!) all you have to do is nest an array where the frequency goes...

let's test it on the ol' sine:

{ SinOsc.ar([500,300], 0, 0.1) }.scope;


behold !! two channels appear automatically on the scope... in fact we could have more:

{ SinOsc.ar([500,300,100], 0, 0.1) }.scope;

but because we only have stereo in our computer setup we only hear the first two, although we can see all three, scope knows that you have three waves to see...


ok and now an impulse wave: it takes freq, phase, mul and add...

{ Impulse.ar(freq:1, phase: 0.0, mul: 0.8, add: 0) }.play; //this is one impulse per second, btw you do remember this is a comment, right?

using our stereo facility lets have one per second on the left and two per second on the right:

{ Impulse.ar([2,3], 0.0, 0.9, 0) }.play; //cool, hey?

you can try any rhythms like the one before. Go ahead, try them out.

ok, so here it is also at audio rate, so you know what it's like:

{ Impulse.ar(100,0,0.1) }.scope(1, zoom: 4);

and using the famous XLine (it also works as Line, but the X stands for eXponential !! so it is an exponential line...):

{ Impulse.ar(XLine.kr(800,100,5), 0.0, 0.5, 0) }.scope;

here is a neat trick, if we change the phase of one side of the two channels, then as it changes relative to the other side, we get rhythms and the clicks come in and out of sync (or phase !)... in fact, notice how even though there is one value for frequency, when we put an array into any value, we get two channels working... in this case MouseX is nested in the right channel:
(try moving the mpuse horizontally and see what happens)

{ Impulse.ar(4, [0, MouseX.kr(0, 1)], 0.2) }.play;

check out these examples:

nesting an LFTri into an impulse:

{ Impulse.ar(LFTri.kr(0.2, 0, 400,800),0,0.1) }.scope(zoom: 4);

double nesting for that great sci-fi ray-gun effect ! :

{ Impulse.ar(LFTri.kr(LFTri.kr(0.2,0,8,10),0, 400,800),0,0.1) }.scope(zoom: 4);



The Low Frequency Sawtooth wave.

Here it is played at audio rate with full use of keywords for clarity:

{ LFSaw.ar(freq: 100, iphase: 0,mul: 0.1, add: 0) }.scope(zoom: 4);

as you can see from the scope the wave has the shape of a rising ramp... how would this affect a ugen into which we nest it in the frequency value? Think about it for a bit then double click on the parenthesis below to select the whole example, which I have broken down for clarity and to start getting you used to this... ( I will also add comments by using the double forward slashes...)


( // <--------- double click on this parenthesis

{SinOsc.ar( //the ol' SinOsc ugen ! 

freq: LFSaw.ar(freq:0.4, mul: 100, add: 400), //the LFSaw has been nested, we have no value for phase, it doesn't ,matter !
mul: 0.2, //a low volume setting
add: 0 // no offset
) // close the parenthesis for the SinOsc ugen 

}.scope; //scope everything
)


what is happening to the pitch? Does the sound remind you of the waveform fo LFSaw?

ok, let's nest an LFSaw into another LFSaw:

{ LFSaw.ar(LFSaw.kr(0.2, 0, 400,800),0,0.1) }.scope(zoom: 4);

notice there is some high frequency noise... this is because this ugen is "not band limited", it means basically that as it tries to produce high frequencies that the computer won't properly playback because they would go above the bandwith of audible sounds, these get "folded" back into the audible band, producing sonic artifacts, which sometimes can be interesting... (and sometimes just sound unpleasant)

another example:

{ LFSaw.ar(LFSaw.kr(LFSaw.kr(0.2,0,8,10),0, 400,800),0,0.1) }.scope(1, zoom: 4);

3.4.jpg 




with XLine, the eXponential line ugen, remember?

{ LFSaw.ar(XLine.kr(100,15000,6),0,0.1) }.scope(1, zoom: 4);


finally, last but not least !

the Low frequency Pulse wave:

I think you will recognize this sound: 
 
{ LFPulse.ar(freq: 200, iphase: 0, width: 0.2, mul: 0.1, add: 0 ) }.scope(1, zoom: 4);

yes, just a basic pulse wave, but how about this one, achieved by nesting:

{ LFPulse.ar(LFPulse.kr(12, 0, 0.3, 200, 800), 0, 0.2, 0.1) }.scope(zoom: 4);

Yes, the famous ringtone. If you had to emulate the sound of an old fashioned mobile ringtone, you would now know where to start !


Using Variables for Nesting

Code can get complicated when we are nesting, consider this example (note the keywords telling you what the values mean):


( // <--------- double click on this parenthesis
{ LFPulse.ar( //here we have a pulse wave at audio rate
 freq: LFPulse.kr( //...with a nested ugen at 'kr' to create frequency values (1st nest)
 freq: LFPulse.kr( freq:0.2, // but in turn it has another (2nd nest) nested ugen at 'kr' !
 iphase: 0,
 width: 0.5,
 mul: 8,
 add: 10), 
 iphase: 0,
 width: 0.5, 
 mul: 400,
 add: 800),
 iphase: 0,
 width: 0.5,
 mul: 0.1, 
 add: 0) 
}.scope;
) // <--------- by the way you can also double click on this parenthesis instead of the first one !


ok, let's look at the innermost nested pulse... it has a freq of 0.2, this means the wave will repeat itself every 5 secs. Pulse waves are not like sines or sawtooths, the don't glide up to their value, they are rather like switches that are either ON or OFF... the width controlls how long they are on/off, so for example a width of 0.5 means that 50% of the time the wave will be ON (above zero) and 50% of the time it will be OFF (below zero). Because the wave spends as much time ON as it does OFF, it looks square. When we looked at Pulse waves we saw how this affects the sound.

So our 1st nest is switching on and then off every 5 seconds. It outputs the value 18 (10 for the offset and 8 for the mul) when it is ON and 2 (10 for the Offset minus 8 from the mul) when it is OFF. So, every five seconds this (2nd nest) ugen spits out the value 18 for 2.5 secs and then 2 for the remaining 2.5 secs.

When the value 18 is handed to the 1st nest, we make this ugen repeat its waveform 18 times per second, when it is handed the value 2, it repeats 2 times per second. This means that the frequency of the 1st nested ugen is changing every 2.5 secs, first fast (freq=18), then slow (freq=2). Just replay the code so you can hear it...

Because the first nested ugen has an offset (add) of 800, that value will be the center frequency for the 'mother' ugen, the outermost one... (keep looking at the code), because the mul = 400, then the resulting frequency value that will be fed to the mother ugen by this pulse wave will either be 1200hz (mul of 800 + add of 400) or 400hz(mul of 800 - add of400), but this value itself is changing in speed every 2.5 secs, because of the 2nd nested ugen... phew ! if you don't get it, try plugging different values into the code because it is worth understanding... the second nested ugen is actually the speed of the beeper, the second nested ugen provides the pitch of the beeper, the 'mother' ugen has therefore a pitch which changes in speed regularly...


let's now try and simplify the whole thing by breaking it down...

speed of change is provided by this ugen: 

LFPulse.kr( freq:0.2, iphase: 0, width: 0.5,mul: 8, add: 10); 


in itself it makes no sound because it outputs a frequency which is not audible... let's give it a name:

beepSpeed = LFPulse.kr( freq:0.2, iphase: 0, width: 0.5,mul: 8, add: 10);

this is called assignement. beepSpeed has been assigned the whole ugen. So instead of writing the lengthy ugen over and over, we could use beepSpeed. Notice that I am using a capital (the "S") in the middle of two joined up words... this is called "camel notation" and I think it's a great name ! anyway, beepSpeed is a variable. We have assigned our ugen to a variable.

this is how we declare a variable in supercollider. It is how we tell the computer that something will be from now on called by a given name. Instead of LFPulse, bla, bla bla, we only need to say beepSpeed !

( // <--------- double click on this parenthesis
var beepSpeed;
beepSpeed = LFPulse.kr( freq:0.2, iphase: 0, width: 0.5,mul: 8, add: 10);
)


if you look at the supercollider window (the one where you get lots of gobledygook if you make a mistake !) it will tell you that you have defined "a MulAdd"... don't worry that's ok.

now, let's add this bit of code to our example, remember that a function is anything inside a curly bracket !:




(
{var beepSpeed; // we need to declare the var within the function where it will be used

beepSpeed = LFPulse.kr( freq:0.2, iphase: 0, width: 0.5,mul: 8, add: 10);


 LFPulse.ar( 
 freq: LFPulse.kr( freq: beepSpeed, // see? now the frequency of the nested ugen is given by beepSpeed
 iphase: 0,
 width: 0.5, 
 mul: 400,
 add: 800),
 iphase:0,
 width: 0.5,
 mul: 0.1, 
 add: 0) 
}.scope;
)


the final code looks clearer now, in fact we could assign the 1st nested ugen to a variable as well...

(
{var beepSpeed, variableTone; // we need to declare the var within the function where it will be used

beepSpeed = LFPulse.kr( freq:0.2, iphase: 0, width: 0.5,mul: 8, add: 10);
variableTone = LFPulse.kr( freq: beepSpeed, iphase: 0, width: 0.5, mul: 400, add: 800);

 LFPulse.ar( 
 freq: variableTone, 
 iphase:0,
 width: 0.5,
 mul: 0.1, 
 add: 0) 
}.scope;
)

Now it should read much more clearly: an LFPulse at audio rate receives as its frequency a 'variableTone' which happens to contain itself a change in speed (beepSpeed). All LFPulse.ar is 'interested in' is in having a frequency value, which in this case happens to be a rather complex one but now with a simple name!


At the end of this section you should be able to:

1. Explain in your own words the following concepts:
Vibrato, tremolo, nesting, variables, assignements.

2. Create lines of code using the following UGens:
Impulse, XLine, LFPulse, LFTri, LFSaw,LFNoise0, LFNoise1, LFNoise2


3. Competently use the following messages/methods: ( a method is the way that the messages we send to the ugens are implemented, it is the activity they do when they receive a message)

Do the following practice:

1.
write code to produce a sinewave with a vibrato of 300hz from a center frequency of 700hz. at the speed of 3 times per second.


2.
write code to produce a sinewave with a tremolo effect that changes the amplitude 8 times per second periodically.

3.
rewrite this code, using all the appropriate keywords and substituting the nested Xline with a variable:

{ LFPulse.ar(XLine.kr(100,15000,6),0,0.5,0.1) }.scope(1, zoom: 4);

4.
rewrite this code, using all the appropriate keywords and substituting the nested LFTri.kr with a variable:

{ Impulse.ar(LFTri.kr(0.2, 0, 400,800),0,0.1) }.scope(zoom: 4);

5.
rewrite this code, using all the appropriate keywords and substituting both nested LFTri.kr with appropriate variables:

{ Impulse.ar(LFTri.kr(LFTri.kr(0.2,0,8,10),0, 400,800),0,0.1) }.scope(zoom: 4);









