// PMONO to control click w/o ID
(
~clkM1 = Pmono(
	\click,
	\dur, Pdefn(\clkM1dur, 3),
	\outFreq, Pdefn(\clkM1out, 10),
	\freq, Pdefn(\clkM1freq, 10),
	\amp, Pdefn(\clkM1amp, 0.3)
);
)

z = ~clkM1.play;
z.stop;

// 2ND PMONO for another instance of same synth
// identify yours by your group #, higher node # = more recent
(
~clkM2 = Pmono(
	\click,
	\dur, Pdefn(\clkM2dur, 3),
	\outFreq, Pdefn(\clkM2out, 10),
	\freq, Pdefn(\clkM2freq, 10),
	\amp, Pdefn(\clkM2amp, 0.3)
);
)

b = ~clkM2.play;
b.stop;

// PMONO mods
Pdefn(\clkM1dur, 1);
Pdefn(\clkM1dur, Prand((0.3..1),inf));
Pdefn(\clkM1out, 20);
Pdefn(\clkM1freq, Pseq((400..4000), inf, 12));
Pdefn(\clkM1amp, 0.5);

// 2ND PMONO mods
Pdefn(\clkM2dur, Pseq((0.1..0.5),inf));
Pdefn(\clkM2out, 0.2);
Pdefn(\clkM2freq, Pshuf((2000..2033), inf, 3));
Pdefn(\clkM2amp, 0.01);

// PBIND to control running Pmono w/ Pbind
// query nodes, assign clkB1nodeID to appropriate node
s.queryAllNodes;
~clkB1nodeID = 201327593;

(
~clkB1=Pbind(
\instrument, \click,
\id, ~clkB1nodeID,
\type, \set,
\args, #[],
\dur, Pdefn(\clkB1dur, Pexprand(0.01, 0.1)),
\outFreq, Pdefn(\clkB1outFreq, 10, inf),
\amp, Pdefn(\clkB1amp, Pseq([ Pseries(0, 0.0001, 2000), Pn(0.2) ], inf)),
\freq, Pdefn(\clkB1freq, 100, inf),
);
)

a = ~clkB1.play;
a.stop;

// PBIND mods
Pdefn(\clkB1outFreq, 0.2, inf);
Pdefn(\clkB1freq, Prand([Pseries(200, -10, 19), 50, 80],inf));
Pdefn(\clkB1freq, Pseq((400..4000), inf, 12));
Pdefn(\clkB1amp, 2);
Pdefn(\clkB1amp, 0.05);
Pdefn(\clkB1dur, 1);

// BUNK node? query nodes, find synth, kill it
s.queryAllNodes;
s.sendMsg("/n_free", 134218728);