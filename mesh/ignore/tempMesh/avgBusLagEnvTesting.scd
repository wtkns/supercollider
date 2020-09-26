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
	| out, t_trig,
	freq1, freq2,
	amp1, amp2,
	pan1, pan2,
	frqlag1, frqlag2,
	amplag1, amplag2,
	panlag1, panlag2,
	ampenv, envdur=1.0,
	nilampL=0.01, ampattackL=0.99, ampsusL=0.6,
	ampattackT=0.05, ampdecayT=0.245, ampsusT=0.65, amprelT=0.1
	|

	var avfrq, avamp, avpan, avfrqlag, avamplag, avpanlag, freqenv;

	ampenv = EnvGen.kr(
		Env.new(
			[ nilampL, ampattackL, ampsusL, ampsusL, nilampL],
		[ampattackT, ampdecayT, ampsusT, amprelT] ),
	gate: t_trig, timeScale: envdur);

	avfrq = (freq1 + freq2)/2;
	avamp = (amp1 + amp2)/2;
	avpan = (pan1 + pan2)/2;
	avfrqlag = (frqlag1 + frqlag2)/2;
	avamplag = (amplag1 + amplag2)/2;
	avpanlag = (panlag1 + panlag2)/2;

	Out.ar(
		out,
		Pan2.ar(
			SinOsc.ar(
				Lag.kr(avfrq, avfrqlag), 0,
//				Lag.kr(avamp, avamplag)
				Lag.kr(avamp, avamplag)*ampenv
			), Lag.kr(avpan, avpanlag)
	))
}).add;

)

u=Synth.new(\trigTest, [freq: 800, dur: 0.75], s, \addToHead)

~nodeID = u.nodeID;

(
p = Pmono(
	\trigTest,
    \id, ~nodeID,
    \dur, Pdefn(\pdur),
	\freq1, Pdefn(\pfreq),
	\amp1, Pdefn(\pamp),
	\pan1, Pdefn(\ppan),
	\frqlag1, Pdefn(\pfrqlag),
	\amplag1, Pdefn(\pamplag),
	\panlag1, Pdefn(\ppanlag),
	\trig, 3
).play(quant: TempoClock.default.beats);


q = Pmono(
	\trigTest,
    \id, ~nodeID,
    \dur, Pdefn(\qdur),
	\freq2, Pdefn(\qfreq),
	\lag2, Pdefn(\qlag),
	\amp2, Pdefn(\qamp),
	\pan2, Pdefn(\qpan),
	\frqlag2, Pdefn(\pfrqlag),
	\amplag2, Pdefn(\pamplag),
	\panlag2, Pdefn(\ppanlag)
).play(quant: TempoClock.default.beats);
)

p.stop
q.stop

(
Pdefn(\pfreq, Pwhite(50, 200) );
Pdefn(\qfreq, Pwhite(100, 800) );

Pdefn(\pdur, Pwhite(0.5, 1.5) );
Pdefn(\qdur, Pwhite(0.5, 1.5) );

Pdefn(\pamp, Pwhite(0.2, 0.75));
Pdefn(\qamp, Pwhite(0.5, 0.75));

Pdefn(\ppan, Pwhite(-1.0, 1.0));
Pdefn(\qpan, Pwhite(-1.0, 1.0));

Pdefn(\pfrqlag, Pwhite(0.01, 0.25));
Pdefn(\qfrqlag, Pwhite(0.01, 0.25));

Pdefn(\pamplag, Pwhite(0.1, 0.5));
Pdefn(\qamplag, Pwhite(0.1, 0.5));

Pdefn(\ppanlag, Pwhite(0.25, 1.0));
Pdefn(\qpanlag, Pwhite(0.1, 0.5));

Pdefn(\pfreq, Pseq([0], inf).midicps );
Pdefn(\qfreq, Pshuf([50,52,54,56,60,62,64], inf).midicps*2 );
Pdefn(\qfreq, Pdefn(\pfreq));
)




u.set(\id, ~nodeID, \trig, 1);
u.set(\id, ~nodeID, \envdur, 0.2);


p.play(quant: 1);
q.play(quant: 4);
p.stop
q.stop

p.free
q.free
u.free

