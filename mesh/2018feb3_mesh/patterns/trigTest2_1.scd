MeshMono.makeTemplate(\trigTest2, "_mono", "_bind");

//Either create a Synth, or use a Pmono
//I prefer creating a Synth, and then using the Pbind to control the synth
~trigTest2 = Synth(\trigTest2);

(
~trigTest2_mono = Pmono(\trigTest2,
\out, Pdefn(\trigTest2out_mono, nil),
\dur, Pdefn(\trigTest2len_mono, nil),
\freq2, Pdefn(\trigTest2freq2_mono, nil),
\freq3, Pdefn(\trigTest2freq3_mono, nil),
\freq, Pdefn(\trigTest2freq_mono, nil),
\freq4, Pdefn(\trigTest2freq4_mono, nil),
\trig, Pdefn(\trigTest2t_trig_mono, nil),
\lagTime, Pdefn(\trigTest2t_lagTime_mono, nil),
\dur, Pdefn(\trigTest2dur_mono, nil)
).play;
)

~trigTest2_mono.isPlaying;
~trigTest2_mono.stop;

s.queryAllNodes;

~trigTest2_bindID = 1012;

(
~trigTest2_bind = Pbind(
\instrument, \trigTest2,
\id, ~trigTest2_bindID,
\args, #[],//magic parameter that is needed for this to work.
\type, \set,
\out, Pdefn(\trigTest2out_bind),
\freq2, Pdefn(\trigTest2freq2_bind),
\freq3, Pdefn(\trigTest2freq3_bind),
\freq, Pdefn(\trigTest2freq_bind),
\freq4, Pdefn(\trigTest2freq4_bind),
\trig, Pdefn(\trigTest2t_trig_bind),
\lagTime, Pdefn(\trigTest2t_lagTime_bind, nil),
\dur, Pdefn(\trigTest2dur_bind)
).play;
)

~trigTest2_bind.isPlaying;
~trigTest2_bind.stop;
~trigTest2_bind.reset.play;

//////////////////////////////////////////
// low pitched flop around
//////////////////////////////////////////
//
// 2 channel
Pdefn(\trigTest2out_bind, Pxrand([0, 1], inf));
///////////////////////
// OR 4 channel
Pdefn(\trigTest2out_bind, Pxrand([0, 1, 2, 3], inf));
Pdefn(\trigTest2out_bind, Pseq([0, 1, 2, 3], inf));
///////////////////////
Pdefn(\trigTest2t_lagTime_bind, Pn(0.25));
Pdefn(\trigTest2freq_bind, Pbrown(80, 200, 10, inf));
Pdefn(\trigTest2freq2_bind, Pbrown(60, 90, 30, inf));
Pdefn(\trigTest2freq3_bind, Pbrown(300, 500, 100, inf));
Pdefn(\trigTest2freq4_bind, Pbrown(200, 300, 50, inf));
Pdefn(\trigTest2t_trig_bind, Pexprand(0.5, 1.0, inf));
Pdefn(\trigTest2dur_bind, Pn(Prand([Pgbrown(0.0125, 1.0, 0.0125, 5), Pseq([0.125, 0.025], 15)], inf)));

// alternate duration rythms
Pdefn(\trigTest2dur_bind, Pn(0.025));
Pdefn(\trigTest2dur_bind, Pn(0.05));
Pdefn(\trigTest2dur_bind, Pn(Pseries(0.05, 0.01, 20)));
Pdefn(\trigTest2dur_bind, Pn(Pseries(0.05, 0.05, 7)));
Pdefn(\trigTest2dur_bind, Pseq([Pseries(0.05, 0.01, 20), Pseries(0.05, 0.05, 7)], inf));

//////////////////////
// Slow and stretchy
//////////////////////
Pdefn(\trigTest2t_lagTime_bind, Pn(5));
Pdefn(\trigTest2dur_bind, Pn(5));



//////////////////////
// Higher freqs
//////////////////////
(
Pdefn(\trigTest2freq_bind, Pbrown(400, 700, 10, inf));
Pdefn(\trigTest2freq2_bind, Pbrown(100, 1000, 30, inf));
Pdefn(\trigTest2freq3_bind, Pbrown(300, 500, 100, inf));
Pdefn(\trigTest2freq4_bind, Pbrown(1200, 1600, 50, inf));
)

~trigTest2.free;
s.sendMsg("/n_free",~trigTest2_bindID);
