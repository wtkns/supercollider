SynthDef(\pulsar, {|
	outBus = (~masterOut),
	impulsePeriod = 6,
	pulseFreq = 840,
	pulseLength = 0.01,
	pulseWidth = 0.5,
	lpfFreq = 500,
	pan = 0,
	dur = 5.0,
	lag = 2.5
	|
	var lagTime = lag;
    var trigger = Impulse.ar(Lag.kr(impulsePeriod, lagTime), 0.0, 1.0, 0);
	var envTime = (Lag.kr(pulseLength, lagTime)/Lag.kr(impulsePeriod, lagTime));
	var envelope = EnvGen.ar(Env.new([0,1,0], [envTime,envTime], 'linear') , trigger);
	var signal =LFPulse.ar( Lag.kr(pulseFreq, lagTime), 0, Lag.kr(pulseWidth, lagTime) );
	signal = LPF.ar(signal*envelope, Lag2.kr(lpfFreq, lagTime) );
		signal = Pan2.ar(signal, Lag2.kr(pan, lagTime) );
    signal = Out.ar(outBus, signal );
},

metadata: (
	\vertexType: \CSynth,
	\author: "james watkins",
	\outBusAr: 2,
))