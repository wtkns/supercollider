
-----------------
Live Coding

The SuperCollider Language application keeps on running while the Server is synthesising sound, so you can keep on sending commands to the Server, writing new SynthDefs or doing whatever programming you desire. 

You can do this even while you perform a live set, playing by 'live coding'. 

It's an interesting new approach to improvisation, rooted in the technology. 




















Live coding is very natural to SuperCollider 3- you should have noticed that it was happening in most of the examples we ran so far! It has been possible since SC2 when the interpreter kept running while your Synth ran. 

//Running these one at a time is a miniature live coding performance:
a={Pan2.ar(SinOsc.ar(440,0,0.2),0.5)}.play;

b={Pan2.ar(SinOsc.ar(445,0,0.2),-0.5)}.play;

a.free;

b.free;


















The ability to change a graph while playing is built into SC Server, as it is standard with something like MAX/MSP or Reaktor, but you get the flexibility of the SC language to make the changes. This programatic control of the state of the synthesis engine is incredibly powerful.


For instance, you can substitute SynthDefs, set inputs of Synths, swap the execution Graph around and pause and unpause Synths on the fly: 






















s=Server.local; if(not(s.serverRunning), {s.boot});

SynthDef("sound", {arg freq=440;
 var osc;
 osc = Pan2.ar(SinOsc.ar(freq, 0, 0.1),SinOsc.kr(0.2)); //sine oscillator
 Out.ar(0, osc); // send output to audio bus zero.
}).load(s);

a=Synth.head(s,"sound", [0,550]); //place at head (top) of execution graph on the Server's RootNode. 
 
SynthDef("sound", {arg freq=440;
 var osc;
 osc = SinOsc.ar(freq*[0.97,1.03], 0, 0.1); //sine oscillator
 Out.ar(0, osc); // send output to audio bus zero.
}).load(s);

b=Synth.after(a,"sound", [0,660]); //place the new Synth after a in the execution graph

b.set(\freq, 770); //set input 0 to value 770Hz

b.run(false); //pause it momentarily

b.run(true); //unpause

a.moveAfter(b); //swap their execution order (no audible difference in this simple case) 

a.free; b.free;
//See the Synth help file for a more involved examples with FX












A little knowledge of SuperCollider is all that might be required for a live coding performance. Here is a rough and ready demonstration (you'd need bbcut):

~sf= SF3("a11wlk01.wav",4);

~playback1= BBCSPlayback1(0.999);

~bbcut1=
BBCut(BBCutSynthSF(~sf,pbsfunc:~playback1),
ThrashCutProc1.new({[0.7,0.2].choose},{[0.125,0.5].choose}, 
7, {[0.5,0.25,0.125,0.125]},{4.rand},{5.rand})
).tempo_(1.0).ar;

~playback1.pbmfunc= 0.9;

~thrashriff= [0.5,0.25,0.125,0.125];

~bbcut2=
BBCut(BBCutSynthSF(~sf),
ThrashCutProc1.new({[0.7,0.2].choose},{[0.125,0.5].choose}, 
7,{~thrashriff},{4.rand},{5.rand})
).tempo_(1.1).ar;

~thrashriff= [0.5,0.1,0.1,0.1,0.1,0.1];

~bbcut1.run(false);

~fx1={ReplaceOut.ar(0, Resonz.ar(In.ar(0,2),MouseX.kr(100,10000),MouseY.kr(0.1,1.0)))}.play;

~fx1.run(false);

~bbcut1.run(true);

~fx2={ReplaceOut.ar(0, CombN.ar(In.ar(0,2),0.5,MouseY.kr(0.01,0.45),MouseY.kr(0.5,5)))}.play;

~fx2.run(false);

~fx1.run(true);

~clock1= TempoClock.new(2.05);

~clock1.schedAbs(~clock1.elapsedBeats,{
var on;
on= 0.5.coin;
~bbcut1.run(on);
~bbcut2.run(if(on,0.5.coin,true));
~fx1.run(0.5.coin);
~fx2.run(0.5.coin);
0.5});

~clock1.stop







Imagine we'd like to do some dynamic repatching with feedback. Here is a very clunky demonstration:

~mod=SynthDef(\modulator, {
Out.ar(20,SinOsc.ar(44,0,50, 100));
}).play;

~carr=SynthDef(\carrier, {
Out.ar(0,Pan2.ar(SinOsc.ar(InFeedback.ar(20,1),0,0.2), 0.0));
}).play;

~mod.free;
~mod=SynthDef(\modulator, {
Out.ar(20,SinOsc.ar(MouseY.kr(5,50),0,50, MouseX.kr(1000,5000)*InFeedback.ar(0,1)));
}).play;


But there are much easier ways to go about this. 















There is an extension set for SC3, which comes with the basic application, devoted to the potential of live coding. This is Julian Rohrhuber's JITLib, for 'Just in Time' programming. 

["SC://JITLib"] //cmd+d

JITLib will hide the execution graph on the Server from you so you don't need to worry about it, and you can keep plugging all sorts of things into other things quite happily, swapping the connections around and having fun without worrying too much over the bookkeeping.


















In order to do this, you'll note the use of an Environment like entity, the ProxySpace, which becomes the current Environment. We then set properties (keys) of the current Environment to get things running. 

for example-
~mykey = {SinOsc.ar(440,0,0.1)}; //set some sound function to a key

It's probably best to just work through an example of its use, an enjoyable performance by Julian himself. We'll run through a line at a time, watching the post window as well to see how the ProxySpace gets updated as we go along. 
 













//prepare the set by replacing the current environment with a proxy space on a server (could be anywhere) which will allow me to create references to new objects and thus substitute or change them later on
s=Server.local; if(not(s.serverRunning), {s.boot}); ProxySpace.push(s);

//prepare a context (acting as a key to a dictionary) to play through the output channels
~out.play(0,2);

~out = {SinOsc.ar(440,0,0.05) }; //play a classic sine sound function in it

~out = {LFPar.ar(434,0,0.02) }; //replace the current sound with another one.

//start two channels with slightly different sine functions
~x1 = {SinOsc.kr(0.1) };

~x2 = {SinOsc.kr(0.14) };

//controlling the rate of a filtered trigger impulses by x1 and x2

~trig = {Impulse.ar(30*[ ~x1.kr.max(0), ~x2.kr.max(0) ], 0, 2) };

~out = {RLPF.ar(~trig.ar(2), [400,410], 0.05) };

//reassigning x1 and x2 with intermodulating sine waves

~x1 = {Mix( SinOsc.kr(2*[1,1.1,1.3,1.04] * ~x2.kr(1)) ) + 1 * 0.2 };

~x2 = {Mix( SinOsc.kr(2*[1,1.1,1.31,1.2] * ~x1.kr(1)) ) + 1 * 0.2 };

 

//to add more sounds I mostly just use new references

(

~out1 = {var amp, t; t = ~trig.ar(1) * 2; 
amp = Decay2.ar(t, 0.001, 0.01);
BPF.ar(t, [400,431]*(amp+1), 0.05)
};

)

//turn on the fridge

~out2 = {SinOsc.ar(4*50*[1,1.1], 0, 0.02) };

//mix it in

~out = ~out1 + ~out2;

//prepare a soft cross-fade

~out2.fadeTime = 2.0

//phase modulate the fridge a little

~out2 = {SinOsc.ar(4*50*[1,1.03], SinOsc.ar(300, pi), 0.02) };

//some more complex interconnections between parameters

~out2 = {SinOsc.ar(4*50*[1,1.032]*[1,~x2.kr*2+1], SinOsc.ar(20) * pi * ~x1.kr, 0.03) };

//a placeholder in this environment also constitutes a parameter context that
//can be modified and is applied to every new sound process that takes that place.

(
~out2 = {arg freq=200, ffreq=20;
SinOsc.ar(freq*[1,1.03], SinOsc.ar(ffreq, pi) * ~x1.kr * pi, 0.02)};
)

//set the arguments

~out2.set(\freq, 240, \ffreq, 1200);

//map argument to a proxy

~out2.map(\ffreq, ~x1);

//change that proxy

~x1 = {LFNoise0.kr(3)*10 };

//a new function uses the previously changed arguments

(
~out2 = {arg freq=200, ffreq=20;
SinOsc.ar(freq*[1,1.05], LFPulse.ar(ffreq * ~x1.ar(1), 0, 0.5) * pi, 0.02)
};
)

/*

... //up to imagination

*/

//end of performance, turn off the fridge

(

~out2 = {SinOsc.ar(400*[1,1.1]*Line.kr(1, 0, 10), SinOsc.ar(1, 0.8 * ~x1.kr + pi), 0.02) };

~x1 = {Line.kr(3, 0, 10) };

~x2 = {Line.kr(3, 0, 10) };

)


















To administrate what is going on in JITLib: 

//check the state of the ProxySpace in use
currentEnvironment.postln;

~out.fadeTime = 5; //5 second fade out time set
~out.release; //don't kill immediately, let it fade before death

~x2.free; //kill the associated Synth
~x1.clear; //stop Synth and clear key from ProxySpace

currentEnvironment.free; //free all node proxies, ie stop synthesis;
currentEnvironment.clear; //get rid of all the keys, will also stop anything running

ProxySpace.pop; //finish with JITLib ProxySpace, go back to standard Environment



There are plenty of further examples scattered through the help files for JITLib.

Finally, here's an example of a programmatic attack on the 
execution graph, with n sines being continually plugged into one another:



(
n=16;
p=ProxySpace.push(s);
~out.play(0,2);
)


(
n.do({arg i; p.put(i, { arg in=100, add=0.0, mul=1.0;
 Pan2.ar(SinOsc.ar((100+(220*((mul*InFeedback.ar(in,1))+1.0+add))), 0,1.0/(n)), 1.0.rand2) });
});
)

n.do({arg i; ~out.add(p.at(i)) });

currentEnvironment.postln;

(
t = Task({
var nxt;

nxt= 0.5;

 loop({
 n.do({arg i;
 if(0.1.coin,{
 p.at(i).set(\in, p.at(n.rand).index);
 },
 {
 p.at(i).set(\add,rrand(-0.9,0.9));
 if(0.1.coin,{p.at(i).set(\mul,exprand(0.1,100.0))});
 });
 });

 //my favourite SC code trick, idea by Mr.McCartney
 if(nxt.coin,{nxt=[0.13,0.3,0.7,1.1, 1.37, 3.17].choose});
 
 nxt.wait;
 })
});
)

t.start;

//let's have two competing processes! 
(
u = Task({
var nxt;

nxt= 0.5;
 loop({
 n.do({arg i;
 if(0.1.coin,
 {
 p.at(i).set(\in, p.at(n.rand).index);
 },
 {
 p.at(i).set(\add,rrand(-2,2));
 if(0.1.coin,{p.at(i).set(\mul,exprand(0.1,1000.0))});
 });

 });
 if(nxt.coin,{nxt=[0.04,0.14,0.6,1.2, 1.46, 4.24].choose});
 
 nxt.wait;
 })
});
)

u.start;

u.stop;
t.stop;

p.pop














Julian has also written classes that assist you in substituting new scheduling Tasks or Patterns on the fly:

["SC://Pdef"]

//My example:

//can alter the SynthDef too of course
(
SynthDef(\blip,{ arg out=0, freq=440, amp=0.1, pan=0, gate=1;
 var z;
 z = LPF.ar(
 Mix.new(Blip.ar(freq * [1, Rand(0.98,0.99), Rand(1.01,1.02)], 200)),
 XLine.kr(Rand(100,1000), Rand(4500,5000), 0.02)) * Linen.kr(gate, 0.01, amp * 0.7, 0.2, 2);
 Out.ar(out, Pan2.ar(z, pan));

}).store;
)

SynthDescLib.read; 

Pdef(\a, Pbind(\instrument, \blip, \dur, 0.6, \degree, Pseq([0, 5, 6, 2, 5,0,5,0,4,0,1,6,5], 1)));
Pdef(\b, Pbind(\instrument, \blip, \dur, 0.8, \degree, Pseq([0, 5, 6, 2, 5,0,5,0,4,0,1,6,5].reverse-2, 1)));

//transposing schedule
Pdefn(\c,Pstutter(13, Pseq([0,1,2,3,4,5,6,-5],inf)));

Pdefn(\d,Pseq([1.0],inf)); //dur of 0.1 is fun


// Pref can be used in multiple patterns

(
Ppar([
 Pbindf(Pn(Pdef(\a), inf),
 \mtranspose, Pdefn(\c)
 ),
 Pbindf(Pn(Pdef(\b), inf),
 \mtranspose, Pdefn(\c)
 ),
 Pbindf(Pn(Pdef(\a), inf),
 \mtranspose, Pdefn(\c),
 \dur, Pdefn(\d)
 )
]).play;
)


["SC://Tdef"]
 
(
// load a synthdef
SynthDef("pdef_grainlet", 
 { arg out=0, freq=440, dur=0.05, width=0.5;
 var env;
 env = EnvGen.kr(Env.perc(0.01, dur, 0.3), doneAction:2);
 Out.ar(out, Pulse.ar(freq, width, env))
 }).load(s);
)


Tdef(\x).play;

(
Tdef(\x, { 
 loop({
 s.sendMsg("/s_new", "pdef_grainlet", -1,0,0, \freq, rrand(600, 640), \width, rrand(0.2,0.4));
 [0.1,0.5].choose.wait;
 })
})
)

(
Tdef(\x, { 
 var x;
 x = Pseries(100, 10, 100).loop.asStream;
 loop({
 s.sendMsg("/s_new", "pdef_grainlet", -1,0,0, \freq, x.next,\width, rrand(0.2,0.8));
 (0.01+(x.next/11000)).wait;
 //s.sendMsg("/s_new", "pdef_grainlet", -1,0,0, \freq, (x.next)*0.5,\width, rrand(0.7,0.8));
 //(0.02+(x.next/11000)).wait;
 })
})
)



 

















