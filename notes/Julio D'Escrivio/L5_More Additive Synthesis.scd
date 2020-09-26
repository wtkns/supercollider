
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 6
Lesson 5 


In Class we will have covered the following topics: more on arrays and partials, including reciprocals and ways to calcualte the harmonics in terms of the fundamental. Midi values in hertz.


CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)


More on additive synthesis...

Let's review for a second what we know so far. When an array is plugged in to a ugen such as a SinOsc or any other ugen, this ugen is reproduced for every item of the array. It doesn't matter where it is plugged in ! for example:

{SinOsc.ar(freq: [200,300])}.play //it will distort because both channels default to //Mul: 1

will create two SinOsc ugens, one on the left and one on the right, with 200hz and 300hz for their frequencies, each with the default MUL and ADD since these were not specified...

but...

{SinOsc.ar(freq: 300, mul: [0.2, 0.8]) }.play

will create two SinOsc ugens, one on the left and one on the right, this time both have the same freq as there is only one value there, but their amplitude will be different, 0.2 on the left and 0.8 on the right, this is, louder on the right.

Also, do remember that when arrays create ugens, they get assigned to a separate audio channel each, so in order to hear them all at once we need to use Mix.ar to bounce them down to one channel !!

...and when arrays do their thing in the way described above, we call it "multichannel expansion"... even if later we bounce down to one channel.

Remember that partials that are multiples of the fundamental are called harmonics, and this is the case of the sounds that are produced by musical instruments like the flute, the piano or the trumpet. Partials that are not related to the fundamental are called inharmonics and we explored them when we synthesized sounds using unrelated frequencies. The partials produced by bells are inharmonics.

Let's try making some more interesting sounds by firing up lots of ugens with different frequencies. First I want to show you two things you can do with supercollider... the first is calculating the frequency of a given midi note. This is, to translate from midi notes to hertz (cycles per second). It is done by applying the message "midicps" to a midi note number:

60.midicps; // middle C

As you can see from the post window, supercollider returns the value 261.62556530114, and this is the frequency in cycles per second of middle C.

equally if we ask for

69.midicps; // A above middle C

we get 440cps, the most common frequency used for tunning forks.

so, let's use the midicps method to make some sounds:

( 
{
( 
 Mix.ar( 
 SinOsc.ar( 
 [60, 64, 67, 71, 74, 78].midicps, // a major 7th chord !
 mul: 0.1) 
 ) 
)
}.scope(1) 
) 


before you go on, try running the above example after changing the midi note numbers to see the different sounds you can generate by creating chords...but to help you, I'll start, here is a major chord:

( 
{
( 
 Mix.ar( 
 SinOsc.ar( 
 [60, 64, 67].midicps, // a major chord 
 mul: 0.1) 
 ) 
)
}.scope(1) 
) 

and here is a minor chord:

( 
{
( 
 Mix.ar( 
 SinOsc.ar( 
 [60, 63, 67].midicps, // a major chord 
 mul: 0.1) 
 ) 
)
}.scope(1) 
) 


Go on, give it a try. Experiment with any arbitrary number combinations...

Now, let's look at another method ( remember that a method is something that can be done to an object... we covered this earlier in the course, but just in case...). This is a method for obtaining random numbers from a given range.

It is called "rrand" and it must be provided with a lower and an upper limit, like this:

rrand(2, 5); // range-random (low value, high value)

evaluate it several times and look at the post window...

a random value between 2 and 5 is returned each time.

now, let's use decimal numbers, in supercollider all we have to do is add the decimal point:

rrand(2.0, 5.0); // now 2 and 5 are expressed as decimals.

evaluate it and look at the post window...

a random number with decimals is produced within the range.

now, let's put together a few things we have covered to make something new, here is a script with comments, study it carefully, it incorporates envelopes, you may just want to revise envelopes before you carry on, (or not !?) in any case have a look at the code below and then read the explanations that follow, as I am anticipating some new points will come up...

( 
{ 
t = Impulse.kr(2); //we assign an impulse ugen to the variable t, we will use it to trigger the Env
 Mix.ar( // bounce down to one channel
 SinOsc.ar( 
 [60, 64, 67, 71, 74, 78].midicps, // make an array of six frequencies, a chord !
 mul: EnvGen.kr( // you need an EnvGen to be able to run the Env
 Env.perc(0, 1), // we choose a percussive one, you could try others here... 
 t, // the trigger we declared earlier
 levelScale: 1/(1..6), // scales the breakpoint for each freq: 1/1, 1/2, 1/3, 1/4, 1/5, 1/6 
 timeScale: rrand(1.0, 3.0) // scales the breakpoint durations 
 )*(0.1) //scales the whole envelope !
 ) 
)*[0.5, 0.5] //creates multichannel expansion AND scales the two resultant channels 
}.scope(1) 
) 

Some comments:
1. Notice that we assigned the impulse ugen to the letter "t" for trigger so we could then nest it into the EnvGen.

2. We gave levelScale a value of 1/(1..6) and that looks admittedly confusing. This is because it is shorthand for 1/1, 1/2, 1/3, 1/4, 1/5, 1/6. Remember that the (1..6) is shorthand for the array [1,2,3,4,5,6].

3. Scaling. Scaling is multiplying a value by a number to make it larger or smaller. If we have the value 4, we can scale it by multiplying it by 0.5, this will result in the value 2. This is very handy because you can multiply our waveform-making ugens by a number to make them quieter ! just try it:

{ SinOsc.ar(261)*(0.01) }.play; //sounds quiet

{ SinOsc.ar(261)*(0.1) }.play; //sounds a bit louder

{ SinOsc.ar(261)*(0.2) }.play; //sounds louder still

and, two birds with one stone (no pun intended):

{SinOsc.ar(261)*[0.2, 0.3]}.play // scales and also expands the ugen to two //channels


In the previous example of code where we used Trigger to generate a steady pulse we used the same envelope for all the partials, yet this is not what happens in real life as we have discussed before, so have a look at this example from the Cottle manual; A new ugen is introduced, TRand. If you consult the help file for it you will see that all it does is generate a random float (decimal) value when it recieves a signal and this signal changes from negative to positive. Listen to this example, then, and notice how each strike is different in timbre, also notice that you can multiply the SinOsc ugen by the envelope, because in any case, that is what an envelope does, it scales the sound:


( //ADDITIVE SAW WITH INDEPENDENT ENVELOPES

//double click on this parenthesis to get the sound going
{
var gate, fund;
gate = Impulse.kr(0.6); // this is for triggering the TRand
fund = MouseX.kr(50, 1000); // you can change the fundamental by moving the //mouse horizontally

Mix.ar( // we mix to get the 16 partials into one channel
 Array.fill(16,
 {arg counter;
 var partial, envelope;
 partial = counter + 1; // so we don't have a freq of value '0'.
 envelope = EnvGen.kr(Env.adsr(0, 0, 1.0, TRand.kr(0.2, 2.0, gate)), //TRand has been plugged in to the release value gate, // the Impulse ugen triggers the EnvGen 
 1/partial ); // each instance of the envelope has a different amplitude, and they decrease as the number of the partial grows...
 
 SinOsc.ar(fund*partial)*envelope; // finally, each slot in the array is filled // with this recipe... the harmonic // series
 }
 )
 )*0.2 //scaling the overall volume
}.scope(1)
)


It is worth spending some time analysing and understanding the patch above. See what values you can change to get different sounds and different pulses from it.


Here is another patch or code that Cottle, in his manual, calls the "gaggle of sines" it changes constantly... have a listen and read the comment, then try changing values to learn what is happening:


(
{
var harmonics = 16, fund = 50; 
Mix.fill(harmonics, // number of partials, defined above
// we are filling the Mix ugen directly: no Array ugen is necessary. we can still 
// create the array by instructing Mix to be 'filled', fill is a method that Mix understands! 
 {arg count;
 Pan2.ar( // each slot will be panned individually
 FSinOsc.ar( //another type of Sine ugen
 fund * (count + 1), // calculates each harmonic
 mul: FSinOsc.kr(rrand(1/3, 1/6), mul: 0.5, add:0.5 )),
 // the amplitude is modulated up and down by this // FSinOsc
 1.0.rand2) //the volume(amplitude) is random for each slot
 }
 ) / (2*harmonics)
}.play;
)

When the array is made by sending the 'fill' method to the Mix ugen, each slot has it's own partial and its MUL or amplitude is being controlled by an FSinOsc, which because of its smooth shape, creates a crescendo-decrescendo for each slot.

we can isolate that particular effect by making a sinewave whose amplitude is modulated in the same way:

{FSinOsc.ar( 300, mul: (FSinOsc.kr (0.2)) )}.scope //listen and look in the scope window

You will notice that the modulating sine has a very low frequency and that the method used is 'kr'.



(
{
var trigger, fund;
trigger = Dust.kr(3/7); //trigger at random...
fund = rrand(100, 400); //choose the fundamental from a value between 100 and 400
Mix.ar(
 Array.fill(16, // sixteen slots with the following recipe:...
 {arg counter;
 var partial, envelope;
 partial = counter + 1; //so we don't start from '0'
 envelope = EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0), trigger, 1/partial);
 Pan2.ar(
 SinOsc.ar(freq: fund*partial, mul: envelope)*max(0, LFNoise1.kr(rrand(5.0, 12.0))), // the sound to be panned, see below
 1.0.rand2) // the pan position, rand2 returns values between -1.0 and 1.0 
 })
 )*0.5 //overall volume achieved by scaling the entire thing by 0.5
}.play
)

the use of 'max' above is very interesting because it ensures that the SinOsc in each slot is scaled differently, and because LFNoise1 produces continuous 'gliding' values then the different SinOsc in each slot are forever growing in volume or disappearing in a very 'organic' way, also since these glides are random, we get an unpredictable and 'natural' feel. Sometimes the SinOsc is even silenced when the values returned by LFNoise are negative, ensuring in this way that the different partials can also 'glide' to silence.

One of the advantages of code is that we can build on our previous efforts, so let's take the code above and make an array where each slot is filled with a developing sound, according to the 'recipe' above !!


(
{
var trigger, fund, flashInst; //the variable flashinst is the name we will give to our array...
flashInst = Array.fill(5, //fill five slots with...
 { //the recipe inside these curly brackets
 trigger = Dust.kr(3/7);
 fund = rrand(100, 400);
 Pan2.ar(
 Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0), 
 trigger, 1/partial
 ) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
 })
 )*0.2,
 1.0.rand2)
 });
Mix.ar(flashInst)*0.6 //having named the array, all we need do now is apply the Mix //ugen to the variable flashInst
}.play
)

Now I will show you some more examples made by D. Cottle and comment them, you can use these and all the previous ones we have looked at as the basis for creating your own, don't be afraid to experiment !!

Some of the techniques in these examples are advanced, but there is no harm in observing them, one we should mention is a close cousin of the "max" method we saw above, it is another 'max' trick. Remember where we multiplied the The EnvGen by max(0, LFNoise1.kr(rrand(5.0, 12.0))? well it's kind of complicated but at least you know you can plug that line in a similar place even if you don't fully understand it !! try it and you will see, for example here:

{SinOsc.ar(440)*max(0, LFNoise1.kr(rrand(5.0, 12.0)))}.scope

now try it with a fixed frequency for LFNoise1...

{SinOsc.ar(440)*max(0, LFNoise1.kr(3))}.scope


see? the max is a method that chooses the maximum between two values. The LFNoise spits out continuous gliding values between -1 and 1, in this case, changing the start and end points of the glides 3 times per second. 'max' ensures that we don't use the negative numbers and so we never go below 0. This is useful because it creates curves that grow and decay from 0. If you understand this, great. If you don't just use it as above and experiment some more. It will come !!!

Anyway, let's look at these Cottle examples and comment them:


In this first one, an array is made with 16 harmonics (the partials are multiples of the fundamental). 


look:

(
{
 var harmonics = 16, fund = 50, speeds;
 speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/5;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(speeds.wrapAt(count)))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

The fundamental is set at 50Hz, you could change that if you like. A variable called 'speeds' is declared. It is an array of 11 elements divided by 5. This means that each element of the array is divided by 5... so

[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/5

is the same as

[1/5, 2/5, 3/5, 4/5, 5/5, 6/5, 7/5, 8/5, 9/5, 10/5, 11/5]

or:

[0.2, 0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, 2.2]

this array is called speed because we are going to use each element as the speed of change of the MUL value for each sinewave in each slot.

As we said before, we will use a 'max' object... have a listen:


(
{
 var harmonics = 16, fund = 50, speeds;
 speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/5;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(speeds.wrapAt(count)))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)




in the example above, 16 slots get filled. Each one has a different frequency given by the fundamental. Also, each one has different tremolo, or amplitude variation, given by the choice of one element of the array each. This is done with the message 
"speeds.wrapAt(count)". If you want to learn more about the messages understood by Arrays, you can double click on the following words:

Array

ArrayedCollection 

In ArrayedCollections you can see the message "wrapAt(n)", basically, in "speeds.wrapAt(count)" it reads the value in the array 
"speeds" that is held in the position "count", if the count is greater than the number of positions of the array then it "wraps" back to the beginning... 

let's try it: (remember that positions in computing start at 0 !)

[1,2,3].wrapAt(0)

returns 1, because 1 is at position 0.

[1,2,3].wrapAt(4)

returns 2, because it wraps from position 2 which contains 3 (remember the positions go 0,1,2...), to position 3 which contains 1 (because we have 'wrapped' to the beginning, position 0) and then position 4 which contains 2.

wrapAt means you count through the position however meany times you are asked to, so above you are doing 0,1,2,0,1,2, 0,1,2,0,1, etc 
wrapping to 4 would then be: 0,1,2,0,2 
the number at position 4 is 2 !

see:
pos 0 contains 1
pos 1 contains 2
pos 2 contains 3 (we only have three elements so now we must wrap to the beginning...)
pos 3 contains 1
pos 4 contains 2


The use of the "max" method, is the trick that prevents the results MUL from falling below 0 !!



Here is another cool example:

(
{
 var harmonics = 16, fund, speeds;
 speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/20;
 fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(speeds.choose))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

This time, the mouse changes the fundamental and the elements of the array "speeds" that will be used as frequencies, are decided by the method "choose" which as it name implies, chooses randomly from the array.

The line of code that determines how the mouse will behave is worth commenting.

"MouseX.kr(0, 36).round(7) + 24"

the line above divides the X axis of the screen into 37 steps (0-36), so the mouse can give any value between 0 and 36 according to how far you move it left to right or viceversa.
 
so let's work out what the other methods do...
 
say the mouse is near the left and produces the value 5. 
Let's apply the method "round(7)".

5.round(7);

result = 0.

now, let's say the mouse is around mid-screen, at 18.

18.round(7);

result = 21.

Can you make an educated guess about what is happening?...

...That's right every value that is evaluated is rounded to the nearest multiple of 7. 

Let's look at the original expression again:

MouseX.kr(0, 36).round(7) + 24

so, we know that we are rounding the mouse position to a multiple of 7 and then adding 24. This is done to get the mouse values to produce notes that are higher in the midi range so they can be appreciated better and 7 is the number of semitones that make the interval of a perfect fifth, In this way when we move the mouse on screen we get sounds that go up or down in fifths. You can try changing the numbers within the mouse line and see what happens.




Finally, the following example has a random frequency modulating the amplitude and a random total amplitude !


(
{
 var harmonics = 16;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 exprand(100, 2000),
 mul: max(0, FSinOsc.kr(rrand(1/3, 1/6))*rrand(0.1, 0.9))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)


At the end of this section you should be able to:

1. Explain in your own words the following concepts:
scaling.


2. Create lines of code using the following UGens:
Array, Mix, FSinOsc, Pan2.



3. Competently use the following messages/methods: 
fill, max, wrapAt, rrand, Trand, rand2.


Do the following practice:

1. What is the difference between all the random methods we have used?

2. Create a sound that contains 24 harmonics and where each harmonic has an envelope with different values.

3. Create a sound that contains 24 harmoics, controlled by the vertical movement of the mouse and where the pitch jumps in octaves.

4. Create a sound where the frequency of the partials is different each time we evaluate the code.


5. (from Cottle) Using any of the additive patches above as a model, create a harmonic collection 
of only odd harmonics, with decreasing amplitudes for each partial. What is the 
resulting wave shape? 


6. (from Cottle) Modify the "additive saw with independent envelopes" patch above so that all the decays 
are 0, but the attacks are different (e.g. between 0.2 and 2.0 seconds). Use a 
random function if you'd like. 





