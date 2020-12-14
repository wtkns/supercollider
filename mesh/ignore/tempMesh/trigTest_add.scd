(
SynthDef(\trigTest, {
	|out, t_trig=0, dur=1.0, freq=440|
	Out.ar(
		out,
		SinOsc.ar(
			freq, 0,
			Decay2.kr(t_trig, 0.005, dur)
		)
	);
}).add;
)


u=Synth.new(\trigTest, [freq: 800, dur: 0.75], s, \addToHead)

s.queryAllNodes(queryControls: true);

~nodeID = 1000;

(
p = Pbind(
	\instrument, \trigTest,
    \type, \set,
    \id, ~nodeID,
    \args, #[],
	\t_trig, 1,
	\dur, Pwhite(0.1, 1),
    \freq, Pwhite(100, 1000),
).play;
)
