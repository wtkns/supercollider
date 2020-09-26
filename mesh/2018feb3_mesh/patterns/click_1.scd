Synth(\click);

~cnodeID=1000;
s.queryAllNodes;

(
~click_mono=Pmono(
	\click,
    \id, ~cnodeID,
	\dur, Pdefn(\clickdur_mono, Pexprand(0.01, 0.1)),
	\outFreq, Pdefn(\clickoutFreq_mono, 10, inf),
	\freq, Pdefn(\clickamp_mono, 10, inf),
	\amp, Pdefn(\clickfreq_mono, Pseq([ Pseries(0, 0.0001, 2000), Pn(0.2) ], inf))
).play;
)


~click_mono.stop;

s.queryAllNodes;


~click_bindID = 1000;

(
~click_bind=Pbind(
\instrument, \click,
\id, ~click_bindID,
\type, \set,
\args, #[],
\dur, Pdefn(\clickdur_bind, Pexprand(0.01, 0.1)),
\outFreq, Pdefn(\clickoutFreq_bind, 10, inf),
\amp, Pdefn(\clickamp_bind, Pseq([ Pseries(0, 0.0001, 2000), Pn(0.2) ], inf)),
\freq, Pdefn(\clickfreq_bind, 10, inf),
).play;


Pdefn(\clickoutFreq_bind, 10, inf);
Pdefn(\clickamp_bind, Pseq([ Pseries(0, 0.0001, 2000), Pn(0.2) ], inf));
Pdefn(\clickfreq_bind, 10, inf);
)

~click_bind.stop

s.sendMsg(/n_free, ~click_monoID);

-> MeshMono
