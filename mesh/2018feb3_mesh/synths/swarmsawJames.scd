// swarmsaw James, w 4chan Bobert mod
SynthDef(\swarmSawJames, {
    | out=0,
    freq1=50, freq2=50, freq3=50, freq4=50,
    amp1=0, amp2=0, amp3=0, amp4=0,
    rlpfrq1=440, rlpfrq2=440, rlpfrq3=440, rlpfrq4=440,
    rlpfrqlag1 = 0.5, rlpfrqlag2 = 0.5, rlpfrqlag3 = 0.5, rlpfrqlag4 = 0.5,
    rlprq1=1, rlprq2=1, rlprq3=1, rlprq4=1,
    panx1=0, panx2=0, panx3=0, panx4=0,
    pany1=0, pany2=0, pany3=0, pany4=0,
    panxlag1=0.5, panxlag2=0.5, panxlag3=0.5, panxlag4=0.5,
    panylag1=0.5, panylag2=0.5, panylag3=0.5, panylag4=0.5,
    frqlag1=0.5, frqlag2=0.5, frqlag3=0.5, frqlag4=0.5,
    amplag1=0.5, amplag2=0.5, amplag3=0.5, amplag4=0.5,
    frqOffset=50, frqSpread=100 |

    var arryPan = [

        Pan4.ar(
            in: RLPF.ar(
                in: SawDPW.ar(
                    freq: Lag.kr(freq1+frqOffset, frqlag1),
                    iphase: 0,
                    mul: Lag.kr(amp1, amplag1)
                    ),
			    freq: Lag.kr(rlpfrq1, rlpfrqlag1),
                rq: rlprq1,
                mul: 1,
                add: 0
                ),
            xpos: Lag.kr(panx1, panxlag1),
            ypos: Lag.kr(pany1, panylag1),
            level: 1
        ),

        Pan4.ar(
            in: RLPF.ar(
                in: SawDPW.ar(
                    freq: Lag.kr(freq2+frqSpread+frqOffset, frqlag2),
                    iphase: 0,
                    mul: Lag.kr(amp2, amplag2)
                    ),
			    freq: Lag.kr(rlpfrq2, rlpfrqlag2),
                rq: rlprq2,
                mul: 1,
                add: 0
                ),
            xpos: Lag.kr(panx2, panxlag2),
            ypos: Lag.kr(pany2, panylag2),
            level: 1
        ),

        Pan4.ar(
            in: RLPF.ar(
                in: SawDPW.ar(
                    freq: Lag.kr(freq3+(2*frqSpread)+frqOffset, frqlag3),
                    iphase: 0,
                    mul: Lag.kr(amp3, amplag3)
                    ),
                freq: Lag.kr(rlpfrq3, rlpfrqlag3),
                rq: rlprq3,
                mul: 1,
                add: 0
                ),
            xpos: Lag.kr(panx3, panxlag3),
            ypos: Lag.kr(pany3, panylag3),
            level: 1
        ),

        Pan4.ar(
            in: RLPF.ar(
                in: SawDPW.ar(
                    freq: Lag.kr(freq4+(3*frqSpread)+frqOffset, frqlag4),
                    iphase: 0,
                    mul: Lag.kr(amp4, amplag4)
                    ),
                freq: Lag.kr(rlpfrq4, rlpfrqlag4),
                rq: rlprq4,
                mul: 1,
                add: 0
                ),
            xpos: Lag.kr(panx4, panxlag4),
            ypos: Lag.kr(pany4, panylag4),
            level: 1
        )];

    Out.ar(0, arryPan);
}, metadata:(
	\out: Pseq([0],inf),
    \dur: Pmeanrand(1, 5, inf),
    \freq1: Pmeanrand(50, 70, inf),
    \freq2: Pmeanrand(50, 70, inf),
    \freq3: Pmeanrand(50, 70, inf),
    \freq4: Pmeanrand(50, 70, inf),
    \amp1: Pmeanrand(0.01, 0.1, inf),
    \amp2: Pmeanrand(0.01, 0.1, inf),
    \amp3: Pmeanrand(0.01, 0.1, inf),
    \amp4: Pmeanrand(0.01, 0.1, inf),
    \rlpfrq1: Pmeanrand(100, 500, inf),
    \rlpfrq2: Pmeanrand(100, 500, inf),
    \rlpfrq3: Pmeanrand(100, 500, inf),
    \rlpfrq4: Pmeanrand(100, 500, inf),
    \rlpfrqlag1: Pmeanrand(1, 5, inf),
    \rlpfrqlag2: Pmeanrand(1, 5, inf),
    \rlpfrqlag3: Pmeanrand(1, 5, inf),
    \rlpfrqlag4: Pmeanrand(1, 5, inf),
    \rlprq1: Pmeanrand(0.5, 1.5, inf),
    \rlprq2: Pmeanrand(0.5, 1.5, inf),
    \rlprq3: Pmeanrand(0.5, 1.5, inf),
    \rlprq4: Pmeanrand(0.5, 1.5, inf),
    \panx1: Pmeanrand(-1.0, 1.0, inf),
    \panx2: Pmeanrand(-1.0, 1.0, inf),
    \panx3: Pmeanrand(-1.0, 1.0, inf),
    \panx4: Pmeanrand(-1.0, 1.0, inf),
    \pany1: Pmeanrand(-1.0, 1.0, inf),
    \pany2: Pmeanrand(-1.0, 1.0, inf),
    \pany3: Pmeanrand(-1.0, 1.0, inf),
    \pany4: Pmeanrand(-1.0, 1.0, inf),
    \panxlag1: Pmeanrand(1, 5, inf),
    \panxlag2: Pmeanrand(1, 5, inf),
    \panxlag3: Pmeanrand(1, 5, inf),
    \panxlag4: Pmeanrand(1, 5, inf),
    \panylag1: Pmeanrand(1, 5, inf),
    \panylag2: Pmeanrand(1, 5, inf),
    \panylag3: Pmeanrand(1, 5, inf),
    \panylag4: Pmeanrand(1, 5, inf),
    \frqlag1: Pmeanrand(1, 5, inf),
    \frqlag2: Pmeanrand(1, 5, inf),
    \frqlag3: Pmeanrand(1, 5, inf),
    \frqlag4: Pmeanrand(1, 5, inf),
    \amplag1: Pmeanrand(1, 5, inf),
    \amplag2: Pmeanrand(1, 5, inf),
    \amplag3: Pmeanrand(1, 5, inf),
    \amplag4: Pmeanrand(1, 5, inf),
    \frqOffset: Pmeanrand(10, 50, inf),
    \frqSpread: Pmeanrand(5, 25, inf)
)).add
