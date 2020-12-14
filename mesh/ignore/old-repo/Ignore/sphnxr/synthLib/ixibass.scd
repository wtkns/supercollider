SynthDef(\ixibass, {|
	outBus = (~masterOut),
	amp = 0.3,
	t_trig = 1,
	freq = 100,
	rq = 0.004|
	var env, signal;
	var rho, theta, b1, b2;
	b1 = 1.98 * 0.989999999 * cos(0.09);
	b2 = 0.998057.neg;
	signal = SOS.ar(K2A.ar(t_trig), 0.123, 0.0, 0.0, b1, b2);
	signal = RHPF.ar(signal, freq, rq) + RHPF.ar(signal, freq*0.5, rq);
	signal = Decay2.ar(signal, 0.4, 0.3, signal);
	DetectSilence.ar(signal, 0.01, doneAction:2);
	Out.ar(outBus, signal*(amp*0.45)!2);
},

metadata: (
	\vertexType: \PSynth,
	\author: "Thor Magnusson",
	\outBusAr: 2,
	\freq: (Pseq([0, 2, 4, 7, 9], inf) + 40).midicps,
	\dur: Pshuf([1/4, 1/4, 1/8, 1/8], inf),
	\amp: Pmeanrand(0.2, 0.3, inf),
	\pan: Pmeanrand(-0.5, 0.5, inf),
	\att: Pmeanrand(0.1, 0.2, inf)
))