
-----------------

//quick network music introduction (adapted from code by Julian Rohrhuber)

//this sets up connections to the various IP addresses around the network- you will need to update this code to reflect your local setup

//I've put in the IPs of the Macs in the MI Lab 
(
a = [190, 30, 198, 200,196, 227].collect({ arg el;
 Server("test"++el, NetAddr("139.184.50." ++ el, 57110))
});
)

//makes a Server GUI that represents a particular network target
a[0].makeWindow;

//function to encapsulate sending a SynthDef to all Servers 
f = { arg synthDef; a.do({ arg el; synthDef.send(el) }) };

//send to a specific Server
(
SynthDef("finesine", { arg out, freq=440, amp=0.1, pan, sustain=0.01, x=0.5;
 var e, u;
 e = EnvGen.ar(Env.perc(0.001, sustain, amp), doneAction:2);
 u = SinOsc.ar(freq * [1.0, 5/6, 17/8] * XLine.ar(1 + x, 1, sustain)).sum * amp;
 Out.ar(out, u)
}).send(a[0]);
)

//use function f to send to all
(
f.value(
 SynthDef("finesine", { arg out, freq=440, amp=0.1, pan, sustain=0.01, x=0.5;
 var e, u;
 e = EnvGen.ar(Env.perc(0.001, sustain, amp), doneAction:2);
 u = SinOsc.ar(freq * [1.0, 5/6, 17/8] * XLine.ar(1 + x, 1, sustain)).sum * amp;
 Out.ar(out, u)
 })
)
)

//automate Synth grain firing once around the Servers in random order
(
{
 10.do { arg el, i;
 Synth.grain(\finesine, [\freq, 1000 +(i*200)], a.choose);
 0.1.wait;
 }
}.fork;
)

//Using a pattern to target particular Servers in the array a
(
{
 var pat;
 pat = Pseq([0,1,2,3,2,1,4,5]);
 pat.asStream.do { arg serverIndex, i;
 Synth.grain(\finesine, [\freq, rrand(500,2000)], a[serverIndex]);
 0.1.wait;
 }
}.fork;
)








