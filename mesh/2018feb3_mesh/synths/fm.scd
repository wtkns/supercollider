//This synth uses Pan4.ar, with panX and panY args mapping 2-dimensional panning position. Note that the out bus is hard coded as 0 because it is not necessary to switch buses to move sound around in space.

SynthDef(\fm, {|
	freq=440,
	modPartial = 1,
	index = 3,
	carPartial = 1,
	amp=0,
	att=0.15,
	t_gate=1,
	len=1.0,
	panX=0,
	panY=0|

	// index values usually are between 0 and 24
	// carPartial :: modPartial => car/mod ratio

	var mod = SinOsc.ar(freq * modPartial, 0,
        freq * index * LFNoise1.kr(5.reciprocal).abs);

	var car = SinOsc.ar((freq * carPartial) + mod, 0, amp);

	var env = Env([0.001, 0.001, 0.9, 0.001], [0, att, 1.0-att], [\sin, \sin]);
	var envGen = EnvGen.kr(env, t_gate, doneAction: 0, timeScale: len);
	Out.ar(0, Pan4.ar(car * envGen, panX, panY));
}, metadata:()).add;



	