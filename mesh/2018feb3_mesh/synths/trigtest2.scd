// trigtest2 synth, Jeff
SynthDef('trigTest2', {
	|out, t_trig=0, dur=1.0, freq=440, freq2=500, freq3=600, freq4=700, lagTime=0.1 |
	var v1, v2, v3, v4;
	v1 = SinOsc.ar(freq.lag(lagTime), 0, Decay2.kr(t_trig, 0.005, dur));
	v2 = SinOsc.ar(freq2.lag(lagTime), 0, Decay2.kr(t_trig, 0.005, dur));
	v3 = SinOsc.ar(freq3.lag(lagTime), 0, Decay2.kr(t_trig, 0.005, dur));
	v4 = SinOsc.ar(freq4.lag(lagTime), 0, Decay2.kr(t_trig, 0.005, dur));
	Out.ar(out, v1 * v2 * v3 * v4);
}, metadata:()).add;