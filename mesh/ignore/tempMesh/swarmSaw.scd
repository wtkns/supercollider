s.boot
s.scope

(
SynthDef(\swarmSaw, {
	| out,
	freq1, freq2, freq3, freq4,
	amp1, amp2, amp3, amp4,
	rlpfrq1, rlpfrq2, rlpfrq3, rlpfrq4,
	pan1=0, pan2=0, pan3=0, pan4=0,
	frqlag1=0.51, frqlag2=0.52, frqlag3=0.53, frqlag4=0.5,
	amplag1=0.5, amplag2=0.5, amplag3=0.5, amplag4=0.5,
	panlag1=0.5, panlag2=0.5, panlag3=0.5, panlag4=0.5,
	frqOffset=50, frqSpread=100, panOffset=0
 |

	var arrySaw, arryPan, arryFilt;

	frqOffset = MouseX.kr(50, 500, 1, 5.0);
	panOffset = LinLin.kr(MouseX.kr(1, 100), 1, 100, -1.0, 1.0);
	frqSpread = MouseY.kr(5, 50, 1);

	arrySaw = [
		SawDPW.ar(frqOffset, 0.05),
		SawDPW.ar(frqSpread+frqOffset, 0.05),
		SawDPW.ar((2*frqSpread)+frqOffset, 0.05),
		SawDPW.ar((3*frqSpread)+frqOffset, 0.05)
	];

	arryFilt = [
		RLPF.ar(arrySaw[0], freq: 440, rq: 1, mul: 1, add: 0),
		RLPF.ar(arrySaw[1], freq: 440, rq: 1, mul: 1, add: 0),
		RLPF.ar(arrySaw[2], freq: 440, rq: 1, mul: 1, add: 0),
		RLPF.ar(arrySaw[3], freq: 440, rq: 1, mul: 1, add: 0)
	];

	arryPan = [
		LinPan2.ar( arryFilt[0], panOffset/(1.0)),
		LinPan2.ar( arryFilt[1], panOffset/(-1.0)),
		LinPan2.ar( arryFilt[2], panOffset/(2.0)),
		LinPan2.ar( arryFilt[3], panOffset/(2.0))
	];


	arryPan.poll;

	Out.ar( out, arryPan);
}).add;

)
s.boot
u=Synth.new(\swarmSaw);

~nodeID = u.nodeID;
