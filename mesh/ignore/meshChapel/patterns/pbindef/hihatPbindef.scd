

(
~hihatMono1 = MeshMono(\hihat,
  \dur, Pdefn(\hihatDurMono1, Pn(Pseries(0.05, 0.01, 20))),
  \gate, Pdefn(\hihatT_gateMono1, 1),
  \len, Pdefn(\hihatLenMono1, 0.01),
  \lpFreq, Pdefn(\hihatLpFreqMono1, 6000, inf),
  \hpFreq, Pdefn(\hihatHpFreqMono1, 2500, inf),
  \out, Pdefn(\hihatOutMono1, Prand([ 0, 1, 2, 3 ], inf)),
  \amp, Pdefn(\hihatAmpMono1, Pseq([ Pseries(0, 0.0004, 500), Pn(0.2) ]))
).collect {|event| ~hihatMono1NodeID = event[\id]; event}.play;
)



~hihatMono1Node = ~hihatMono1NodeID[0].asTarget;


/////////////////////////

MeshBindef.writeBindef(\hihat, 1, ~hihatMono1Node);


~hihatMono1.stop;
~hihatMono1Node.free;
-> MeshMono



(
~hihatBindef1 = MeshBindef(\hihatBindef1,
\instrument, \hihat,
\id, 134217729,
\type, \set,
\args, #[],
	\dur, Pdefn(\hihatDurBindef1, Pwhite(0.1, 1, inf))
).play;
)

Pbindef(\hihatBindef1, \dur, Pdefn(\hihatDurBindef1, Pexprand(0.01, 0.2, inf)));
Pbindef(\hihatBindef1, \gate, Pdefn(\hihatT_gateBindef1, 1));
Pbindef(\hihatBindef1, \len, Pdefn(\hihatLenBindef1, Pexprand(0.01, 2, inf)));
Pbindef(\hihatBindef1, \lpFreq, Pdefn(\hihatLpFreqBindef1, 100, inf));
Pbindef(\hihatBindef1, \hpFreq, Pdefn(\hihatHpFreqBindef1, 1500, inf));
Pbindef(\hihatBindef1, \out, Pdefn(\hihatOutBindef1, Prand([ 0, 1, 2, 3 ], inf)));
Pbindef(\hihatBindef1, \amp, Pdefn(\hihatAmpBindef1, Pexprand(0.01, 0.2, inf)));



Pdefn(\hihatHpFreqBindef1, Pwalk([200, 240, 440, 600]))
Pdefn(\hihatLpFreqBindef1, Pwalk([2000, 2400, 4400, 6000]))


~hihatBindef1.stop

-> MeshBindef



Pbindef.clear