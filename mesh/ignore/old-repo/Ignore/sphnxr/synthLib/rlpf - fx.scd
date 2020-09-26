SynthDef(\rlpf, {|
	inBus=(~rlpfIn),
	outBus=(~masterOut),
	freq = 400,
	rq = 1,
	mix = 0.5|
	var dry = In.ar(inBus, 2);
	var wet = RLPF.ar(dry, Lag.kr(freq, Line.kr(0, 1, 15)), rq);
	Out.ar(outBus, ((wet*mix) + (dry * (1 - mix))) );
},

metadata: (
	\vertexType: \ESynth,
	\author: "james watkins",
	\inBusAr: 2,
	\outBusAr: 2,
))