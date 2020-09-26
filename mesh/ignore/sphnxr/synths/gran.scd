SynthDef(\gran, {|
	outBus=(~masterOut),
	bufOffset=0,
	bufPos=0.1,
	rate=10.0,
	granDurMin=0.1,
	granDurMax=0.1,
	playRateMin=0.5,
	playRateMax=2,
	envBuf=(-1),
	envLevels = #[0,1,0],
	envTimes = #[1,1],
	pan=0,
	amp=0.85,
	noteDur=1.0|
	var bufferNum=~buffers[0].bufnum+bufOffset;
	var env = EnvGen.kr(
		Env(envLevels, envTimes, \sin),
		timeScale: noteDur,
		levelScale: amp,
		doneAction: 2);
	Out.ar(outBus,
		GrainBuf.ar(2, Impulse.kr(rate), LFNoise1.kr.range(granDurMin, granDurMax), bufferNum, LFNoise1.kr.range(playRateMin, playRateMax), LFNoise2.kr(bufPos).range(0, 1), 2, pan, envBuf) * env)
}).add;