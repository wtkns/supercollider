SynthDef(\dist, {|
	inBus=(~distortIn),
	outBus=(~masterOut),
	preGain=8,
	postGain=0.6|
	var input = In.ar(inBus, 2);
	var sig = (input * preGain).distort;
	Out.ar(outBus, sig * postGain);
}).add;