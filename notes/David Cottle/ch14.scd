/*
14 - Additive Synthesis, Random Numbers, CPU usage
Harmonic Series and Wave Shape

14.1. String Vibration and Upper Harmonics



14.2. Vibrating Strings



14.3. Spectral Analysis of "Four Score"



Additive Synthesis

14.4. Adding sines together
*/

(
{
(
 SinOsc.ar(400) + SinOsc.ar(800) + SinOsc.ar(1200) + 
 SinOsc.ar(1600) + SinOsc.ar(2000) + SinOsc.ar(2400) + 
 SinOsc.ar(2800) + SinOsc.ar(3200) + SinOsc.ar(3600) + 
 SinOsc.ar(4000) + SinOsc.ar(4400) + SinOsc.ar(4800) 
)*0.1
}.scope
)

// Harmonics adjusted

(
{
(
 SinOsc.ar(400, mul: 1) + SinOsc.ar(800, mul: 1/2) + 
 SinOsc.ar(1200, mul: 1/3) + SinOsc.ar(1600, mul: 1/4) +
 SinOsc.ar(2000, mul: 1/5) + SinOsc.ar(2400, mul: 1/6) + 
 SinOsc.ar(2800, mul: 1/7) + SinOsc.ar(3200, mul: 1/8) + 
 SinOsc.ar(3600, mul: 1/9) + SinOsc.ar(4000, mul: 1/10) + 
 SinOsc.ar(4400, mul: 1/11) + SinOsc.ar(4800, mul: 1/12) 
)*0.1
}.scope
)
/*


14.5. Additive synthesis with a variable
*/

(
{
f = 100;
[
 SinOsc.ar(f*1, mul: 1), SinOsc.ar(f*2, mul: 1/2),
 SinOsc.ar(f*3, mul: 1/3), SinOsc.ar(f*4, mul: 1/4),
 SinOsc.ar(f*5, mul: 1/5), SinOsc.ar(f*6, mul: 1/6), 
 SinOsc.ar(f*7, mul: 1/7), SinOsc.ar(f*8, mul: 1/8), 
 SinOsc.ar(f*9, mul: 1/9), SinOsc.ar(f*10, mul: 1/10), 
 SinOsc.ar(f*11, mul: 1/11), SinOsc.ar(f*12, mul: 1/12) 
]
}.scope(12)
)
/*


14.6. Additive saw with modulation
*/

(
{
var speed = 14;
f = 300;
t = Impulse.kr(1/3);
Mix.ar([
 SinOsc.ar(f*1, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/1), 
 SinOsc.ar(f*2, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/2),
 SinOsc.ar(f*3, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/3), 
 SinOsc.ar(f*4, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/4),
 SinOsc.ar(f*5, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/5), 
 SinOsc.ar(f*6, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/6), 
 SinOsc.ar(f*7, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/7), 
 SinOsc.ar(f*8, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/8), 
 SinOsc.ar(f*9, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/9), 
 SinOsc.ar(f*10, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/10), 
 SinOsc.ar(f*11, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/11), 
 SinOsc.ar(f*12, mul: LFNoise1.kr(rrand(speed, speed*2), 0.5, 0.5)/12) 
])*0.5
}.scope(1)
)
 /*


14.7. Additive saw with independent envelopes
*/

(
{
f = 100;
t = Impulse.kr(1/3);
Mix.ar([
 SinOsc.ar(f*1, mul: EnvGen.kr(Env.perc(0, 1.4), t)/1), 
 SinOsc.ar(f*2, mul: EnvGen.kr(Env.perc(0, 1.1), t)/2),
 SinOsc.ar(f*3, mul: EnvGen.kr(Env.perc(0, 2), t)/3), 
 SinOsc.ar(f*4, mul: EnvGen.kr(Env.perc(0, 1), t)/4),
 SinOsc.ar(f*5, mul: EnvGen.kr(Env.perc(0, 1.8), t)/5), 
 SinOsc.ar(f*6, mul: EnvGen.kr(Env.perc(0, 2.9), t)/6), 
 SinOsc.ar(f*7, mul: EnvGen.kr(Env.perc(0, 4), t)/7), 
 SinOsc.ar(f*8, mul: EnvGen.kr(Env.perc(0, 0.3), t)/8), 
 SinOsc.ar(f*9, mul: EnvGen.kr(Env.perc(0, 1), t)/9), 
 SinOsc.ar(f*10, mul: EnvGen.kr(Env.perc(0, 3.6), t)/10), 
 SinOsc.ar(f*11, mul: EnvGen.kr(Env.perc(0, 2.3), t)/11), 
 SinOsc.ar(f*12, mul: EnvGen.kr(Env.perc(0, 1.1), t)/12) 
])*0.5
}.scope(1)
)

/*

Shortcuts

14.8. additive synthesis with array expansion 
*/

Mix.ar([SinOsc.ar(100), SinOsc.ar(200), SinOsc.ar(300)])

// The results are the same with this code

Mix.ar(SinOsc.ar([100, 200, 300]))

/*

14.9. additive synthesis with array expansion 
*/

midicps(60);

midicps([60, 62, 64, 65, 57, 69, 71]);

(1..12) // shortcut for [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

midicps((1..24)*60)

(1, 3..13) // means [1, 3, 5, 7, 9, 11, 13]

midicps((60, 63..72))

// additive synthesis with shortcuts

(
{
f = 100;
t = Impulse.kr(1/3);
Mix.ar(
 SinOsc.ar(
 f*(1..12),
 mul: EnvGen.kr(
 Env.perc(0, 1), 
 t, 
 levelScale: 1/(1..12),
 timeScale: [1.4, 1.1, 2, 1, 1.8, 2.9, 4, 0.3, 1, 3.6, 2.3, 1.1]
 )
 )
)*0.5
}.scope(1)
)
/*

14.10. additive synthesis with array expansion 
*/

(
{
t = Impulse.kr(1/3);
Mix.ar(
 SinOsc.ar(
 [60, 64, 67, 71, 74, 78].midicps,
 mul: EnvGen.kr(
 Env.perc(0, 1), 
 t, 
 levelScale: 1/(1..6),
 timeScale: rrand(1.0, 3.0).dup
 )
 )
)*[0.3, 0.3]
}.scope(1)
)

(
{
Mix.ar(
 Pan2.ar(
 SinOsc.ar(
 [60, 62, 63, 65, 67, 68, 71, 72].midicps,
 mul: LFNoise1.kr(rrand(0.1, 0.5).dup(8), 0.5, 0.5)
 ),
 1.0.rand2.dup(8)
 )
)*0.2
}.scope(1)
)
/*
Filling an array

14.11. Array.fill 
*/

Array.fill(16, {100.rand})

Array.fill(16, {SinOsc.ar(100.rand)})

/*

14.12. Array.fill with arg
*/

//fill an array with the number of this iteration
Array.fill(16, {arg counter; counter})

//fill an array with random numbers
Array.fill(16, {arg counter; [counter, rrand(20, 100)]})

//fill an array with multiples of counter
Array.fill(16, { |counter| counter*3})

//fill an array with SinOsc objects, each with a freq of the counter*100
Array.fill(16, { |counter| SinOsc.ar(counter*100)})

/*

14.13. Additive saw wave, separate decays 
*/

(
{
var gate, fund;
gate = Impulse.kr(1/3);
fund = MouseX.kr(50, 1000);
Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(Env.adsr(0, 0, 1.0, TRand.kr(0.2, 2.0, gate)), 
 gate, 1/partial)
 })
 )*0.2 //overall volume
}.scope(1)
)

/*

14.14. Additive saw wave, same decays 
*/

(
{
var gate, fund, env;
gate = MouseButton.kr(0, 1, 0);
fund = MouseX.kr(50, 1000);
env = Env.adsr(0, 0, 1.0, 2.0);
Mix.ar(
 Array.fill(16,
 {arg counter;
 var partial;
 partial = counter + 1;
 SinOsc.ar(fund*partial) * 
 EnvGen.kr(env, gate, 1/partial)
 })
 )*0.2 //overall volume
}.scope(1)
)

/*

14.15. Single sine with control
*/

{SinOsc.ar(400, mul: SinOsc.ar(1/3, mul: 0.5, add: 0.5))}.play

/*

14.16. Gaggle of sines
*/

(
{
 var harmonics = 16, fund = 50; 
 Mix.fill(harmonics, 
 { arg count;
 Pan2.ar(
 FSinOsc.ar(
 fund * (count + 1), // calculates each harmonic
 mul: FSinOsc.kr(rrand(1/3, 1/6), mul: 0.5, add: 0.5 )),
 1.0.rand2)
 }
 ) / (2*harmonics)
}.play;
)

/*
Inharmonic spectra

14.17. Inharmonic spectrum
*/

{Mix.ar(
 SinOsc.ar(
 [72, 135, 173, 239, 267, 306, 355, 473, 512, 572, 626],
 0, //phase
 [0.25, 0.11, 0.12, 0.04, 0.1, 0.15, 0.05, 0.01, 0.03, 0.02, 0.12]
 ))}.scope(1)

/*
Random Numbers, Perception

14.18. rand
*/

10.rand;

10.0.rand;

/*

14.19. Test a random array
*/

{100.rand}.dup(20)

/*

14.20. Error from not using a function
*/

(100.rand).dup(20)

/*
 
14.21. Client random seed 
*/

{100.rand}.dup(20);

thisThread.randSeed = 5; {100.rand}.dup(20);

/*

14.22. Server random seed
*/

// different every time
{SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)}.play

// same every time
(
{
RandSeed.kr(1, 1956); 
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)

// resets every 5 seconds
(
{
RandSeed.kr(Impulse.kr(1/5), 1956); 
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)
/*

14.23. Post clock seed 
*/

thisThread.randSeed = Date.seed.postln; {100.rand}.dup(20);

(
{
RandSeed.kr(Impulse.kr(1/5), Date.seed.postln); 
SinOsc.ar(LFNoise0.kr(7, 12, 72).midicps, mul: 0.5)
}.play
)
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
14. Exercises
*/
