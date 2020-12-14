
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 9
Lesson 8 


In Class we will have covered the following topics:


CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)



Amplitude Modulation Synthesis 

Amplitude modulation, as you can probably guess, is synthesis that occurs when the amplitude of a soundwave is made to change in some way...
Let's try it:


{SinOsc.ar(261, mul: SinOsc.ar(100, mul: 0.5) )}.scope

... and this is what we have done, the first 'boxlet' after MUL is the input to the box, in both cases a sinewave, and the second 'boxlet' is the mul value, 
so have look and mull it over ! (sorry couldn't resist !! :)

L8, AM ex 1.jpg 

As in FM, the outer (or receiving sine) is the carrier and the inner (or plugged in sine !) is the modulator. Remember how there were many sidebands in FM? well... here only two sidebands come up... one is the sum of the carrier plus the modulator frequencies and the other is the difference between these frequencies...

Given the example above, what we hear then is two pitches, one at 261+100 and the other at 261-100...

If there are partials in one of the waves (for example if we use a sawtooth), then sidebands will originate for each of those partials:

{SinOsc.ar(261, mul: Saw.ar(1000, mul: 0.5) )}.scope //nasty, hey?


L8 AM ex2.jpg 



We Should experiment with AM, it is relatively simple compared with FM but quite effective. There are a lot of effects pedals for electric guitars that use Amplitude Modulation under its cooler alias: Ring Modulation.

Let's try it with our voice: (but first, get those headphones on)

{ SinOsc.ar([440, 440], mul: AudioIn.ar(1, 0.1) )}.scope

Sing for a little while and when you're tired, have a look at this: (yellow boxes represent the values that are sent to the system to initialize it, in this case so that In will read from channel 1, as seen in the yellow "Add-boxlet-1")

L8 AM Ring Mod ex3.jpg 


On a brief tangent, just remember that in computing, names for things relate to their mathematical roles as opposed to their everyday life usefulness, because the former are more general and thus applicable to more situation. Thus instead of calling an amplifier by the nickname "amp", it is called MUL, because the signal gets multiplied; If we needed to multiply any value other than a signal or for different purposes then the name AMP would be useless, but MUL would still make sense, is that clearer?

Back to business, then. Now try this: (headphones !)

{ SinOsc.ar([261, 440], mul: AudioIn.ar(1, 0.1) )}.scope

Sing along... 

What is happening here? How many main sidebands are there? (think about what happens when you feed a sawtooth into the sine as explained above, then think about how you have multichannel expansion here...)


-make a routine using AM like the one we did for FM



Latch
select/stepper through modulation values...






At the end of this section you should be able to:


1. Explain in your own words the following concepts:
AM Synthesis, Ring Modulation,


2. Create lines of code using the following UGens/objects:
AudioIn




3. Use the following messages/methods: 




Do the following practice:

1. Create an AM patch where the modulator is a Sawtooth wave that gets fed gradually into the sinewave carrier... hint: use line ugen.

2. a. Create an AM patch where the modulator is fed in random bursts into the carrier. hint: use the dust ugen.
 b. Create a ring modulation where on one channel the voice is randomly passed into the carrier and on the other, it is amplified straight through. hint: use multichannel expansion for stereo and the dust ugen.
 c. Create a ring modulation patch for the voice, with multichannel expansion for stereo, where you can use the mouse to change both carrier frequencies at the same time to different values. hint: use horizontal and vertical mice.
 
 









