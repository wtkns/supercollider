
(
~vosimBindef1 = MeshBindef(\vosimBindef1,
\instrument, \vosim,
\id, 134218732,
\type, \set,
\args, #[],
\out, Pdefn(\vosimOutBindef1, 0, inf),
	\dur, Pdefn(\vosimDurBindef1, Pwhite(0.1,2, inf))
).play;
)

Pbindef(\vosimBindef1, \dur, Pdefn(\vosimDurBindef1, Pwrand([ 2, 0.4, 1 ], [ 0.5, 0.3, 0.2 ], inf)));
Pbindef(\vosimBindef1, \amp, Pdefn(\vosimAmpBindef1, Pseq([ 0.1 ], inf)));
Pbindef(\vosimBindef1, \att, Pdefn(\vosimAttBindef1, Pwhite(0.1)));
Pbindef(\vosimBindef1, \t_gate, Pdefn(\vosimT_gateBindef1, Pseq([ 1 ], inf)));
Pbindef(\vosimBindef1, \len, Pdefn(\vosimLenBindef1, Pseq([ 1 ], inf))*10);
Pbindef(\vosimBindef1, \harms, Pdefn(\vosimHarmsBindef1, Pbrown(1, 12, 1)*2));
Pbindef(\vosimBindef1, \out, Pdefn(\vosimOutBindef1, Pseq([ 0 ], inf)));
Pbindef(\vosimBindef1, \impfreq, Pdefn(\vosimImpfreqBindef1, Pn(Pgeom(10, 1.06, 30)))/4);
Pbindef(\vosimBindef1, \impdepth, Pdefn(\vosimImpdepthBindef1, Pwhite(1, 9))/2);
Pbindef(\vosimBindef1, \freq, Pdefn(\vosimFreqBindef1, Pseq([ 400, 800, 1600 ], inf)));
Pbindef(\vosimBindef1, \freqspread, Pdefn(\vosimFreqspreadBindef1, Pn(Pgeom(1.06, 1.06, 40)*3)));
Pbindef(\vosimBindef1, \endfreq, Pdefn(\vosimEndfreqBindef1, Prand([ 40, 60, 10, 80, 5 ]/2, inf)));
Pbindef(\vosimBindef1, \ncycles, Pdefn(\vosimNcyclesBindef1, Pshuf([ 8, 12, 16, 20, 7 ]/4, inf)));
Pbindef(\vosimBindef1, \decay, Pdefn(\vosimDecayBindef1, Pn(Pseries(1, -0.1, 8)/2)));
-> MeshBindef
~vosimBindef1.stop