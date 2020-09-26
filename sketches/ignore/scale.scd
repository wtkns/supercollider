(
var scale, buffer;
scale = FloatArray[200,300, 350, 400];
buffer = Buffer.alloc(s, scale.size, 1, {|b| b.setnMsg(0, scale) });

play({
	CombN.ar(
		SinOsc.ar(
			DegreeToKey.kr(
				buffer.bufnum,
				MouseX.kr(0,scale.size)
			),
			0,
			0.1)
		, 0.31, 0.61, 2, 1)})
)