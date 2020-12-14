/*
16 - FM/AM Synthesis, Phase Modulation, Sequencer, Sample and 
Hold
AM and FM synthesis or "Ring" Modulation

16.1. From LFO to FM
*/

{SinOsc.ar(SinOsc.ar(MouseX.kr(1, 500), mul: 300, add: 800))}.play

/*

16.2. AM Synthesis (SinOsc, scope, mul, Saw)
*/

{SinOsc.ar(500, mul: SinOsc.ar(50, mul: 0.5))}.scope(1)

{Saw.ar(500, mul: SinOsc.ar(50, mul: 0.5))}.scope(1)

/*

16.3. FM Synthesis 
*/

{SinOsc.ar(400 + SinOsc.ar(124, mul: 100), mul: 0.5)}.scope(1)

/*
Phase Modulation

16.4. PM Synthesis 
*/

{PMOsc.ar(400, 124, 1, mul: 0.5)}.scope(1)

/*

16.5. Controls for carrier, modulator, and index
*/

(
{PMOsc.ar(LFNoise0.kr(5, 300, 700),// carrier
 134, 4, mul: 0.4)
 }.scope(1)
)

(
{PMOsc.ar(700,
 LFNoise0.kr(5, 500, 700),//modulator
 12, mul: 0.4
 )}.scope(1)
)
 
(
{PMOsc.ar(700, 567,
 LFNoise0.kr(5, 6, 12), //index
 mul: 0.4
 )}.scope(1)
)
 
(
// All three. This is the type of sound that
// got me hooked on synthesis in the first place.

{PMOsc.ar(LFNoise0.kr([9, 9], 300, 700),
 LFNoise0.kr([9, 9], 500, 700),
 LFNoise0.kr([9, 9], 6, 12),
 mul: 0.5
 )}.scope(1)
)

/*

16.6. Efficiency of PM
*/

{PMOsc.ar(1000, 1367, 12, mul: EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))}.play

(
{
Mix.ar(
 SinOsc.ar(abs((-20..20)*1367 + 1000), 
 mul: 0.1*EnvGen.kr(Env.perc(0, 0.5), Impulse.kr(1)))
)}.play
)

/*
 
16.7. Carrier and modulator ratio
*/

(
{var freq, ratio;
freq = LFNoise0.kr(4, 20, 60).round(1).midicps;
ratio = 2/1;
PMOsc.ar(
 freq, //carrier
 freq*ratio, //modulator
 MouseY.kr(0.1, 10), //index
 Mul: [0.4, 0.4]
)}.play
)

/*

16.8. Envelope applied to amplitude and modulation index
*/
 
(
{var freq, ratio, env, rate = 5, trig;
trig = Impulse.kr(5);
freq = TRand.kr([36, 60], [72, 86], trig).midicps;
ratio = 2;
env = EnvGen.kr(Env.perc(0, 1/rate), gate: trig);
PMOsc.ar(
 freq,
 freq*ratio,
 3 + env*4, 
 mul: env
)}.play
)

/*
Sequencer

16.9. Sequencer (array, midicps, SinOsc, Sequencer, Impulse, kr)
*/

(
var pitchArray; //Declare a variable to hold the array
 //load the array with midi pitches
pitchArray = [60, 62, 64, 65, 67, 69, 71, 72].midicps; 
{
 SinOsc.ar(
 Select.kr(
 Stepper.kr(Impulse.kr(8), max: pitchArray.size-1),
 pitchArray),
 mul: 0.5)
}.play
)

(
var pitchArray; //Declare a variable to hold the array
 //load the array with midi pitches
pitchArray = Array.rand(24, 100, 2000); 
{
 SinOsc.ar(
 Select.kr(
 Stepper.kr(Impulse.kr(8), max: pitchArray.size-1),
 pitchArray),
 mul: 0.5)
}.play
)

/*

16.10. scramble, reverse (Array.rand, postln, scramble, reverse)
*/

(
var pitchArray;
pitchArray = Array.rand(10, 60, 84);
pitchArray.postln.scramble.postln.reverse.postln;
(pitchArray + 12).postln
)

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
16. Exercises
*/
