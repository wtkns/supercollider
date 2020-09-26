(
n = NetAddr("10.0.10.100", 57110);
o = ServerOptions.new;
o.maxLogins_(16);
Server.default = Server.remote(\mesher, n, o);

//Server.default = Server.local;

s.boot;
)

(
SynthDef(\trigTest, {
	|out, freqContA, freqContB, t_trig=0, dur=1.0, freq=440|

	var avfrq;

	avfrq = (freqContA + freqContB);

	Out.ar(
		out,
		Pan2.ar(
			SinOsc.ar(
//				avfrq, 0,
				Lag.kr(avfrq, 1.0), 0,
				Decay2.kr(t_trig, 0.005, dur)
		), 0));
}).add;

)

u=Synth.new(\trigTest, [freq: 800, dur: 0.75], s, \addToHead)

~nodeID = u.nodeID;

(
p = Pmono(
	\trigTest,
    \id, ~nodeID,
    \trig, Pdefn(\ptrig),
    \dur, Pdefn(\pdur),
	\freqContA, Pdefn(\pfreq)
).play(quant: TempoClock.default.beats);


q = Pmono(
	\trigTest,
    \id, ~nodeID,
    \trig, Pdefn(\qtrig),
    \dur, Pdefn(\qdur),
	\freqContB, Pdefn(\qfreq)
).play(quant: TempoClock.default.beats);
)

p.stop
q.stop

(
Pdefn(\ptrig, Pseq([0.5], inf));

Pdefn(\pfreq, Pseq([200], inf) );

Pdefn(\pdur, Pseq([0.5], inf) );

Pdefn(\qtrig, Pseq([0.5], inf) );

Pdefn(\qdur, Pseq([0.5], inf) );

Pdefn(\qfreq, Pseq([100], inf) );

)


p.play(quant: 1);
q.play(quant: 4);
p.stop
q.stop

p.free
q.free
u.free

