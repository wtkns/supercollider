SynthDef(\rlpf, {|
	inBus=(~rlpfIn),
	outBus=(~masterOut),
	freq = 400,
	rq = 1,
	mix = 0.5|
	var dry = In.ar(inBus, 2);
	var wet = RLPF.ar(dry, freq, rq);
	Out.ar(outBus, ((wet*mix) + (dry * (1 - mix))) );
}).add;
