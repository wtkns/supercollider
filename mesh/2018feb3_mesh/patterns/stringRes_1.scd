Synth(\stringRes);

s.queryAllNodes;

~srnodeID = 1002;

(
~stringRes = Pmono(\stringRes,
	\id, ~srnodeID,
	\out, Pdefn(\srout, Prand([0, 1, 2, 3], inf)),
    \startfreq, Pdefn(\srstartfreq, 40, inf),
    \endfreq, Pdefn(\srendfreq, 40, inf),
    \len, Pdefn(\srlen, Pdefn(\srdur)),
    \gate, Pdefn(\srt_gate, 1, inf),
    \res, Pdefn(\srres, 0.99, inf),
    \amp, Pdefn(\sramp, 0.01, inf),
    \att, Pdefn(\sratt, 1, inf),
    \dec, Pdefn(\srdec, 1, inf),
    \sus, Pdefn(\srsus, 1, inf),
    \attime, Pdefn(\srattime, 1, inf),
    \dectime, Pdefn(\srdectime, 1, inf),
    \sustime, Pdefn(\srsustime, 1, inf),
	\reltime, Pdefn(\srreltime, 0.4, inf),
    \dur, Pdefn(\srdur, 40, inf)
).play;

Pdefn(\srout, Prand([0, 1, 2, 3], inf));

Pdefn(\srdur, 40, inf);
Pdefn(\srlen, 40, inf);

Pdefn(\srt_gate, 1, inf);

Pdefn(\srstartfreq, 40, inf);
Pdefn(\srendfreq, 40, inf);

Pdefn(\srres, 0.99, inf);

Pdefn(\sratt, 1, inf);
Pdefn(\srdec, 1, inf);
Pdefn(\srsus, 1, inf);

Pdefn(\srattime, 1, inf);
Pdefn(\srdectime, 1, inf);
Pdefn(\srsustime, 1, inf);
Pdefn(\srreltime, 0.4, inf);

Pdefn(\sramp, 0.01, inf);
)



~stringRes_mono.stop

s.queryAllNodes;


~stringRes_bindID = 1002;

(
~stringRes_bind=Pbind(
	\instrument, \stringRes,
	\id, ~stringRes_bindID,
	\type, \set,
	\args, #[],
	\out, Pdefn(\stringResout_bind, Prand([ 0, 1, 2, 3 ], inf)),

	\dur, Pdefn(\stringResdur_bind, 40, inf),
    \len, Pdefn(\stringReslen_bind, 40, inf),

	\t_gate, Pdefn(\stringRest_gate_bind, 1, inf),

	\startfreq, Pdefn(\stringResstartfreq_bind, 40, inf),
	\endfreq, Pdefn(\stringResendfreq_bind, 40, inf),

    \res, Pdefn(\stringResres_bind, 0.99, inf),

	\att, Pdefn(\stringResatt_bind, 1, inf),
	\dec, Pdefn(\stringResdec_bind, 1, inf),
	\sus, Pdefn(\stringRessus_bind, 1, inf),

	\attime, Pdefn(\stringResattime_bind, 1, inf),
	\dectime, Pdefn(\stringResdectime_bind, 1, inf),
	\sustime, Pdefn(\stringRessustime_bind, 1, inf),
    \reltime, Pdefn(\stringResreltime_bind, 0.4, inf),

	\amp, Pdefn(\stringResamp_bind, 0.01, inf),
).play;
)

Pdefn(\stringResout_bind, Prand([ 0, 1, 2, 3 ], inf));

Pdefn(\stringResdur_bind, 40, inf);
Pdefn(\stringReslen_bind, 40, inf);

Pdefn(\stringRest_gate_bind, 1, inf);

Pdefn(\stringResres_bind, 0.99, inf);

Pdefn(\stringResstartfreq_bind, 40, inf);
Pdefn(\stringResendfreq_bind, 40, inf);

Pdefn(\stringResatt_bind, 1, inf);
Pdefn(\stringResdec_bind, 1, inf);
Pdefn(\stringRessus_bind, 1, inf);

Pdefn(\stringResattime_bind, 1, inf);
Pdefn(\stringResdectime_bind, 1, inf);
Pdefn(\stringRessustime_bind, 1, inf);
Pdefn(\stringResreltime_bind, 0.4, inf);

Pdefn(\stringResamp_bind, 0.01, inf);
)

~stringRes_bind.stop

s.sendMsg("/n_free", ~stringRes_monoID);
