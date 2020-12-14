

(
~vosimMono1 = MeshMono(\vosim,
  \dur, Pdefn(\vosimDurMono1, Pwrand([ 2, 0.4, 1 ], [ 0.5, 0.3, 0.2 ], inf)),
  \amp, Pdefn(\vosimAmpMono1, Pseq([ 0.01 ], inf)),
  \att, Pdefn(\vosimAttMono1, Pwhite(0.001)),
  \t_gate, Pdefn(\vosimT_gateMono1, Pseq([ 1 ], inf)),
  \len, Pdefn(\vosimLenMono1, Pseq([ 1 ], inf)),
  \harms, Pdefn(\vosimHarmsMono1, Pbrown(1, 12, 1)),
  \out, Pdefn(\vosimOutMono1, Pseq([ 0 ], inf)),
  \impfreq, Pdefn(\vosimImpfreqMono1, Pn(Pgeom(10, 1.06, 30))),
  \impdepth, Pdefn(\vosimImpdepthMono1, Pwhite(1, 9)),
  \freq, Pdefn(\vosimFreqMono1, Pseq([ 400 ], inf)),
  \freqspread, Pdefn(\vosimFreqspreadMono1, Pn(Pgeom(1.06, 1.06, 40))),
  \endfreq, Pdefn(\vosimEndfreqMono1, Prand([ 40, 60, 10, 80, 5 ], inf)),
  \ncycles, Pdefn(\vosimNcyclesMono1, Pshuf([ 8, 12, 16, 20, 7 ], inf)),
  \decay, Pdefn(\vosimDecayMono1, Pn(Pseries(1, -0.1, 8)))
).collect {|event| ~vosimMono1NodeID = event[\id]; event}.play;
)

~vosimMono1


~vosimMono1Node = ~vosimMono1NodeID[0].asTarget;


/////////////////////////

MeshBindef.writeBindef(\vosim, 1, ~vosimMono1Node);


~vosimMono1.stop;
~vosimMono1Node.free;
-> MeshMono
