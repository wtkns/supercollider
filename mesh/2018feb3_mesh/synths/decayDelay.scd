
SynthDef(\decayDelay, {|
	decayTime = 0.2,
	maxdelaytime = 0.2,
	delaytime = 0.2,
	delayDecay = 3 |

	Out.ar(
		bus: 0,
		channelsArray: CombN.ar(
			in: Decay.ar(
				in: In.ar(
					bus: 0,
					numChannels: 4),
				decayTime: decayTime,
				mul: WhiteNoise.ar),
			maxdelaytime: maxdelaytime,
			delaytime: delaytime,
			decaytime: delayDecay))
}, metadata: (
	\decayTime: 0.2,
	\maxdelaytime: 0.2,
	\delaytime: 0.2,
	\delayDecay: 3,
	\group: \effect
)).add;
