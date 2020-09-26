// Sample session.
// first run the code in ../mesh_startup
"synthdefs.scd".loadRelative;
// Anyone can instantiate a synth.
// only the person who instantiates the synth can .set args on the synth
u=Synth.new(\trigTest, [freq: 800, dur: 0.75], s, \addToHead)
v=Synth.new(\trigTest2, [freq: 800, dur: 0.75], s, \addToHead)

u.free;
v.free;

{SinOsc.ar(200);}.play

u.set(\t_trig, 1);
u.set(\freq, 00);
v.set(\t_trig, 0.05);
v.set(\len, 2);
v.set(\freq, 400);
v.set(\freq1, 200);
v.set(\freq3, 200);
v.set(\freq4, 200);

// replace these node ids with the desired one
~nodeID = 67110290;
~nodeID2 = 67109865;
(
p = Pmono(
  \trigTest,
  \id, ~nodeID,
  \t_trig, 1,
  \dur, Pdefn(\pdur),
  \freq, Pdefn(\pfreq)
).play(quant: TempoClock.default.beats);
)
p.stop;
p.reset.play;
p.free;

(
q = Pmono(
  \trigTest2,
  \id, ~nodeID2,
  \t_trig, Pdefn(\ptrig),
  \dur, Pdefn(\pdur),
	\out, Pdefn(\pout),
  \len, Pdefn(\plen),
  \freq, Pdefn(\pfreq),
  \freq2, Pdefn(\pfreq2),
  \freq3, Pdefn(\pfreq3),
  \freq4, Pdefn(\pfreq4)
).play(quant: TempoClock.default.beats);
)
q.stop;
q.pause;
q.play;
q.reset.play;
q.free;

// some sample Pdefns
Pdefn(\pfreq, Prand([1200, 650, 520], inf));
Pdefn(\pfreq2, Prand([900, 370, 1400], inf));
Pdefn(\pfreq3, Prand([1300, 620, 740, 400], inf));
Pdefn(\pfreq4, Prand([650, 540, 340, 520], inf));
Pdefn(\t_trig, Pseq([0.15], inf));
Pdefn(\pdur, Pexprand(0.125, 0.5, inf));
Pdefn(\plen, Pexprand(0.125, 0.5, inf));
Pdefn(\pout, Prand([0,1,2,3], inf));

SynthDescRelay

~string = Pmono(
	\stringRes,
	\id, r.nodeID,
	\startfreq, Pdefn(\stringFreq),
	\dur, Pdefn(\sr_dur),
	\res, Pdefn(\sr_res),
	\len, Pdefn(\sr_len),
	\gate, Pdefn(\ps_gate),
	\out, Pdefn(\ps_out),
).play(quant:TempoClock.default.beats);

~string.reset.play;
~string.stop;
~string.pause;
~string.free


Pdefn(\stringFreq, Pseq([8, 20, 4, 10], inf));
Pdefn(\sr_dur, Pseq([0.125, 0.5, 0.25], inf));
Pdefn(\sr_res, Prand([0.8, 0.85, 0.9], inf));
Pdefn(\sr_len, Prand([0.2, 0.17, 1.125], inf));
Pdefn(\ps_gate, Prand([1], inf));
Pdefn(\ps_out, Prand([[0,1],[2,3]],inf));

SynthDescLib.at(\trigTest2)
SynthDescLib.at(\stringRes)


//free a node
s.sendMsg("/n_free", 67109865);


s.sendMsg("/n_set", 201327592);
s.sendMsg("/n_set", 201327594, \t_gate, 1);
s.sendMsg("/n_set", 201327595, \out, [2,3]);

"hello".postln

r.nodeID

~srnodeID = 1000;

~srnodeID