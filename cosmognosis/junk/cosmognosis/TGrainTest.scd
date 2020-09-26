// Boot the server
s.boot;

// Load an audio file
s.sendMsg(\b_allocRead, 10, "/Users/jameswatkins/Desktop/ferry.aiff");

// Now define the granular synth
(
{
var b = 10, trate, dur;
trate = MouseY.kr(2,120,1);
dur = 1.2 / trate;
TGrains.ar(2, Impulse.ar(trate), b,
(1.2 ** WhiteNoise.kr(3).round(1)),
MouseX.kr(0,BufDur.kr(b)),
dur,
WhiteNoise.kr(0.6), 0.1);
}.play;
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(4, clk, b, 1, pos, dur, pan, 0.1);
}.scope(4, zoom: 4);
)




b.free

s.boot;
b = Buffer.read(s, "/Users/jameswatkins/Desktop/samp/summerstart1.wav");
b = Buffer.read(s, "/Users/jameswatkins/Desktop/samp/pianoloop.wav");

b.plot;
(
{
    var trate, dur, rate;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
    TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);
}.scope(zoom: 4);
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)

// 4 channels
(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(4, clk, b, 1, pos, dur, pan, 0.1);
}.scope(4, zoom: 4);
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 4 / trate;
    clk = Dust.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)



(
{
    var trate, dur, clk, pos, pan;
    trate = LinExp.kr(LFTri.kr(MouseY.kr(0.1,2,1)),-1,1,8,120);
    dur = 12 / trate;
    clk = Impulse.ar(trate);
    pos = MouseX.kr(0,BufDur.kr(b));
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)


(
{
    var trate, dur, clk, pos, pan;
    trate = 12;
    dur = MouseY.kr(0.2,24,1) / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)

(
{
    var trate, dur, clk, pos, pan;
    trate = 100;
    dur = 8 / trate;
    clk = Impulse.kr(trate);
    pos = Integrator.kr(BrownNoise.kr(0.001));
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.scope(zoom: 4);
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(1,400,1);
    dur = 8 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b));
    pan = WhiteNoise.kr(0.8);
    TGrains.ar(2, clk, b, 2 ** WhiteNoise.kr(2), pos, dur, pan, 0.1);
}.scope(zoom: 4);
)


(
{
    var trate, dur;
    trate = MouseY.kr(2,120,1);
    dur = 1.2 / trate;
    TGrains.ar(2, Impulse.ar(trate), b, (1.2 ** WhiteNoise.kr(3).round(1)), MouseX.kr(0,BufDur.kr(b)), dur, WhiteNoise.kr(0.6), 0.1);
}.scope(zoom: 4);
)


// demand ugens as inputs
(
{
    var trate, dur, z, d;
    trate = MouseX.kr(1, 100, 1);
    d = { Dwhite(0.1, 0.2, 1) };
    z = {
        Drand([Dgeom(0.1, 1 + d.value, Diwhite(20, 40)), Dgeom(1, 1 - d.value, Diwhite(20, 40))])
    };
    TGrains.ar(2,
        Impulse.ar(trate),
        bufnum: 10,
        rate: Dseq([1, 1, z.value, 0.5, 0.5, 0.2, 0.1, 0.1, 0.1, 0.1], inf) * 2 + 1,
        centerPos: Dseq(z.dup(8), inf),
        dur: Dseq([1, d.value, 1, z.value, 0.5, 0.5, 0.1, z.value] * 2, inf) / trate,
        pan: Dseq([1, 1, 1, 0.5, 0.2, 0.1, 0, 0, 0], inf) * 2 - 1,
        amp: Dseq([1, 0, z.value, 0, 2, 1.0, 1, 0.1, 0.1], inf)
    );
}.scope(zoom: 4);
)

b.free