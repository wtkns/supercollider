s.queryAllNodes

~effects = Group.after(1);

~effects = 67109864.asTarget;



(
~limiter_mono = Pmono(\limiter,
	\time, Pdefn(\limitertime_mono, 0.01, inf),
	\limit, Pdefn(\limiterlimit_mono, 0.25, inf),
	\group, ~effects
).play;
)


s.queryAllNodes;
~limiter_nodeID = 67109865.asTarget

Pdefn(\limitertime_mono, 0.01, inf);
Pdefn(\limiterlimit_mono, 0.5, inf);



(
~click1 = Pmono(\click,
	\dur, Pdefn(\clickDur, 0.1, inf),
	\outFreq, Pdefn(\clickoutFreq1, 10, inf),
	\amp, Pdefn(\clickamp1, Pseq([ Pn(0.2) ], inf)),
	\freq, Pdefn(\clickfreq1, 10, inf)
).play;
)

~click1.stop;

Pdefn(\clickamp1, Pshuf([ 0.5, 0.25, 0.1 ], inf));

1011.asTarget.free //hihat
1010.asTarget.free //pulse
1009.asTarget.free //stringRes
1006.asTarget.free //swarmSawJames
1005.asTarget.free //vosim
1002.asTarget.free //click






(
// SECTION 1:
MeshMono.insertMono(\simpleQuadMonoSaw, "test1");

)

(
~simpleQuadMonoSawtest1=MeshMono(
\simpleQuadMonoSaw,
\dur, Pdefn(\simpleQuadMonoSawdurtest1),
\out, Pdefn(\simpleQuadMonoSawouttest1),
\panX, Pdefn(\simpleQuadMonoSawpanXtest1),
\amp, Pdefn(\simpleQuadMonoSawamptest1),
\freq, Pdefn(\simpleQuadMonoSawfreqtest1),
\panY, Pdefn(\simpleQuadMonoSawpanYtest1),
).play;


Pdefn(\simpleQuadMonoSawdurtest1, Pshuf([ 1, 0.5, 0.25, 0.125, 0.125 ], inf));
Pdefn(\simpleQuadMonoSawouttest1, nil);
Pdefn(\simpleQuadMonoSawpanXtest1, Pmeanrand(-0.5, 0.5));
Pdefn(\simpleQuadMonoSawamptest1, Pmeanrand(0.2, 0.3));
Pdefn(\simpleQuadMonoSawfreqtest1, (Pseq([ 0, 2, 4, 7, 9 ], inf) + 60).midicps);
Pdefn(\simpleQuadMonoSawpanYtest1, Pmeanrand(-0.5, 0.5));
)

~simpleQuadMonoSawtest1.stop


(
~simpleQuadMonoSawtest1=MeshMono(
\simpleQuadMonoSaw,
\dur, Pdefn(\simpleQuadMonoSawdurtest1),
\out, Pdefn(\simpleQuadMonoSawouttest1),
\panX, Pdefn(\simpleQuadMonoSawpanXtest1),
\amp, Pdefn(\simpleQuadMonoSawamptest1),
\freq, Pdefn(\simpleQuadMonoSawfreqtest1),
\panY, Pdefn(\simpleQuadMonoSawpanYtest1),
).play;


Pdefn(\simpleQuadMonoSawdurtest1, Pshuf([ 1, 0.5, 0.25, 0.125, 0.125 ], inf));
Pdefn(\simpleQuadMonoSawouttest1, nil);
Pdefn(\simpleQuadMonoSawpanXtest1, Pmeanrand(-0.5, 0.5));
Pdefn(\simpleQuadMonoSawamptest1, Pmeanrand(0.2, 0.3));
Pdefn(\simpleQuadMonoSawfreqtest1, (Pseq([ 0, 2, 4, 7, 9 ], inf) + 60).midicps);
Pdefn(\simpleQuadMonoSawpanYtest1, Pmeanrand(-0.5, 0.5));
)

~simpleQuadMonoSawtest1.stop


(
// SECTION 2:
MeshMono.insertMono(\simpleQuadPolySaw, "test2");
)

(
// SECTION 3:
// alternatively
"/patterns/mono/simpleQuadMonoSaw/simpleQuadMonoSawSession.scd".openRelative;
)









// Sample session.
// first run the code in ../mesh_startup
"synthdefs.scd".loadRelative;
// Anyone can instantiate a synth.
// only the person who instantiates the synth can .set args on the synth
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


n = s.nextNodeID;
s.sendMsg("/s_new", "default", n);
s.sendMsg("/n_free", n);


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

// when you are finished, at the end of the session:
//    cleanup everything
~cleanupUtopia.value;



MeshMono.makeTemplate(\click, "_mono", "_bind");

MeshMono.makeTemplate(\decayDelay, "_mono", "_bind");

MeshMono.postPdefns(\click, "_bind");
MeshMono.postPdefns(\decayDelay, "_bind");
MeshMono.postPdefns(\decayDelay, "_bind", false);

MeshMono.insertMono(\click, "_mono", "_bind");


Synths:


~effectGroup = Group.new;


(
~decayDelay_mono = Pmono(\decayDelay,
\dur, Pdefn(\decayDelayDur_mono, nil),
\delayDecay, Pdefn(\decayDelaydelayDecay_mono, 3, inf),
\maxdelaytime, Pdefn(\decayDelaymaxdelaytime_mono, 0.2, inf),
\decayTime, Pdefn(\decayDelaydecayTime_mono, 0.2, inf),
\delaytime, Pdefn(\decayDelaydelaytime_mono, 0.2, inf),
	\group, ~effectGroup
).play;
)
