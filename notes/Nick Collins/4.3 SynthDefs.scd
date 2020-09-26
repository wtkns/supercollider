
-----------------
SynthDefs (Synth Definitions)

The {}.play notation is not the preferred one for SuperCollider 3, but it allowed us to get started with synthesis quickly. What you will often see from now on is a use of the SynthDef construct to define networks of unit generators instead. Lots of synths are then created from a single SynthDef recipe, which is especially important for making clouds of similar sounds and other granular and ensemble processes. 

SynthDef = Synthesizer Definition


























In order to synthesise and process sounds in SuperCollider you have to write a recipe for the UGen network in program code. This recipe is written using a particular language construct, the SynthDef. 

SynthDef(\sine, {Out.ar(0,SinOsc.ar(Rand(440,880),0,0.1))}).load(s); 

Once a recipe is known to the system, you can create an individual synthesiser to that specification: 

Synth(\sine); 

In fact, it can be used as many times over as you desire (run these lines one at a time):

a=Synth(\sine); 
b=Synth(\sine); 
c=Synth(\sine); 
 
And these lines one at a time to individually stop each synth:

a.free;
b.free;
c.free;

Note how each of the Synths got initialised to a random frequency from 440 to 880 when created; this is due to the Rand UGen in the SynthDef above

There are shortcuts to do this in one step:

SynthDef(\saw, {Out.ar(0,Saw.ar(Rand(440,880),0.1))}).play(s);

















You may see some variations in the way the SynthDef is made and used:

SynthDef("aaa",{Out.ar(0,SinOsc.ar(440,0,0.1))}).send(s)

Synth("aaa"); //now this

\aaa is the same as "aaa" for the purposes of naming the SynthDef recipe here. The SynthDef was sent rather than loaded, but that is a technical detail to do with storing SynthDefs on disk rather than just using them directly. 
























If you look in the synthdefs folder in the SuperCollider application directory, you'll see various files that each represent individual SynthDefs. These are automatically loaded up when you start the synthesis server (via that Boot button). 

.send - just sends the SynthDef to the synthesis server at this moment, doesn't place any file on disk

.writeDefFile - just writes the SynthDef into a file on disk, doesn't load it to the synthesis server. 

.load - writes the file on disk, so it's loaded every time you start the synthesis server from now on, and also sends it immediately so it's available right away. 

There are further versions you might see like .writeOnce and .store - we'll get to these when we need them. 























The only difference to our canned SinOsc example from earlier is the SynthDef wrapper and the use of the Out UGen. The full explanation of the Out UGen is deferred until we discuss busses, but you can think of it for now as saying 'play on the first audio output of the computer'. 

SynthDef(\sine,{arg freq=440, amp=0.1; Out.ar(0,SinOsc.ar(freq,0,amp))}).load(s); //added frequency argument to recipe, note how the name of the SynthDef can either be specified as a literal \sine and a string "sine"- you'll see both ways in examples, which is why you're being warned now

Synth("sine"); //now this accepts the default

Synth("sine",[\freq,880]); //this makes another Synth from the recipe an octave up, by being explicit about the frequency argument to the SynthDef

You can see how this allows us to make lots of related Synths from a common recipe with slight variations in sound between them. 


a=Synth(\sine); 
b=Synth(\sine,[\freq,550]); 
c=Synth(\sine,[\freq,660, \amp, 0.5]); 

And these lines one at a time to individually stop each synth:

a.free;
b.free;
c.free;



















Exercise:

Try taking a simple synthesis patch you've been working on and turn it into a SynthDef. 

As a prototype you want something like:

(
SynthDef(\synthdefname,{arg input1; //any arguments go here

//some code for UGens - the sort of thing that went inside {}.play before

Out.ar(0, finaloutput) //finaloutput is the final result UGen you want to hear
}).send(s)
)



Synth(\synthdefname, [\input1, inputval1]); //inputval1 is the constant 



















