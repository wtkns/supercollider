SynthDef(
	\risset_bell,
	{ |freq=440, dur=4.0, out=0|
		var partials, addPartial;

		partials = Array.new(11);

		addPartial = { |amplitude, rel_duration, rel_freq, detune|
				partials.add(
					EnvGen.kr(
						Env.perc(0.05, dur*rel_duration, amplitude*0.1, -4),
						doneAction: 0
					) * SinOsc.ar(freq*rel_freq+detune)
				);
		};

		addPartial.(1, 1, 0.56, 0);
		addPartial.(0.67, 0.9, 0.56, 1);
		addPartial.(1, 0.65, 0.92, 0);
		addPartial.(1.8, 0.55, 0.92, 1.7);
		addPartial.(2.67, 0.325, 1.19, 0);
		addPartial.(1.67, 0.35, 1.7, 0);
		addPartial.(1.46, 0.25, 2, 0);
		addPartial.(1.33, 0.2, 2.74, 0);
		addPartial.(1.33, 0.15, 3, 0);
		addPartial.(1, 0.1, 3.76, 0);
		addPartial.(1.33, 0.075, 4.07, 0);

		OffsetOut.ar(out,
			EnvGen.kr(
				Env.perc(0.05, dur, curve: -4),
				doneAction: 2
			) * Mix.new(partials)
		);
	}
).add;

a = (
	type: \note,
	instrument: \risset_bell,
	freq: 100,
	dur: 1000.0
);
a.play;   // play the note
