// trigtest Jeff
SynthDef(\trigTest, {
    |out, t_trig=1, dur=1.0, freq=440|
    Out.ar(out,
        Pan2.ar(
            SinOsc.ar(
                freq, 0,
                Decay2.kr(t_trig, 0.005, dur)
        ), 0));
}, metadata:()).add;
