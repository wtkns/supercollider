Synth(\fmGrain);

s.queryAllNodes;

~fmGrnodeID = 1001;


(

~fmGrain_mono=Pmono(
	\fmGrain,
	\id, ~fmGrnodeID,
	\gate, Pdefn(\fmGraint_gate_mono, 1, inf),
	\dur, Pdefn(\fmGraindur_mono, Pexprand(0.01, 0.1)),
	\len, Pdefn(\fmGrainlen_mono, 0.2, inf),
	\indexRangeHi, Pdefn(\fmGrainindexRangeHi_mono, Pexprand(10, 100)),
	\amp, Pdefn(\fmGrainamp_mono, 0.5, inf),
	\carfreq, Pdefn(\fmGraincarfreq_mono, 440, inf),
	\panY, Pdefn(\fmGrainpanY_mono, Pbrown(-1)),
	\modfreq, Pdefn(\fmGrainmodfreq_mono, 2200-Pexprand(100, 1600)),
	\indexRate, Pdefn(\fmGrainindexRate_mono, 10, inf),
	\panX, Pdefn(\fmGrainpanX_mono, Pbrown(-1)),
	\indexRangeLow, Pdefn(\fmGrainindexRangeLow_mono, 1, inf),
	\freq, Pdefn(\fmGrainfreq_mono, 20, inf)
).play;

)


~fmGrain_mono.stop

s.queryAllNodes;


~fmGrain_bindID = NNNNNNN;

(
~fmGrain_bind=Pbind(
	\instrument, \fmGrain,
	\id, ~fmGrain_bindID,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\fmGraindur_bind, Pexprand(0.01, 0.1)),

	\len, Pdefn(\fmGrainlen_bind, 0.2, inf),
	\indexRangeHi, Pdefn(\fmGrainindexRangeHi_bind, Pexprand(10, 100)),
	\amp, Pdefn(\fmGrainamp_bind, 1.2, inf),
	\carfreq, Pdefn(\fmGraincarfreq_bind, 440, inf),
	\gate, Pdefn(\fmGraint_gate_bind, 1, inf),
	\panY, Pdefn(\fmGrainpanY_bind, Pbrown(-1)),
	\modfreq, Pdefn(\fmGrainmodfreq_bind, 2200-Pexprand(100, 1600)),
	\indexRate, Pdefn(\fmGrainindexRate_bind, 10, inf),
	\panX, Pdefn(\fmGrainpanX_bind, Pbrown(-1)),
	\indexRangeLow, Pdefn(\fmGrainindexRangeLow_bind, 1, inf),
	\freq, Pdefn(\fmGrainfreq_bind, 20, inf),
).play;


Pdefn(\fmGrainlen_bind, 0.2, inf);
Pdefn(\fmGrainindexRangeHi_bind, Pexprand(10, 100));
Pdefn(\fmGrainamp_bind, 1.2, inf);
Pdefn(\fmGraincarfreq_bind, 440, inf);
Pdefn(\fmGraint_gate_bind, 1, inf);
Pdefn(\fmGrainpanY_bind, Pbrown(-1));
Pdefn(\fmGrainmodfreq_bind, 2200-Pexprand(100, 1600));
Pdefn(\fmGrainindexRate_bind, 10, inf);
Pdefn(\fmGrainpanX_bind, Pbrown(-1));
Pdefn(\fmGrainindexRangeLow_bind, 1, inf);
Pdefn(\fmGrainfreq_bind, 20, inf);
)

~fmGrain_bind.stop

Pdefn(\fmGrainamp_mono, 0.0, inf)

s.sendMsg("/n_free", ~fmGrnodeID);
