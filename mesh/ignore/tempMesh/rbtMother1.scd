Server.killAll;
s.options.outDevice_("MOTU 828mk2");
s.options.numOutputBusChannels_(4);
s.boot;
NetAddr("192.168.1.123", 57120);
NetAddr.langPort;

(
{Out.ar(~cord1, LFPulse.kr(2, mul: 200, add: 100))};
)

(
~cord1=Bus.control(s, 1);
~cord2=Bus.control(s, 2);
~cord3=Bus.control(s, 3);
~cord4=Bus.control(s, 4);
~cord5=Bus.control(s, 5);
~cord6=Bus.control(s, 6);
~cord7=Bus.control(s, 7);
~cord8=Bus.control(s, 8);
)


(
SynthDef(\blip,
	{|out= 0,
	freq=80,
	freq1=1,
	freq2=1,
	freq3=1,
	freq1time=1,
	freq2time=1,
	freq3time=1,
	t_freqEnvGate=0,
	numharm=60,
	noteOn=3,
	amp1=1,
	amp2=0.2,
	amp3=0,
	amp1time=0.1,
	amp2time=0.4,
    amp3time=0.1,
	t_ampGate=0,
	amp=0.3,
	pan=0|
		var freqEnv=EnvGen.kr(Env([freq1, freq1, freq2, freq3], [freq1time, freq2time, freq3time], \exp), t_freqEnvGate);
		var ampEnv=EnvGen.kr(Env([amp1, amp1, amp2, amp3], [amp1time, amp2time, amp3time], \exp), t_ampGate);
		Out.ar([0, 1],  Pan2.ar(Blip.ar(freq*freqEnv, numharm)*amp*ampEnv), pan);
}).add;
)

~cord1.set(\LFImpulse);
~cord2.set(1);

(
SynthDef(\LFImpulse,
	{Out.kr(~cord1, LFPulse.kr(LFPulse.kr(2, mul: 20, add: 1)));}
);
)


~blip=Synth(\blip,  [\freq0, 0.455, \freq1, 2.45, \freq2, 2.47, \freq1time, 0.1, \freq2time, 0.3]);
~blip.set(\t_ampGate, 1);
~blip.set(\amp3, 0.0002);
~blip.set(\t_freqEnvGate, ~cord2);

~blip.map(\numharm, ~cord1);
~blip.map(\t_freqEnvGate, ~cord2);

~blip=Synth(\blip, [\freq0, 0.455, \freq1, 2.45, \freq2, 2.47, \freq1time, 0.1, \freq2time, 0.3]);

~blip.set([\noteRateTime1, 10, \noteRateTime2, 0.8]);

~blip.set(\freq, 80);

~blip.set(\noteOn, 2.1);

~blip.set(\numharm, 60);

~blip.set([\noteRate0, 0.5, \noteRate1, 0.1]);

~blip.set([\amp1time, 0.1, \amp2time, 0.1, \amp3time, 0.1]);

~blip.set(\freq, [240, 20, 65, 403]);


(
~cord1=Bus.control(s, 1);
~cord2=Bus.control(s, 2);
~cord3=Bus.control(s, 3);
~cord4=Bus.control(s, 4);
~cord5=Bus.control(s, 5);
~cord6=Bus.control(s, 6);
~cord7=Bus.control(s, 7);
~cord8=Bus.control(s, 8);
)


(
SynthDef(\rlpf, { |ffreq, rq|
    Out.ar(0, RLPF.ar(WhiteNoise.ar(0.2), ffreq, rq))
}).play(s, [\ffreq, a.asMap, \rq, b.asMap]);
)



(
~cord1=OSCdef(\rotary1, {|msg|
	~blip.set(\freq, msg[1].linexp(-1, 1, 45, 8000));
}, 'mother-test/rotary1'
);

~cord2=OSCdef(\rotary2, {|msg|
	~blip.set(\numharm, msg[1].linexp(-1, 1, 1, 30));
}, 'mother-test/rotary2'
);
)