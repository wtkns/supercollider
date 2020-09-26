/*
Other External Controls
Practice

10.10. Practice sci-fi computer 
*/

(
{
PMOsc.ar(
 LFNoise1.kr(
 MouseX.kr([1, 1], 12), 
 mul: MouseY.kr(10, 1000), 
 add: 1000),
 LFNoise0.kr(
 MouseX.kr([1, 1], 12), 
 mul: MouseY.kr(30, 1000), 
 add: 1000),
 MouseY.kr(0.1, 5.0),
 mul: 0.3)
}.play
)

(
// exponential random
{Mix.fill(12, // number of oscillators
 {arg i;
 Pan2.ar(SinOsc.ar(SinOsc.ar(
 freq: MouseX.kr(rrand(0.1, 5.0), rrand(3.0, 20.0)), // speed of vibrato 
 mul: MouseY.kr(10, 50), // width of vibrato
 add: exprand(200, 5000)), // freq of oscillators 
 mul: max(0, LFNoise0.kr(MouseX.kr(rrand(1, 6), rrand(6, 1))))), 1.0.rand2)
})*0.03
}.play
)

(
// linear random waves
{Mix.fill(12, // number of oscillators
 {arg i;
 Pan2.ar(SinOsc.ar(SinOsc.ar(
 freq: MouseX.kr(rrand(0.1, 5.0), rrand(3.0, 20.0)), // speed of vibrato 
 mul: MouseY.kr(10, 50), // width of vibrato
 add: rrand(200, 5000)), // freq of oscillators 
 mul: max(0, LFNoise0.kr(MouseX.kr(rrand(1, 6), rrand(6, 1))))), 1.0.rand2)
})*0.03
}.play
)

/*
Practice

11.4. Harmonic swimming from the examples folder, variable decay bells
*/
(
// harmonic swimming
play({
 var fundamental, partials, out, offset;
 fundamental = 50; // fundamental frequency
 partials = 20; // number of partials per channel
 out = 0.0; // start of oscil daisy chain
 offset = Line.kr(0, -0.02, 60); // causes sound to separate and fade
 partials.do({ arg i;
 out = FSinOsc.ar(
 fundamental * (i+1), // freq of partial
 0,
 max(0, // clip negative amplitudes to zero
 LFNoise1.kr(
 6 + [4.0.rand2, 4.0.rand2], // amplitude rate 
 0.02, // amplitude scale
 offset // amplitude offset
 )
 ), 
 out
 )
 });
 out
})
)


// Decay rates linked to frequency using a variable. (Low freq; long decay. High freq; 
// short decay.)

(
{
Mix.fill(15,
{
var freq; 
freq = exprand(100, 3000);
 Pan2.ar(
 SinOsc.ar(
 freq * LFNoise1.kr(1/6, 0.4, 1),
 mul: EnvGen.kr(
 Env.perc(0, (freq**(-0.7))*100), Dust.kr(1/5))
 ), LFNoise1.kr(1/8)
 )
})*0.3
}.play
)

 
(
{ //SinOsc (sci-fi)
var lfo;
lfo = SinOsc.ar(freq: 10, mul: 100, add: 400); 
SinOsc.ar(lfo, mul: 0.5)
}.play
)



(
{ //Pulse (phone ring)
var lfo;
lfo = LFPulse.ar(freq: 15, mul: 200, add: 1000); 
SinOsc.ar(lfo, mul: 0.5)
}.play
)



(
{ //Saw
var lfo;
lfo = LFSaw.ar(freq: 2, mul: -100, add: 600); 
SinOsc.ar(lfo, mul: 0.5) 
}.play
)

(
{ //Noise (computer)
var lfo;
lfo = LFNoise0.ar(freq: [28, 27], mul: 1000, add: 2000); 


SinOsc.ar(lfo, mul: 0.5)
}.play
)

(
{ //Noise (manic birds)
var lfo;
lfo = LFNoise1.ar(freq: [28, 27], mul: 400, add: 2000); 
SinOsc.ar(lfo, mul: 0.5)
}.play
)

/*
The Experimental Process
Practice, Bells
*/

12.15. Bells 

(
//frequency linked to envelope length
 //high notes short, low long
{
var frequency;
Mix.ar(
 {
 frequency = rrand(100, 5000);
 Pan2.ar(
 SinOsc.ar(
 frequency,
 mul: EnvGen.kr(
 Env.perc(0.001, 500/frequency), 
 Dust.kr(0.05),
 0.2
 )
 ), 
 rrand(-1.0, 1.0)
 ) 
 }.dup(100)
)
}.play
)


(
//frequency linked to decay length
 //basically the same code but more compact
 //low notes short, high long
{var frequency;
Mix.ar({
 frequency = rrand(100, 3000);
 Pan2.ar(SinOsc.ar(frequency,
 mul: EnvGen.kr(Env.perc(0.001, frequency/1000), 
 Dust.kr(0.05), 0.2)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

(//high notes short, low long
{var frequency;
Mix.ar({
 frequency = rrand(100, 3000);
 Pan2.ar(SinOsc.ar(frequency,
 mul: EnvGen.kr(Env.perc(200/frequency, 0.0001), 
 Dust.kr(0.05), 0.2)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

(//low notes short, high long
{var frequency;
Mix.ar({
 frequency = rrand(100, 1000);
 Pan2.ar(SinOsc.ar(frequency,
 mul: EnvGen.kr(Env.perc(frequency/500, 0001), 
 Dust.kr(0.05), 0.05)), rrand(-1.0, 1.0)) }.dup(100))}.play
)

/*

Practice, Free-Just, and Equal-Tempered Tuning 
*/

13.9. Tuning 

( //double click to select the entire example
SynthDef("PureTone",
{arg justFreq = 440, equalFreq = 440;
Out.ar(0, SinOsc.ar([justFreq, equalFreq], mul: 0.4)
 *EnvGen.kr(Env.perc(0, 1), doneAction:2));
}).load(s);

Task({
var jfreq = 440, efreq = 69, next = 6, equalInt, justInt;
equalInt = [-10, -8, -7, -5, -3, -1, 
 0, 2, 4, 5, 7, 9, 11];
justInt = [9/16, 5/8, 2/3, 3/4, 5/6, 15/16, 1/1, 
 9/8, 5/4, 4/3, 3/2, 5/3, 15/8];
 {
 [equalInt.at(next), justInt.at(next).round(0.01)].post;
 Synth("PureTone", [\justFreq, jfreq.round(0.01), 
 \equalFreq, efreq.midicps.round(0.01)].postln);
 next = 13.rand;
 jfreq = jfreq*justInt.at(next);
 efreq = efreq + equalInt.at(next);
 if(jfreq < 100, {jfreq = jfreq*2; efreq = efreq + 12});
 if(jfreq > 1000, {jfreq = jfreq/2; efreq = efreq - 12});
 [0.125, 0.125, 0.124, 0.25, 0.5, 1].choose.wait
 }.loop;
}).play(SystemClock);
)

// Same example with just a scale.

( //double click to select the entire example
SynthDef("PureTone",
{arg justFreq = 440, equalFreq = 440;
Out.ar(0, SinOsc.ar([justFreq, equalFreq], mul: 0.4)
 *EnvGen.kr(Env.perc(0, 1), doneAction:2));
}).load(s);

Task({
var jfreq = 440, efreq = 69, next = 0, equalInt, justInt;
equalInt = [-12, 2, 2, 1, 2, 2, 3];
justInt = [1/2, 9/8, 9/8, 16/15, 9/8, 9/8, 6/5];
 {
 [equalInt.wrapAt(next), justInt.wrapAt(next).round(0.01)].post;
 Synth("PureTone", [\justFreq, jfreq.round(0.01), 
 \equalFreq, efreq.midicps.round(0.01)].postln);
 next = next + 1;
 jfreq = jfreq*justInt.wrapAt(next);
 efreq = efreq + equalInt.wrapAt(next);
 0.25.wait
 }.loop;
}).play(SystemClock);
)

// Free just intonation only



/*
Bells
 
14.24. random frequencies (Pan2, Mix, EnvGen, Env, fill)
*/

( // Let it run for a while, the strikes are random
{
var trigger, partials = 12;
trigger = Dust.kr(3/7);
Pan2.ar(
 Mix.ar(
 {
 SinOsc.ar(rrand(50.0, 4000)) * 
 EnvGen.kr(
 Env.perc(0, rrand(0.2, 3.0)), 
 trigger,
 1.0.rand
 )
 }.dup(partials)
 )/partials, 
 1.0.rand2
)
}.play
)

/*
 CPU Usage
Practice: flashing sines, gaggle of sines, diverging, converging, decaying gongs

14.25. flashing (MouseButton, Mix, Array.fill, Pan2, EnvGen, Env LFNoise1)
*/

(
{
var trigger, fund;
trigger = Dust.kr(3/7);
fund = rrand(100, 400);
Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 Pan2.ar(
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0), 
 trigger, 1/partial
 ) * max(0, LFNoise1.kr(rrand(5.0, 12.0))), 1.0.rand2)
 })
 )*0.5 //overall volume
}.play
)

//Several of the above mixed down

(
{
var trigger, fund, flashInst;
flashInst = Array.fill(5,
{
 trigger = Dust.kr(3/7);
 fund = rrand(100, 400);
 Pan2.ar(
 Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.adsr(0, 0, 1.0, 5.0), 
 trigger, 1/partial
 ) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
 })
 )*0.2,
 1.0.rand2)
});
Mix.ar(flashInst)*0.6
}.play
)

// Gaggle of sines varations

(
{
 var harmonics = 16, fund = 50, speeds;
 speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/5;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(speeds.wrapAt(count)))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

(
{
 var harmonics = 16, fund, speeds;
 speeds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]/20;
 fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(speeds.choose))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

// Use mouse to change fundamental 

(
{
 var harmonics = 16, fund;
 fund = (MouseX.kr(0, 36).round(7) + 24).midicps;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1),
 mul: max(0, FSinOsc.kr(rrand(1, 1/3), mul: 20).softclip)),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

(
{
 var harmonics = 16;
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 exprand(100, 2000),
 mul: max(0, FSinOsc.kr(rrand(1/3, 1/6))*rrand(0.1, 0.9))),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)



// Dissipating and converging gongs illustrates how a patch can be built
// from duplicating one idea; classic additive synthesis. It also shows
// how additive synthesis can be used to control each harmonic.
// Listen in stereo to hear the harmonics diverge.

(

{
var dur = 6, base, aenv, fenv, out, trig;
base = Rand(40, 100);
trig = SinOsc.ar(1/10);
out = Mix.fill(15,{
 var thisDur;
 thisDur = dur * rrand(0.5, 1.0);
 aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
 fenv = EnvGen.kr(Env.new([0, 0, 1, 0], [0.25*thisDur, 0.75*thisDur, 0]), trig);
 Pan2.ar(SinOsc.ar( Rand(base, base * 12) * 
 LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
 mul: aenv // amp
 ), ([1, -1].choose) * fenv)
}) * 0.05;
out
}.play(s);


{
var dur = 6, base, aenv, fenv, out, trig, detune;
base = Rand(40, 60);
detune = 0.1; // increase this number to detune the second bell
trig = SinOsc.ar(1/10, pi);
out = Mix.fill(15,
{ arg count;
 var thisDur;
 thisDur = dur * rrand(0.5, 1.0);
 aenv = EnvGen.kr(Env.perc(0, thisDur), trig);
 fenv = EnvGen.kr(Env.new([1, 1, 0, 1], [0.05*thisDur, 0.95*thisDur, 0]), trig);
 Pan2.ar(SinOsc.ar( base*(count+1+ detune.rand) * 
 LFNoise1.kr(10, mul: 0.02 * fenv, add: 1), // freq
 mul: aenv // amp
 ), ([1, -1].choose) * fenv)
}) * 0.05;
out
}.play(s);
)

// Decaying bell

(
{
var aenv, fenv, out, trig, dur, base;
dur = rrand(1.0, 6.0);
base = exprand(100, 1000);
trig = Impulse.kr(1/6);
out = Mix.ar(
 Array.fill(15,{
 arg count;
 var thisDur;
 thisDur = dur * rrand(0.5, 1.0);
 aenv = EnvGen.kr(
 Env.new([0, 1, 0.4, 1, 0], [0, 0.5, 0.5, 0]), trig, 
 timeScale: thisDur);
 fenv = EnvGen.kr(
 Env.new([0, 0, 0.5, 0.5, 0], [0.25, 0.5, 0.25, 0]), 
 trig, timeScale: thisDur);
 Pan2.ar(SinOsc.ar( Rand(base, base * 12) * 
 LFNoise1.kr(10, mul: 0.1 * fenv, add: 1), // freq
 mul: aenv // amp
 ), ([1, -1].choose) * fenv)
 })
) * EnvGen.kr(Env.linen(0, dur, 0), Impulse.kr(6), timeScale: dur, 
 levelScale: 0.05, doneAction: 2);
out*0.3;
}.play;
)


/*
Chimes

15.7. chime burst (Env, perc, PinkNoise, EnvGen, Spawn, scope)
*/

(
{
var burstEnv, att = 0, burstLength = 0.0001, signal; //Variables
burstEnv = Env.perc(0, burstLength); //envelope times
signal = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1))); //Noise burst
signal;
}.play
)

/*

15.8. chimes (normalizeSum, round, Klank, EnvGen, MouseY)
*/

(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;

freqSpecs = `[
 {rrand(100, 1200)}.dup(totalHarm), //freq array
 {rrand(0.3, 1.0)}.dup(totalHarm).normalizeSum.round(0.01), //amp array
 {rrand(2.0, 4.0)}.dup(totalHarm)]; //decay rate array

burstEnv = Env.perc(0, burstLength); //envelope times
burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1))); //Noise burst

Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.8)
}.scope(1)
)

/*

15.9. Tuned chime (or pluck?)
*/

(
{
var chime, freqSpecs, burst, totalHarm = 10;
var burstEnv, att = 0, burstLength = 0.0001;

freqSpecs = `[
 {rrand(1, 30)*100}.dup(totalHarm), 
 {rrand(0.1, 0.9)}.dup(totalHarm).normalizeSum,
 {rrand(1.0, 3.0)}.dup(totalHarm)];
burstEnv = Env.perc(0, burstLength);
burst = PinkNoise.ar(EnvGen.kr(burstEnv, gate: Impulse.kr(1)));

Klank.ar(freqSpecs, burst)*MouseX.kr(0.1, 0.8)
}.scope(1)
)

/*
Practice, Chimes and Cavern

15.17. Subtracitive Synthesis (Klank, Decay, Dust, PinkNoise, RLPF, LFSaw)
*/

(
{
var totalInst, totalPartials, baseFreq, ampControl, chimes, cavern;
totalInst = 5; //Total number of chimes
totalPartials = 12; //Number of partials in each chime
baseFreq = rrand(200, 1000); //Base frequency for chimes

chimes = 
 Mix.ar(
 {
 Pan2.ar(
 Klank.ar(`[
 {baseFreq*rrand(1.0, 12.0)}.dup(totalPartials),
 Array.rand(totalPartials, 0.3, 0.9),
 Array.rand(totalPartials, 0.5, 6.0)], 
 Decay.ar(
 Dust.ar(0.2, 0.02), //Times per second, amp
 0.001, //decay rate
 PinkNoise.ar //Noise
 )), 1.0.rand2) //Pan position
 }.dup(totalInst)
 );

cavern = 
 Mix.ar(
 {
 var base;
 base = exprand(50, 500);
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( [rrand(0.03, 0.1), rrand(0.03, 0.1)])
 )*max(0, LFNoise1.kr(3/rrand(5, 20), mul: 0.005))
 }.dup(5));
cavern + chimes
}.play
)

[New]

// Cavern variation
(
{
var totalPartials = 12;

 Mix.ar(
 {
 var base;
 base = exprand(50, 1000);
 Pan2.ar(
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( rrand(0.03, 0.1))
 )*max(0, LFNoise1.kr(6, mul: 0.005)),
 LFNoise0.kr(1))
 }.dup(5));
 
}.play
)

// Rotating wheels

{
var totalPartials = 4;

 Mix.ar(
 {
 var base;
 base = exprand(50, 10000);
 Pan2.ar(
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( rrand(0.03, 0.1))
 )*max(0, SinOsc.kr(6/rrand(1, 10), mul: 0.005)),
 LFNoise1.kr(1))
 }.dup(8));
 
}.play


// This one floats in and out, so if there is no
// sound let it run a while.
// Execute it four or five times to get a bunch
// of them going. 

{
var totalPartials = 3;

 Mix.ar(
 {
 var base;
 base = exprand(50, 100);
 Pan2.ar(
 Klank.ar(
 `[ //frequency, amplitudes, and decays
 {rrand(1, 24) * base * 
 rrand(1.0, 1.1)}.dup(totalPartials),
 Array.rand(10, 1.0, 5.0).normalizeSum
 ],
 GrayNoise.ar( rrand(0.03, 0.1))
 )*max(0, SinOsc.kr(10/rrand(1, 5), mul: 0.005)),
 LFNoise1.kr(1))
 }.dup(8)) * max(0, LFNoise1.kr(1/10));
 
}.play



/*

16.11. sequencer variations
*/

(
var pitchArray; 
pitchArray = [60, 62, 64, 65, 67, 69, 71, 72]; 
pitchArray = [ //pick one of the following
 (pitchArray + rrand(1, 12)).midicps, //transpose
 pitchArray.reverse.midicps, //reverse
 pitchArray.scramble.midicps, //scramble
 Array.rand(12, 36, 72).midicps, //random midi
 Array.rand(12, 100, 1200) //random frequency
 ].choose;
{
 SinOsc.ar(
 Select.kr(
 Stepper.kr(Impulse.kr(7), pitchArray.size-1),
 pitchArray),
 mul: 0.5)
}.play
)

// [New] a more interesting example using PM

(
{
var freq, freqArray, ratioArray, indexArray, 
 env, rate = 5, trig;
trig = Impulse.kr(rate);
freqArray = [48, 50, 52, 53, 55, 57, 59, 60,
 62, 64, 65, 67, 69, 71, 72].scramble.midicps;
ratioArray = {rrand(1.0, 3.0)}.dup(20);
indexArray = {rrand(1.0, 4.0)}.dup(20);
env = EnvGen.kr(Env.perc(0, 1/rate), gate: trig);
freq = Select.kr(Stepper.kr(trig, freqArray.size-1), freqArray);
PMOsc.ar(
 freq,
 freq*Select.kr(Stepper.kr(trig, ratioArray.size-1), ratioArray),
 Select.kr(Stepper.kr(trig, indexArray.size-1), indexArray)
 + env*4, 
 mul: env
)}.play
)


/*
Sample and Hold

16.12. Latch 
*/

(
{
SinOsc.ar(
 Latch.kr(
 LFSaw.kr(MouseX.kr(0.1, 20), 0, 500, 600), 
 Impulse.kr(10)),
 mul: 0.3 //Volume of Blip
)
}.scope(1)
)

(
{
SinOsc.ar(
 Latch.kr(
 LFSaw.kr(Line.kr(0.1, 20, 60), 0, 500, 600), 
 Impulse.kr(10)),
 mul: 0.3 //Volume of Blip
)
}.scope(1)
)

/*
 
16.13. Latch 
*/

(
{ // controlling modulator and carrier freq 
f = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 1000, 1100), 
 Impulse.kr(10));
PMOsc.ar(f, f*2, 12, mul: 0.3)
}.scope(1)
)

(
{ // controlling index
i = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 5, 5), 
 Impulse.kr(10));
PMOsc.ar(300, 356, i, mul: 0.3)
}.scope(1)
)

(
{ // controlling ratio
r = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 2.0, 3.0), 
 Impulse.kr(10));
PMOsc.ar(300, 300*r, 12, mul: 0.3)
}.scope(1)
)

(
{ // and of course, scaled to control all three
c = Latch.kr(
 LFSaw.kr(MouseX.kr(1.1, 30), 0, 0.5, 0.5), 
 Impulse.kr(10));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

/*

16.14. Latch sample and speed ratio (Blip, Latch, LFSaw, Impulse, mul)
*/
 
(
{ 
var rate, speed, ratio;
rate = MouseX.kr(1, 24); 
ratio = 1.61803399;
c = Latch.kr(
 LFSaw.kr(rate*ratio, 0, 0.5, 0.5), 
 Impulse.kr(rate));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

(
{ 
var rate, speed, ratio;
rate = MouseX.kr(1, 24); 
ratio = SinOsc.ar(2/7, mul: 0.2, add: 1.75);
c = Latch.kr(
 LFSaw.kr(rate*ratio, 0, 0.5, 0.5), 
 Impulse.kr(rate));
f = c*1000+200;
o = PMOsc.ar(f, f*(c*3+4), c*5+6, mul: 0.3);
[o, CombL.ar(o, 2, 2)]
}.scope(1)
)

/*

16.15. Complex Wave as Sample Source (Mix, SinOsc, Blip, Latch, Mix, Impulse)
*/

{Mix.ar(SinOsc.ar([100, 200, 300, 550], mul: 0.1))}.scope(1)

(
//Used in a sample and hold
{
f = Latch.kr(
 Mix.ar(SinOsc.ar([100, 200, 300, 550], mul: 100, add: 110)), 
 Impulse.kr(7));
e = EnvGen.kr(Env.perc(0, 0.2), Impulse.kr(7));
PMOsc.ar(f, f*1.25, e*5, mul: e*0.3)
}.play
)

/*
Practice S&H FM

16.16. Practice, Sample and Hold, FM
*/

(
{var freq, latchrate, index, ratio, env, rate;
rate = 9;
latchrate = rate*1.61803399;
// latchrate = rate*LFNoise1.kr(1/7, mul: 0.03, add: 1.6);
// latchrate = rate*LFNoise0.kr(1/3, mul: 0.03, add: 1.6);

index = Latch.kr(
 LFSaw.kr(latchrate, mul: 4, add: 8),
 Impulse.kr(rate)
 );
freq = Latch.kr(
 LFSaw.kr(latchrate, mul: 36, add: 60),
 Impulse.kr(rate)
 ).round(1).midicps;
// freq = 200; //uncomment this line to hear just the index

ratio = 2.01; 
// ratio = LFNoise1.kr(1, mul: 2.3, add: 3.0);
// ratio = LFNoise0.kr(1, mul: 2.3, add: 3.0);
// ratio = LFNoise1.kr(1/5, mul: 2.0, add: 5.0);

env = EnvGen.kr(Env.perc(0, 2/rate), gate: Impulse.kr(rate));

PMOsc.ar([freq, freq * 1.5],
 [freq*ratio, freq*1.5*ratio], 
 index, 
 mul: env*0.5
)}.play
)

// Variation

(
{var freq, latchrate, index, ratio, env, rate;
rate = 9;
latchrate = rate*LFNoise0.kr(1/10, mul: 0.03, add: 1.6);
index = Latch.kr(
 LFSaw.kr(latchrate, mul: 5, add: 6),
 Impulse.kr(rate)
 );
freq = Latch.kr(
 LFSaw.kr(latchrate, 
 mul: max(0, LFNoise1.kr(1/5, 24, 10)), 
 add: LFNoise0.kr(1/7, 12, 60)),
 Impulse.kr(rate)
 ).round(1).midicps;
ratio = LFNoise1.kr(1/10, mul: 2.0, add: 5.0);

env = EnvGen.kr(Env.perc(0, LFNoise0.kr(rate, 1, 1.5)/rate), Impulse.kr(rate), 
LFNoise1.kr([5, 5], 2, 1).max(0).min(0.8));
PMOsc.ar(
 [freq, freq * 1.5],
 freq*ratio,
 index,
 mul: env //overall volume
)}.play
)


// Crotale
// Run this code first to define the instrument, 
// then execute the "task" below as many times
// as you want.

(
SynthDef("crotale", {
arg param = #[500, 3, 2, 0, 6, 5, 0, 0.9]; 
var factor, env, out, freq, index, dur;
var bus, ratioa, ratiob, attack, decay, panCont;
freq = param.at(0); index = param.at(1); dur = param.at(2);
bus = param.at(3); ratioa = param.at(4); ratiob = param.at(5);
attack = param.at(6); decay = param.at(7);

env = Env.perc(attack, decay);
factor = gcd(ratioa, ratiob);
ratioa = div(ratioa, factor); 
ratiob = div(ratiob, factor);

panCont = (EnvGen.kr(env, timeScale: dur*1.1, 
 levelBias: -1, levelScale: 2))
 * (IRand(0, 1) * 2 - 1); // 0*2-1 = -1, 1*2-1 = 1

out = PMOsc.ar(
 ratioa*freq, //or try ratioa*freqCont,
 ratiob*freq, //or try ratioa*freqCont,
 pmindex: EnvGen.kr(env, timeScale: dur, 
 levelBias: 1, levelScale: index), 
 mul: EnvGen.kr(env, timeScale: dur, levelScale: 0.3));

out = Pan2.ar(out, panCont);

out = out * EnvGen.kr(env, timeScale: 1.3*dur, 
 levelScale: Rand(0.1, 0.5), doneAction:2); 
Out.ar(0, out); //Out.ar(bus, out);

}).play;
)

// Define the instrument by running the code
// above, then run this task to actually play 
// the instrument. 

(
r = Task({
 var freq, indexDepth, indexRange, synthIndex, dur, repeat;
 var next, count, countDown, offset, ratioa, ratiob, envs, env;
 var range = 60, outBus = 0;
 count = 0; countDown = 0; offset = 0;
 envs = [[0, 0.9], [0.01, 0.9], [0.1, 0.8], [0.8, 0.01]];
 repeat = Array.fill(10, 
 {[rrand(range, range+24).round(1).midicps, 3, 
 2.1 - exprand(0.1, 2.0), 0, 1, 1, 0, 0.9]});
 next = Array.fill(10, {[3, 0.75, 0.5, 0.25, 0.125].choose});
 freq = rrand(range, range*2); // these two are just starting points
 indexDepth = 1;
 
 inf.do({
 if(countDown <= 0,
 {
 env = envs.choose;
 next.put(count%10, [3, 0.5, 0.25, 0.125, 0.125].choose); 
 repeat.put(count%10, [
 rrand(range, range + 24).round(1).midicps, 
 rrand(0.1, 12.0),
 2.1 - exprand(0.1, 2.0), outBus, rrand(1, 12), 
 rrand(1, 12), env.at(0), env.at(1)]);
 });
 
 Synth("crotale").setn(\param, repeat.wrapAt(count));
 next.wrapAt(count).wait; 
 if((count > 10).and(countDown <= 0), 
 {offset = countDown = [0, 3.rand, 6.rand].choose; 
 count = count - offset});
 count = count + 1;
 countDown = countDown - 1;
 });
}).play(SystemClock);
)

/*
Practice: Karplus-Strong Patch

17.16. Practice: K S pluck (EnvGen, PinkNoise, LFNoise1, Out, DetectSilence)
*/

//Load this definition
(
SynthDef.new("KSpluck3", 
 { //Beginning of Ugen function
 arg midiPitch, art;
 var burstEnv, att = 0, dec = 0.01, legalPitches; //Variable declarations
 var out, delayTime;
 delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec)); 
 out = PinkNoise.ar([burstEnv, burstEnv]); //Noise burst
 out = CombL.ar(out, delayTime, delayTime, 
 art, add: out); //Echo chamber
 out = RLPF.ar(out, LFNoise1.kr(2, 2000, 2100), 0.1); //Filter
 DetectSilence.ar(out, doneAction:2);
 Out.ar(0, out*0.8)
 }
).play;
)


//Then run this routine

(
r = Task({
 {Synth("KSpluck3",
 [
 \midiPitch, [0, 2, 4, 6, 8, 10].choose + [24, 36, 48, 60].choose,
 \art, [0.125, 0.25, 0.5, 1.0, 2.0].choose
 ]);
 //Choose a wait time before next event
 [0.125, 0.125, 0.125, 0.125, 0.125, 1].choose.wait;
 }.loop;
}).play(SystemClock)
)

/*
Practice: Bells and Echoes

18.21. Bells and echoes
*/

(
SynthDef("bells", 
{arg freq = 100;
var out, delay; 
out = SinOsc.ar(freq, mul: 0.1)
*
EnvGen.kr(Env.perc(0, 0.01), gate: Dust.kr(1/7));

out = Pan2.ar(Klank.ar(`[Array.fill(10, {Rand(100, 5000)}),
 Array.fill(10, {Rand(0.01, 0.1)}),
 Array.fill(10, {Rand(1.0, 6.0)})], out), Rand(-1.0, 1.0));

Out.ar(0, out*0.4); //send dry signal to main out
Out.ar(16, out*1.0); //and send louder dry signal to fx bus

}).load(s);

SynthDef("delay1", // first echo
{var dry, delay;
dry = In.ar(16, 2);
delay = AllpassN.ar(dry, 2.5, 
 [LFNoise1.kr(2, 1.5, 1.6), LFNoise1.kr(2, 1.5, 1.6)], 
 3, mul: 0.8);
Out.ar(0, delay);
}).load(s);

SynthDef("delay2", // second echo
{var delay, dry;
dry = In.ar(16, 2);
delay = CombC.ar(dry, 0.5, [Rand(0.2, 0.5), Rand(0.2, 0.5)], 3);
Out.ar(0, delay);
}).load(s);

SynthDef("delay3", // third echo
{
var signal, delay; 
signal = In.ar(16, 2);
delay = Mix.arFill(3, { CombL.ar(signal, 1.0, LFNoise1.kr(Rand([0.1, 0.1], 0.3), 0.4, 
0.5), 15) });
 Out.ar(0, delay*0.2)
}).load(s);
)

//define groups
~fxGroup = Group.tail;
~bellGroup = Group.head;

// start one of the echoes and 4 bells
f = Synth("delay3", target: ~fxGroup);
4.do({Synth("bells", [\freq, rrand(30, 1000)], target: ~bellGroup)})

// stop existing echo and change to another
f.free; f = Synth("delay1", target: ~fxGroup);
f.free; f = Synth("delay2", target: ~fxGroup);
f.free; f = Synth("delay3", target: ~fxGroup);
Synth("delay1", target: ~fxGroup); // add delay1 without removing delay3

/*
Practice, just flashing

19.14. Function practice, free, just tempered flashing
*/

(
//run this first
SynthDef("Flash", 
{
arg fund = 400, decay = 4, filter = 1;
var out, harm;

out = Mix.ar(
 Array.fill(7,
 {
 arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.linen(0, 0, decay + 2), 
 levelScale: 1/(partial*filter)
 ) * max(0, LFNoise1.kr(rrand(5.0, 12.0)))
 })
 )*0.3; //overall volume
out = Pan2.ar(out, Rand(-1.0, 1.0));
DetectSilence.ar(out, doneAction:2);
Out.ar(0, out)
}
).play(s);
)

(
//then this
r = Task({
var freqFunc, pitch = 440, nextEvent;

freqFunc = {arg previousPitch;
 var nextPitch, nextInterval;
 nextInterval = [3/2, 2/3, 4/3, 3/4, 5/4, 4/5, 6/5, 5/6].choose;
 nextPitch = (previousPitch*nextInterval).wrap(100, 1000);
 nextPitch.round(0.01).post; " != ".post; 
 nextPitch.cpsmidi.round(1).midicps.round(0.01).postln;
 nextPitch
};

{
 nextEvent = [0.5, 0.25, 5, 4, 1].choose;
 pitch = freqFunc.value(pitch);
 Synth("Flash", 
 [\fund, pitch, \decay, nextEvent, \filter, rrand(1.0, 4.0)]);
 //Choose a wait time before next event
 nextEvent.wait;
}.loop;
}).play
)

/*
Practice: Example Functions

19.15. Pitch functions
*/
pitches = [60, 61, 62, 63, 64]; //declare an array of pitches
freqFunc = {
 midiNote = pitches.choose; //pick a pitch from the array
 midiNote.midicps; // return the cps for that pitch 
}; 
pitches = [60, 62, 64, 67, 69, 72, 74, 76]; //declare an array of pitches 
count = 0; //initialize count 
freqFunc = {
 midiNote = pitches.wrapAt(count); // wrapped index of count
 if(count%30 == 29, //every ninth time
 {pitches = pitches.scramble} //reset "pitches" to a scrambled 
 //verion of itself
 );
 count = count + 1; //increment count
 midiNote.midicps; //return cps 
};


// My favorite:
var freqFunc, pitches, pitch = 440, count, midiNote, nextEvent;
pitches = [60, 62, 64, 67, 69, 72, 74, 76].scramble; 
freqFunc = {
 midiNote = pitches.wrapAt(count); // wrap index of count
 if(count%10 == 9, //every tenth time
 {pitches.put(5.rand, (rrand(60, 76)))}//put a new pitch between
 //65 and 75 into the array pitches
 //at a random index
 );
 count = count + 1; //increment count
 midiNote.midicps; //return cps 
};

/*
Practice, Random Study

23.7. (Biased) random study
*/

(

a = Task({
 inf.do({arg i;
 var note, dur, next, amp, inst;
 note = rrand(24, 84);
 dur = rrand(0.1, 0.5);
 amp = rrand(30, 127);
 next = rrand(0.1, 0.5);
 m.noteOn(1, note, amp);
 thisThread.clock.sched(dur, {m.noteOff(1, note); nil});
 next.wait
 })
});

b = Task({
 inf.do({arg i;
 var note, dur, next, amp, inst;
 note = rrand(24, 84);
 dur = rrand(0.1, 0.5);
 amp = rrand(30, 127);
 next = rrand(0.1, 0.5);
 m.noteOn(2, note, amp);
 thisThread.clock.sched(dur, {m.noteOff(2, note); nil});
 next.wait
 })
});

c = Task({
 inf.do({arg i;
 var note, dur, next, amp, inst;
 note = rrand(24, 84);
 dur = rrand(0.1, 0.5);
 amp = rrand(30, 127);
 next = rrand(0.1, 0.5);
 m.noteOn(3, note, amp);
 thisThread.clock.sched(dur, {m.noteOff(3, note); nil});
 next.wait
 })
});
)

a.start;
b.start;
c.start;
a.stop; 127.do({arg i; m.noteOff(1, i)})
b.stop; 127.do({arg i; m.noteOff(2, i)})
c.stop; 127.do({arg i; m.noteOff(3, i)})


/*

26.10. Parallel Pbinds
*/

(
a = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2] * 0.1, inf),
 \pan, -1
 ).play;

b = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69, 0], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2] * 0.1, inf),
 \pan, 0
 ).play;

c = Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69, 0, 0], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2] * 0.1, inf), 
 \pan, 1
 ).play;
)

a.mute;
b.mute;
a.unmute;
c.mute;
b.unmute;
c.unmute;

// Riley?

(

p = Array.fill(20, {[0, 2, 4, 7, 9].choose + [60, 72].choose}).postln;
q = p.copyRange(0, p.size - 2).postln;
Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([Pseq(p), Pseq(p), Pseq(p)], inf),
 \dur, 0.1,
 \pan, -1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([Pseq(p), Pseq(p), Pseq(q)], inf),
 \dur, 0.1,
 \pan, 1
 ).play;
)

// Or gradual phase
(

p = Array.fill(20, {[0, 2, 4, 7, 9].choose + [60, 72].choose}).postln;
Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.1,
 \pan, -1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.101,
 \pan, 1
 ).play;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq(p, inf),
 \dur, 0.102,
 \pan, 0
 ).play;
)

/*

26.11. Serialism
*/

(

a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.1, 0.1, 1.0, 0.2, 0.3, 0.166, 0.166];
o = [48, 60, 72]; 

Pbind(
 \instrument, "SimpleTone",
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;
)

(

// And of course, three at once.

// If seed is any number other than 0 that seed will be used. 
// If 0, a random seed will be picked and posted. Use it to 
// repeat a performance. 

var seed = 0;

if(seed !=0, {thisThread.randSeed = seed},
 {thisThread.randSeed = Date.seed.postln});

a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
r = [0.1, 0.1, 1.0, 0.2, 0.3, 0.166, 0.166];
o = [48, 60, 72]; 

Pbind(
 \instrument, "SimpleTone",
 \pan, -1,
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;

Pbind(
 \instrument, "SimpleTone",
 \pan, 0,
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;

Pbind(
 \instrument, "SimpleTone",
 \pan, 1,
 \midinote, Prand(
 [ //P, R, I, IR
 Pseq(a) + o.choose,
 Pseq(a.reverse) + o.choose,
 Pseq(12 - a) + o.choose,
 Pseq((12 - a).reverse) + o.choose
 ], inf),
 \dur, Pseq([Prand([0.1, 0.2, 0.5, 1.0], 7),
 Prand([Pseq(r), Pseq(r.reverse)], 1)], inf),
 \amp, Prand([
 Pseries(0.1, 0.1, 5), // cresc
 Pseries(0.9, -0.1, 6), // decresc
 Prand([0.1, 0.3, 0.5, 0.7], 5)
 ], inf)
).play;

)

/*
Serialization Without Synthesis or Server using MIDIout
Practice: Total Serialization using MIDI only

26.12. Babbitt: Total Serialization (sort of)
*/

(
MIDIClient.init;
m = MIDIOut(0, MIDIClient.destinations.at(0).uid);
)

(
var pitchSeries, octaveSeries, durationSeries, nextSeries, dynSeries, instSeries;
pitchSeries = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].scramble.postln;
octaveSeries = Array.fill(6, {[36, 48, 60, 72].choose}).postln;
durationSeries = Array.fill(23, {rrand(0.1, 3.0).round(0.1)}).postln;
nextSeries = Array.fill(30, {[0, 0, 0.1, 0.1, 0.1, 0.2, 0.2, 0.2, 0.4, 0.4, 
2.0].choose}).postln;
dynSeries = Array.fill(24, {rrand(40, 120).round(0.1)}).postln;
instSeries = Array.fill(20, {4.rand}).postln;

r = Task({
 inf.do({arg count;
 var note; 
 note = pitchSeries.wrapAt(count) + octaveSeries.wrapAt(count);
 if(count%12 == 0, {
 pitchSeries = // choose a new version of the row
 [pitchSeries.reverse, // retrograde
 (12 - pitchSeries).reverse, // retrograde inversion
 12 - pitchSeries, // inversion
 pitchSeries // prime
 ].choose;
 // choose a transposition of the row
 pitchSeries = (pitchSeries + 12.rand)%12;
 pitchSeries.postln;});
 if(0.1.coin, {
 durationSeries = durationSeries.scramble.postln;
 nextSeries = nextSeries.scramble.postln;
 dynSeries = dynSeries.scramble.postln;
 instSeries = instSeries.scramble.postln;
 });
 m.noteOn(instSeries.wrapAt(count), note, dynSeries.wrapAt(count));
 thisThread.clock.sched(durationSeries.wrapAt(count), 
 {m.noteOff(instSeries.wrapAt(count), note); nil});
 nextSeries.wrapAt(count).wait
 })
});

r.start;
)

r.stop; 4.do({arg j; 127.do({arg i; m.noteOff(j, i, 0)})})

/*
MIDI Using Pbind

26.13. Pbind and MIDI, by Julian Rohrhuber
*/

(
var f;
f = (
 noteOn: #{ arg chan, midinote, amp;
 [chan, midinote, asInteger((amp * 255).clip(0, 255))]
 },
 noteOff:#{ arg chan, midinote, amp;
 [ chan, midinote, asInteger((amp * 255).clip(0, 255))]
 },
 polyTouch: #{ arg chan, midinote, polyTouch=125;
 [ chan, midinote, polyTouch]
 },
 control: #{ arg chan, ctlNum, control=125;
 [chan, ctlNum, control]
 },
 program: #{ arg chan, progNum=1;
 [ chan, progNum]
 }
 /*
 touch ( chan, val )
 bend ( chan, val )
 allNotesOff ( chan )
 smpte ( frames, seconds, minutes, hours, frameRate )
 songPtr ( songPtr )
 songSelect ( song )
 midiClock ( )
 startClock ( )
 continueClock ( )
 stopClock ( )
 reset ( )
 sysex ( uid, Int8Array )
 
 */ 
 
 );

~midiEnv = ( 
 chan: 1,
 msgFuncs: f,
 hasGate: true,
 midicmd: \noteOn,
 play: #{
 var freqs, lag, dur, sustain, strum;
 var tempo, bndl, midiout, hasHate, midicmd;
 
 freqs = ~freq = ~freq.value + ~detune;
 
 tempo = ~tempo;
 if (tempo.notNil) {
 thisThread.clock.tempo = tempo;
 };
 
 if (freqs.isKindOf(Symbol).not) {
 ~finish.value;
 ~amp = ~amp.value;
 strum = ~strum;
 lag = ~lag;
 sustain = ~sustain = ~sustain.value;
 midiout = ~midiout;
 hasHate = ~hasGate;
 midicmd = ~midicmd;
 bndl = ~msgFuncs[midicmd].valueEnvir;
 
 bndl = bndl.flop;
 
 bndl.do {|msgArgs, i|
 var latency;
 
 latency = i * strum + lag;
 
 
 midiout.performList(midicmd, msgArgs);
 if(hasHate and: { midicmd === \noteOn }) {
 thisThread.clock.sched(sustain) { 
 midiout.noteOff(*msgArgs)
 };
 };
 };
 }
 }
 
 ).putAll(
 Event.partialEvents.pitchEvent, 
 Event.partialEvents.ampEvent, 
 Event.partialEvents.durEvent 
 )
);


// initialize midiout
(
MIDIClient.init;
m = MIDIOut(0, MIDIClient.destinations.at(0).uid);
)


// I've modified the Pbind to show more values [they aren't very good]

(
Pbind(
 \parent, ~midiEnv,
 \midiout, m,
 \chan, Pseq([0, 1, 2, 3], 60), //total number of events
 \amp, Prand([
 Pseq([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]),
 Pseq([0.8, 0.7, 0.5, 0.3, 0.1]),
 Prand([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], 10)
 ], inf),
 \dur, Prand([0.1, 0.1, 0.1, 0.2, 0.2,1.0, 2.0], inf),
 \sustain, Pfunc({rrand(0.1, 2.0)}),
 \midinote, Prand([36, 38, 40, 42, 43, 45, 47, 49, //synthetic scale
 50, 52, 54, 56, 57, 59, 61, 63, 64, 66, 68, 70], inf)
).play;
)
