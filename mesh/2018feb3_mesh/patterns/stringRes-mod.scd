// PMONO to control click w/o ID
(
~srM1 = Pmono(\stringRes,
	\out, Pdefn(\srM1out, Prand([0, 1, 2, 3], inf)),
    \startfreq, Pdefn(\srM1startfreq, 40, inf),
    \endfreq, Pdefn(\srM1endfreq, 40, inf),
    \len, Pdefn(\srM1len, Pdefn(\srM1dur)),
    \gate, Pdefn(\srM1t_gate, 1, inf),
    \res, Pdefn(\srM1res, 0.99, inf),
    \amp, Pdefn(\srM1amp, 0.01, inf),
    \att, Pdefn(\srM1att, 1, inf),
    \dec, Pdefn(\srM1dec, 1, inf),
    \sus, Pdefn(\srM1sus, 1, inf),
    \attime, Pdefn(\srM1attime, 1, inf),
    \dectime, Pdefn(\srM1dectime, 1, inf),
    \sustime, Pdefn(\srM1sustime, 1, inf),
	\reltime, Pdefn(\srM1reltime, 0.4, inf),
    \dur, Pdefn(\srM1dur, 40, inf)
);
)

c = ~srM1.play;
c.stop;

// PMONO mods
Pdefn(\srM1out, Prand([0, 1, 2, 3], inf));

Pdefn(\srM1dur, 40, inf);
Pdefn(\srM1len, 40, inf);

Pdefn(\srM1t_gate, 1, inf);

Pdefn(\srM1startfreq, 40, inf);
Pdefn(\srM1endfreq, 40, inf);

Pdefn(\srM1res, 0.99, inf);

Pdefn(\srM1att, 1, inf);
Pdefn(\srM1dec, 1, inf);
Pdefn(\srM1sus, 1, inf);

Pdefn(\srM1attime, 1, inf);
Pdefn(\srM1dectime, 1, inf);
Pdefn(\srM1sustime, 1, inf);
Pdefn(\srM1reltime, 0.4, inf);

Pdefn(\srM1amp, 0.01, inf);

// PBIND to control running Pmono w/ Pbind
// query nodes, assign clkB1nodeID to appropriate node
s.queryAllNodes;
~srB1nodeID = 11111111;

(
~srB1 = Pbind(
	\instrument, \stringRes,
	\id, ~srB1nodeID,
	\type, \set,
	\args, #[],
	\out, Pdefn(\srB1out, Prand([ 0, 1, 2, 3 ], inf)),

	\dur, Pdefn(\srB1dur, 40, inf),
    \len, Pdefn(\srB1len, 40, inf),

	\t_gate, Pdefn(\srB1t_gate, 1, inf),

	\startfreq, Pdefn(\srB1startfreq, 40, inf),
	\endfreq, Pdefn(\srB1endfreq, 40, inf),

    \res, Pdefn(\srB1res, 0.99, inf),

	\att, Pdefn(\srB1att, 1, inf),
	\dec, Pdefn(\srB1dec, 1, inf),
	\sus, Pdefn(\srB1sus, 1, inf),

	\attime, Pdefn(\srB1attime, 1, inf),
	\dectime, Pdefn(\srB1dectime, 1, inf),
	\sustime, Pdefn(\srB1sustime, 1, inf),
    \reltime, Pdefn(\srB1reltime, 0.4, inf),

	\amp, Pdefn(\srB1amp, 0.01, inf),
);
)

d = ~srB1.play;
d.stop;

// PBIND mods
Pdefn(\srB1out, Prand([ 0, 1, 2, 3 ], inf));

Pdefn(\srB1dur, 40, inf);
Pdefn(\srB1len, 40, inf);

Pdefn(\srB1t_gate, 1, inf);

Pdefn(\srB1res, 0.99, inf);

Pdefn(\srB1startfreq, 40, inf);
Pdefn(\srB1endfreq, 40, inf);

Pdefn(\srB1att, 1, inf);
Pdefn(\srB1dec, 1, inf);
Pdefn(\srB1sus, 1, inf);

Pdefn(\srB1attime, 1, inf);
Pdefn(\srB1dectime, 1, inf);
Pdefn(\srB1sustime, 1, inf);
Pdefn(\srB1reltime, 0.4, inf);

Pdefn(\srB1amp, 0.01, inf);

// BUNK node? query nodes, find synth, kill it
s.queryAllNodes;
s.sendMsg("/n_free", ~srB1nodeID);
