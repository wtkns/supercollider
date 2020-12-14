(
SynthDef(\gabberkick, {
    var snd;
    snd = SinOsc.ar(Env([1000, 69, 60], [0.015, 0.1], \exp).ar * [-0.1, 0,
0.1].midiratio);
    snd = Mix(snd);
    snd = (snd * \drive.kr(10)).tanh;
    snd = (snd * \drive.kr(10) * 0.5).atan;
    snd = BPeakEQ.ar(snd, XLine.kr(2000, 100, 0.3), 2.0, 8);
    snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(4).range(0.0, 0.001));
    snd = RLPF.ar(snd, 8000, 0.7);
    snd = snd * Env([0, 1, 0.7, 0.7, 0], [0.001, 0.01, 0.3, 0.02]).ar(2);
    snd = (snd * 0.6).clip(-1, 1);
    Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)


Synth(\gabberkick, [amp: 0.6, drive: 10])

(
var length;
length = 30;

Pbind(*[
    instrument: \gabberkick,
    amp: 0.6,
    dur: 0.3,
    pan: Pwhite(-1.0, 1.0, inf),
    drive: Pseq(Array.series(length, 0, 1 / length).linexp(0, 1, 1, 10).mirror, inf)
]).play;
)


(
SynthDef(\hoover, {
    var snd, bw, freq;
    freq = \freq.kr(440).varlag(0.05, warp: \exp);
    freq = freq * Env([-5, 6, 0], [0.1, 1.7], [\lin, -4]).kr.midiratio;
    bw = 1.035;
    snd = { DelayN.ar(Saw.ar(freq * ExpRand(bw, 1 / bw)) + Saw.ar(freq * 0.5
* ExpRand(bw, 1 / bw)), 0.01, Rand(0, 0.01)) }!20;
    snd = Splay.ar(snd);
    snd = (snd * 3).atan;
    snd = snd * Env.asr(0.01, 1.0, 0.01).kr(2, \gate.kr(1));
    snd = snd * \amp.kr(0.1);
    Out.ar(\out.kr(0), snd);
}).add;
)


(
Pbind(
    \instrument, \hoover,
    \midinote, 74,
    \dur, 3.0
).play;
)
