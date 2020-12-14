
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk

Sound and Synthesis
MUB2004
Week 2
Lesson 1 

In Class we will have covered the following topics:
The nature of sound. Sound transmits through air
Modes of excitation: plucking, bowing, blowing, etc.
The concept of overtones of a fundamental frequency. An overview of synthesis methods
The sine wave. Other Basic Waves.

CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)



--Making a sound: If you have launched Supercolider, first you must look for the two grey windows that are called "Localhost server" and "internal server" and switch them on. That is, click on the button called "boot" -you can ask me later where this term comes from, it is a quaint reference to real life in the mid 20th century :))) The boot button will now turn to display "Quit" -in case you want to turn it off. The name of the server will be displayed in red and some numbers and percentages will appear below, which we needn't worry about.--



As explained in class, here is the simplest sound you can make, it is called a sine wave, it has no "overtones" meaning that it has no sounds that resonate in sympathy to the main base tone or "fundamental" sound you hear. Other soundwaves have different overtone content, the sine wave has none, for this reason it is very simple... 

To recap on class information, a string vibration is quite complex and produces a number of vibrations that relate to the fundamental, the sinewave only produces the fundamental, here is a picture of a string vibrating with its overtones or harmonics to refresh your memory:


string vibs.jpg 

A pure sine wave can only be made electronically, isn't that appropriate for us?

so let's start here:

{SinOsc.ar}.play;

in order to make the computer play this sound, you must place the cursor(the blinking stright line on the screen!) somewhere within the instruction line, or at the end, and press ENTER (_not RETURN_) this way the computer knows you wish to send that instruction. Try it.

{SinOsc.ar}.play;

You could also highlight the text and press ENTER.


To stop the sound, press and hold the apple key (it is actually called the command key) plus the "." key.

The instruction SinOsc means that we want to play a sine wave. the instruction".ar" means at audio rate
which is to say above 20cps and up to 20.000cps.

In Supercollider, the simplest way to play a sound is by using the curly brackets and the instruction "play".

Things in curly brackets are called FUNCTIONS. Things like SinOsc or indeed all the other noise making or processing devices, are called UGens, which means Unit Generators (how about that for sci fi terminology? :)

Supercollider is an Object Oriented Programming Language, or OOP. Everything we use in supercollider, or SC, is an "object"...

This means that ever character, bracket, number or word that is used in SC is considered an object.

Objects are sent messages to change them or to 'make them happen'... thus:

{SinOsc.ar}.play;

means that the Object SinOsc, within curly brackets, should be 'played' at 'ar' or audio rate. A sinewave will be played. The ";" is to show the computer where the instruction ends.

The following explanation taken from David Michael Cottle's tutorial manual for Supercollider 3 is a great introduction to the idea of OOP:

>>>>
Sandwich.make 
The terminology of object oriented languages is more difficult because the object names and 
messages are often cryptic acronyms (Synth, PMOsc, LFNoise0, midicps, rrand, etc.). So I'll 
use familiar fictitious objects and messages to explain how they work. (These examples 
won't work in SC!) If you are comfortable with these terms, you can skip this section. 
Suppose we had a virtual sandwich maker and a virtual tofu based meat substitute both of 
which understood smalltalk commands. I'll call these fictitious objects Sandwich and Tofu. 
Every object understands a collection of messages. The messages tell the object what to do. 
Likewise, there are many objects that understand any given message. The power of object- 
oriented languages lies in the way you can mix and match messages and objects. 
For example, let's assume that Sandwich understands three messages: make, cut, and bake. 
And that Tofu understands three messages: bake, fry, and marinate. The syntax for sending 
the make message to the Sandwich might be this: 
 
Sandwich.make; 
If you wanted the Tofu to be baked you might write: 
 
Tofu.bake; 
You may be wondering if we need to give the make message and the bake message some 
arguments to describe how the sandwich is made and the tofu is baked. Actually we don't. 
Most messages have default values built into the code so you can leave them off provided the 
defaults are appropriate for your project. Try running the line below, which uses no 
arguments in the .ar or .play messages, in SC. 
 
{SinOsc.ar}.play 

The result is a sine tone at 440 Hz, 1.0 amplitude, at 0 phase. Those are the defaults for 
SinOsc. Often you are able to use one or two of the defaults, but rarely will you use a 
message with defaults only. 
Before adding arguments we need to know what each of them means. To find out you use the 
help files. 
In each of the help files are prototypes of all the messages understood by that object, with the 
list of arguments the message uses. Sandwich and Tofu might be documented this way: 
 
Sandwich 
 
 *make(vegArray, bread, meat) 
 *cut(angle, number) 
 *bake(temp, rackLevel) 
 
Tofu 
 
 *bake(temp, baste, rackLevel) 
 *fry(temp, length, pan, oil) 
 *marinate(sauce, time) 
It is important to understand that for a message argument list changes for different objects. 
That is to say the bake message used with Sandwich has two arguments, while when used 
with Tofu it has three. Not understanding this, and using the same arguments with a message 
to different objects is a common beginner error. When bake is used with Sandwich, as in 
Sandwich.bake(20, 2) the 2 is rack level, while in Tofu.bake(20, 2) the 2 is baste time. 
Remember; argument lists are not interchangeable. 
Now that we understand what the arguments for Sandwich.make are, we could put together a 
Sandwich with this mock code. 
 
Sandwich.make([lettuce, tomato, pickle], rye, chicken) 
or 
 
Sandwich.cut(90, 1) 

and 
 
Tofu.marinate(peanut, 160) 
The first line will make the Sandwich using an array (list) of vegetables17, bread, and chicken. 
The second line will make one cut of the Sandwich at an angle of 90 degrees. The Tofu will 
be marinated with peanut sauce for 160 minutes. 
Another powerful aspect (the whole point, really) of SC and object oriented languages is that 
everything is an object, and you can substitute them freely. Instead of chicken as the third 
argument I could use the entire section of Tofu code. This is called nesting. 
 
Sandwich.make([lettuce, tomato, pickle], rye, Tofu.marinate(peanut, 160)) 
The second argument in marinate could be replaced with rrand(20, 100), which chooses a 
value between 20 and 100. 
 
Sandwich.make( 
 [lettuce, tomato, pickle], 
 rye, 
 Tofu.marinate(peanut, rrand(20, 100)) 
) 
When a program evaluates the code it begins with the inner most parts, and uses the results of 
those values to run the subsequent upper layers. In English, the example above might read 
like this: Marinate tofu in peanut sauce for some value between 20 and 100. After marinating 
the tofu, use it as the meat (third argument) for a sandwich with lettuce, tomato, and pickle, 
on rye bread. 
It is possible to link messages. For example Sandwich.make.bake.cut would first make the 
sandwich (in this case using defaults), then bake it (using defaults), then cut it (with defaults). 
One object can be used as an argument for another instance of the same object. For example, 
you could write Tofu.marinate(Tofu.marinate(peanut, 60), 60). In this case, a batch of tofu 
will be marinated in peanut sauce for 60 minutes, then another batch of tofu will be 
marinated in that batch of marinated tofu (ick!). 
<<<<



Now look at the instruction to play a sinewave and make it play:

{SinOsc.ar}.play;

Do you feel you understand a bit more of what may be going on?

we could also "see" the sinewave if instead of "play" we sent the message "scope"... try it:
(the internal server must be booted for scope to work, in case of doubt boot them both !!)

{SinOsc.ar}.scope;


The "SinOsc" is what we call a "ugen" in supercollider -and in fact in most somputer music languages- and everythiong after the dot is a message to the ugen telling it to apply some "method" to it... just like in the Cottle tutorial you apply different methods to tofu. The SinOsc, which is receiving all these instructions (just like the tofu!) is called the RECEIVER. And this kind of code where you have:

Receiver.method

is called RECEIVER NOTATION. There are other valid ways of writing code but to avoid confusion I will stick to reciever notation as much as I can throughout these lesson workbooks.


actually, now going back to the scope method do you realize that you get two for the price of one as scope also plays the sound ?!

In fact I could have made the above comment as part of my "code" (that's geek for computer instructions written in text ! no offense intended to geeks, I am one myself) and here is how:


{SinOsc.ar}.scope; // you get two for the price of one as scope also plays the sound!

as you can see above, if I use "//" the computer ignores the following text to the end of the line so I can use it as comments...

also the cool colouring you can get by selecting the whole line and going to the main menu FORMAT and choosing Syntax Colorize from the scrolldown menu. In the future, I shall refer to finding something like that in this way: FORMAT>Syntax Colorize



you can fine tune the way you see the sound with the following keys from your computer "qwerty" keyboard. (incidentally, you do know that QWERTY means the typing keyboard as opposed to your midi keyboard, right?)


M toggle screen size
 
 + / - zoom horizontally
* / _  zoom vertically


ok, another basic concept...

-Default:
This means the initial values that a thing will have when it is called up... for example when you turn on the G5 computer, it "defaults" to the desktop with no applications running...

Another example of "default" is the famous sinewave you've been getting the computer to play:

{SinOsc.ar}.scope;





What you hear is a sine wave played at 440cps (cycles per second or 'hertz', abbreviated 'hz', thus 440hz). Basically that number tells you how high or low in pitch the sound is going to be and 440 happens to correspond to the note "A" immediately above middle "C" on the piano.

440 is the DEFAULT frequency of the SinOsc object, which is a unit generator or UGen. It is also blaring out at a set volume... and unbeknown to you at a set 'phase value' and offset.


here is a little schematic of this idea... we will understand it better as we go along. The yellow box is the default value for which channel to use to playback the sound, in this case the first channel which is channel zero, 0. In computers we count from 0, so first is 0, second is 1, third is 2 and so on... 



L1 sinosc simple.jpg 





To find out more about the SinOsc "UGen", you can highlight the object and then request help like this: 

HELP>SuperCollider Help

or you can use the keyboard shortcut indicated in the menu... :) learn your keycommands, they make life easier and faster.

anyway, if you do request help... go ahead, do it!

you will get this:

SinOsc interpolating sine wavetable oscillator

SinOsc.ar(freq, phase, mul, add)


If you are a daring soul you can read what follows in that help file but I am going to re-write it here anyway in simpler terms for you... so you can also play the examples and see some cool synthesis at work, which at present you won't understand, but don't worry, this is also a ZEN exercise in humility.

ok, you can actually tell the computer what frequency you want instead of the default, and you could simply write a number between 20 and 20.000 and the computer will play that pitch, but what you really want is to write stuff you can later reckognize so let's use some key words...


{ SinOsc.ar( freq: 200}.scope;

frequency is a characteristic of all sound waves

 frequency   
n. pl. frequencies
1. The property or condition of occurring at frequent intervals.
2. Mathematics & Physics. The number of times a specified periodic phenomenon occurs within a specified interval, as:
1. The number of repetitions of a complete sequence of values of a periodic function per unit variation of an independent variable.
2. The number of complete cycles of a periodic process occurring per unit time.
3. The number of repetitions per unit time of a complete waveform, as of an electric current.
3. Statistics.
1. The number of measurements in an interval of a frequency distribution.
2. The ratio of the number of times an event occurs in a series of trials of a chance experiment to the number of trials of the experiment performed.

[Latin, multitude, frome, crowded, numerous, frequent.]

(from dictionary.com)


you may also want to specify a 'phase' value, meaning

phase 
n.
Physics.
1. A particular stage in a periodic process or phenomenon
(from dictionary.com)
 
Actually, phase is only noticeable if you play two soundwaves with different phases together... but more of that later.. in any case if we want to specify it, we use the keyword thusly:  

{ SinOsc.ar( freq: 200, phase: 0.5)}.scope;


if you play a it, by now you can see it seems to change in a predictable way, drawing a nice round waveform. We call this a "periodic" waveform, as it repeats always in the same way. You will also have noticed that it draws itself as a kind of undulating shape. Although the stethoscope does not show you this explicitly, what you are seeing is an 'amplitude(how loud), versus time' graph, and you could guess that it repeats a number of times per second, so for example 440hz means that the waveform repeats 440 times every second (this is the frequency). 

If we used an x-y graph like the ones you know from maths, we would see that the sine wave we are playing is symmetrical, that is identical both above a zero line and below it.


Pasted Graphic.tiff 


from the diagram above you can see that the sinewave is can begin at any point, in the example you can see that one complete cycle of the wave takes place between zero crossing no.1 and zero crossing no.3... imagine that when you "switch on" a sinewave you would like it to start somewhere other than at the zero crossing... this "other" point, is called the "phase".

by the way (BTW) did I mention that you can add sinewaves together using a plus sign "+" ?

the plus sign is a binary operator, because it combines two (english for binary !) things... as in a+b. What other binary operators can you think of?

here are two sinewaves added together, notice how it happens within the function (curly brackets), and then I ask for a scope of the whole thing, outside the curly brackets:


{ SinOsc.ar( freq: 200, phase: 0) + SinOsc.ar( freq:200, phase: 0.75pi) }.scope;

nothing, hey? phase only becomes noticeable in certain circumstances, like for example when a sine wave is started exactly half a cycle down the road... look at the example above and think about it... if you do that and add the two 'out of phase' sinewaves, for every point above zero, you get one below zero... if you add equal values of different signs, what do you get? 

Remember how the number Pi (as in apple pie or if you remember your trigonometry, 3.1415... or rounded to 3.1416) describes the circumference of a circle? Have you already guessed that the graph of a sinewave is na "unfolded" circle? ok, lets add to sign waves that are identical except that their phase is separated by Pi or one half cycle (a whole circumference is 2Pi):

try it:

{ SinOsc.ar( freq: 200, phase: 0) + SinOsc.ar( freq: 200, phase: pi) }.scope;


What happened then? Here is a favourite sound-engineer phrase to impress musicians: "phase cancellation". Only now we are not so impressed... it's quite simple actually.


Lets get back to the things our sinewave can have:

SinOsc.ar(freq, phase, mul, add)

ok, what on earth is "mul"... ? it stands for 'multiplier'...er...well, lets call it volume. The minimum is 0 and the maximum is 1, you can use decimals (you have to!) the reason for this range will become evident as we learn more in the lessons ahead.

Listen to the following examples and edit the lines of code yourself to get different volumes:


{ SinOsc.ar( freq: 200, phase: 0, mul: 0.2)}.scope; //quiet

this is what it looks like inside SC:



1.2.jpg 




with different values:

{ SinOsc.ar( freq: 200, phase: 0, mul: 0.5)}.scope; //medium

{ SinOsc.ar( freq: 200, phase: 0, mul: 1)}.scope; //loud

{ SinOsc.ar( freq: 200, phase: 0, mul: 2)}.scope; //distortion !!



use this line to change the mul value:

{ SinOsc.ar( freq: 200, phase: 0, mul: 0.5)}.scope;



Finally there is one value we haven't discussed and it is the "add", change it around so you can see in scope what happens to the soundwave, its usefulness will appear later on in the course



{ SinOsc.ar( freq: 200, phase: 0, mul: 0.5, add: 0)}.scope; //center screen

{ SinOsc.ar( freq: 200, phase: 0, mul: 0.5, add: 0.8)}.scope; //slightly up

{ SinOsc.ar( freq: 200, phase: 0, mul: 0.5, add: 1)}.scope; //further up and an 8ve is added... 

{ SinOsc.ar( freq: 200, phase: 0, mul: 0.5, add: 2)}.scope; //can't hear and way up!


the above examples, when graphed look like this (with their different values)

1.3.jpg 


you can jumble the values around as long as you use keywords... that is one of the cool things about them


{ SinOsc.ar(phase: 0, mul: 0.5, freq: 200, add: 0)}.scope;

go ahead, test it ! ... it still works.

{ SinOsc.ar(phase: 0, mul: 0.5, freq: 200, add: 0)}.scope;

when you become so expert that you don't need to see the keywords, you can just write the values, but in that case they MUST be in the right order, this means always:

freq, phase, mul, add. so:

{ SinOsc.ar(200, 0, 0.5,0)}.scope;

Also works fine !

ok, now, do some intrepid explorations and evaluate each of the following lines of code in turn, they come with the help file for SinOsc and I have made them simpler here. Use the help command to investigate the other UGen that is present and work out what is happening... putting a UGen where a parameter goes is called "nesting"... for now all I want is for you to experiment on these lines of code by changing only the number values to see what happens...

go ahead, try it:

example 1


{SinOsc.ar(freq: XLine.kr(2000,200,5), phase: 0, mul: 0.5, add: 0)}.draw;

and it looks like this:
1.4.jpg 

example 2


{SinOsc.ar(freq: SinOsc.ar( XLine.kr(1,1000,9),0,200,800), phase: 0, mul: 0.25, add: 0)}.scope; 

and it looks like this:

1.5.jpg 



example 3


{SinOsc.ar(freq: 800, phase: SinOsc.ar(XLine.kr(20,8000,10),0,2pi), mul: 0.25, add: 0)}.scope; 


and it looks like this: (the value 2pi is 6.2831 etc!)

1.6.jpg 




You can see from the examples above, that if you put a whole UGen where previously there was a value, then the appropriate parameter( the aspect of the sound that corresponds to that value) becomes "dynamic" as the UGen feeds its data into that parameter slot. In the first example above, the frequency is changed (modulated) by the UGen called XLine, which is going at a slower speed, called a "control rate" and designated by the geek word "kr". The job of XLine is to generate a steady stream of numbers from a to b, so that in this example:

{SinOsc.ar(freq: XLine.kr(2000,200,2), phase: 0, mul: 0.5, add: 0)}.scope;

the Xline creates frequency values from 2000hz to 200hz during 2 seconds and then settles on 200hz 'till you turn the sound off (with 'command+dot' or if you will, command+"." ).

We can say that we have "nested" the XLine UGen into the SinOsc UGen. We can also say that we have plugged in the XLine UGen into the frequency parameter.

Can you explain what has happened in the other two examples?

BTW if you need to make things clearer in supercollider so you can better see what is going on, you can break it into lines, but remember you will have to highlight ALL of the text to get the computer to interpret the instruction...

for example:

{
 SinOsc.ar(
 freq: XLine.kr(2000,200,2), 
 phase: 0, 
 mul: 0.5, 
 add: 0)
}.scope;

highlight EVERYTHING including the curly brackets... notice the indented text... you can do that with FORMAT>Shift Left

There is a very convenient way to do this and it works by enclosing everything you want to highlight with parenthesis and then if you double click on either of the parenthesis then the whole thing becomes highlighted, try it on this one:

(
 {
  SinOsc.ar(
 freq: XLine.kr(2000,200,2), 
 phase: 0, 
 mul: 0.5, 
 add: 0)
 }.scope;
)


Visually this is better because we can see what is enclosed inside what ! Also you can see the parameters for the SinOsc very clearly now...

Try and organize the other two examples in a similar way, it is good practice and you will accomplish something with little effort ! Also, it will show you visually how the nesting is arranged...

Here is a very useful bit of nesting, try this patch out:

(
 {
 SinOsc.ar(
 freq: MouseY.kr(8000,200, 1), //the first value to mouse means //the value at the top of your screen
 phase: 0, 
 mul: MouseX.kr(1.0,0.1, 1),
 add: 0)
 }.scope;

)


and it looks like this:

1.7.jpg 



As you can see the mouse is being used vertically to control pitch and horizontally to control amplitude(geek for volume). I am showing you this so you can plug the mouse into the new UGens we are going to look at, that way you can get them to be more expressive from the start... here we go:

The Sawtooth Wave

evaluate this:

{Saw.ar}.scope;

Can you guess what the default value for frequency is?
Can you see why it is called a Sawtooth wave, Saw for short? The Sawtooth is very rich in harmonic content, theoretically it contains all the overtones possible for the given base tone otherwise known as the fundamental. (see the string vibrations graphiic right at the beginning)


Although as you get to the higher overtones the amplitude decreases...

waves and partials 2.jpg 



Anyway, here is the format in which you need to feed values to Saw, a very 'bright' sounding wave, the brightness coming from all the harmonics that are present.

Saw.ar(kfreq, mul, add)

Now, don't ask me why but the frequency in the Saw helpfile is called kfreq, but I believe it is a mistake because if you use keywords, Saw will respond to "freq" but not to "kfreq"... !!! so this is better:

Saw.ar(freq, mul, add)

in any case Saw needs to be fed three things: a frequency (freq), a volume(mul) and an offset(add)


so... here is a simple saw:

{Saw.ar(200,0.5,0)}.scope; // at 200hz and medium volume, and no offset.

Here is when you start seeing the value of a text based computer language... let's use the example from sinewaves above to show keywords in Saw, a lot of it is reusable... remember that Saw accepts no phase value... less to worry about!


(
 {
 Saw.ar(
 freq: MouseY.kr(8000,200, 1), mul: MouseX.kr(1.0,0.1, 1),
 add: 0)
 }.scope;

)


Examine the patch above and make sure you understand it. Can you tell this sound apart from the sinewave sound without looking at the Stethoscope screen? Try it with a friend playing the mouse for you and see if you can tell them apart.

The Pulse Wave

{Pulse.ar}.scope;

This one sits somewhere between the sawtooth and the sine, doesn't it? in sound I mean... you can guess that it probably receives a frequency value if you just give it that, so why not try it?

{Pulse.ar(200)}.scope;

This is the format it wants its values in:

Pulse.ar(freq, width, mul, add)

...so if we adapt our mouse-theremin to play the pulse, lets plugin MouseX into this "width" parameter and see what it does... try it here:


(
 {
 Pulse.ar(
 freq: MouseY.kr(8000,200, 1), width: MouseX.kr(1.0,0.1, 1),
 mul: 0.5,
 add: 0)
 }.scope;

)


How does width affect the sound? How does it affect the presence of overtones? Are there more overtones whenm the width is smaller or when it is larger? Synthesists refer to the width of a Pulse wave in percentages and they say a 50% pulse wave, meaning that the resulting square wave spends an equal amount of time above and below zero (ooops, didn't I mention pulse waves are sometimes also called square waves although as you can observe from scope, this is only true if the pulse wave is "at 50%", try it and see that it looks square through the 'scope)

In class we looked at Blip and Klang ...

lets have a look at Blip... try increasing the value in the parameter "numharm"

{Blip.ar( freq: 200, numharm: 1, mul: 0.5 )}.play

try it several times, what happens to the sound?

Here is a cool example from the Blip help file:

{ Blip.ar(200,Line.kr(1,100,20),0.2) }.play;

what do you think is happening? (hint: this is related to increasing 'numharm')


At the end of this section you should be able to:

1. Explain in your own words the following concepts:

you are expected to know and understand the meaning of the following terms:

Harmonics, fundamental, frequency, phase, amplitude, offset, Unit Generator, OOP, Sine wave, Pulse wave, Sawtooth wave.

2. Create lines of code using the following UGens:

Sine, Pulse, Saw, XLine, MouseX, MouseY and Blip.


3. Competently use the following messages/methods: ( a method is the way that the messages we send to the ugens are implemented, it is the activity they do when they receive a message):
.ar
.kr
.play
.scope

Exercises:
1. try adding different waves with "+" but with frequencies that are no more than 10hz apart... remember that the addition must happen within the curly brackets...

2. using the format provided in the saw and pulse theremin, can you make a mouse-theremin for Blip ?

3. Can you look up the help file for XLine, and learn how to use it by changing the numbers and see what happens? (for now ignore the parameter called 'done action'). Create a few examples of your own using it.


















