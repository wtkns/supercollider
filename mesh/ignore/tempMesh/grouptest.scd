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

t=Synth.new(\trigTest, [freq: 800, dur: 0.75], s, \addToHead)

~nodeID = u.nodeID;

~node2ID = t.nodeID;

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
    \id, ~node2ID,
    \trig, Pdefn(\qtrig),
    \dur, Pdefn(\qdur),
	\freqContB, Pdefn(\qfreq)
).play(quant: TempoClock.default.beats);
)

p.stop
q.stop

(
Pdefn(\ptrig, Pseq([0.5, 0.75, 0.25], inf));

Pdefn(\pfreq, Pshuf([20, 100, 200, 300, 400], inf));

Pdefn(\qfreq, Pshuf([20, 100, 200, 300, 400], inf));

Pdefn(\pfreq, Pseq([100], inf) );

Pdefn(\pdur, Pseq([0.5, 0.25], inf) );

Pdefn(\qtrig, Pseq([0.5, 0.25], inf) );

Pdefn(\qdur, Pseq([0.5, 0.25, 1.5], inf) );

Pdefn(\qfreq, Pseq([100, 200, 300], inf) );

)


p.play(quant: 1);
q.play(quant: 4);
p.stop
q.stop

p.free
q.free
u.free

