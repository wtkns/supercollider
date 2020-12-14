Pbindef.clear

~swarmSawJamesBindef1.stop;

(
~swarmSawJamesBindef1 = MeshBindef(\swarmSawJamesBindef1,
	\instrument, \swarmSawJames,

	///// or this
	\id, 1003,

	\type, \set,
	\args, #[],
	\dur, Pdefn(\swarmSawJamesDurBindef1, Pwhite(1, 5))
).play;
)

Pbindef(\swarmSawJamesBindef1, \dur, Pdefn(\swarmSawJamesDurBindef1, Pwhite(0.5, 1)));

Pbindef(\swarmSawJamesBindef1, \frqOffset, Pdefn(\swarmSawJamesFrqOffsetBindef1, Pmeanrand(20, 40)));
Pbindef(\swarmSawJamesBindef1, \frqSpread, Pdefn(\swarmSawJamesFrqSpreadBindef1, Pmeanrand(5, 40)));


Pbindef(\swarmSawJamesBindef1, \freq1, Pdefn(\swarmSawJamesFreq1Bindef1, Pexprand(40, 140)));
Pbindef(\swarmSawJamesBindef1, \freq2, Pdefn(\swarmSawJamesFreq2Bindef1, Pexprand(40, 140)));
Pbindef(\swarmSawJamesBindef1, \freq3, Pdefn(\swarmSawJamesFreq3Bindef1, Pexprand(40, 120)));
Pbindef(\swarmSawJamesBindef1, \freq4, Pdefn(\swarmSawJamesFreq4Bindef1, Pexprand(40, 120)));


Pbindef(\swarmSawJamesBindef1, \amp1, Pdefn(\swarmSawJamesAmp1Bindef1, Pmeanrand(0.01, 0.1)));
Pbindef(\swarmSawJamesBindef1, \amp2, Pdefn(\swarmSawJamesAmp2Bindef1, Pmeanrand(0.01, 0.1)));
Pbindef(\swarmSawJamesBindef1, \amp3, Pdefn(\swarmSawJamesAmp3Bindef1, Pmeanrand(0.01, 0.1)));
Pbindef(\swarmSawJamesBindef1, \amp4, Pdefn(\swarmSawJamesAmp4Bindef1, Pmeanrand(0.01, 0.1)));

Pbindef(\swarmSawJamesBindef1, \rlpfrq1, Pdefn(\swarmSawJamesRlpfrq1Bindef1, Pmeanrand(50, 1000)));
Pbindef(\swarmSawJamesBindef1, \rlpfrq2, Pdefn(\swarmSawJamesRlpfrq2Bindef1, Pmeanrand(50, 1000)));
Pbindef(\swarmSawJamesBindef1, \rlpfrq3, Pdefn(\swarmSawJamesRlpfrq3Bindef1, Pmeanrand(50, 1000)));
Pbindef(\swarmSawJamesBindef1, \rlpfrq4, Pdefn(\swarmSawJamesRlpfrq4Bindef1, Pmeanrand(50, 1000)));

Pbindef(\swarmSawJamesBindef1, \rlprq1, Pdefn(\swarmSawJamesRlprq1Bindef1, Pmeanrand(0.015, 0.15)));
Pbindef(\swarmSawJamesBindef1, \rlprq2, Pdefn(\swarmSawJamesRlprq2Bindef1, Pmeanrand(0.015, 0.15)));
Pbindef(\swarmSawJamesBindef1, \rlprq3, Pdefn(\swarmSawJamesRlprq3Bindef1, Pmeanrand(0.015, 0.15)));
Pbindef(\swarmSawJamesBindef1, \rlprq4, Pdefn(\swarmSawJamesRlprq4Bindef1, Pmeanrand(0.015, 0.15)));

Pbindef(\swarmSawJamesBindef1, \rlpfrqlag1, Pdefn(\swarmSawJamesRlpfrqlag1Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \rlpfrqlag2, Pdefn(\swarmSawJamesRlpfrqlag2Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \rlpfrqlag3, Pdefn(\swarmSawJamesRlpfrqlag3Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \rlpfrqlag4, Pdefn(\swarmSawJamesRlpfrqlag4Bindef1, Pmeanrand(0.1, 0.5)));


Pbindef(\swarmSawJamesBindef1, \panx1, Pdefn(\swarmSawJamesPanx1Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \panx2, Pdefn(\swarmSawJamesPanx2Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \panx3, Pdefn(\swarmSawJamesPanx3Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \panx4, Pdefn(\swarmSawJamesPanx4Bindef1, Pmeanrand(-1.0, 1)));

Pbindef(\swarmSawJamesBindef1, \pany1, Pdefn(\swarmSawJamesPany1Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \pany2, Pdefn(\swarmSawJamesPany2Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \pany3, Pdefn(\swarmSawJamesPany3Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \pany4, Pdefn(\swarmSawJamesPany4Bindef1, Pmeanrand(-1.0, 1)));

Pbindef(\swarmSawJamesBindef1, \panxlag1, Pdefn(\swarmSawJamesPanxlag1Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panxlag2, Pdefn(\swarmSawJamesPanxlag2Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panxlag3, Pdefn(\swarmSawJamesPanxlag3Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panxlag4, Pdefn(\swarmSawJamesPanxlag4Bindef1, Pmeanrand(0.1, 0.5)));

Pbindef(\swarmSawJamesBindef1, \panylag1, Pdefn(\swarmSawJamesPanylag1Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panylag2, Pdefn(\swarmSawJamesPanylag2Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panylag3, Pdefn(\swarmSawJamesPanylag3Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panylag4, Pdefn(\swarmSawJamesPanylag4Bindef1, Pmeanrand(0.1, 0.5)));

Pbindef(\swarmSawJamesBindef1, \frqlag1, Pdefn(\swarmSawJamesFrqlag1Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \frqlag2, Pdefn(\swarmSawJamesFrqlag2Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \frqlag3, Pdefn(\swarmSawJamesFrqlag3Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \frqlag4, Pdefn(\swarmSawJamesFrqlag4Bindef1, Pmeanrand(0.1, 0.5)));

Pbindef(\swarmSawJamesBindef1, \amplag1, Pdefn(\swarmSawJamesAmplag1Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \amplag2, Pdefn(\swarmSawJamesAmplag2Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \amplag3, Pdefn(\swarmSawJamesAmplag3Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \amplag4, Pdefn(\swarmSawJamesAmplag4Bindef1, Pmeanrand(0.1, 0.5)));




Pbindef(\swarmSawJamesBindef1, \dur, Pdefn(\swarmSawJamesDurBindef1, Pexprand(0.01, 0.5)));

MeshBindef(\swarmSawJamesBindef1).stop;

MeshBindef(\swarmSawJamesBindef1).play;


// KILL KILL KILL !!!!!!

(
~swarmSawJamesb = Pbind(
	\instrument, \swarmSawJames,
	\id, 67109864,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\swarmSawJamesDurb, Pwhite(0.01,0.1)),
	\freq1, Pdefn(\swarmSawJamesfreq1b),
	\freq2, Pdefn(\swarmSawJamesfreq2b),
	\freq3, Pdefn(\swarmSawJamesfreq3b),
	\freq4, Pdefn(\swarmSawJamesfreq4b),
	\amp1, Pdefn(\swarmSawJamesamp1b),
	\amp2, Pdefn(\swarmSawJamesamp2b),
	\amp3, Pdefn(\swarmSawJamesamp3b),
	\amp4, Pdefn(\swarmSawJamesamp4b)
).play;
)

~swarmSawJamesb.stop

Pdefn(\swarmSawJamesfreq1b, Pwhite(0,1));
Pdefn(\swarmSawJamesfreq2b, Pwhite(0,1));
Pdefn(\swarmSawJamesfreq3b, Pwhite(0,1));
Pdefn(\swarmSawJamesfreq4b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp1b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp2b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp3b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp4b, Pwhite(0,1));


Pdefn(\swarmSawJamesDurBindef1, Pseq([ Pseries(0.1, (-0.0001), 999), Pn(0.001) ], inf));



Pdefn(\swarmSawJamesDurb, 0.1, inf);

Pdefn(\swarmSawJamesDurb, 0.01, inf);

Pdefn(\swarmSawJamesDurb, 0.001, inf);

Pbindef.clear



~swarmSawJamesb.stop
~swarmSawJamesb.play





///////////////////////
//  ??????????????????

~swarmSawJamesBindef1.stop;
(
~swarmSawJamesBindef1 = MeshBindef(\swarmSawJamesBindef1,
\instrument, \swarmSawJames,
\id, 1001,
\type, \set,
\args, #[],
\out, Pdefn(\swarmSawJamesOutBindef1, 0, inf),
\dur, Pdefn(\swarmSawJamesDurBindef1, 0.1, inf)
).play;
)

Pbindef(\swarmSawJamesBindef1, \dur, );

Pbindef(\swarmSawJamesBindef1, \frqOffset, Pdefn(\swarmSawJamesFrqOffsetBindef1, Pmeanrand(0, 10)));
Pbindef(\swarmSawJamesBindef1, \frqSpread, Pdefn(\swarmSawJamesFrqSpreadBindef1, Pmeanrand(0, 100)));


Pbindef(\swarmSawJamesBindef1, \freq1, Pdefn(\swarmSawJamesFreqBindef1, Pmeanrand(30, 70)));
Pbindef(\swarmSawJamesBindef1, \freq2, Pdefn(\swarmSawJamesFreqBindef1));
Pbindef(\swarmSawJamesBindef1, \freq3, Pdefn(\swarmSawJamesFreqBindef1));
Pbindef(\swarmSawJamesBindef1, \freq4, Pdefn(\swarmSawJamesFreqBindef1));


Pbindef(\swarmSawJamesBindef1, \amp1, Pdefn(\swarmSawJamesAmp1Bindef1, Pmeanrand(0.01, 0.25)));
Pbindef(\swarmSawJamesBindef1, \amp2, Pdefn(\swarmSawJamesAmp2Bindef1, Pmeanrand(0.01, 0.25)));
Pbindef(\swarmSawJamesBindef1, \amp3, Pdefn(\swarmSawJamesAmp3Bindef1, Pmeanrand(0.01, 0.25)));
Pbindef(\swarmSawJamesBindef1, \amp4, Pdefn(\swarmSawJamesAmp4Bindef1, Pmeanrand(0.01, 0.25)));

Pbindef(\swarmSawJamesBindef1, \rlpfrq1, Pdefn(\swarmSawJamesRlpfrq1Bindef1, Pmeanrand(50, 1000)));
Pbindef(\swarmSawJamesBindef1, \rlpfrq2, Pdefn(\swarmSawJamesRlpfrq2Bindef1, Pmeanrand(50, 1000)));
Pbindef(\swarmSawJamesBindef1, \rlpfrq3, Pdefn(\swarmSawJamesRlpfrq3Bindef1, Pmeanrand(50, 1000)));
Pbindef(\swarmSawJamesBindef1, \rlpfrq4, Pdefn(\swarmSawJamesRlpfrq4Bindef1, Pmeanrand(50, 1000)));

Pbindef(\swarmSawJamesBindef1, \rlpfrqlag1, Pdefn(\swarmSawJamesRlpfrqlag1Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \rlpfrqlag2, Pdefn(\swarmSawJamesRlpfrqlag2Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \rlpfrqlag3, Pdefn(\swarmSawJamesRlpfrqlag3Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \rlpfrqlag4, Pdefn(\swarmSawJamesRlpfrqlag4Bindef1, Pmeanrand(0.1, 0.5)));

Pbindef(\swarmSawJamesBindef1, \rlprq1, Pdefn(\swarmSawJamesRlprq1Bindef1, Pmeanrand(0.015, 0.15)));
Pbindef(\swarmSawJamesBindef1, \rlprq2, Pdefn(\swarmSawJamesRlprq2Bindef1, Pmeanrand(0.015, 0.15)));
Pbindef(\swarmSawJamesBindef1, \rlprq3, Pdefn(\swarmSawJamesRlprq3Bindef1, Pmeanrand(0.015, 0.15)));
Pbindef(\swarmSawJamesBindef1, \rlprq4, Pdefn(\swarmSawJamesRlprq4Bindef1, Pmeanrand(0.015, 0.15)));

Pbindef(\swarmSawJamesBindef1, \panx1, Pdefn(\swarmSawJamesPanx1Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \panx2, Pdefn(\swarmSawJamesPanx2Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \panx3, Pdefn(\swarmSawJamesPanx3Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \panx4, Pdefn(\swarmSawJamesPanx4Bindef1, Pmeanrand(-1.0, 1)));

Pbindef(\swarmSawJamesBindef1, \pany1, Pdefn(\swarmSawJamesPany1Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \pany2, Pdefn(\swarmSawJamesPany2Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \pany3, Pdefn(\swarmSawJamesPany3Bindef1, Pmeanrand(-1.0, 1)));
Pbindef(\swarmSawJamesBindef1, \pany4, Pdefn(\swarmSawJamesPany4Bindef1, Pmeanrand(-1.0, 1)));

Pbindef(\swarmSawJamesBindef1, \panxlag1, Pdefn(\swarmSawJamesPanxlag1Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panxlag2, Pdefn(\swarmSawJamesPanxlag2Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panxlag3, Pdefn(\swarmSawJamesPanxlag3Bindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \panxlag4, Pdefn(\swarmSawJamesPanxlag4Bindef1, Pmeanrand(0.1, 0.5)));

Pbindef(\swarmSawJamesBindef1, \panylag1, Pdefn(\swarmSawJamesPanylag1Bindef1, Pmeanrand(1, 5)));
Pbindef(\swarmSawJamesBindef1, \panylag2, Pdefn(\swarmSawJamesPanylag2Bindef1, Pmeanrand(1, 5)));
Pbindef(\swarmSawJamesBindef1, \panylag3, Pdefn(\swarmSawJamesPanylag3Bindef1, Pmeanrand(1, 5)));
Pbindef(\swarmSawJamesBindef1, \panylag4, Pdefn(\swarmSawJamesPanylag4Bindef1, Pmeanrand(1, 5)));

Pbindef(\swarmSawJamesBindef1, \frqlag1, Pdefn(\swarmSawJamesFrqlagBindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \frqlag2, Pdefn(\swarmSawJamesFrqlagBindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \frqlag3, Pdefn(\swarmSawJamesFrqlagBindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \frqlag4, Pdefn(\swarmSawJamesFrqlagBindef1, Pmeanrand(0.1, 0.5)));


Pbindef(\swarmSawJamesBindef1, \amplag1, Pdefn(\swarmSawJamesAmplagBindef1, Pmeanrand(0.1, 0.5)));
Pbindef(\swarmSawJamesBindef1, \amplag2, Pdefn(\swarmSawJamesAmplagBindef1));
Pbindef(\swarmSawJamesBindef1, \amplag3, Pdefn(\swarmSawJamesAmplagBindef1));
Pbindef(\swarmSawJamesBindef1, \amplag4, Pdefn(\swarmSawJamesAmplagBindef1));



MeshBindef(\swarmSawJamesBindef1).stop;

MeshBindef(\swarmSawJamesBindef1).play;


Pdefn(\swarmSawJamesFrqOffsetBindef1, Pmeanrand(0, 10));
Pdefn(\swarmSawJamesFrqSpreadBindef1, Pmeanrand(0, 100));


Pdefn(\swarmSawJamesDurBindef1, Pmeanrand(0.01, 0.05))

Pdefn(\swarmSawJamesFreqBindef1, Pmeanrand(100, 570))

Pdefn(\swarmSawJamesAmplagBindef1, Pmeanrand(0.01, 0.05))

// KILL KILL KILL !!!!!!

(
~swarmSawJamesb = Pbind(
	\instrument, \swarmSawJames,
	\id, 1001,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\swarmSawJamesDurb, Pwhite(0.01,0.1)),
	\out, Pdefn(\swarmSawJamesoutb),
	\freq1, Pdefn(\swarmSawJamesfreq1b),
	\freq2, Pdefn(\swarmSawJamesfreq2b),
	\freq3, Pdefn(\swarmSawJamesfreq3b),
	\freq4, Pdefn(\swarmSawJamesfreq4b),
	\amp1, Pdefn(\swarmSawJamesamp1b),
	\amp2, Pdefn(\swarmSawJamesamp2b),
	\amp3, Pdefn(\swarmSawJamesamp3b),
	\amp4, Pdefn(\swarmSawJamesamp4b)
).play;
)

Pdefn(\swarmSawJamesfreq1b, Pwhite(0,1));
Pdefn(\swarmSawJamesfreq2b, Pwhite(0,1));
Pdefn(\swarmSawJamesfreq3b, Pwhite(0,1));
Pdefn(\swarmSawJamesfreq4b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp1b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp2b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp3b, Pwhite(0,1));
Pdefn(\swarmSawJamesamp4b, Pwhite(0,1));

Pdefn(\swarmSawJamesDurb, 0.1, inf);

Pdefn(\swarmSawJamesDurb, 0.01, inf);

Pdefn(\swarmSawJamesDurb, 0.001, inf);

Pdefn(\swarmSawJamesDurb, Pseq([ Pseries(0.1, (-0.0001), 999), Pn(0.001) ], inf));



~swarmSawJamesb.stop
~swarmSawJamesb.play
