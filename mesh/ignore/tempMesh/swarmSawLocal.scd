(
Server.default = Server.local;
s.boot;
//s.scope;
)

(
SynthDef(\swarmSaw, {
	| out,
	freq1=50,	freq2=50,	freq3=50,	freq4=50,
	amp1=0.05, amp2=0.05, amp3=0.05, amp4=0.05,
	rlpfrq1=440, rlpfrq2=440, rlpfrq3=440, rlpfrq4=440,
	rlpfrqlag1 = 0.5, rlpfrqlag2 = 0.5, rlpfrqlag3 = 0.5, rlpfrqlag4 = 0.5,
	rlprq1=1, rlprq2=1, rlprq3=1, rlprq4=1,
	pan1=0, pan2=0, pan3=0, pan4=0,
	frqlag1=0.5, frqlag2=0.5, frqlag3=0.5, frqlag4=0.5,
	amplag1=0.5, amplag2=0.5, amplag3=0.5, amplag4=0.5,
	panlag1=0.5, panlag2=0.5, panlag3=0.5, panlag4=0.5,
	frqOffset=50, frqSpread=100, panOffset=0
 |

	var arrySaw, arryPan, arryFilt;

	// frqOffset = MouseX.kr(50, 500, 1, 5.0);
	frqSpread = MouseY.kr(0, 100);
	panOffset = MouseX.kr(-1,1);

	arrySaw = [
		SawDPW.ar(Lag.kr(freq1+frqOffset, frqlag1), Lag.kr(amp1, amplag1)),
		SawDPW.ar(Lag.kr(freq2+frqSpread+frqOffset, frqlag2), Lag.kr(amp2, amplag2)),
			SawDPW.ar(Lag.kr(freq3+(2*frqSpread), frqlag3)+frqOffset, Lag.kr(amp3, amplag3)),
				SawDPW.ar(Lag.kr(freq4+(3*frqSpread)+frqOffset, frqlag4), Lag.kr(amp4, amplag4))
	];

	arryFilt = [
		RLPF.ar(arrySaw[0], freq: Lag.kr(rlpfrq1, rlpfrqlag1), rq: rlprq1, mul: 1, add: 0),
		RLPF.ar(arrySaw[1], freq: Lag.kr(rlpfrq2, rlpfrqlag2), rq: rlprq2, mul: 1, add: 0),
		RLPF.ar(arrySaw[2], freq: Lag.kr(rlpfrq3, rlpfrqlag3), rq: rlprq3, mul: 1, add: 0),
		RLPF.ar(arrySaw[3], freq: Lag.kr(rlpfrq4, rlpfrqlag4), rq: rlprq4, mul: 1, add: 0)
	];

	arryPan = [
		LinPan2.ar( arryFilt[0], panOffset),
		LinPan2.ar( arryFilt[1], panOffset/(-1)),
		LinPan2.ar( arryFilt[2], panOffset/(-2)),
		LinPan2.ar( arryFilt[3], panOffset/(2))
	];

//xx	arryPan.poll;

	Out.ar( out, arryPan.sum);
}).add;

)


u=Synth.new(\swarmSaw);
u.nodeID

~nodeID = u.nodeID;

(
p = Pmono(
	\swarmSaw,
    \id, ~nodeID,
	\dur, Pdefn(\pdur),
	\freq1, Pdefn(\pfrq1),
	\freq2, Pdefn(\pfrq2),
	\freq3, Pdefn(\pfrq3),
	\freq4, Pdefn(\pfrq4),
	\pan1,Pdefn(\ppan1),
	\pan2,Pdefn(\ppan2),
	\pan3,Pdefn(\ppan3),
	\pan4,	Pdefn(\ppan4),
	\panlag1,Pdefn(\ppanlag1),
	\panlag2,Pdefn(\ppanlag2),
	\panlag3,Pdefn(\ppanlag3),
	\panlag4,	Pdefn(\ppanlag4),
	\rlpfrq1, Pdefn(\prlpfrq1),
	\rlpfrq2, Pdefn(\prlpfrq2),
	\rlpfrq3, Pdefn(\prlpfrq3),
	\rlpfrq4, Pdefn(\prlpfrq4),
	\rlprq1, Pdefn(\prlprq1),
	\rlprq2, Pdefn(\prlprq2),
	\rlprq3, Pdefn(\prlprq3),
	\rlprq4, Pdefn(\prlprq4),
	\rlpfrqlag1, Pdefn(\prlpfrqlag1),
	\rlpfrqlag2, Pdefn(\prlpfrqlag2),
	\rlpfrqlag3, Pdefn(\prlpfrqlag3),
	\rlpfrqlag4, Pdefn(\prlpfrqlag4)
	\amp1, Pdefn(\pamp1),
	\amp2, Pdefn(\pamp2),
	\amp3, Pdefn(\pamp3),
	\amp4, Pdefn(\pamp4),
	\amplag1, Pdefn(\pamplag1),
	\amplag2, Pdefn(\pamplag2),
	\amplag3, Pdefn(\pamplag3),
	\amplag4, Pdefn(\pamplag4)

).play;


Pdefn(\pdur, Pshuf([0.25, 0.5, 0.75, 1.0], inf));

Pdefn(\pfrq1, Pshuf([20, 100, 200, 300, 400], inf));
Pdefn(\pfrq2, Pshuf([20, 100, 200, 300, 400], inf));
Pdefn(\pfrq3, Pshuf([20, 100, 200, 300, 400], inf));
Pdefn(\pfrq4, Pshuf([20, 100, 200, 300, 400], inf));

Pdefn(\prlpfrq1, Pshuf([20, 100, 200, 300, 400]*8, inf));
Pdefn(\prlpfrq2, Pshuf([20, 100, 200, 300, 400]*6, inf));
Pdefn(\prlpfrq3, Pshuf([20, 100, 200, 300, 400]*3, inf));
Pdefn(\prlpfrq4, Pshuf([20, 100, 200, 300, 400]*4, inf));

Pdefn(\prlprq1, Pshuf([0.020, 0.100, 0.200, 0.300, 0.400], inf));
Pdefn(\prlprq2, Pshuf([0.020, 0.100, 0.200, 0.300, 0.400], inf));
Pdefn(\prlprq3, Pshuf([0.020, 0.100, 0.200, 0.300, 0.400], inf));
Pdefn(\prlprq4, Pshuf([0.020, 0.100, 0.200, 0.300, 0.400], inf));

Pdefn(\prlpfrqlag1, Pshuf([0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\prlpfrqlag2, Pshuf([0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\prlpfrqlag3, Pshuf([0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\prlpfrqlag4, Pshuf([0.25, 0.5, 0.75, 1.0], inf));
)



(
Pdefn(\pdur, Pwhite(0,0.5));

Pdefn(\pfrq1, Pwhite(0,1000));
Pdefn(\pfrq2, Pwhite(0,1000));
Pdefn(\pfrq3, Pwhite(0,1000));
Pdefn(\pfrq4, Pwhite(0,1000));

Pdefn(\prlpfrq1, Pwhite(0,1000));
Pdefn(\prlpfrq2, Pwhite(0,1000));
Pdefn(\prlpfrq3, Pwhite(0,1000));
Pdefn(\prlpfrq4, Pwhite(0,1000));

Pdefn(\prlprq1, Pwhite(0,10));
Pdefn(\prlprq2, Pwhite(0,10));
Pdefn(\prlprq3, Pwhite(0,10));
Pdefn(\prlprq4, Pwhite(0,10));

Pdefn(\prlpfrqlag1, Pwhite(0,1));
Pdefn(\prlpfrqlag2, Pwhite(0,1));
Pdefn(\prlpfrqlag3, Pwhite(0,1));
Pdefn(\prlpfrqlag4, Pwhite(0,1));

)
p.stop





u.set(\frqlag1, 5.0,\frqlag2, 15.0,\frqlag3, 10.0,\frqlag4, 20.0)

(
Pdefn(\ptrig, Pseq([0.5, 0.75, 0.25], inf));


Pdefn(\qfreq, Pshuf([20, 100, 200, 300, 400], inf));

Pdefn(\pfreq, Pseq([100], inf) );

Pdefn(\pdur, Pseq([0.5, 0.25], inf) );

Pdefn(\qtrig, Pseq([0.5, 0.25], inf) );

Pdefn(\qdur, Pseq([0.5, 0.25, 1.5], inf) );

Pdefn(\qfreq, Pseq([100, 200, 300], inf) );

)

u.free
