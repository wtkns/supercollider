~sin = PStream(
	Pbind(
		\target, Pdefn(\sinTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinInstrument),
		\outBus, Pdefn(\sinOutBus),
		\freq, Pdefn(\sinFreq),
		\dur, Pdefn(\sinDuration),
		\amp, Pdefn(\sinAmp),
		\pan, Pdefn(\sinPan),
		\att, Pdefn(\sinAtt),
		\mod1, Pdefn(\sinMod1),
		\mod2, Pdefn(\sinMod2)
	), Pdefn(\sinsawWait),
	~addrBook);

~saw = PStream(
	Pbind(
		\target, Pdefn(\sawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sawInstrument),
		\outBus, Pdefn(\sinsawOutBus),
		\freq, Pdefn(\sawFreq),
		\dur, Pdefn(\sawDuration),
		\amp, Pdefn(\sawAmp),
		\pan, Pdefn(\sawPan),
		\att, Pdefn(\sawAtt),
	), Pdefn(\sinsawWait),
	~addrBook);


~ixibass = PStream(
	Pbind(
		\target, Pdefn(\ixiTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\ixiInstrument),
		\outBus, Pdefn(\ixiOutBus),
		\amp, Pdefn(\ixiAmp),
		\t_trig, Pdefn(\ixiTrig),
		\freq, Pdefn(\ixiFreq),
		\rq, Pdefn(\ixiRQ),
	), Pdefn(\ixiWait)
	~addrBook);

~granular = PStream(
	Pbind(
		\target, Pdefn(\granTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, \gran,
		\outBus, Pdefn(\granOutBus),
		\numChannels, Pdefn(\granNumChannels),
		\bufOffset, Pdefn(\granBufOffset),
		\bufPos, Pdefn(\granBufPos),
		\rate, Pdefn(\granRate),
		\grandurMin, Pdefn(\granDurMin),
		\grandurMax, Pdefn(\granDurMax),
		\playRateMin, Pdefn(\granPlayRateMin),
		\playRateMax, Pdefn(\granPlayRateMax),
		\envBuf, Pdefn(\granEnvBuf),
		\envLevels, Pdefn(\granEnvLevels),
		\envTimes, Pdefn(\granEnvTimes),
		\pan, Pdefn(\granPan),
		\amp, Pdefn(\granAmp),
		\noteDur, Pdefn(\granNoteDuration)
	), Pdefn(\granWait),
	~addrBook);


~sinsaw = PStream(
	Pbind(
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsawInstrument),
		\outBus, Pdefn(\sinsawOutBus),
		\freq, Pdefn(\sinsawFreq),
		\dur, Pdefn(\sinsawDuration),
		\amp, Pdefn(\sinsawAmp),
		\pan, Pdefn(\sinsawPan),
		\att, Pdefn(\sinsawAtt),
		\mod1, Pdefn(\sinsawMod1),
		\mod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait),
	~addrBook);











	