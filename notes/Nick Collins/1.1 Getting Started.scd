
-----------------
'Essentials'

This is SC3, also called SC Server. 

It is an interpreted programming language for audio synthesis. You have to learn this language:

1) The stupid computer will only accept syntactically correct statements in this language.

2) You need to become aware of standard mechanisms of computer languages, like iteration, conditional execution, messaging and containers.

3) It's frustrating if you have a specific musical task in mind to have to deal with this computer language stuff













BUT the payoff is:

1) You can explore musical tasks that standard software doesn't give you as an option

2) You can learn the programming parts 'on the side' as you practise with the language, and I hope you'll hear inspiring outputs quickly in this course

3) You are working with free software which is easily extendable





















You need to know three specific things before you dare to run any code: 

(Mac version- there may be keyboard shortcut variations for Linux/Windows)

1. Use enter, not return, to run lines of code. Enter is at the base of the numeric keypad on some keyboards, or on the bottom row of my laptop keyboard. [windows- alt+enter]

2. Before doing any sound synthesis, turn on the localhost server, by pressing 'Boot' on the grey localhost server graphic. 

3. To stop running sounds, use command+period (apple key and .) [win: alt+.]





















Here are some warm up examples:

2+2 //run me by pressing enter with the cursor on this line- a four should appear in the posting window 

"I am SuperCollider 3".speak //run with enter

{Pan2.ar(SinOsc.ar(440,0,0.1),0.0)}.play //similarly, concert A sine

//one powerful feature of SuperCollider is the ease with which you might bring in interaction: here I substitute a Mouse controller for frequency rather than having a constant

{Pan2.ar(SinOsc.ar(MouseX.kr(440,880),0,0.1),0.0)}.play 

























//another traffic moment, more involved example. Double click on the initial bracket to select this whole block of text, which needs to be run at once. You can't use enter on a single line of this example since its a program consisting of more than one line. 
(
{var n;
n=10;

Resonz.ar(
Mix.arFill(n,{
var freq, numcps;

freq= rrand(50,560.3);
numcps= rrand(2,20);
Pan2.ar(Gendy1.ar(6.rand,6.rand,1.0.rand,1.0.rand,freq ,freq, 1.0.rand, 1.0.rand, numcps, SinOsc.kr(exprand(0.02,0.2), 0, numcps/2, numcps/2), 0.5/(n.sqrt)), 1.0.rand2)
})
,MouseX.kr(100,2000), MouseY.kr(0.01,1.0))
;
}.play
)

















SuperCollider is very powerful and much loved because it is easy to do real time synthesis, interaction and algorithmic composition, within one package.

SC3 has the same operating freedom as MAX/MSP or PD, but with the power of the SuperCollider language for UGen Graph generation (connecting up a flow graph of sound generators and processors).

On the down side, the visual display of graphs is very limited or non-existent- I hope you aren't surprised at this in a text based interface. I promise that you will grow to be familiar with this, the structures existing in your mind, and if you're worried at any point, try drawing out a diagram of what you're trying to build on good old fashioned paper as an aid memoire. 






















If you see this, I hope you're already in the SuperCollider environment. We write code as text (on the Mac as .rtf files), and when we instruct the code to run, SuperCollider compiles and executes it immediately.

SuperCollider has similar control structures to programming languages you may already know, like conditional execution and loops. It is an object orientated language based on Smalltalk and C, and has a very strong set of Collection classes like Arrays. 

In this course we shall try to get you to pick up the syntax as we go along, and get on to making sounds as quickly as possible! 


//this is a comment

/* this is also a comment */
























To do audio synthesis, we give SuperCollider a list of instructions for building a Synth, that is, a valid network of Unit Generators, or UGens. 

{Pan2.ar(SinOsc.ar(440,0,0.1),0.0)}.play //This code plugs a sine oscillator into a panner; don't worry, this will be further explained as we go along!

(If you run this code, note that the localhost GUI will show important runtime information (like CPU load and number of Synths playing/UGens used) when synthesis is underway)
























( //double click on the inside of any bracket to highlight the code contained within

)


( //select this code within the outer parentheses 
 //then press the ENTER key on the numeric keypad
{
SinOsc.ar(440,0,0.1)
+
Pulse.ar(443,0.6,0.05)
}.play 

)

So a selection is either the blued out area, or the current line of the cursor.





































Types of Parentheses 

( ) //for grouping expressions together

{ } //function

[ ] //array (list of data)


SuperCollider code gets full of nested expressions- you look at the selections
within brackets to check on the scope (level of nesting) of code fragments.
Try double clicking around any of the brackets in the following code:

(

if(4==4, { 
 
 if(3==3, { 
 "correct!".postln
 });
 
});

)












How do I find out about strange new code objects?


Use Cmd+d on it's own to bring up a general help window

or on selected text (that has an associated help file)

LFSaw //select and use Cmd+d

You can also use Cmd+j go to source code to find out more:

LFSaw //select and use Cmd+j






















All generated text will appear in the posting window. Bring the posting window to the front with cmd+\

You'll often see the postln and Post instructions, which are useful for checking on the running state of variables and particularly debugging. 

Run these lines of code by using enter with the cursor on each line

2.postln;

Post << [2,3,4,5] <<nl; 

The reason you see more than one thing posted is that when you execute some code, SuperCollider always posts the last object it dealt with. This is the object '2' in the first example and the special 'Post' operator in the second. If you run this:

(
var freq;

freq=rrand(300,600);

{SinOsc.ar(freq,0,0.1)}.play;
)

You'll see something posted about a Synth (the object that represents the sound synthesis asked for in the last line). You'll get used to all this, don't worry! 





























What happens when it all goes wrong?

This will crash:

{SinOsc.ar(nil)}.play

So will this:

Array.series(9,0,1)+nil

Don't be scared!

You get a trace of the stack (execution order of functions in SuperCollider code)
This is very helpful in telling you what caused the error. Don't be intimidated by it: everyone's code crashes, especially when you're developing it.

Occasionally, you may crash the entire program. This happens most often when programming big loops, where your instructions cause the computer to get locked in repetitions of some task. There is no cure for this, and SuperCollider is not doing anything wrong- it is faithfully following your instructions. But if you did not anticipate the consequences of your program, such an error may occur. This happens to everyone at some point, we can't anticipate every aspect of every line of code we program! 




















How do I start exploring?

If you type Cmd+O you can open files. SuperCollider comes with an examples folder, plus lots of examples in particular help files. 

It is best probably to begin by running examples, and perhaps tinkering with a few numbers in the patches.

Listen to what happens to the sound. 

For some of you, you'll be learning about sound synthesis and processing as you explore- others will be familiar with the theory, but it may take some time and effort to come to grips with the way things are implemented in SuperCollider. 

If you have internet access, go to audiosynth.com, from where you can get hold of various websites which have SuperCollider examples and extensions. 






Now run through this tutorial file again if you're unsure, and start to try a few examples out. There is also a 'getting around in SC3' file which summarises some useful shortcuts. Also have a look under the application menus above. 



[cross platform note: 

["SC://Shortcuts"]

Virtually all code should run on any operating system. However, one area of difference is the GUIs- when we get onto them I shall try to indicate cross platform compatabilities- Linux and Windows users will use SwingOSC, Mac users can use SwingOSC or Cocoa. The other chief difference is the Mouse UGens, which are for Mac only. However, via SwingOSC you can make a mouse area for controlling patches:

JMouseBase.makeGUI //run me first, you only need to run this part once and can keep using this window

then in any code with a MouseX or MouseY UGen, add a J in front, i.e.

{SinOsc.ar(JMouseX.kr(400,800),0,0.1)}.play //now move the mouse in the Java window you created

rather than 

{SinOsc.ar(MouseX.kr(400,800),0,0.1)}.play

]











