// some quad droney drones


({
	var src = Pulse.ar(freq: [
		SinOsc.kr(1/10, 0).curverange(10, 60, 3),
		SinOsc.kr(1/66, (pi*(-1))).curverange(60, 120, 2),
		SinOsc.kr(1/123, 2pi).curverange(120, 460, 1),
		SinOsc.kr(1/257, pi).curverange(460, 1200, 0.5),
	], mul: 1.0, add: 0.0);


	var distAmt = SinOsc.kr(SinOsc.kr(1/300).range(1.0,10.0)).range(0.1, 0.5);
	var k = 2 * distAmt / (1 - distAmt);
	var sig = (1 + k) * src / (1 + (k * src.abs));

	var rqFreq = SinOsc.kr(freq: 0.1, phase: 0).curverange(100, Saw.kr(freq: 0.01).range(2000,5000), 3.0);
	var rqAmt = SinOsc.ar(0.1).range(0.1, 0.9);
	var filt = RLPF.ar(in: sig, freq: rqFreq, rq: rqAmt, mul: 0.25);

	Pan4.ar(filt, SinOsc.kr(20.0, 0, 0.75, 0.0 ), SinOsc.kr(100.0, 2pi, 0.75, 0.0 ), 0.25);
}.play;
)
