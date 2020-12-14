
~kickMono1.stop

134218730.asTarget.free

(
~kickMono1 = Pmono(\kick,
  \dur, Pdefn(\kickDurMono1, Pexprand(0.001, 0.5)),
	\gate, Pdefn(\kickT_gateMono1, Pshuf([0,0,1,0],inf)),
  \len, Pdefn(\kickLenMono1, Pexprand(0.001, 0.5)),
  \subFreq, Pdefn(\kickSubFreqMono1, Pexprand(100, 200)),
  \hitFreq, Pdefn(\kickHitFreqMono1, Pexprand(100, 200)),
  \panX, Pdefn(\kickPanXMono1, Pwhite(1, -1)),
  \panY, Pdefn(\kickPanYMono1, Pwhite(-1, 1)),
  \amp, Pdefn(\kickAmpMono1, Pwhite(0.1, 0.25))
).play;
)


(
~kickMono2 = Pmono(\kick,
  \dur, Pdefn(\kickDurMono1, Pexprand(0.001, 0.5)),
	\gate, Pdefn(\kickT_gateMono1, Pshuf([0,0,1,0],inf)),
  \len, Pdefn(\kickLenMono1, Pexprand(0.001, 0.5)),
  \subFreq, Pdefn(\kickSubFreqMono1, Pexprand(10, 200)),
  \hitFreq, Pdefn(\kickHitFreqMono1, Pexprand(10, 200)),
  \panX, Pdefn(\kickPanXMono1, Pwhite(1, -1)),
  \panY, Pdefn(\kickPanYMono1, Pwhite(-1, 1)),
  \amp, Pdefn(\kickAmpMono1, Pwhite(0.1, 0.25))
).play;
)

(
~kickMono3 = Pmono(\kick,
  \dur, Pdefn(\kickDurMono1, Pexprand(0.001, 0.5)),
	\gate, Pdefn(\kickT_gateMono1, Pshuf([0,0,1,0],inf)),
  \len, Pdefn(\kickLenMono1, Pexprand(0.001, 0.5)),
  \subFreq, Pdefn(\kickSubFreqMono1, Pexprand(10, 200)),
  \hitFreq, Pdefn(\kickHitFreqMono1, Pexprand(10, 200)),
  \panX, Pdefn(\kickPanXMono1, Pwhite(1, -1)),
  \panY, Pdefn(\kickPanYMono1, Pwhite(-1, 1)),
  \amp, Pdefn(\kickAmpMono1, Pwhite(0.1, 0.25))
).play;
)

~kickMono1Node = ~kickMono1NodeID[0].asTarget;


/////////////////////////

MeshBindef.writeBindef(\kick, 1, ~kickMono1Node);


~kickMono1.stop;
~kickMono1Node.free;


(
~kickBindef1 = Pbindef(\kickBindef1,
\instrument, \kick,
\id, 201326593,
\type, \set,
\args, #[],
\dur, Pdefn(\kickDurBindef1, Pexprand(0.001, 0.5))
).play;
)

Pbindef(\kickBindef1, \dur, Pdefn(\kickDurBindef1, nil));
Pbindef(\kickBindef1, \gate, Pdefn(\kickT_gateBindef1, Pshuf([1], inf)));
Pbindef(\kickBindef1, \len, Pdefn(\kickLenBindef1, Pgeom.new(start: 0, grow: 0.001, length: inf)));
Pbindef(\kickBindef1, \subFreq, Pdefn(\kickSubFreqBindef1, nil));
Pbindef(\kickBindef1, \hitFreq, Pdefn(\kickHitFreqBindef1, nil));
Pbindef(\kickBindef1, \panX, Pdefn(\kickPanXBindef1, nil));
Pbindef(\kickBindef1, \panY, Pdefn(\kickPanYBindef1, nil));
Pbindef(\kickBindef1, \amp, Pdefn(\kickAmpBindef1, nil));

Pdefn(\kickLenMono1, Pgeom.new(start: 0.001, grow: 0.01, length: inf));

\kickDurMono1

Pbindef(\kickBindef1, \gate, Pdefn(\kickT_gateBindef1, 1));

Pbindef(\kickBindef1, \gate, nil)

Pbindef(\kickBindef1).clear

67109871.asTarget.free
67109870.asTarget.free
67109869.asTarget.free
