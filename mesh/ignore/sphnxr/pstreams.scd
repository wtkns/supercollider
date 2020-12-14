// 2. Set up a Pstream with some basic defaults.
//    Assign a Pdefn for each arg you want to control.
//    You could do this multiple times for the same synth
//    assigning different ***(or the same!)*** Pdefns
//    for different voices with shared or separate control values


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
	), Pdefn(\sinWait),
	~addrBook, ~clock, 0.5);

~pulse = PStream(
	Pbind(
		\target, Pdefn(\sinTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\pulseInstrument),
		\outBus, Pdefn(\pulseOutBus),
		\freq, Pdefn(\pulseFreq),
		\dur, Pdefn(\pulseDuration),
		\amp, Pdefn(\pulseAmp),
		\pan, Pdefn(\pulsePan),
		\att, Pdefn(\pulseAtt),
		\mod1, Pdefn(\pulseMod1),
		\mod2, Pdefn(\pulseMod2),
		\int, Pdefn(\pulseInt)
	), Pdefn(\pulseWait),
	~addrBook, ~clock, 0.5);

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
		\att, Pdefn(\sawAtt)
	), Pdefn(\sawWait),
	~addrBook, ~clock, 0.5);


~ixibass = PStream(
	Pbind(
		\target, Pdefn(\ixiTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\ixiInstrument),
		\outBus, Pdefn(\ixiOutBus),
		\amp, Pdefn(\ixiAmp),
		\t_trig, Pdefn(\ixiTrig),
		\freq, Pdefn(\ixiFreq),
		\rq, Pdefn(\ixiRQ)
	), Pdefn(\ixiWait),
	~addrBook, ~clock, 1);

~granular = PStream(
	Pbind(
		\target, Pdefn(\granTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\granInstrument),
		\outBus, Pdefn(\granOutBus),
		\numChannels, Pdefn(\granNumChannels),
		\bufOffset, Pdefn(\granBufOffset),
		\bufPos, Pdefn(\granBufPos),
		\rate, Pdefn(\granRate),
		\granDurMin, Pdefn(\granDurMin),
		\granDurMax, Pdefn(\granDurMax),
		\playRateMin, Pdefn(\granPlayRateMin),
		\playRateMax, Pdefn(\granPlayRateMax),
		\envBuf, Pdefn(\granEnvBuf),
		\envLevels, Pdefn(\granEnvLevels),
		\envTimes, Pdefn(\granEnvTimes),
		\pan, Pdefn(\granPan),
		\amp, Pdefn(\granAmp),
		\noteDur, Pdefn(\granNoteDuration)
	), Pdefn(\granWait),
	~addrBook, ~clock, 1);


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


~fm = PStream(
	Pbind(
		\target, Pdefn(\fmTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\fmInstrument),
		\outBus, Pdefn(\fmOutBus),
		\freq, Pdefn(\fmFreq),
		\carPartial, Pdefn(\fmCar),
		\modPartial, Pdefn(\fmMod),
		\index, Pdefn(\fmIndex),
		\dur, Pdefn(\fmDuration),
		\amp, Pdefn(\fmAmp),
		\pan, Pdefn(\fmPan),
		\att, Pdefn(\fmAtt),
		\mod1, Pdefn(\fmMod1),
		\mod2, Pdefn(\fmMod2)
	), Pdefn(\fmWait),
	~addrBook);