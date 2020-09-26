(
n = NetAddr("10.0.10.100", 57110);
o = ServerOptions.new;
o.maxLogins_(16);
Server.default = Server.remote(\mesher, n, o);
)
(
Server.default = Server.local;
s.boot;
)

(
SynthDef(\swarmSaw, {
	| out,
	freq1=50,
	amp1=0.05, amp2=0.05, amp3=0.05, amp4=0.05,
	rlpfrq1=440, rlpfrq2=440, rlpfrq3=440, rlpfrq4=440,
	rlprq1=1, rlprq2=1, rlprq3=1, rlprq4=1,
	pan1=0, pan2=0, pan3=0, pan4=0,
	frqlag1=0.51, frqlag2=0.52, frqlag3=0.53, frqlag4=0.5,
	amplag1=0.5, amplag2=0.5, amplag3=0.5, amplag4=0.5,
	panlag1=0.5, panlag2=0.5, panlag3=0.5, panlag4=0.5,
	frqOffset=50, frqSpread=100, panOffset=0
 |

	var arrySaw, arryPan, arryFilt;

	// frqOffset = MouseX.kr(50, 500, 1, 5.0);
	// panOffset = LinLin.kr(MouseX.kr(1, 100), 1, 100, -1.0, 1.0);
	// frqSpread = MouseY.kr(5, 50, 1);

	frqOffset = 100;
	panOffset = MouseX.kr(1,-1);
	frqSpread = 50;

	arrySaw = [
		SawDPW.ar(freq1+frqOffset, amp1),
		SawDPW.ar(freq1+frqSpread+frqOffset, amp2),
		SawDPW.ar(freq1+(2*frqSpread)+frqOffset, amp3),
		SawDPW.ar(freq1+(3*frqSpread)+frqOffset, amp4)
	];

	arryFilt = [
		RLPF.ar(arrySaw[0], freq: rlpfrq1, rq: rlprq1, mul: 1, add: 0),
		RLPF.ar(arrySaw[1], freq: rlpfrq2, rq: rlprq2, mul: 1, add: 0),
		RLPF.ar(arrySaw[2], freq: rlpfrq3, rq: rlprq3, mul: 1, add: 0),
		RLPF.ar(arrySaw[3], freq: rlpfrq4, rq: rlprq4, mul: 1, add: 0)
	];

	arryPan = [
		LinPan2.ar( arryFilt[0], FSinOsc.kr(2)),
		LinPan2.ar( arryFilt[1], FSinOsc.kr(2)),
		LinPan2.ar( arryFilt[2], FSinOsc.kr(2)),
		LinPan2.ar( arryFilt[3], FSinOsc.kr(2))
	];


	arryPan.poll;

	Out.ar( out, arryPan.sum);
}).add;

)

s.boot

u.free
u=Synth.new(\swarmSaw);
u.nodeID
u.free
~nodeID = u.nodeID;
