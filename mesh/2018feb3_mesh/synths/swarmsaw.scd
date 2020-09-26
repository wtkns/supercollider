// swarmsaw James, w 4chan Bobert mod
SynthDef(\swarmSaw2, {
    | out=0,
    freq1=50,    freq2=50,    freq3=50,    freq4=50,
    amp1=0, amp2=0, amp3=0, amp4=0,
    rlpfrq1=440, rlpfrq2=440, rlpfrq3=440, rlpfrq4=440,
    rlpfrqlag1 = 0.5, rlpfrqlag2 = 0.5, rlpfrqlag3 = 0.5, rlpfrqlag4 = 0.5,
    rlprq1=1, rlprq2=1, rlprq3=1, rlprq4=1,
    pan1=0, pan2=0, pan3=0, pan4=0,
    panlag1=0.5, panlag2=0.5, panlag3=0.5, panlag4=0.5,
    frqlag1=0.5, frqlag2=0.5, frqlag3=0.5, frqlag4=0.5,
    amplag1=0.5, amplag2=0.5, amplag3=0.5, amplag4=0.5,
    frqOffset=50, frqSpread=100 |

    // frqOffset = MouseX.kr(50, 500, 1, 5.0);
    //frqSpread = MouseY.kr(0, 100);
    //panOffset = MouseX.kr(-1,1);

    var arryPan = [
        Pan4.ar( RLPF.ar(SawDPW.ar(Lag.kr(freq1+frqOffset, frqlag1), 0, Lag.kr(amp1, amplag1)),
			freq: Lag.kr(rlpfrq1, rlpfrqlag1), rq: rlprq1, mul: 1, add: 0), Lag.kr(pan1, panlag1), 1),
        Pan4.ar( RLPF.ar(SawDPW.ar(Lag.kr(freq2+frqSpread+frqOffset, frqlag2), 0, Lag.kr(amp2, amplag2)),
			freq: Lag.kr(rlpfrq2, rlpfrqlag2), rq: rlprq2, mul: 1, add: 0), 1, Lag.kr(pan2, panlag2)),
		Pan4.ar(RLPF.ar(SawDPW.ar(Lag.kr(freq3+(2*frqSpread), frqlag3)+frqOffset, 0, Lag.kr(amp3, amplag3)),
			freq: Lag.kr(rlpfrq3, rlpfrqlag3), rq: rlprq3, mul: 1, add: 0), -1, Lag.kr(pan3, panlag3)),
        Pan4.ar(RLPF.ar(SawDPW.ar(Lag.kr(freq4+(3*frqSpread)+frqOffset, frqlag4), 0, Lag.kr(amp4, amplag4)),
			freq: Lag.kr(rlpfrq4, rlpfrqlag4), rq: rlprq4, mul: 1, add: 0), Lag.kr(pan4, panlag4), -1)
    ];

    Out.ar(0, arryPan);
}, metadata:()).add;