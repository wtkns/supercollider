(
SynthDef(\berlinb, { arg out=0, freq = 80, amp = 0.01, pan=0, gate=1;
    var synth, env;
    env = Decay2.kr(gate, 0.05, 8, 0.0003);
    synth = RLPF.ar(
        LFPulse.ar(freq, 0, SinOsc.kr(0.12, [0, 0.5pi], 0.48, 0.5)),
        freq * SinOsc.kr(0.21, 0, 18, 20),
        0.07
    );
    #a, b = synth*env;
    DetectSilence.ar(a, 0.1, doneAction: Done.freeSelf);
    Out.ar(out, amp * Mix.ar(PanAz.ar(4, [a, b], [pan, pan+1])));
}).add;
)

(
f = Pbind(
    \degree, Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf),
    \dur, 0.5, \octave, 3, \instrument, \berlinb
).play;
)

(
f.stream = Pbind(
    \degree, Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf),
    \dur, 0.5, \octave, [2, 1],
    \instrument, \berlinb,
    \pan, Pfunc({1.0.rand2})
).asStream;
)

s.boot