(
~stringResTestMono = Pmono(\stringResJames,
	\dur, Pdefn(\stresDur, 40, inf),
	\out, Pdefn(\srM1out, Prand([0, 1, 2, 3], inf)),
    \startfreq, Pdefn(\srM1startfreq, 400),
    \endfreq, Pdefn(\srM1endfreq, 410),
	\len, Pdefn(\srM1len, 30),
	\gate, Pdefn(\srM1gate, 1, inf),
    \att, Pdefn(\srM1att, 0.1),
    \dec, Pdefn(\srM1dec, 0.3),
    \sus, Pdefn(\srM1sus, 0.4),
    \res, Pdefn(\srM1res, 0.9),
    \attime, Pdefn(\srM1attime, 0.3),
    \dectime, Pdefn(\srM1dectime, 0.2),
    \sustime, Pdefn(\srM1sustime, 0.5),
	\reltime, Pdefn(\srM1reltime, 0.2),
	\amp, Pdefn(\srM1amp, 0.1)
).play;
)


~stringResTestMono.stop




67109864.asTarget.free;

