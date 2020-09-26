// very simple synthdef with percussive attack
SynthDef(\trigTest, {
	|out, t_trig=0, dur=1.0, freq=440|
	Out.ar(
		out,
		Pan2.ar(
			SinOsc.ar(
				freq, 0,
				Decay2.kr(t_trig, 0.005, dur)
		), 0));
}).add;

//
// caution, summing signals, so it is possible to blow out.
// Decay time
SynthDef(\trigTest2, {
	|out, t_trig=0, len=1.0, freq=440, freq2=500, freq3=600, freq4=700|
	var v1, v2, v3, v4;
	v1 = SinOsc.ar(
		freq.lag(), 0,
		Decay2.kr(t_trig, 0.005, len));
	v2 = SinOsc.ar(
		freq2.lag(), 0,
			Decay2.kr(t_trig, 0.005, len));
	v3 = SinOsc.ar(
		freq3.lag(), 0,
				Decay2.kr(t_trig, 0.005, len));
	v4 = SinOsc.ar(
		freq4.lag(), 0,
					Decay2.kr(t_trig, 0.005, len));
	Out.ar(out, v1 * v2 * v3 * v4);
}).add;

