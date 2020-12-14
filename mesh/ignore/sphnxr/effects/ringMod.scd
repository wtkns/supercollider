SynthDef(\ringMod, {|
	inBus=(~ringModIn),
	outBus=(~masterOut),
	freq=400|
	var sig = In.ar(inBus, 2);
	var mod = SinOsc.ar(freq); //alt: MouseX.kr(2, 200, 1)
	Out.ar(outBus, sig * mod);
}).add;