/*
30 - Concrète, Audio Files, Live Audio DSP
Music Concrète
Buffers

30.1. Loading Audio into and Playing From a Buffer
*/
b = Buffer.read(s, "sounds/africa2");

c = Buffer.read(s, "sounds/africa1", numFrames: 44100); // one second

// check data: 
[b.bufnum, b.numChannels, b.path, b.numFrames].postln;

[c.bufnum, c.numChannels, c.path, c.numFrames].postln;

{PlayBuf.ar(1, 0)}.play(s); // Your buffer number may differ

{PlayBuf.ar(1, 1)}.play(s);
/*

30.2. Loading Audio into a Buffer from Live Audio Source
*/
d = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer

{RecordBuf.ar(In.ar(2), d.bufnum, loop: 0)}.play;
d
{PlayBuf.ar(1, d.bufnum)}.play(s);
/*

30.3. Playback with Mouse
*/
b.free; b = Buffer.read(s,"sounds/africa2", 0, 4*44100);

{BufRd.ar(1, b.bufnum, K2A.ar(MouseX.kr(0, 4*44100)))}.play
/*

30.4. LinLin, LFSaw for Sweeping Through Audio File
*/

// Same thing:

{SinOsc.ar(LinLin.kr(SinOsc.kr(5), -1, 1, 700, 1000))}.play

{SinOsc.ar(SinOsc.kr(5, mul: 150, add: 850))}.play

// Will sweep through 66150 110250, or 1.5" to 2.5" of audio file

LinLin.ar(LFSaw.ar(1), -1, 1, 1.5, 2.5)*44100

/*


30.5. Looping a Section of a File
*/

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1;
// Use these lines for proportional lengths
// var bufNum = 0, srate = 44100, start = 0.21, end = 0.74, 
// rate = 1, duration, total;
// total = BufFrames.kr(bufNum)/44100;
// end = end*total; start = start*total;
duration = abs(end - start); 
BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 
}.play
)
/*


30.6. Looper 
*/

(
{
var bufNum = 0, srate = 44100, start = 0.21, end = 0.74, 
 rate = 1, totalDur = 20, pan = 0;
var out, duration, total;
start = [0.3, 0.2]; end = [0.2, 0.3]; 
total = BufFrames.kr(bufNum)/44100;
end = end*total; start = start*total;
duration = abs(end - start); 
BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration));
}.play
)

/*
 forward and backward loops of the same material as shown above (start = [0.2, 0.3]; end = 
[0.3, 0.2];)

30.7. Modulating Audio Buffers
*/

// FM Modulation

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
duration = abs(end - start); 
// or
// end = [2.3, 3.5];
signal = BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 

SinOsc.ar(LFNoise1.kr([0.4, 0.43], mul: 200, add: 200))*signal;
// or
// SinOsc.ar(LFNoise0.kr([12, 15], mul: 300, add: 600))*signal;
// or 
// SinOsc.ar(LFNoise1.kr([0.4, 0.43], mul: 500, add: 1000))*signal; 

}.play(s)
)


// Pulsing in and out

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1;
var pulse;
pulse = [6, 10];
duration = abs(end - start); 
BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.3, 0.01), timeScale: duration/pulse,
 gate: Impulse.kr(pulse/duration)); 
}.play(s)
)

// Filtered

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
duration = abs(end - start); 
signal = BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 
RLPF.ar(signal, LFNoise1.kr([12, 5], mul: 700, add: 1000), rq: 0.05)*0.2;
}.play(s)
)

// Modulating one with another, dry in left, dry in right, modulated center
// Listen for a while for full effect

(
{
var bufNum = 0, srate = 44100, start = 0, end = 3, duration, rate = 1, signal;
end = [2.5, 2.9];
duration = abs(end - start); 
signal = BufRd.ar(1, bufNum, // Buffer 0
 LinLin.ar(
 LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
 )*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
 gate: Impulse.kr(1/duration)); 
(signal*0.1) + (signal.at(0) * signal.at(1)) 
}.play(s)
)
/*
*/
