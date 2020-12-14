
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 10
Lesson 9 


In Class we will have covered the following topics: Synth definitions, virtual knobs and sliders, arguments.


CAVEAT (a latin word, yes, look it up!)
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)



The SynthDef


Up until now, we have used the method 'play' to audition all our experiments in sound. We have not worried so much about what Supercollider can do for us to make things easier in terms of reusing our code; in fact, this is precisely one of the great things about supercollider. A synthesizer, meaning any recipe for making a noise, can be stored in the server and then simply told to change the various parameters by the code you make.

The code you write as a 'client' is sent to the 'server' when you evaluate it in order to make the sounds. This means that every time you have made a synth, even as simple as this:

{Pulse.ar(200, 0.2, mul: 0.4)}.play //remember, frequency and width? ... look it up !

... you have to write all that code again. Not only that, but if we want a pulse wave with a different frequency, we then have to write another one, identical in everything, except for the values... does that seem a bit redundant or is it just me? Wouldn't it be nice if we could send our code, which is a 'recipe' for making a sound, to the server and leave it there? In this way, every time we launch supercollider, all we would have to do is call it by name to get it to play something and send it some values.

The 'recipe' we are talking about is really called a 'definition'. In fact it is called a 'synthesizer definition' or SynthDef for short. Let's make one:

first, one that we can't really change. but just recall in a simpler way:

we write the recipe:


SynthDef( \mySound, { Out.ar(0, Pulse.ar(200, 0.2, mul: 0.4) ) } ).load(Server.internal);

then we recall it:

Synth(\mySound);

(By the way, in case I haven't told you before, if you can't hear anything, just quit supercollider and re-launch, it doesn't happen often, but it happens !!)

that last line of code is easier to write than the recipe, right? 

Synth(\mySound);


at present we are only loading the SynthDef into the server, but we could actually store it there permanently and it would get put in the SynthDef folder inside the supercollider folder. This would make it available everytime we start Supercollider.

Ok, so far so good, but we don't really know what the different lines inside the synth def are and we have only one frequency we can play, so let's break it down and add a way to change it...

So, let's comment our SynthDef:

(
SynthDef( \mySound, //this is the name we give it, the backward slash is so SC knows it is a name
 { Out.ar( // our synth must be output somewhere
 0, // so it gets sent to your first channel, which is 0. (Left = 0, Right = 1)
 Pulse.ar(200, 0.2, mul: 0.4) // this is what the synth will play
 ) 
 } 
 ).load(Server.internal); //and it must be loaded into the internal server where it will live...
)


and to play it back, you simply use a synth object:

Synth(\mySound);



ok, so now, let's make it so we can change it as we go along, so to speak !

(
SynthDef( \mySound, 
 { arg pitch = 300; // declare an argument
 var e; //a variable to hold the envelope
 e = EnvGen.ar(Env.perc, 1.0, doneAction: 2);
 
 Out.ar( 
 0, 
 Pulse.ar(pitch, 0.2)*e //insert the env here...(scaling)
 ) 
 } 
 ).load(Server.internal); 
)


and now you can just write this:

Synth(\mySound, [\pitch, 200]);

then, to stop, as usual comman-".", right?

well, let's learn another way:

if we assign it to a variable name, in this case the letter "a" (single letters are global variables, this means they don't have to be declared with "var" and can be reused during your sesssion endlessly)

a = Synth(\mySound, [\pitch, 300]);

we can stop the sound with this command:

a.free; 

in that way, if we do this:


evaluate the following one after the other withut stopping them:

a = Synth(\mySound, [\pitch, 300]);

b = Synth(\mySound, [\pitch, 600]);

c = Synth(\mySound, [\pitch, 50]);


we can stop them selectively, for example:

b.free;
c.free;
a.free;


trés cool? you may be suspecting rightly that this way of writing things is a preparation for something else... otherwise, why go to all this trouble?


ok, evaluate this and we will break it down...

(
var t;

t=Task({

inf.do({
 
Synth(\mySound, [\pitch, rrand(550, 1000)]);

0.12.wait
});

});

t.start;

)


Firstly, notice how clean the code looks once we have made our SynthDef and are merely recalling it within the Task... you could have defined very complex synths and then when you substitute them in a task, all you need to do is call up the synth ! In fact, you could get a SynthDef that somebody else made, and create a task for it, among many other things... but one of the simplest things you can do is a little task, so... what is a task?

A task is a class in supercollider that allows you to do something repeatedly... until it is told to stop... or the thing that you are repeating already has an indication of how many times to do it...

for example (from the actual help file):

(
t = Task({ 
 50.do({ arg i;
 i.squared.postln; 
 0.5.wait 
 }); 
 });
)

t.start;
t.stop;
t.start;
t.reset;
t.stop; 


a task just needs something to do, and how long to wait between doing these things. In the case of the help file, everytime the function inside the 'do' is evaluated, it is posted to the supercollider window and then Sc waits for 0.5 secs. It is quite basic...

In our own example above, we didn't define how many times to 'do' the task, in fact we used 'Inf', which stands for 'infinite', and you can see intuitively that this means doing the task until it is stopped by external forces !!



For now, this is all you need to know both about making and storing a SynthDef and about why making one can be useful... To complement these explanations, you must spend the remaining time you have for study this week on making the projects described below




At the end of this section you should be able to:


1. Explain in your own words the following concepts:
What is a synthesizer definition in supercollider and ways in which it could be used.


2. Create lines of code using the following UGens/objects:
SynthDef, Inf.




3. Use the following messages/methods: 
do.



Do the following practice:

1. edit my synth def above (\mySound) so that when you run the same task, it comes out stereo.

2. 
a. edit my synth def above (\mySound) to include a pan argument.
b. make a task that will feed this argument some random values.

3. Create a SynthDef involving a phase modulation ugen and create a task that will play a note repeatedly and change the timbre in a random way. hint: use PMOsc.ar with an argument for the modulation index then change that randomly inside the same task...

4. Create a SynthDef of your own that is then manipulated in your own original way inside a Task.

5. And another one !!!


















