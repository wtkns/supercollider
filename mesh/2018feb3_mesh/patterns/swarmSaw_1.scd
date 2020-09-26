(
~swarmSawJames_mono=Pmono(
\swarmSawJames,
\dur, Pdefn(\swarmSawJamesdur_mono, Pmeanrand(1, 5)),

\frqlag3, Pdefn(\swarmSawJamesfrqlag3_mono, Pmeanrand(1, 5)),
\frqOffset, Pdefn(\swarmSawJamesfrqOffset_mono, Pmeanrand(10, 50)),
\rlpfrq4, Pdefn(\swarmSawJamesrlpfrq4_mono, Pmeanrand(100, 500)),
\rlprq2, Pdefn(\swarmSawJamesrlprq2_mono, Pmeanrand(0.5, 1.5)),
\out, Pdefn(\swarmSawJamesout_mono, nil),
\panx3, Pdefn(\swarmSawJamespanx3_mono, Pmeanrand(-1.0)),
\rlpfrqlag2, Pdefn(\swarmSawJamesrlpfrqlag2_mono, Pmeanrand(1, 5)),
\rlprq3, Pdefn(\swarmSawJamesrlprq3_mono, Pmeanrand(0.5, 1.5)),
\rlpfrqlag1, Pdefn(\swarmSawJamesrlpfrqlag1_mono, Pmeanrand(1, 5)),
\panxlag3, Pdefn(\swarmSawJamespanxlag3_mono, Pmeanrand(1, 5)),
\amplag3, Pdefn(\swarmSawJamesamplag3_mono, Pmeanrand(1, 5)),
\frqlag2, Pdefn(\swarmSawJamesfrqlag2_mono, Pmeanrand(1, 5)),
\panxlag1, Pdefn(\swarmSawJamespanxlag1_mono, Pmeanrand(1, 5)),
\panylag4, Pdefn(\swarmSawJamespanylag4_mono, Pmeanrand(1, 5)),
\panx4, Pdefn(\swarmSawJamespanx4_mono, Pmeanrand(-1.0)),
\rlpfrq3, Pdefn(\swarmSawJamesrlpfrq3_mono, Pmeanrand(100, 500)),
\freq1, Pdefn(\swarmSawJamesfreq1_mono, Pmeanrand(50, 70)),
\rlpfrqlag4, Pdefn(\swarmSawJamesrlpfrqlag4_mono, Pmeanrand(1, 5)),
\pany4, Pdefn(\swarmSawJamespany4_mono, Pmeanrand(-1.0)),
\rlpfrqlag3, Pdefn(\swarmSawJamesrlpfrqlag3_mono, Pmeanrand(1, 5)),
\pany3, Pdefn(\swarmSawJamespany3_mono, Pmeanrand(-1.0)),
\amplag2, Pdefn(\swarmSawJamesamplag2_mono, Pmeanrand(1, 5)),
\freq2, Pdefn(\swarmSawJamesfreq2_mono, Pmeanrand(50, 70)),
\amplag4, Pdefn(\swarmSawJamesamplag4_mono, Pmeanrand(1, 5)),
\pany1, Pdefn(\swarmSawJamespany1_mono, Pmeanrand(-1.0)),
\panxlag4, Pdefn(\swarmSawJamespanxlag4_mono, Pmeanrand(1, 5)),
\amp1, Pdefn(\swarmSawJamesamp1_mono, Pmeanrand(0.01, 0.1)),
\amp3, Pdefn(\swarmSawJamesamp3_mono, Pmeanrand(0.01, 0.1)),
\panylag2, Pdefn(\swarmSawJamespanylag2_mono, Pmeanrand(1, 5)),
\rlprq4, Pdefn(\swarmSawJamesrlprq4_mono, Pmeanrand(0.5, 1.5)),
\rlpfrq1, Pdefn(\swarmSawJamesrlpfrq1_mono, Pmeanrand(100, 500)),
\rlprq1, Pdefn(\swarmSawJamesrlprq1_mono, Pmeanrand(0.5, 1.5)),
\panx2, Pdefn(\swarmSawJamespanx2_mono, Pmeanrand(-1.0)),
\freq3, Pdefn(\swarmSawJamesfreq3_mono, Pmeanrand(50, 70)),
\frqSpread, Pdefn(\swarmSawJamesfrqSpread_mono, Pmeanrand(5, 25)),
\freq4, Pdefn(\swarmSawJamesfreq4_mono, Pmeanrand(50, 70)),
\panx1, Pdefn(\swarmSawJamespanx1_mono, Pmeanrand(-1.0)),
\pany2, Pdefn(\swarmSawJamespany2_mono, Pmeanrand(-1.0)),
\amp4, Pdefn(\swarmSawJamesamp4_mono, Pmeanrand(0.01, 0.1)),
\frqlag4, Pdefn(\swarmSawJamesfrqlag4_mono, Pmeanrand(1, 5)),
\panxlag2, Pdefn(\swarmSawJamespanxlag2_mono, Pmeanrand(1, 5)),
\panylag3, Pdefn(\swarmSawJamespanylag3_mono, Pmeanrand(1, 5)),
\amplag1, Pdefn(\swarmSawJamesamplag1_mono, Pmeanrand(1, 5)),
\rlpfrq2, Pdefn(\swarmSawJamesrlpfrq2_mono, Pmeanrand(100, 500)),
\amp2, Pdefn(\swarmSawJamesamp2_mono, Pmeanrand(0.01, 0.1)),
\panylag1, Pdefn(\swarmSawJamespanylag1_mono, Pmeanrand(1, 5)),
\frqlag1, Pdefn(\swarmSawJamesfrqlag1_mono, Pmeanrand(1, 5)),
).play;

)

~swarmSawJames_mono.stop

s.queryAllNodes;


~swarmSawJames_bindID = 1000;

(
~swarmSawJames_bind=Pbind(
\instrument, \swarmSawJames,
\id, ~swarmSawJames_bindID,
\type, \set,
\args, #[],
\out, Pdefn(\swarmSawJamesout_bind, 0, inf),
\dur, Pdefn(\swarmSawJamesdur_bind, Pmeanrand(0.1, 0.5)),

\frqOffset, Pdefn(\swarmSawJamesfrqOffset_bind, Pmeanrand(10, 50)),
\frqSpread, Pdefn(\swarmSawJamesfrqSpread_bind, Pmeanrand(5, 25)),

\freq1, Pdefn(\swarmSawJamesfreq1_bind, Pmeanrand(50, 70)),
\freq2, Pdefn(\swarmSawJamesfreq2_bind, Pmeanrand(50, 70)),
\freq3, Pdefn(\swarmSawJamesfreq3_bind, Pmeanrand(50, 70)),
\freq4, Pdefn(\swarmSawJamesfreq4_bind, Pmeanrand(50, 70)),

\frqlag1, Pdefn(\swarmSawJamesfrqlag1_bind, Pmeanrand(1, 5)),
\frqlag2, Pdefn(\swarmSawJamesfrqlag2_bind, Pmeanrand(1, 5)),
\frqlag3, Pdefn(\swarmSawJamesfrqlag3_bind, Pmeanrand(1, 5)),
\frqlag4, Pdefn(\swarmSawJamesfrqlag4_bind, Pmeanrand(1, 5)),

\rlpfrq1, Pdefn(\swarmSawJamesrlpfrq1_bind, Pmeanrand(100, 500)),
\rlpfrq2, Pdefn(\swarmSawJamesrlpfrq2_bind, Pmeanrand(100, 500)),
\rlpfrq3, Pdefn(\swarmSawJamesrlpfrq3_bind, Pmeanrand(100, 500)),
\rlpfrq4, Pdefn(\swarmSawJamesrlpfrq4_bind, Pmeanrand(100, 500)),

\rlpfrqlag1, Pdefn(\swarmSawJamesrlpfrqlag1_bind, Pmeanrand(1, 5)),
\rlpfrqlag2, Pdefn(\swarmSawJamesrlpfrqlag2_bind, Pmeanrand(1, 5)),
\rlpfrqlag3, Pdefn(\swarmSawJamesrlpfrqlag3_bind, Pmeanrand(1, 5)),
\rlpfrqlag4, Pdefn(\swarmSawJamesrlpfrqlag4_bind, Pmeanrand(1, 5)),

\rlprq1, Pdefn(\swarmSawJamesrlprq1_bind, Pmeanrand(0.5, 1.5)),
\rlprq2, Pdefn(\swarmSawJamesrlprq2_bind, Pmeanrand(0.5, 1.5)),
\rlprq3, Pdefn(\swarmSawJamesrlprq3_bind, Pmeanrand(0.5, 1.5)),
\rlprq4, Pdefn(\swarmSawJamesrlprq4_bind, Pmeanrand(0.5, 1.5)),

\amp1, Pdefn(\swarmSawJamesamp1_bind, Pmeanrand(0.01, 0.1)),
\amp2, Pdefn(\swarmSawJamesamp2_bind, Pmeanrand(0.01, 0.1)),
\amp3, Pdefn(\swarmSawJamesamp3_bind, Pmeanrand(0.01, 0.1)),
\amp4, Pdefn(\swarmSawJamesamp4_bind, Pmeanrand(0.01, 0.1)),

\amplag1, Pdefn(\swarmSawJamesamplag1_bind, Pmeanrand(1, 5)),
\amplag2, Pdefn(\swarmSawJamesamplag2_bind, Pmeanrand(1, 5)),
\amplag3, Pdefn(\swarmSawJamesamplag3_bind, Pmeanrand(1, 5)),
\amplag4, Pdefn(\swarmSawJamesamplag4_bind, Pmeanrand(1, 5)),

\panx1, Pdefn(\swarmSawJamespanx1_bind, Pmeanrand(-1.0)),
\panx2, Pdefn(\swarmSawJamespanx2_bind, Pmeanrand(-1.0)),
\panx3, Pdefn(\swarmSawJamespanx3_bind, Pmeanrand(-1.0)),
\panx4, Pdefn(\swarmSawJamespanx4_bind, Pmeanrand(-1.0)),

\panxlag1, Pdefn(\swarmSawJamespanxlag1_bind, Pmeanrand(1, 5)),
\panxlag2, Pdefn(\swarmSawJamespanxlag2_bind, Pmeanrand(1, 5)),
\panxlag3, Pdefn(\swarmSawJamespanxlag3_bind, Pmeanrand(1, 5)),
\panxlag4, Pdefn(\swarmSawJamespanxlag4_bind, Pmeanrand(1, 5)),

\pany1, Pdefn(\swarmSawJamespany1_bind, Pmeanrand(-1.0)),
\pany2, Pdefn(\swarmSawJamespany2_bind, Pmeanrand(-1.0)),
\pany3, Pdefn(\swarmSawJamespany3_bind, Pmeanrand(-1.0)),
\pany4, Pdefn(\swarmSawJamespany4_bind, Pmeanrand(-1.0)),

\panylag1, Pdefn(\swarmSawJamespanylag1_bind, Pmeanrand(1, 5)),
\panylag2, Pdefn(\swarmSawJamespanylag2_bind, Pmeanrand(1, 5)),
\panylag3, Pdefn(\swarmSawJamespanylag3_bind, Pmeanrand(1, 5)),
\panylag4, Pdefn(\swarmSawJamespanylag4_bind, Pmeanrand(1, 5))
).play;


Pdefn(\swarmSawJamesout_bind, 0, inf);
Pdefn(\swarmSawJamesdur_bind, Pmeanrand(0.1, 0.5));

Pdefn(\swarmSawJamesfrqOffset_bind, Pmeanrand(10, 50));
Pdefn(\swarmSawJamesfrqSpread_bind, Pmeanrand(5, 25));

Pdefn(\swarmSawJamesfreq1_bind, Pmeanrand(50, 70));
Pdefn(\swarmSawJamesfreq2_bind, Pmeanrand(50, 70));
Pdefn(\swarmSawJamesfreq3_bind, Pmeanrand(50, 70));
Pdefn(\swarmSawJamesfreq4_bind, Pmeanrand(50, 70));

Pdefn(\swarmSawJamesfrqlag1_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesfrqlag2_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesfrqlag3_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesfrqlag4_bind, Pmeanrand(1, 5));

Pdefn(\swarmSawJamesrlpfrq1_bind, Pmeanrand(100, 500));
Pdefn(\swarmSawJamesrlpfrq2_bind, Pmeanrand(100, 500));
Pdefn(\swarmSawJamesrlpfrq3_bind, Pmeanrand(100, 500));
Pdefn(\swarmSawJamesrlpfrq4_bind, Pmeanrand(100, 500));

Pdefn(\swarmSawJamesrlpfrqlag1_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesrlpfrqlag2_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesrlpfrqlag3_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesrlpfrqlag4_bind, Pmeanrand(1, 5));

Pdefn(\swarmSawJamesrlprq1_bind, Pmeanrand(0.5, 1.5));
Pdefn(\swarmSawJamesrlprq2_bind, Pmeanrand(0.5, 1.5));
Pdefn(\swarmSawJamesrlprq3_bind, Pmeanrand(0.5, 1.5));
Pdefn(\swarmSawJamesrlprq4_bind, Pmeanrand(0.5, 1.5));

Pdefn(\swarmSawJamesamp1_bind, Pmeanrand(0.01, 0.1));
Pdefn(\swarmSawJamesamp2_bind, Pmeanrand(0.01, 0.1));
Pdefn(\swarmSawJamesamp3_bind, Pmeanrand(0.01, 0.1));
Pdefn(\swarmSawJamesamp4_bind, Pmeanrand(0.01, 0.1));

Pdefn(\swarmSawJamesamplag1_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesamplag2_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesamplag3_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamesamplag4_bind, Pmeanrand(1, 5));

Pdefn(\swarmSawJamespanx1_bind, Pmeanrand(-1.0));
Pdefn(\swarmSawJamespanx2_bind, Pmeanrand(-1.0));
Pdefn(\swarmSawJamespanx3_bind, Pmeanrand(-1.0));
Pdefn(\swarmSawJamespanx4_bind, Pmeanrand(-1.0));

Pdefn(\swarmSawJamespanxlag1_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamespanxlag2_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamespanxlag3_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamespanxlag4_bind, Pmeanrand(1, 5));

Pdefn(\swarmSawJamespany1_bind, Pmeanrand(-1.0));
Pdefn(\swarmSawJamespany2_bind, Pmeanrand(-1.0));
Pdefn(\swarmSawJamespany3_bind, Pmeanrand(-1.0));
Pdefn(\swarmSawJamespany4_bind, Pmeanrand(-1.0));

Pdefn(\swarmSawJamespanylag1_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamespanylag2_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamespanylag3_bind, Pmeanrand(1, 5));
Pdefn(\swarmSawJamespanylag4_bind, Pmeanrand(1, 5));
)

~swarmSawJames_bind.stop

s.sendMsg("/n_free", ~swarmSawJames_monoID);


