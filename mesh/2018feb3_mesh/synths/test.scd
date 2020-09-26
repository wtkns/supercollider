// test synth
SynthDef(\test, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, t_gate = 1 |
    var audio = Blip.ar(freq, nharms, amp);
    var env = Linen.kr(t_gate);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}, metadata:()).add;