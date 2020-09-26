
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 8
Lesson 7 


In Class we will have covered the following topics: Frequency Modulation, Carrier, Modulator and Modulation Index.


CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)



Frequency Modulation Synthesis.



To synthesize sound by Amplitude Modulation (AM) or Frequency Modulation (FM) means exactly what it says: new sounds are made by affecting the frequency or the amplitude of a given waveform.

We have already covered instances of this when we used Low Frequency Oscillators, back in lesson 3. In fact when we studied nesting back in lesson 3, this is exactly what we were doing, plugging a waveform into another waveforms parameter...

So for example:

{SinOsc.ar(SinOsc.ar(100, mul: 300, add: 800) ) }.play

Where the SinOsc expects to receive a frequency value, a number, telling it what pitch to play, it actually receives another SinOsc !

What happens then, is that the "outer" SinOsc is receiving a stream of values made by another SinOsc.

Soooo... the inner SinOsc is sending the number values between 1.0 and -1.0 continuously, in a stream, at 100 times per second, this means that the actual frequency of the "outer" SinOsc in the example above is changing 100 times per second. This is perceived as a complex sound. If the frequency value is ver small, it gets perceived as vibrato

let's play it again...

{SinOsc.ar(SinOsc.ar(100, mul: 300, add: 800) ) }.play //frequency modulation

versus:

{SinOsc.ar(SinOsc.ar(2, mul: 300, add: 800) ) }.play // vibrato !


Before you go on, try and modify the frequency of the modulator ugen (the inner one) to see at what value we stop hearing it as a vibrato and start hearing a complex waveform...

I'll get you going:

{SinOsc.ar(SinOsc.ar(0.1, mul: 300, add: 800) ) }.play //vibrato

{SinOsc.ar(SinOsc.ar(1, mul: 300, add: 800) ) }.play // still vibrato

{SinOsc.ar(SinOsc.ar(2, mul: 300, add: 800) ) }.play // still vibrato

now you carry on trying values...


You will also remember (or revise if you need to !) that oscillator ugens, in order to make a sound, send a stream of values to the supercollider server at audio or control rate that oscillate between 1.0 and -1.0... From these values, the server builds the audio signal.

hmmm... so why the big numbers in the inner ugen? Can you remember?

Let's revise that anyway.

let's do the maths in slow motion. Let's stop the clock and see what the inner ugen is doing: 100 times per second, we multiply a number between 1.0 and -1.0 by 300 and then add 800...

ok, let's do one of those calculations, the one that will give us the larger value: (in this way we can see what is happening at the extremes)

Let's say that at second no. 1, a value of 1 (the max that a SinOsc can produce before being MUL'd and ADD'd) is produced. It is multiplied by 300, so now the value is 300. It is then added to 800 so now the value is 1100. This value is recieved by the outer ugen SinOsc which then makes a sinetone with a frequency of 1100. 

Further along the line, some seconds (or milliseconds ! ) later, a value of 0 is produced. It is multiplied by 300, so the resulting value is 0. It is then added to 800 so now the value is 800 (800+0). This value is recieved by the outer ugen SinOsc which then makes a sinetone with a frequency of 800. 

And still further along the line, some seconds (or milliseconds ! ) later, a value of -1 is produced. It is multiplied by 300, so the resulting value is -300. It is then added to 800 so now the value is 500 (-300+800). This value is recieved by the outer ugen SinOsc which then makes a sinetone with a frequency of 500. 

So, having worked this out and remembering earlier explanations of this (check it up !) what is happening is that the inner SinOsc is creating values between 500 and 1100. The ADD value acts as a centre-point, 800, and the MUL value, 300, acts as an offset below and above. And 100 times a second these calculations are performed, yielding numbers that start at 500 and go up to 1100 then down to 300 then up again and so on.

Now, the highest frequency that the outer ugen will receive is 1100 but does this mean that we can hear it as such?

compare:

{SinOsc.ar(1100) }.play

and...

{SinOsc.ar(SinOsc.ar(100, mul: 300, add: 800) ) }.play


Nowhere near hey? This is because when a modulating frequency is within audio rate, the resulting sound will contain new partials which are called sidebands in FM. The use of Frequency Modulation as a synthesis technique was first developed by John Chowning of Stanford University in California, in 1967. It was later licensed to Yamaha Corporation which has based it's synthesis on this method either totally or partially ever since. The vintage DX7 synthesizer was a purely FM synth.

In the following ugen, you can change the frequency of the inner ugen by moving the mouse horizontally. Remember that the ADD value is your centre frequency and the MUL is the offset, the frequency value (in this case given by MouseX) will give you the depth of the modulation... the more to the left you go, the more it sounds like a vibrato, the more to the right you move the mouse, the more sidebands will appear...


try it:

{SinOsc.ar(SinOsc.ar(MouseX.kr(1, 500), mul: 300, add: 800) ) }.play


In fact, let's get a bit more technical and learn the lingo. The outer SinOsc is called the carrier because it is the one that 'carries' the sound... 

Notice that the inner SinOsc doesn't make any sound on its own:

{SinOsc.ar(MouseX.kr(1, 500), mul: 300, add: 800)}.play


But if you plug it into a carrier, it will make a sound, because as we have explained, it modulates the frequency of that carrier. For this reason we call it the modulator.


The modulator produces sidebands, as we can hear when we move the mouse in the example above. The number of sidebands that get produced depends on how big is the total amplitude of the modulating wave... sounds sort of logical, no? the larger, bigger (greater in amplitude) that the modulating wave is, then the greater the effect on the carrier....

We can show this by plugging in a mouse ugen into the MUL of the modulator, that way we change the amplitude progressively... the lower the MUL, lower on the screen, the more sine-like and pure the sound is, the higher you move the mouse, the more complex it becomes because more sidebands appear...

try it:

{SinOsc.ar(SinOsc.ar(50, mul: MouseY.kr(5000, 0), add: 800) ) }.play


As you sweep the mouse up and down the screen, notice that what changes is the timbre of the sound (the partials that are present which in FM are called sidebands), but the pitch remains the same. It is similar to filtering in subtractive synthesis: partials are filtered/emphasized but the fundamental pitch remains the same. So, how can we change the pitch of the carrier?

let's write it in a more explicit way. Examine this example:

{SinOsc.ar(400 + SinOsc.ar(50, mul: 100), mul: 0.5)}.scope(1)


If you do the maths like we did before you will see that the basic frequency of the resulting sound is 400hz and that we are adding to it, 50 times per second, values between 100 and -100. Can you remember why? Don't carry on until you can.

It is easier to see now... we have a basic frequency, that of the carrier, which if changed very rapidly to values above and below will not sound like vibrato but like a sound which has some unexpected partials...

again, quite slow:

{SinOsc.ar(400 + SinOsc.ar(1, mul: 100), mul: 0.5)}.scope(1) //under audio rate... i.e. 20hz to 20khz

faster...

{SinOsc.ar(400 + SinOsc.ar(10, mul: 100), mul: 0.5)}.scope(1) //still under


even faster...

{SinOsc.ar(400 + SinOsc.ar(20, mul: 100), mul: 0.5)}.scope(1) //still, but just...

and even faster...

{SinOsc.ar(400 + SinOsc.ar(30, mul: 100), mul: 0.5)}.scope(1) //and now at audio rate...



So if the basic frequency above is 400, let's prove that by changing it alone, we can change just the pitch and not the timbre of the sound (the sidebands present). Let's go back to some earlier values:

{SinOsc.ar(400 + SinOsc.ar(50, mul: 100), mul: 0.5)}.scope(1)


now we plug the mouse into where the base carrier frequency goes:

{SinOsc.ar(MouseY.kr(1200, 400) + SinOsc.ar(50, mul: 100), mul: 0.5)}.scope(1)


Observe that the change is only in pitch and not in timbre but if we plug in another Mouse, this time into the modulator frequency...

{SinOsc.ar(MouseY.kr(1200, 400) + SinOsc.ar(MouseX.kr(500, 50), mul: 100), mul: 0.5)}.scope(1)


We can hear how the timbre also changes as we move the mouse horizontally. Notice how some of the sidebands are so strong when they appear -moving the mouse along the X axis, i.e. horizontally) that it seems like the pitch of the sound is changing, but if you listen carefully you will hear that it is only components (sidebands) in the sound that are changing, not the base pitch. The latter only changes when the mouse moves vertically.

So, what are the functions of the various elements of FM synthesis?

This is what you need to know:

FM synthesis is produced when the frequency of one waveform is modulated by another. Modulation means change, so when a basic frequency is changed by another waveform, we say that frequency has been modulated.

The basic frequency of the sound is given by the frequency of the CARRIER.

The kinds of sidebands that will appear (beacuse they do not appear in a predictable way like when you filter a sawtooth wave ! ) are determined by the frequency of the MODULATOR.

The intensity with which these new partials or sidebands appear in the carrier is determined by the level or amplitude of the modulator and it is called the MODULATION INDEX.

Try playing with this patch here:

{SinOsc.ar(400 + SinOsc.ar(MouseX.kr(500, 50), mul: MouseY.kr(1000, 100)), mul: 0.5)}.scope(1)


As you move the mouse vertically downwards the sound gets purer in that the number of sidebands diminishes. As you move the mouse sideways, to the right, the volume intensity of those sidebands increases to the point that you hear new pitches coming out of the sound, but essentially the basic frequency doesn't change.

To summarize in pseudo code (it won't work if evaluated !!) a simple FM instruction will take this form:

Carrier ( Cfrequency + Modulator( Mfreq, ModIndex), overallvolume)


There is another way to see this in supercollider and it is through he use of a phase modulation ugen. Phase modulation is another form of frequency modulation, only that the phase is changed instead of the frequency, however they are basically very similar and sound the same... look at this comparison (Cottle 2005):

Here is a carrier with a frequency of 400hz, modulated by a frequency of 124hz with an amplitude of 100:

{SinOsc.ar(400 + SinOsc.ar(124, mul: 100), mul: 0.5)}.scope(1)

now try the same using phase modulation:


{PMOsc.ar(400, 124, 1, mul: 0.5)}.scope(1)

Can you tell the difference? I can't !!!!

Ok, by now you may have deduced that in the PhaseMod ugen, PMOsc, the first value is Carrier Frequency, The Second is Modulator Frequency and the third is the modulation index. Then we have a phase (called modphase in this case), mul and add just like in other ugens... Much simpler hey?

Now with keywords:

{PMOsc.ar( carfreq: 400, modfreq: 124, pmindex: 1, modphase: 0, mul: 0.5, add: 0)}.scope(1)


Let me copy that line again for you (woithout the keywords), and please change the values while watching the scope window. I would like you to observe first, by keeping the ModIndex at 1, what waveforms appear when the relationship between carrier frequency and modulator frequency changes...

For example look at this:

{PMOsc.ar(400,300, 1, mul: 0.5)}.scope(1)

now look at this:

{PMOsc.ar(400,800, 1, mul: 0.5)}.scope(1)


How are these resulting waves different?


how about the following one?

{PMOsc.ar(400,1200, 1, mul: 0.5)}.scope(1)

versus this one:

{PMOsc.ar(400,1150, 1, mul: 0.5)}.scope(1)


What kind of sidebands to these different ratios between carrier and modulator produce?

Can you predict them in any way?

Now listen to this and try and analyse what is happening:

{ PMOsc.ar( Line.kr(600, 900, 5), 600, 5, 0, 0.1 ) }.play

to make things clearer listen to this:

{SinOsc.ar(Line.kr(600, 900, 5))}.play

now, trying to listen for this sound inside it, listen again to the example above:

{ PMOsc.ar( Line.kr(600, 900, 5), 600, 5, 0, 0.1 ) }.play

As the carrier changes, what happens?
What aspect of the sound is changing?

( I will ask you this in class, and I have already explained this above, I am just trying to get you to really assimilate these ideas!!)

What is happening here in the following case? Which frequency remains the same? (answer this no matter how obvious it sounds!)

{ PMOsc.ar(carfreq: 300, modfreq: Line.kr(600, 900, 5), pmindex: 3, modphase: 0, mul: 0.1, add: 0) }.play


And finally, what is happening here in the following line of code?, listen:

{ PMOsc.ar(300, 550, Line.ar(0,20,8), 0, 0.1) }.play

One more thing, what happens if we modify the code like this:

{ PMOsc.ar( [300, 600], [550, 1200], [Line.ar(0,20,8), SinOsc.ar(0.022, mul: 300, add: 1000) ] , 0, 0.1) }.play

What happened?


We were able to create some inner movement in the sound by using ugens, I won't explain that anymore because I want you to really work it out.

However here is a simple thing we can do and alter without knowing too much. We will use a control structure called Routine. you can use the code below as a shell into which you change the sound producing values, I will document some of it for you, but you could work it out for yourself by now:

( //double click here
var e = Env.linen(2, 5, 2); // a linear envelope to be used for fading the sound in and out by scaling the amplitude of the PMOsc
Routine.run({ //everything below is a routine or job to be done
 {
 { // this is the job, to play a sound and pan it
 LinPan2.ar(
 EnvGen.ar(e, doneAction: 2) *PMOsc.ar(2000.0.rand,800.0.rand, Line.kr(0.0, 12.0.rand,9),0,0.1), 
 1.0.rand2)
 }.play;
 2.wait; //once you made a sound and panned it, wait 2 seconds before...
 }.loop // doing it again !!
}))


go ahead and play with this example for a while... change the envelope, the wait time, the frequencies, plug in a Mouse, etc, etc. Have fun !!!

At the end of this section you should be able to:

1. Explain in your own words the following concepts:
FM Synthesis, sidebands


2. Create lines of code using the following UGens/objects:
PMOsc.ar, Routine.




3. Use the following messages/methods: 
wait, loop, run.



Do the following practice:

1. Using PMOsc.ar, create 
 a. a patch where you control just the modulation index with the mouse. 
 b. a patch where you control just the carrier frequency with the mouse.
 c. a patch where you control just the modulation frequency with the mouse.
2. Make 4 patches where you have more than one FM process going on at once... you can use arrays. hint: look at my last example in the lesson.
3. Create a variation on the routine patch in order to make an atmospheric FM texture.










