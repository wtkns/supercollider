SynthDef(\limiter, {|limit=0.5, time=0.1|
	ReplaceOut.ar(
		bus: 0,
		channelsArray: Sanitize.ar(
			in: Limiter.ar(
				in: In.ar(bus: 0, numChannels: 4),
				level: limit,
			dur: time),
		replace: 0)
	)
	}, metadata: (
		\limit: 0.5,
		\time: 0.1,
		\group: \tail
)).add;


