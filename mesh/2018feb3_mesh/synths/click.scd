SynthDef(\click, {|
	outFreq=120,
	freq=120,
	amp=0 |

	var click = Impulse.ar(freq);
	Out.ar(
		TIRand.kr(0, 3, Impulse.kr(outFreq)),
		click * amp);
}, metadata:(
	\dur: Pexprand(0.01, 0.1),
	\outFreq: 10,
	\freq: 10,
	\amp: Pseq([Pseries(0, 0.0001, 2000), Pn(0.2)], inf)
)).add;
