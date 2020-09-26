
-----------------

Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 7
Lesson 6 


In Class we will have covered the following topics: EQ, Filters, noise.


CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)


Subtractive Synthesis

By now you will have realized that the best way to learn Supercollider is to explore examples of code and adapt and change tha various values. Eventually you will start building your own. Because you will have accumulated a personal 'library' of synthesis resources. Also it is worth mentioning that some of the patches we have explored up till now, have a behaviour that depends on random values or even on some rules. We saw this in the way MouseX can choose values, in the use of "max" and in the use of rrand. The use of rules and randomness to generate music is called 'algorithmic' music, it is also called 'generative' music, because the music is generated from rules; The composer establishes the rules that will give rise to the music.

Subtractive synthesis is about "taking away" elements of the sound. This is done by means of filters. A filter is an audio device that only lets certain frequencies pass through.

There are three main types of filter:

The Lowpass filter (only the low frequencies below a certain point will pass through the filter)
The Highpass filter (only the high frequencies below a certain point will pass through the filter)
The Bandpass filter (only a band of frequencies will pass through the filter)


A filter must have a sound which is to be filtered. This is called the source. A filter must have specified the frequency from which to filter, high, low or bands of frequencies. Finally, a filter has a resonance value, which consists in specifying how frequencies around the cutoffpoint are to be emphasized. If the focus around the cutoff encompasses a small frequency range, we say it is "narrow". If it encompassess a large frequency range we say it is "wide".


We have in past lessons already discussed Noise and the various types of noise that can be produced with SC. In subtractive synthesis, the richer the initial wave is, the more interesting the filtering will be. For this reason a sawtooth wave offers more material to be chiselled away by the filter than a sine wave; Noise offers even more raw material.

Re-acquaint yourself with the various noise ugens:

{WhiteNoise.ar}.scope(1)

..and here is the graph:

Ex.1 White noise goes directly to the output.

L6 White Noise ex1 .jpg 

and of course, likewise:

{PinkNoise.ar}.scope(1) 

{BrownNoise.ar}.scope(1)

{GrayNoise.ar}.scope(1)

{Dust.ar(12)}.scope(1)

In the following examples, taken from Cottle (2005), we can appreciate the effects of filtering. Analyse the following examples to see how they work:

( //high pass filtering
{
var signal, filter, cutoff, resonance;

signal = PinkNoise.ar(mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

RHPF.ar(signal, cutoff, resonance)}.scope(1)
)

( //low pass filtering
{
var signal, filter, cutoff, resonance;

signal = PinkNoise.ar(mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

RLPF.ar([signal, signal], cutoff, resonance)}.scope(1) //multichannel expansion !
)

( //band pass filtering
{
var signal, filter, cutoff, resonance;

signal = PinkNoise.ar(mul: 0.7);
cutoff = MouseX.kr(40, 10000, 1);
resonance = MouseY.kr(0.01, 2.0);

BPF.ar(signal, cutoff, resonance)}.scope(1)
)

Can you reconstruct the above examples, using a sawtooth wave in stereo?
hint: use a low frequency and revise how to do mutichannel expansion in lesson 5.

Notice how when resonance is narrow,we begin to hear pitches when we change the cutoff. This is clearest in the noise ugen examples. From this we know that we can modulate cutoff frequency in a similar way to pitch.

Again, following Cottle, let's look at how to do this.

Remember how a Noise signal is a composite of random frequencies? We have discussed this, but let's refresh it now by looking at more examples from Cottle...

Here is a sine wave ugen with a noise signal plugged in where the frequency would go, can you remember what the add and the mul for noise mean in this case?


{SinOsc.ar(LFNoise0.kr(12, 500, 500), mul: 0.5)}.play

Ex.2 Noise plugged in to frequency

L6 noise plug ex2.jpg 

{SinOsc.ar([LFNoise0.kr(12, 500, 500),LFNoise0.kr(6, 500, 500) ], mul: 0.5)}.draw //expanded ! can you find a simpler way to write this?


Ex.3 plugin and multichannel expansion
 
L6 multinoise pluf ex3.jpg 


The frequency of the SinOsc above will change 12 times per second, randomly between 0 and 1000 hertz. And in the second example it does it at half speed in the other speaker.

// Same control source applied to filter cutoff with narrow resonance

{RLPF.ar(PinkNoise.ar(0.3), LFNoise0.kr([12, 6], 500, 500), 0.02)}.play

// Wider rq does not result in pitch

{RLPF.ar(PinkNoise.ar(0.9), LFNoise0.kr([12, 12], 500, 500), 1)}.play

As you can see, the narrower the resonance values, the more pitch we can get out of a filtered sound. In fact, the pattern of resonant frequencies in a sound, give it its distinguishing timbre. To reproduce the resonant nodes of a vibrating body or space, is to create a physical model. In supercollider we can use an object called Klank to do this... here is how it works...

(
{
Klank.ar(
 `[[100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], //freq array, i.e. which frequency nodes will resonate. Notice the use of one inverted comma outside the array, this instructs supercollider NOT to do multichannel expansion...
 [0.05, 0.2, 0.04, 0.06, 0.11, 0.01, 0.15, 0.03, 0.15, 0.2]], // these are the amplitude values for each freq
 PinkNoise.ar(MouseX.kr(0.01, 0.1))) //this is the input, pink noise, mouse controlled
}.scope(1)
)


notice how the noise is changing all the time, it is shaped by the resonance nodes... a way to understand this is to remember what happens in a resonant space, for example, a tiled bathroom -admittedly in the UK people use carpets in the loo, but if you've been abroad you'll know what I mean !! :)... In a tiled bathroom, if you feel like singing while you shower, you will find that some notes are enhanced by the bathroom acoustics... this means that those notes resonate, that the shape ofg the room favours these frequencies. This is what we call the "resonating nodes", the points at which the space will enhance the sound...


Get your headphones on and check it out with your voice as input, sing into the microphone after running this patch:

( //MUST USE HEADPHONES
{
Klank.ar(
 `[
 [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000],
 [0.05, 0.2, 0.04, 0.06, 0.11, 0.01, 0.15, 0.03, 0.15, 0.2]] , 
 AudioIn.ar(1,0.1) ) //this is the input from your mic.
}.scope(1)
)

As you sweep with your voice through the frequency spectrum you can hear which notes resonate more... the noise from the room is also being enhanced in this way...

Before you read, on, try creating some simpler resonators and changing the frequency values, running your voice through it and listening to what happens !


let me start you off... for example run this:

( //MUST USE HEADPHONES
{
Klank.ar(
 `[
 [600], // frequency node at 600Hz
 [0.8] // boost any sound which hits this freq !
 ] ,
 AudioIn.ar(1,0.1) )//this is the input from your mic
 }.scope(1)
)


now, sing into the mic till you hit the whistling noise (the ambience is already being processed through the mic)... notice how when you hit the note, the sound is boosted... this means that you have hit a resonating frequency !!

Experiment with more resonating frequencies and finally change the input back to mouse controlled noise, perhaps use brown noise this time...

Go on ! you only really learn by doing...

Here is another Klank, notice that to get interesting sounds you need to have interesting frequency arrays, so it helps to know how to generate arrays of numbers that may be interpreted as frequencies...

for example if we wanted 5 values within, say, 100 hz and 800 hz we could do this:

{exprand(100, 800)}.dup(5);

ok, let's break that down because it is quite important we learn this way of generating values...


first let's look at the "dup" method...
try this:

5.dup

what happens? 
... it prints itself and then a duplicate of the object (which is the number 5)

now try this

5.dup(2);

same?

now this:

5.dup(3);

and:

5.dup(4);


ok, by now you know how it works... but what if the object is not a number but a function? you see, functions are evaluated each time so for example, although

rand(5).dup(3)


will return an array with the same random number three times...

but if we do:

{rand(5)}.dup(3)

the function will be evaluated EACH time it is duplicated... this is very useful.

Above, we usde a cousin of "rand" which is "exprand" , you already know other random methods such as "rrand" for example, anyway, just try this example from the Cottle manual now, and evaluate it several times (after stopping each one!):

(
{
Klank.ar(
 `[{exprand(60, 10000)}.dup(15)],
 PinkNoise.ar([0.005, 0.010])
)
}.scope(1);
)


Do you see how useful it is to be able to generate values that are random and form arrays? that way we can specify interesting frequency values and create nice bell-like timbres.




Ok, just to bring it all together, let's recall the concept of envelopes, if you have to, do revise that section before going on... what i would like to do now is to apply an envelope to the cutoff parameter so in the following code we can "freeze" the behaviour of the cutoff in time, as opposed to control it with the mouse:

(
{
var signal, filter, cutoff, resonance;

signal = PinkNoise.ar(mul: 0.7);
cutoff = 5000*EnvGen.kr( 
 Env.new([0,1, 0.3, 0.8, 0], [2, 3, 1, 4],'sine'), 1
 , doneAction: 2);
resonance = 0.01;

RLPF.ar([signal, signal], cutoff, resonance)*0.2}.scope(1) 
)

from above, notice the following new things:

1. EnvGen is scaled by 5000 to put its values in audio range, otherwise you get numbers between 0 and 1 and those are too small values for cutoff which needs to be between 20hz and 20000hz !!!

2. within EnvGen we have added a line of code, doneAction: 2, this is very handy because it turns off the sound when the envelope finishes so you don't have to do command-"." to free the CPU of your computer.

3. we set a tiny resonance value in order to get the noise to make a pitch.

4. because it is so loud otherwise, we are scaling RLPF by 0.2...

5. we are getting an audible click at the end, why do you think that is?


Now re-write the example above but in order to process a Sawtooth wave as its signal. How does the click at the end compare this time?

Synthesized Textures:

You can bunch a few sonic events together and run them at the same time for more complex sounds... for example just add two instances with different envelope values. Let's do it with 2 sawtooths with a low frequency that are slightly detuned for a more unified sound:

( // double click here 
(
{
var signal, filter, cutoff, resonance;

signal = Saw.ar(50, 
 mul: EnvGen.kr( 
 Env.new([0,1, 0.3, 0.8, 0], [2, 3, 1, 3],'sine'), 
 1, 
 doneAction: 2));
cutoff = 5000*EnvGen.kr( 
 Env.new([0,1, 0.3, 0.8, 0], [2, 3, 1, 4],'sine')
 );
resonance = 0.01;

RLPF.ar([signal, signal], cutoff, resonance)*0.1}.scope(1) 
)
+
(
{
var signal, filter, cutoff, resonance;

signal = Saw.ar(51, 
 mul: EnvGen.kr(
 Env.new( [1,0.8, 0.1, 0.4, 0], [1, 4, 2, 1],'sine'), 
 1,
 doneAction: 2
 )
 ); 
cutoff = 5000*EnvGen.kr( 
 Env.new([1,0.8, 0.1, 0.4, 0], [1, 4, 2, 2],'sine'), 
 1
 );

resonance = 0.01;

RLPF.ar([signal, signal], cutoff, resonance)*0.1}.scope(1) 
)
)

Now have a go at changing the frequency and envelope values to get different textures and behaviours, make sure you keep copies of your code so you can reproduce the sounds later on. Also try different signal inputs such as noise ugens or even a Klank with exprand values !

To end this chapter analyse the following example from Cottle (15.17), you know almost all the ugens involved (an you can look Decay.ar in the help files!), all you need is to break it down and understand how he made it, and then substitute your own values and modify it. This experience is the most important way we learn to program, by looking at what others have done, up to now, I have explained everything to you, breaking down the code myself, this may take you a while but it is well worth it !!!

The beauty of this patch is that it is not just a static synthesizer but a "generator" of synthesized sounds. 

Remember that in a function (everything within the curly brackets...), after the declaration of variables, and of arguments -if there are any-, each and every line of code is evaluated that has a ";" at the end, so you can write as many of these as you like.

here it goes:

Chimes and Cavern, from 15.17, D. Cottle, ready for you to comment !:

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
 rrand(1.0, 1.1)}.dup(totalPartials), //why multiply by 1.1 do you // think?
 Array.rand(totalPartials, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( [rrand(0.03, 0.1), rrand(0.03, 0.1)])
 )*max(0, LFNoise1.kr(3/rrand(5, 20), mul: 0.005))
 }.dup(5));
cavern + chimes
}.play
)



At the end of this section you should be able to:

1. Explain in your own words the following concepts:
Subtractive Synthesis; Low-pass filter, High-pass filter and band-pass filter; Resonance;


2. Create lines of code using the following UGens:
RLPF, RHPF, BPF, Klank, AudioIn.ar



3. Competently use the following messages/methods: 
doneAction: 2


Do the following practice:

1. Write out the filter examples again, but this time use your voice as the input... if you can, use multichannel expansion... hint: you must change the signal variable to reflect your mic input.

2. Make a combined patch of sounds which includes Klank together with a filtered sound

3. Create at least 5 different arrays using methods you have learnt or you can find out in the help files, the numbers must be within audio range.

4. Use the arrays above to genereta a Klank sound for each.

5. Create a filter patch for each klank you made and make some with random panning and some where panning is controlled by the mouse.








