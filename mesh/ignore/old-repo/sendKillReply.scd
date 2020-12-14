
s.boot;

(
SynthDef(\killReplyTest, {|
	out = 0,
	t_kill = 0,
	t_gate = 0,
	freq = 200,
    amp = 0.25,
    pos = 0|
	
	var killEnv = EnvGen.kr(Env.adsr, t_kill, doneAction: Done.freeSelf);
	var ampEnv = EnvGen.kr(Env.perc, t_gate, doneAction: Done.none);
	var sig = SinOsc.ar(freq) * amp * ampEnv;

	Out.ar(out, Pan2.ar(sig, pos));
	
	SendReply.kr(
		trig: t_kill,
		cmdName: '/kill',
		replyID: 1)
	
}).add;



o =  OSCFunc({ arg msg, time;
	var node = msg[1];
	[time, msg].postln;
	("Synth Node Killed:  "++node).postln;
	
 	Pbindef.all.keysValuesDo({| key, value |	
		if (value.repositoryArgs[1..].asEvent.at(\id).nodeID == node,
			{("Stopping Pbindef: "++value.key).postln; value.stop })})
},'/kill', s.addr);

)


x = Synth(\killReplyTest);

x.set(\t_gate, 1);


(

Pbindef(\testPbindef,
	\type, \set,
	\id, x,
	\instrument, \killReplyTest,
	\args, #[],
	\dur, 0.5
).play;

Pbindef(\testPbindef, \gate, Pdefn(\gateDefn, Prand([0,1], inf)));
Pbindef(\testPbindef, \freq, Pdefn(\freqDefn, Pexprand(200, 600, inf)));

)

x.set(\t_kill, 1);

Pbindef(\testPbindef).clear;

o.free



