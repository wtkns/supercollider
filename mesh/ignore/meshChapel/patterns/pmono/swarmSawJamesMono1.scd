Pbindef.clear
134218728.asTarget.free


~swarmSawJamesMono1.stop;

(
~swarmSawJamesMono1 = Pmono(\swarmSawJames,
	\dur, Pdefn(\swarmSawJamesDurMono1, Pmeanrand(1, 5)),
	\out, Pdefn(\swarmSawJamesOutMono1, 0, inf),
	\freq1, Pdefn(\swarmSawJamesFreq1Mono1, Pmeanrand(50, 70)),
	\freq2, Pdefn(\swarmSawJamesFreq2Mono1, Pmeanrand(50, 70)),
	\freq3, Pdefn(\swarmSawJamesFreq3Mono1, Pmeanrand(50, 70)),
	\freq4, Pdefn(\swarmSawJamesFreq4Mono1, Pmeanrand(50, 70)),
	\amp1, Pdefn(\swarmSawJamesAmp1Mono1, Pmeanrand(0.01, 0.05)),
	\amp2, Pdefn(\swarmSawJamesAmp2Mono1, Pmeanrand(0.01, 0.05)),
	\amp3, Pdefn(\swarmSawJamesAmp3Mono1, Pmeanrand(0.01, 0.05)),
	\amp4, Pdefn(\swarmSawJamesAmp4Mono1, Pmeanrand(0.01, 0.05)),
	\rlpfrq1, Pdefn(\swarmSawJamesRlpfrq1Mono1, Pmeanrand(100, 500)),
	\rlpfrq2, Pdefn(\swarmSawJamesRlpfrq2Mono1, Pmeanrand(100, 500)),
	\rlpfrq3, Pdefn(\swarmSawJamesRlpfrq3Mono1, Pmeanrand(100, 500)),
	\rlpfrq4, Pdefn(\swarmSawJamesRlpfrq4Mono1, Pmeanrand(100, 500)),
	\rlpfrqlag1, Pdefn(\swarmSawJamesRlpfrqlag1Mono1, Pmeanrand(1, 5)),
	\rlpfrqlag2, Pdefn(\swarmSawJamesRlpfrqlag2Mono1, Pmeanrand(1, 5)),
	\rlpfrqlag3, Pdefn(\swarmSawJamesRlpfrqlag3Mono1, Pmeanrand(1, 5)),
	\rlpfrqlag4, Pdefn(\swarmSawJamesRlpfrqlag4Mono1, Pmeanrand(1, 5)),
	\rlprq1, Pdefn(\swarmSawJamesRlprq1Mono1, Pmeanrand(0.5, 1.5)),
	\rlprq2, Pdefn(\swarmSawJamesRlprq2Mono1, Pmeanrand(0.5, 1.5)),
	\rlprq3, Pdefn(\swarmSawJamesRlprq3Mono1, Pmeanrand(0.5, 1.5)),
	\rlprq4, Pdefn(\swarmSawJamesRlprq4Mono1, Pmeanrand(0.5, 1.5)),
	\panx1, Pdefn(\swarmSawJamesPanx1Mono1, Pmeanrand(-1.0)),
	\panx2, Pdefn(\swarmSawJamesPanx2Mono1, Pmeanrand(-1.0)),
	\panx3, Pdefn(\swarmSawJamesPanx3Mono1, Pmeanrand(-1.0)),
	\panx4, Pdefn(\swarmSawJamesPanx4Mono1, Pmeanrand(-1.0)),
	\pany1, Pdefn(\swarmSawJamesPany1Mono1, Pmeanrand(-1.0)),
	\pany2, Pdefn(\swarmSawJamesPany2Mono1, Pmeanrand(-1.0)),
	\pany3, Pdefn(\swarmSawJamesPany3Mono1, Pmeanrand(-1.0)),
	\pany4, Pdefn(\swarmSawJamesPany4Mono1, Pmeanrand(-1.0)),
	\panxlag1, Pdefn(\swarmSawJamesPanxlag1Mono1, Pmeanrand(1, 5)),
	\panxlag2, Pdefn(\swarmSawJamesPanxlag2Mono1, Pmeanrand(1, 5)),
	\panxlag3, Pdefn(\swarmSawJamesPanxlag3Mono1, Pmeanrand(1, 5)),
	\panxlag4, Pdefn(\swarmSawJamesPanxlag4Mono1, Pmeanrand(1, 5)),
	\panylag1, Pdefn(\swarmSawJamesPanylag1Mono1, Pmeanrand(1, 5)),
	\panylag2, Pdefn(\swarmSawJamesPanylag2Mono1, Pmeanrand(1, 5)),
	\panylag3, Pdefn(\swarmSawJamesPanylag3Mono1, Pmeanrand(1, 5)),
	\panylag4, Pdefn(\swarmSawJamesPanylag4Mono1, Pmeanrand(1, 5)),
	\frqlag1, Pdefn(\swarmSawJamesFrqlag1Mono1, Pmeanrand(1, 5)),
	\frqlag2, Pdefn(\swarmSawJamesFrqlag2Mono1, Pmeanrand(1, 5)),
	\frqlag3, Pdefn(\swarmSawJamesFrqlag3Mono1, Pmeanrand(1, 5)),
	\frqlag4, Pdefn(\swarmSawJamesFrqlag4Mono1, Pmeanrand(1, 5)),
	\amplag1, Pdefn(\swarmSawJamesAmplag1Mono1, Pmeanrand(1, 5)),
	\amplag2, Pdefn(\swarmSawJamesAmplag2Mono1, Pmeanrand(1, 5)),
	\amplag3, Pdefn(\swarmSawJamesAmplag3Mono1, Pmeanrand(1, 5)),
	\amplag4, Pdefn(\swarmSawJamesAmplag4Mono1, Pmeanrand(1, 5)),
	\frqOffset, Pdefn(\swarmSawJamesFrqOffsetMono1, Pmeanrand(10, 50)),
	\frqSpread, Pdefn(\swarmSawJamesFrqSpreadMono1, Pmeanrand(5, 25))
).play;
)


/////////////////////////

MeshBindef.writeBindef(\swarmSawJames, 1, ~swarmSawJamesMono1Node);

////////////////////////

Pdefn(\swarmSawJamesDurMono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesOutMono1, Pseq([ 0 ], inf));

Pdefn(\swarmSawJamesFrqOffsetMono1, Pmeanrand(10, 50));
Pdefn(\swarmSawJamesFrqSpreadMono1, Pmeanrand(5, 25));

Pdefn(\swarmSawJamesFreq1Mono1, Pmeanrand(50, 70));
Pdefn(\swarmSawJamesFreq2Mono1, Pmeanrand(50, 70));
Pdefn(\swarmSawJamesFreq3Mono1, Pmeanrand(50, 70));
Pdefn(\swarmSawJamesFreq4Mono1, Pmeanrand(50, 70));

Pdefn(\swarmSawJamesAmp1Mono1, Pmeanrand(0.01, 0.15));
Pdefn(\swarmSawJamesAmp2Mono1, Pmeanrand(0.01, 0.15));
Pdefn(\swarmSawJamesAmp3Mono1, Pmeanrand(0.01, 0.15));
Pdefn(\swarmSawJamesAmp4Mono1, Pmeanrand(0.01, 0.15));

Pdefn(\swarmSawJamesRlpfrq1Mono1, Pmeanrand(100, 500));
Pdefn(\swarmSawJamesRlpfrq2Mono1, Pmeanrand(100, 500));
Pdefn(\swarmSawJamesRlpfrq3Mono1, Pmeanrand(100, 500));
Pdefn(\swarmSawJamesRlpfrq4Mono1, Pmeanrand(100, 500));

Pdefn(\swarmSawJamesRlpfrqlag1Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesRlpfrqlag2Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesRlpfrqlag3Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesRlpfrqlag4Mono1, Pmeanrand(1, 5));

Pdefn(\swarmSawJamesRlprq1Mono1, Pmeanrand(0.5, 1.5));
Pdefn(\swarmSawJamesRlprq2Mono1, Pmeanrand(0.5, 1.5));
Pdefn(\swarmSawJamesRlprq3Mono1, Pmeanrand(0.5, 1.5));
Pdefn(\swarmSawJamesRlprq4Mono1, Pmeanrand(0.5, 1.5));

Pdefn(\swarmSawJamesPanx1Mono1, Pmeanrand(-1.0));
Pdefn(\swarmSawJamesPanx2Mono1, Pmeanrand(-1.0));
Pdefn(\swarmSawJamesPanx3Mono1, Pmeanrand(-1.0));
Pdefn(\swarmSawJamesPanx4Mono1, Pmeanrand(-1.0));

Pdefn(\swarmSawJamesPany1Mono1, Pmeanrand(-1.0));
Pdefn(\swarmSawJamesPany2Mono1, Pmeanrand(-1.0));
Pdefn(\swarmSawJamesPany3Mono1, Pmeanrand(-1.0));
Pdefn(\swarmSawJamesPany4Mono1, Pmeanrand(-1.0));

Pdefn(\swarmSawJamesPanxlag1Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesPanxlag2Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesPanxlag3Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesPanxlag4Mono1, Pmeanrand(1, 5));

Pdefn(\swarmSawJamesPanylag1Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesPanylag2Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesPanylag3Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesPanylag4Mono1, Pmeanrand(1, 5));

Pdefn(\swarmSawJamesFrqlag1Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesFrqlag2Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesFrqlag3Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesFrqlag4Mono1, Pmeanrand(1, 5));

Pdefn(\swarmSawJamesAmplag1Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesAmplag2Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesAmplag3Mono1, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesAmplag4Mono1, Pmeanrand(1, 5));

//////



//// OUT
Pdefn(\swarmSawJamesDurMono1, Pmeanrand(0.01, 0.05));

Pdefn(\swarmSawJamesAmp1Mono1, Pmeanrand(0.01, 0.05));
Pdefn(\swarmSawJamesAmp2Mono1, Pmeanrand(0.01, 0.05));
Pdefn(\swarmSawJamesAmp3Mono1, Pmeanrand(0.01, 0.05));
Pdefn(\swarmSawJamesAmp4Mono1, Pmeanrand(0.01, 0.05));


Pdefn(\swarmSawJamesAmp1Mono1, Pmeanrand(0.01, 0.025));
Pdefn(\swarmSawJamesAmp2Mono1, Pmeanrand(0.01, 0.025));
Pdefn(\swarmSawJamesAmp3Mono1, Pmeanrand(0.01, 0.025));
Pdefn(\swarmSawJamesAmp4Mono1, Pmeanrand(0.01, 0.025));

Pdefn(\swarmSawJamesAmp1Mono1, Pmeanrand(0.001, 0.01));
Pdefn(\swarmSawJamesAmp2Mono1, Pmeanrand(0.001, 0.01));
Pdefn(\swarmSawJamesAmp3Mono1, Pmeanrand(0.001, 0.01));
Pdefn(\swarmSawJamesAmp4Mono1, Pmeanrand(0.001, 0.01));

Pdefn(\swarmSawJamesAmp1Mono1, Pmeanrand(0.001, 0.001));
Pdefn(\swarmSawJamesAmp2Mono1, Pmeanrand(0.001, 0.001));
Pdefn(\swarmSawJamesAmp3Mono1, Pmeanrand(0.001, 0.001));
Pdefn(\swarmSawJamesAmp4Mono1, Pmeanrand(0.001, 0.001));

Pdefn(\swarmSawJamesAmp1Mono1, 0);
Pdefn(\swarmSawJamesAmp2Mono1, 0);
Pdefn(\swarmSawJamesAmp3Mono1, 0);
Pdefn(\swarmSawJamesAmp4Mono1, 0);

~swarmSawJamesMono1.stop;

~swarmSawJamesMono1Node.free;

201327592.asTarget.free

Pdefn(\swarmSawJamesDurMono1, Pmeanrand(1, 5)),