
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 5
Lesson 4 


In Class we will have covered the following topics: Harmonics, partials, additive synthesis, arrays.


CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)


An Introduction to Additive Synthesis

At the end of the first lesson study notes, I encouraged you to add waves together using binary operators such as "+". If you did that, you already know that you can get more complex sounds from adding simple waves together. Additive synthesis is a form of synthesis in which the simplest wave, the sinwave is added to other sinewaves to produce complex sounds. Imagine what happens when we have a number of sinewaves and each has it's own tuning and envelope... we would get a sound which is 'uniform' because it is made only of soundwaves, and at the same time it would contain a lot of variations within itself as each sine wave has a different envelope and a different tuning. Additive synthesis is based on the findings of Joseph Fourier (1768-1830), a French mathematician who amongst many other things, was interested in infinite series and how they can be divided into smaller units. His ideas where the basis for a mathematical tool called the Fourier Series which breaks a periodic function into, you guessed it, simpler periodic functions that when added together give you the original periodic function. In audio, complex sounds that are periodic, can thus be broken down into simple periodic sounds (sine waves). This is called a Fourier Transform. As an extension of this, complex periodic sounds can be made from simpler sounds.

Let's go back to our basic idea that a string that vibrates breaks into many related vibrations. We know that these vibrations are multiples of the original pitch of the string. If we play a note on a piano and hold it until it dies out, we can hear how these vibrations become apparent. These vibrations, if you remember, are called harmonics of the fundamental (original pitch).

string_vibs.jpg 



Let's try building a pattern of string vibrations using what we know so far:


( //this is an example adapted from the David Cottle Supercollider3 manual
{
(
 SinOsc.ar(400, mul: 0.1) + SinOsc.ar(800, mul: 0.1) + SinOsc.ar(1200, mul: 0.1) + 
 SinOsc.ar(1600, mul: 0.1) + SinOsc.ar(2000, mul: 0.1) + SinOsc.ar(2400, mul: 0.1)+ 
 SinOsc.ar(2800, mul: 0.1) + SinOsc.ar(3200, mul: 0.1) + SinOsc.ar(3600, mul: 0.1) + 
 SinOsc.ar(4000, mul: 0.1) + SinOsc.ar(4400, mul: 0.1) + SinOsc.ar(4800, mul: 0.1) 
)
}.scope;
)


As you can see above, every frequency from 400hz up is a multiple of 400hz. In this case 400hz is the fundamental and the rest will be harmonics: 800 (400*2) ; 1200 (400*3); 1600 (400*4), etc.

In real life, not all harmonics sound equally loud. The higher ones are softer, in fact, as we go up in the harmonic series (this is what we call a series of harmonics that are derived from the fundamental by multiplications of whole numbers: 2,3,4,5,6,7,8,9,10,11,12,etc.

So, here is another example where the loudness of the harmonics has been adjusted, this would be the parameter MUL, and instead of assigning a fixed value of 0.1 as we did above, we can use fractional numbers to give increasingly smaller values:

( //this is an example adapted from the David Cottle Supercollider3 manual
{
(

 SinOsc.ar(400*1, mul: 1) + SinOsc.ar(400*2, mul: 1/2) +
 SinOsc.ar(400*3, mul: 1/3) + SinOsc.ar(400*4, mul: 1/4) +
 SinOsc.ar(400*5, mul: 1/5) + SinOsc.ar(400*6, mul: 1/6) + 
 SinOsc.ar(400*7, mul: 1/7) + SinOsc.ar(400*8, mul: 1/8) + 
 SinOsc.ar(400*9, mul: 1/9) + SinOsc.ar(400*10, mul: 1/10) + 
 SinOsc.ar(400*11, mul: 1/11) + SinOsc.ar(400*12, mul: 1/12)
)
}.scope;
)


Just do an A-B comparison between the two versions of these sounds as written above. The second is closer to what happens in real life. Now, don't worry, it looks cumbersome and long winded because I want you to go step by step, we will eventually make these with fewer lines of code, but some application of previously discussed concepts will be necessary. In lesson 2, we explained that the values for an envelope could be passed on as an array, so if you need to, go back there and have a look at the idea of arrays...

Are you back now? ok, let's get rid of those pesky plus signs in the example above by using them old square brackets that tell Supercollider that there is an array:

( //adapted from the D. Cottle Supercollider 3 manual.
{
(
 [
 SinOsc.ar(400*1, mul: 1), SinOsc.ar(400*2, mul: 1/2),
 SinOsc.ar(400*3, mul: 1/3), SinOsc.ar(400*4, mul: 1/4),
 SinOsc.ar(400*5, mul: 1/5), SinOsc.ar(400*6, mul: 1/6), 
 SinOsc.ar(400*7, mul: 1/7), SinOsc.ar(400*8, mul: 1/8),
 SinOsc.ar(400*9, mul: 1/9), SinOsc.ar(400*10, mul: 1/10),
 SinOsc.ar(400*11, mul: 1/11), SinOsc.ar(400*12, mul: 1/12)
 ]
)
}.scope;
)

The square brackets tell supercollider that the FUNCTION (that stuff within the curly brackets, in this case everything!) is to make all of those values at once, this is an ARRAY.

We will look at arrays in greater detail later on... for now let's do something else, let's use our knowledge of nesting in order to make the code another step simpler:

(//this is an example from the David Cottle Supercollider3 manual
{
f = 261; // here we declare a variable called "f" which will be the fundamental.
[
 SinOsc.ar(f*1, mul: 1), SinOsc.ar(f*2, mul: 1/2),
 SinOsc.ar(f*3, mul: 1/3), SinOsc.ar(f*4, mul: 1/4),
 SinOsc.ar(f*5, mul: 1/5), SinOsc.ar(f*6, mul: 1/6), 
 SinOsc.ar(f*7, mul: 1/7), SinOsc.ar(f*8, mul: 1/8), 
 SinOsc.ar(f*9, mul: 1/9), SinOsc.ar(f*10, mul: 1/10), 
 SinOsc.ar(f*11, mul: 1/11), SinOsc.ar(f*12, mul: 1/12) 
]
}.scope 
)

because we are using an array, supercollider opens a channel for each element of the array, and we only have 2 channels, not 12. Scope shows us all the waves together, try pressing the letter "m" on your computer keyboard, for a change of size to the scope window... and now, to see all the sines overlaid, press the lettter "s"...

ok, that shows you all of the sine waves playing at the same time, you see them individually and then you see them overlaid... 

but what happens if you mix them down? Well, we were previously seeing the 12 harmonics but not hearing them...let's tryhearing. it is as simple as adding the Mix ugen which will blend them into one single wave in mono, since the array is inside Mix, it gets bounced down into one channel:

(
{
f = 261; 
Mix.ar([
 SinOsc.ar(f*1, mul: 1), SinOsc.ar(f*2, mul: 1/2),
 SinOsc.ar(f*3, mul: 1/3), SinOsc.ar(f*4, mul: 1/4),
 SinOsc.ar(f*5, mul: 1/5), SinOsc.ar(f*6, mul: 1/6), 
 SinOsc.ar(f*7, mul: 1/7), SinOsc.ar(f*8, mul: 1/8), 
 SinOsc.ar(f*9, mul: 1/9), SinOsc.ar(f*10, mul: 1/10), 
 SinOsc.ar(f*11, mul: 1/11), SinOsc.ar(f*12, mul: 1/12) 
])*0.1
}.scope 
)

Do you recognize this shape? What do we call a this waveform?
If you don't remember, go back to lesson 1 and read up on basic waves.

What I didn't tell you then is that this kind of waveform contains the whole harmonic series derived from the fundamental. That is the "harmonic fingerprint" as it were.

Two things to note from our latest bit of code above, first, try just substituting the value of "f" for other numbers to get different pitches, this is one of the beauties of supercollider, being able to change one number and getting a whole new set of values... however, notice that no matter which pitch you choose, the waveform looks the same, the "fingerprint" is kept. This is because the pitch changes but the TIMBRE doesn't ! This fingerprint of the sound, is called the timbre, 

secondly note that upon beginning our function all we did is write:

f = 261; //a slightly out of tune middle C !


normally in supercollider, when you are going to use a variable you must "declare" it:

var f=100; 

but single letters can be used without having to write "var".

We were saying that timbre is the fingerprint of the sound, and that timbre results from having a certain group of harmonics present. This means that if we change any harmonic, we get a different timbre...

here is the code again, please spend some time changing just one harmonic and listening to the results:

I'll start, I will look at the 3rd partial (a harmonic is a partial) and change its ratio (the relationship between itself and the fundamental) from 4 to 4.5, a minute change, right? have a listen to see if such a small change can make a difference:

(
{
f = 261; 
Mix.ar([
 SinOsc.ar(f*1, mul: 1), SinOsc.ar(f*2, mul: 1/2),
 SinOsc.ar(f*3, mul: 1/3), SinOsc.ar(f*4.5, mul: 1/4),
 SinOsc.ar(f*5, mul: 1/5), SinOsc.ar(f*6, mul: 1/6), 
 SinOsc.ar(f*7, mul: 1/7), SinOsc.ar(f*8, mul: 1/8), 
 SinOsc.ar(f*9, mul: 1/9), SinOsc.ar(f*10, mul: 1/10), 
 SinOsc.ar(f*11, mul: 1/11), SinOsc.ar(f*12, mul: 1/12) 
])*0.1
}.scope 
)

now you try it and note in a piece of paper your observations about which kinds of numbers give what kind of sound... it can be subjective and that is ok, some harmonic ratios will yield 'warm' sounds, others will yield 'metallic' sounds, and so on.


ok, enough of writing everything out, let's look at how to use our knowledge so far to make some interesting sounds without having to write each partial out in full...


first let's create an additive sound using our Mix ugen and an array... but since we have only looked at what an array is (see above), we will need to see how to generate one.

Here's an easy one. If you want to make an array which contains all the numbers, say from 1 to 12, then you just write:

(1..12)


place your cursor on the line and evaluate it, and look at the supercollider window (we can call it the 'post' window because things get posted there, it actually starts out when you launch the program and it is an 'untitled' window).

you will get this:

[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]

try it again with some values that could be frequency values such as:

(440..500)


now you get this in the post window:

[ 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500 ]

as you can see, all the values between 440 and 500 ...

so if you would like to write the code to make a sound with all these frequencies then you could try this very rough code, which we will refine progressively:

(
 {
 Mix.ar(
 SinOsc.ar(freq: (440..500), mul:0.1 //where a single frequency value would go we put an array !
 ) // remember that for each frequency a separate SinOsc is created, in this case 60 oscillators are made
 )
 
 }.scope(1)
)

what could be happening here? 

why does the sound throb like that? think about it. Each sine wave has a different frequency so they will come in and out of phase periodically... so different ones will coincide in their peaks at different times, hence the throbbing.

Also, it distorts, so let's simplify a bit and just make 10 oscillators...

(
 {
 Mix.ar(
 SinOsc.ar(freq: (440..450), mul: 0.5 //where a single frequency value would go we put an array !
 ) // remember that for each frequency a separate SinOsc is created, in this case 60 oscillators are made
 );
 
 }.scope(1)
)

ok, but it still distorts... and this is because the array generates 11 oscillators... inside the Mix ugen, test it:

(440..450); //evaluate this and count them.

so, the code above, earlier, actually contains this:

SinOsc.ar(freq: (440), mul: 0.5)+
SinOsc.ar(freq: (441), mul: 0.5)+
SinOsc.ar(freq: (442), mul: 0.5)+
SinOsc.ar(freq: (443), mul: 0.5)+
SinOsc.ar(freq: (444), mul: 0.5)+
SinOsc.ar(freq: (445), mul: 0.5)+
SinOsc.ar(freq: (446), mul: 0.5)+ etc, etc...

at least you must admit we have made it simpler ! Anyway, the thing is, we have 11oscillators each with an amplitude of 0.5, because in nesting an array where the frequency would go, supercollider creates one ugen for each frequency value generated by the array, and it assigns mul: 0.5, as above, to all of them, unless we tell it different. So, to get rid of distortion we could do this:


(
 {
 Mix.ar(
 SinOsc.ar(freq: (440..450), mul: 0.05) // now each oscillator has an amplitude of 0.05 
 );
 
 }.scope(1)
)

now, we could have different values for each partial... one array to match the other !
the frequency array is indicated shorthand by the (440..450) notation, but the MUL array is written out in full... thus:

(
 {
 Mix.ar(
 SinOsc.ar(freq: (440..450), mul: [0.05, 0.01, 0.1, 0.02, 0.07, 0.01, 0.05, 0.05, 0.02, 0.05, 0.02] ) // now each oscillator is paired with its corresponding value in the written-out array... 
 );
 
 }.scope(1)
)

in acoustic sounds, each partial has a different amplitude, this is what makes sounds unique.

By now, we may be getting a bit bored of having sounds come out of one channel alone, so enter the handy Pan ugen:


Pan2 - 

Equal power stereo panning of a mono source

Arguments: in, pan position, level

pan controls typically range from -1 to +1

so let's try it out:


( //this script allows you to use the mouse as a pan controller...
{ 
Pan2.ar(BrownNoise.ar, // input sound (sound to be panned)
 MouseX.kr(-1,1), // pan position value, between -1 and 1 given by mouse movement
 0.3) // how loud the sound will be, a value between 0 and 1
}.scope(2);
)




(//this script controls the pan by using values made by the SinOsc, between -1 and 1
 // remember that this is the default range of waveforms...
{ Pan2.ar(BrownNoise.ar, // input sound (sound to be panned)
 SinOsc.kr(0.2), // pan position values made by the SinOsc
 0.3) // how loud the sound will be, a value between 0 and 1 
}.scope(2);
)



Now if we go back to our arrayed additive code, we can pan it :

(
 {
 Pan2.ar(
  Mix.ar( // the content of this Mix ugen is the sound to be panned (called the INPUT)
  SinOsc.ar(freq: (440..450), mul: [0.05, 0.01, 0.1, 0.02, 0.07, 0.01, 0.05, 0.05, 0.02, 0.05, 0.02] )
 ),
 0, // a fixed pan position, right in the middle !!
 0.3 // keeping it quiet. 
 );
 
 }.scope(1)
)

Same thing but panning dynamically:

(
 {
 Pan2.ar(
  Mix.ar( // the contents of the Mix ugen are the sound to be panned
  SinOsc.ar(freq: (440..450), mul: [0.05, 0.01, 0.1, 0.02, 0.07, 0.01, 0.05, 0.05, 0.02, 0.05, 0.02] )
 ),
 MouseX.kr(-1,1), // a dynamic pan value by MouseX.kr
 0.3 // keeping it quiet. 
 );
 
 }.scope(1)
)


To finish this week's study notes, I would like to show you some other ways of making arrays. For additive synthesis this is very useful as we can define with a kind of formula what the harmonic content will be...

Ok, let's recap, and remember that you can test each line of code separately and check the post window to see how supercollider evaluates it.

An array is a collection of objects, numbers or symbols or words enclosed in square brackets:

[1, 2, 3, 4, 5,] // evaluate this and look at the post window, the array returns itself !

Or

[32, 54, 58, 96, 57] //evaluate and see...

If the sequence of numbers is predictable in some way then it can be written 'shorthand'. For example if the numbers are consecutive, and we want all integers from 1 to 10 then we can write it like this:

(1..10) //evaluate and look at the post window


Now, here is something new. If you want all the even numbers from, say, 2- 10, then you can write it like this:

(2,4..10) //evaluate and look at the post window


As you can see, the first two numbers determine the 'step' and the last number is the last number of the series:


(1,3..15) //evaluate and look at the post window, we could call this a 'stepped" array 



So here is for example a SinOsc with only certain frequencies determined by the array shorthand:

(
{ 
Pan2.ar( // so we can place the sound we use Pan.ar
 Mix.ar( // the sine ugen inside this mix is the input to the pan ugen
 SinOsc.ar( (440,500.. 1300), mul: 0.1);
 ),
 0, //let's just pan it center for simplicity
 0.1); //.. and make sure it is quiet and does not distort
}.scope 
)

listen carefully to the example above, can you perceive that it has different partials? that they sound somewhat unrelated, i.e. not like the sound of a flute where the harmonics are natural, but these harmonics or partials are rather arbitrary. 

This is because they are given by the formula: 

(440, 500.. 1300) //evaluate and look at the post window

Still, this is one of the very cool aspects of synthesis: we can create timbres that have never been heard or at least that do not appear in nature !

Another new way to generate an array is by creating a rule...
Look:

Array.fill( 5, 2); // evaluate...

The method 'fill' tells the ugen 'Array' to fill 5 slots, each with the number 2.

But that is a bit boring, how about we make it more interesting?
try evaluating this:
 
3.rand;

and again...

3.rand;

and again...

3.rand;


everytime it returns a number between 0 and 3, not including 3. So we could try this:

Array.fill(5, 3.rand);

But that evaluates 3.rand once and fills the five slots with the same result, so let's try using a function, remember that any operation within curly brackets is a function so:

 
 Array.fill(5, {3.rand}); // evaluate several times and look at the post window...

The method 'fill' tells the ugen 'Array' to fill the 5 slots, each with the result of evaluating the function which contains the 'rand' method applied to the number 3.

Here is another one:

Array.fill(16, {100.rand});

And applied to sound:

{Array.fill(16, {SinOsc.ar(400.rand, mul:0.1) }) }.play //evaluate several times and compare...
 
 Remember that we are only listening to the 2 first channels unless we use a Mix, so:
 
{Mix.ar(Array.fill(16, {SinOsc.ar(400.rand, mul:0.01) }) ) }.play //you can rewrite this in several lines

And that unless we pan it it will all be on one channel once we mix, so let's also do this:


( //double click this parenthesis
{Pan2.ar(
Mix.ar(Array.fill(16, {SinOsc.ar(400.rand, mul:0.01) }) ), //make sure each sine is quiet with mul !
0,
0.6) //the volume of the panned input can then be raised
 }.play
 )
 
 As you can hear if you evaluate the code above, each time you get a new and interesting timbre. Later on we will see how we can shorthand that as well so we can create these beautiful timbres and envelope them and harness them in many ways, for now we will persevere with understanding how they are created. Of course you can import these sounds into Logic Pro and feed them into the EXS24 Sampler and play them with the keyboard... There are no commercial synthesiszers that can do additive synthesis like supercollider. At most you will find they have only 3 oscillators... Above, we made 16 with a single line of code !! And we could've made 500... just make sure you adjust the volume (amplitude) to avoid distortion.


Here is the last array trick we are going to learn this week, it involves keeping a count of what we are doing for each slot... we have actually done this before in a modest way...

remember this ?

(0.. 10);

you could also do it like this:

Array.fill(11, {arg counter; counter}) //explained below...

The only new thing here is the function  {arg counter; counter} because it contains the keyword 'arg'... it stands for ARGUMENT. It is a computing concept, an argument is like a variable, but it comes 'from outside the function'. In this case, the programmer who created the class 'Array' (James McCartney, creator of Supercollider), made it so that if an argument is declared inside the function, each time a slot is filled, the numebr of the slot is passed to the argument... sounds complicated but it isn't. 

(
Array.fill( //create an array
 11, //make 11 slots
 {arg counter; counter} // each time, the number of the slot being //made is assigned to 'counter' and put in the slot
 )
) 


So... to fill this array we create the first slot, then the number 1 is assigned to the argument 'counter' and this value is placed in the slot. How is this useful? Think of the harmonic series. Remember that each partial is a multiple of the fundamental frequency, so if we wanted to generate the first 16 partials of a giiven frequency we could use the code above to fill each slot.


(
var fund=400; // declare a variable for the fundamental freq
Array.fill( //create an array
 16, //make 16 slots for the harmonnics
 {arg counter; counter*fund} // fill each slot by multiplying the number of the slot times the //fundamental, so you get 1*fund, 2*fund, 3*fund 
 //and so on... does it ring a bell? 
 )
) 

If you evaluated the code above, you will have calculated the first 16 harmonics. But there is a hitch... the first one is 0 because the first slot is called '0'... how can we solve that? Let's use another computing trick to create a variable called 'partial' that will allow us to start at 1 and not 0...

(
var fund=400; // declare a variable for the fundamental freq
Array.fill( //create an array
 16, //make 16 slots for the harmonnics
 {arg counter; var partial; 
 partial= counter+1; //this way we don't start at 0 !!
 fund*partial} 
 )
) 


Now that you have several methods to generate arrays, you can experiment with additive waves, make your own, remember to use mix and pan... try using variables to simplify your code...

At the end of this section you should be able to:

1. Explain in your own words the following concepts:
Additive Synthesis, Harmonic Series, Array, Timbre, Partial, dynamic panning, Multichannel expansion, argument


2. Create lines of code using the following UGens:
Mix, Pan2, Array.



3. Competently use the following messages/methods: 
rand, kr, fill.


Do the following practice:

1. Write out some code where you choose explicitly the frequencies in the array so they are not just continuous numbers.


2. Write the code for a sound that is panned by using the mouse and that contains as frequencies a 'stepped' array.

3. Write the code for a sound that contains 500 oscillators, does not distort and is panned dead center.


4. Write the code for a sound that contains 500 oscillators, does not distort and is panned automatically by a square wave.

5. Challenge: Can you make an additive sound that contains the first 16 partials of the harmonics series using Array.fill.






