SynthDef(\freeverb, {|
	inBus=(~freeverbIn),
	outBus=(~masterOut),
	mix = 0.25,
	room = 0.15,
	damp = 0.5|
	var input = In.ar(inBus, 2);
	Out.ar(outBus,
		FreeVerb.ar(
			input,
			mix, // mix 0-1
			room, // room 0-1
			damp // damp 0-1
		)
	);
},

metadata: (
	\vertexType: \ESynth,
	\author: "james watkins",
	\inBusAr: 2,
	\outBusAr: 2,
))