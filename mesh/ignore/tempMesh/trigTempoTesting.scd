(
//n = NetAddr("10.0.10.100", 57110);
//o = ServerOptions.new;
//o.maxLogins_(16);
//Server.default = Server.remote(\mesher, n, o);

Server.default = Server.local;

s.boot;
)

(
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

)

u=Synth.new(\trigTest, [freq: 800, dur: 0.75], s, \addToHead)

~nodeID = u.nodeID;

(
p = Pmono(
	\trigTest,
    \id, ~nodeID,
    \trig, Pdefn(\ptrig),
    \dur, Pdefn(\pdur),
	\freq, Pdefn(\pfreq)
).play(quant: TempoClock.default.beats);
)

p.stop
q.stop

TempoClock.tempo = 2

p.play(quant: 1);
q.play(quant: 4);

Pdefn(\qtrig, Pseq([0.15,0.5], inf));

(
Pdefn(\qtrig, Pseq([0.75,0.25], inf));

Pdefn(\pfreq,
	Pseq([
	Pshuf([100, 200, 300, 400, 500], 2),
			Pshuf([100, 200, 300, 400, 500], 2)], inf)
);

Pdefn(\pdur,
	Pseq([
	Pshuf([0.75, 0.25, 0.25, 0.25, 0.5], 2),
		Pshuf([0.5, 0.25, 0.25, 0.25,  0.75 ], 2)], inf)
);
)


TempoClock.default.beats


(
q = Pmono(
	\trigTest,
    \id, ~nodeID,
    \trig, Pdefn(\qtrig),
    \dur, Pdefn(\qdur),
	\freq, Pdefn(\qfreq)
).play(quant: TempoClock.default.beats + 1.0);
)


(
Pdefn(\qtrig, Pseq([0.5,0.25], inf));

Pdefn(\qfreq,
	Pseq([
	Pshuf([100, 200, 300, 400, 500], 2),
			Pshuf([100, 200, 300, 400, 500], 2)], inf)
);

Pdefn(\qdur,
	Pseq([
	Pshuf([0.75, 0.25, 0.25, 0.25, 0.5], 2),
		Pshuf([0.5, 0.25, 0.25, 0.25,  0.75 ], 2)], inf)
);
)

p.stop
q.stop

p.free
q.free
u.free

s.queryAllNodes;

// now trigger the decay envelope
u.set(\t_trig, 1);
u.set(\t_trig, 1, \dur, 5.0);
u.set(\t_trig, 3, \dur, 0.1);
u.set(\t_trig, 1, \dur, 1.0);

u.set(\t_trig, 1, \freq, 220);
u.set(\t_trig, 1, \freq, 880);

Pdefn(\pfreq,	Pseq([1000], inf));

Pdefn(\qfreq,	Pwhite(100, 1000));
