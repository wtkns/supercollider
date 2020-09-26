
-----------------
//Some effects examples

//use the internal server with the scope

Server.default= s=Server.internal; 

s.scope;


//make some source sound recipe

(
SynthDef(\impulse, {
Out.ar(0,Pan2.ar(Saw.ar(440,Decay2.ar(Impulse.ar(1),0.001,0.1,0.5)),0.0));
}).send(s); 

SynthDef(\continuous, {
Out.ar(0,Pan2.ar(WhiteNoise.ar(0.1),0.0));
}).send(s); 
)

a= Group.basicNew(s,1); //get Group 1

x= Synth.head(a, \impulse);

s.scope










//Delay

(
SynthDef(\fxexampledelay, {arg delaytime=0.1;
var input, effect; 

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

effect= DelayN.ar(input, 1,delaytime); //max delay of one second

Out.ar(0,effect); //adds to bus 0 
}).send(s); 
)

y= Synth.tail(a, \fxexampledelay);

y.free;

y= Synth.tail(a, \fxexampledelay, [\delaytime, 0.4]);

y.free;







//other UGens to explore:
"SC://DelayN", "SC://DelayL", "SC://DelayC", "SC://Delay1", "SC://Tap", "SC://MultiTap"















//Reverb

(
SynthDef(\fxexamplereverb, {arg delaytime=0.01, decaytime=1;
var input; 
var numc,numa,temp;

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

numc = 4; // number of comb delays
numa = 6; // number of allpass delays

// reverb predelay time :
temp = DelayN.ar(input, 0.048,0.048);

temp=Mix.fill(numc,{CombL.ar(temp,0.1,rrand(0.01, 0.1),5)});
 
// chain of 4 allpass delays on each of two channels (8 total) :
numa.do({ temp = AllpassN.ar(temp, 0.051, [rrand(0.01, 0.05),rrand(0.01, 0.05)], 1) });
 
// add original sound to reverb and play it :
Out.ar(0,(0.2*temp));
}).send(s); 
)

y= Synth.tail(a, \fxexamplereverb);

y.free;


//readymade Reverbs in SC3.2 and later
"SC://FreeVerb"
"SC://FreeVerb2"
"SC://GVerb"

//If you build your own reverbs, useful UGens are: 
"SC://CombN", "SC://CombL", "SC://CombC"
"SC://AllpassN", "SC://AllpassL", "SC://AllpassC"
//and the delay reverbs above for early reflections
















//Phasing and Flanging


//phasing = play a signal back in combination with a phase shifted copy of itself (using an allpass filter); vary the delaytime under 20 msec


(
SynthDef(\fxexamplephasing, {arg freq=0.2;
var input, effect; 

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

effect= AllpassN.ar(input,0.02,SinOsc.kr(freq,0,0.01,0.01)); //max delay of 20msec

Out.ar(0,effect); //adds to bus 0 where original signal is already playing
}).send(s); 
)

x.free

x= Synth.head(a, \continuous);

y= Synth.tail(a, \fxexamplephasing);

y.set(\freq, 0.1)

y.set(\freq, 1)

y.free











//flanging= play a signal back in combination with a delayed copy of itself; vary the delaytime around 10 msec
//flanging usually also involves some feedback, acheived here using LocalIn and LocalOut

(
SynthDef(\fxexampleflanging, {arg flangefreq=0.1, fdback=0.1;
var input, effect; 

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

input= input+ LocalIn.ar(2); //add some feedback

effect= DelayN.ar(input,0.02,SinOsc.kr(flangefreq,0,0.005,0.005)); //max delay of 20msec

LocalOut.ar(fdback*effect);

Out.ar(0,effect); //adds to bus 0 where original signal is already playing
}).send(s); 
)

x.free

x= Synth.head(a, \continuous);

y= Synth.tail(a, \fxexampleflanging);

y.set(\flangefreq,0.4);

y.set(\fdback, 0.95);

y.free;











//Dynamics Processing

s.scope

//compress or expand the dynamic range (amplitude variation) of a signal

(
SynthDef(\fxexamplecompression, {arg gain=1.5, threshold=0.5;
var input, effect; 

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

effect= CompanderD.ar(gain*input,threshold,1,0.5); 

ReplaceOut.ar(0,effect); //replaces bus 0 where original signal is already playing
}).send(s); 
)



x.free

x= Synth.head(a, \impulse);

y= Synth.tail(a, \fxexamplecompression);

y.free;

y= Synth.tail(a, \fxexamplecompression,[\gain,2, \threshold,0.1]);

y.free;












//a limiter forces a hard on this limit, and is very useful as a final stage in a patch to avoid overloading 

(
SynthDef(\fxexamplelimiter, {arg gain=1;
var input, effect; 

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

effect= Limiter.ar(gain*input,0.99, 0.01); 

ReplaceOut.ar(0,effect); //replaces bus 0 where original signal is already playing
}).send(s); 
)



x.free

x= Synth.head(a, \impulse);

y= Synth.tail(a, \fxexamplelimiter);

y.set(\gain, 10) //careful with your ears! 

y.free;




"SC://Compander", "SC://Normalizer", "SC://Limiter"


