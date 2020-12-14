
-----------------
Messaging Style and Abstractions

Server.default=s=Server.internal;

SC3 philosophy

With SuperCollider 3, the SuperCollider language which specifies when and which sound events occur is separated from the thing that does the synthesising of sound, the Server. Under the hood, there is a constant stream of messages from the language (SCLang appplication) to the Server (scsynth application).

There can in fact be lots of these Servers, scattered anywhere on a computer network. You communicate with them using the network audio protocol OSC (Open Sound Control). 

There is some slight latency in communication between the Language application and the 'localhost' or remote Server, but if one crashes, the other is free to continue. 

There is an internal Server embedded in the SCLang, with immediate message passing, but this would not support network music, and the 'localhost' or local Server is the usual choice. 




























Running SC3 by passing commands to the Server- Messaging Style

This is not the easiest way to make a sound in SC3, but you should see it at least once to understand what is going on below the surface. I'm going to pass some messages from the language application to the Server in a pretty explicit manner. 


s=Server.local; if(not(s.serverRunning), {s.boot});
//interpreter variable s is always being set to the localhost Server for convenience


In order to synthesise, we have to pass SynthDefs (Synth Definitions) to the Server. These are instructions for building UGen Graphs. SCLang will run the code below but then compile it into a form that the Server understands. 

SynthDef("sine", {arg freq=440;
 var osc;
 osc = SinOsc.ar(freq, 0, 0.1); //sine oscillator
 Out.ar(0, osc); // send output to audio bus zero.
}).writeDefFile; //place this SynthDef on disk in compiled form in the 'synthdefs' folder 


Don't imagine that you can leave in expressions in a SynthDef that will run later on, you are making a fixed combination of UGens. The only way you will communicate with instances of your SynthDef later is if there are arguments, which act like input connections to your module. 



















Now we send some messages to the Server to get things going: (these code constructs are commands to send single OSC messages, see 10.1) 

s.sendMsg("/d_load","synthdefs/sine.scsyndef"); //server loads the SynthDef

s.sendMsg("/s_new", "sine", 1000, 1, 0); //start a Synth instance using the SynthDef- it is created as a Synth Node at the tail of the RootNode Group

s.sendMsg("/s_new", "sine", 1001, 3, 1000, \freq, 450); 
//start a separate Synth instance using the same SynthDef, passing in an initial argument- it is created just after the Node 1000

//we can only access the inputs of the SynthDef, so I can change the frequency of the sound:
s.sendMsg("/n_set", 1001, "freq", 900);

s.sendMsg("/n_free", 1000); //stop Node 1000

s.sendMsg("/n_free", 1001); //stop Node 1001

This should give you an idea of the spirit of the thing, but don't worry too much about the specific details of the messages! 

You can find out about the OSC messages the Server responds to in the help file:

[Server-Command-Reference]

There are messages for controlling buffers, nodes, buses... 

This tutorial works at this level of message passing- [Tutorial]

























Using Classes that encapsulate those commands

There are various ways to hide the complexities of message passing from view. We'll aim to progressively avoid any explicit OSC messaging. But under the surface, the message passing is going on; we're just using useful helper classes to conceal the fine detail. 


s=Server.local; if(not(s.serverRunning), {s.boot});
//interpreter variable s is always being set to the localhost Server for convenience


Let's make another SynthDef, but use the SynthDef class to load it straight to the Server

SynthDef("LFPar", {arg freq=440, pan=0.0;
 var osc;
 osc = LFPar.ar(LFPar.kr(ExpRand.new(1,80),0,freq*0.02,freq), 0, 0.1); 
 Out.ar(0, Pan2.ar(osc,pan));
}).load(s);

Look at the SynthDef count on the localhost Server to see how its gone up by one

a= Synth("LFPar"); 
//make a Synth, let some hidden code worry about Node numbers...

b=Synth("LFPar", [\freq, rrand(200,700), \pan, 1.0.rand2]); 
//make another Synth, pass some values to the arguments

RootNode.freeAll; 
//stop all Synths from the top level Group, or press cmd+period















{}.play

There is a code construction we've seen that hides explicit messages and also SynthDefs from you: so it seems like everything is happening in the language application (it is also provided for backwards compatability with SC2). 

//the way this works is to use code that makes a SynthDef wrapper for the function, sends it to the Server to play as soon as possible
{SinOsc.ar([MouseX.kr(440,880), MouseY.kr(330,660)],0,0.1)}.play

//now start this one too! 
{SinOsc.ar([MouseX.kr(220,770), MouseY.kr(110,550)],0,0.1)}.play

//the code above actually returns the synth instance if you need to do things 
//with it, and you can choose where the new Synth appears in the Server's Node graph 
(
var synth;

synth= {LPF.ar(Pan2.ar(CombN.ar(Impulse.ar(9, 0.5, 0.1),0.2,0.2, 30), MouseX.kr(-1.0,1.0)), MouseY.kr(500,10000))}.play(RootNode.new);

SystemClock.sched(5,{synth.free; nil});
)


What is dangerous about {}.play is that it generates a new SynthDef every time you use it. Never use it within a Routine: your Server's SynthDef count may spiral out of control! Even if you avoid the explicit messaging style, the Synth() construct is recommended so that SynthDefs are properly controlled. 




