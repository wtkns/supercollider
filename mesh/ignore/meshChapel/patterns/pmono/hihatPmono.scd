~hihatMono1.stop


MeshMono.killAll

(
~hihatMono1 = Pmono(\hihat,
  \dur, Pdefn(\hihatDurMono1, ),
  \gate, Pdefn(\hihatT_gateMono1, 1),
  \len, Pdefn(\hihatLenMono1, 0.01),
  \lpFreq, Pdefn(\hihatLpFreqMono1, 6000, inf),
  \hpFreq, Pdefn(\hihatHpFreqMono1, 2500, inf),
  \out, Pdefn(\hihatOutMono1, Prand([ 0, 1, 2, 3 ], inf)),
).play;
)

Pdefn(\hihatHpFreqMono1, Pwalk([200, 240, 440, 600]))
Pdefn(\hihatLpFreqMono1, Pwalk([2000, 2400, 4400, 6000]))



  \amp, Pdefn(\hihatAmpMono1,
		Pshuf([
		Pseq([ Pseries(0, 0.0004, 500), Pn(0.2) ])),
		Pseq([ Pseries(0, 0.0004, 500), Pn(0.2) ])]), inf)


Pdefn(\hihatDurMono1,
	Pshuf([
		Pseq([ Pshuf([0.25, 0.25, 0.5, 0.5], inf), Pn(0.275) ]),
		Pseq([ Pshuf([0.25, 0.1, 0.5], inf), Pn(0.275)])
	], inf));


~hihatMono1Node = ~hihatMono1NodeID[0].asTarget;


/////////////////////////

MeshBindef.writeBindef(\hihat, 1, ~hihatMono1Node);


~hihatMono1.stop;
~hihatMono1Node.free;
-> MeshMono



(
~hihatBindef1 = MeshBindef(\hihatBindef1,
\instrument, \hihat,
\id, 67109872,
\type, \set,
\args, #[],
	\dur, Pdefn(\hihatDurBindef1, Pwhite(0.1, 1, inf))
).play;
)

Pbindef(\hihatBindef1, \dur, Pdefn(\hihatDurBindef1, Pexprand(0.01, 2, inf)));
Pbindef(\hihatBindef1, \gate, Pdefn(\hihatT_gateBindef1, 1));
Pbindef(\hihatBindef1, \len, Pdefn(\hihatLenBindef1, Pexprand(0.01, 2, inf)));
Pbindef(\hihatBindef1, \lpFreq, Pdefn(\hihatLpFreqBindef1, 100, inf));
Pbindef(\hihatBindef1, \hpFreq, Pdefn(\hihatHpFreqBindef1, 1500, inf));
Pbindef(\hihatBindef1, \out, Pdefn(\hihatOutBindef1, Prand([ 0, 1, 2, 3 ], inf)));
Pbindef(\hihatBindef1, \amp, Pdefn(\hihatAmpBindef1, Pexprand(0.01, 0.2, inf)));
~hihatBindef1.stop