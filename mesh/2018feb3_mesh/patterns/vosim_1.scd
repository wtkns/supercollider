(
~vosim_mono=Pmono(\vosim,
	\dur, Pdefn(\vmdur, Pwrand([2, 0.4, 1], [0.5, 0.3, 0.2], inf)),
	\amp, Pdefn(\vmamp, Pseq([0.01], inf)),
	\att, Pdefn(\vmatt, Pwhite(0.001, 1, inf)),
	\gate, Pdefn(\vmgate, Pseq([1], inf)),
	\len, Pdefn(\vmlen, Pseq([1], inf)),
	\harms, Pdefn(\vmharms, Pbrown(1, 12, 1)),
	\out, Pdefn(\vmout, Pseq([0], inf)),
	\impfreq, Pdefn(\vmimpfreq, Pn(Pgeom(10, 1.06, 30))),
	\impdepth, Pdefn(\vmimpdepth, Pwhite(1, 9)),
	\freq, Pdefn(\vmfreq, Pseq([400], inf)),
	\freqspread, Pdefn(\vmfreqspread, Pn(Pgeom(1.06, 1.06, 40), inf)),
	\endfreq, Pdefn(\vmendfreq, Prand([40, 60, 10, 80, 5], inf)),
	\ncycles, Pdefn(\vmncycles, Pshuf([8, 12, 16, 20, 7], inf)),
	\decay, Pdefn(\vmdecay, Pn(Pseries(1, -0.1, 8), inf))
);
)

~vm=~vosim_mono.play;

Pdefn(\vmdur, Pwrand([2, 0.4, 1], [0.5, 0.3, 0.2], inf));
Pdefn(\vmamp, Pseq([0.01], inf));
Pdefn(\vmatt, Pwhite(0.001, 1, inf));
Pdefn(\vmgate, Pseq([1], inf));
Pdefn(\vmlen, Pseq([1], inf));
Pdefn(\vmharms, Pbrown(1, 12, 1));
Pdefn(\vmout, Pseq([0], inf));
Pdefn(\vmimpfreq, Pn(Pgeom(10, 1.06, 30)));
Pdefn(\vmimpdepth, Pwhite(1, 9));
Pdefn(\vmfreq, Pseq([400], inf));
Pdefn(\vmfreqspread, Pn(Pgeom(1.06, 1.06, 40), inf));
Pdefn(\vmendfreq, Prand([40, 60, 10, 80, 5], inf));
Pdefn(\vmncycles, Pshuf([8, 12, 16, 20, 7], inf));
Pdefn(\vmdecay, Pn(Pseries(1, -0.1, 8), inf));

~vm.stop;

~vbindID=NNNNNNN;

(
~vosim_pbind=Pbind(
	\instrument, \vosim,
	\id, ~vbindID,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\vbdur, Pwrand([2, 0.4, 1], [0.5, 0.3, 0.2], inf)),
	\len, Pdefn(\vblen, Pseq([1], inf)),
	\out, Pdefn(\vbout, Pseq([0], inf)),
	\amp, Pdefn(\vbamp, Pseq([0.01], inf)),
	\gate, Pdefn(\vbgate, Pseq([1], inf)),
	\harms, Pdefn(\vbharms, Pbrown(1, 12, 1)),
	\impfreq, Pdefn(\vbimpfreq, Pn(Pgeom(10, 1.06, 30))),
	\impdepth, Pdefn(\vbimpdepth, Pwhite(1, 9)),
	\freq, Pdefn(\vbfreq, Pseq([400], inf)),
	\freqspread, Pdefn(\vbfreqspread, Pn(Pgeom(1.06, 1.06, 40), inf)),
	\endfreq, Pdefn(\vbendfreq, Prand([40, 60, 10, 80, 5], inf)),
	\ncycles, Pdefn(\vbncycles, Pshuf([8, 12, 16, 20, 7], inf)),
	\att, Pdefn(\vbatt, Pwhite(0.001, 1, inf)),
	\decay, Pdefn(\vbdecay, Pn(Pseries(1, -0.1, 8), inf))
);
)

~vb=~vosim_pbind.play;

Pdefn(\vbdur, Pwrand([2, 0.4, 1], [0.5, 0.3, 0.2], inf));
Pdefn(\vblen, Pseq([1], inf));
Pdefn(\vbout, Pseq([0], inf));
Pdefn(\vbamp, Pseq([0.01], inf));
Pdefn(\vbgate, Pseq([1], inf));
Pdefn(\vbharms, Pbrown(1, 12, 1));
Pdefn(\vbimpfreq, Pn(Pgeom(10, 1.06, 30)));
Pdefn(\vbimpdepth, Pwhite(1, 9));
Pdefn(\vbfreq, Pseq([400], inf));
Pdefn(\vbfreqspread, Pn(Pgeom(1.06, 1.06, 40), inf));
Pdefn(\vbendfreq, Prand([40, 60, 10, 80, 5], inf));
Pdefn(\vbncycles, Pshuf([8, 12, 16, 20, 7], inf));
Pdefn(\vbatt, Pwhite(0.001, 1, inf));
Pdefn(\vbdecay, Pn(Pseries(1, -0.1, 8), inf));

~vb.stop;

	