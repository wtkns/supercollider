/*
12 - Voltage Control, LFO, Envelopes, Triggers, Gates, Reciprocals

Com-, Go to line number
Com-/ Make selected lines a comment
Opt-Com-/ Remove comment marks on selected lines
Shift-Com-B Balance enclosures
Com-] Shift code right
Com-[ Shift code left
Com-. Stop all playback
Shift-Com-/ (Com-?) Open help file for selected item
Com-' Syntax colorize
Double click enclosure Balance enclosures
Com-\ Bring post window to front
Shift-Com-K Clear post window
Shift-Com-\ Bring all windows to front

12.1. SinOsc as vibrato
*/

{SinOsc.ar(freq: 400, mul: 0.7)}.play

{SinOsc.ar(freq: Line.kr(200, 2000, 10), mul: Line.kr(0.9, 0.2, 10))}.play

/*
Vibrato

12.2. SinOsc as vibrato
*/

SinOsc.ar(freq: 5, mul: 5, add: 440)

/*

12.3. Vibrato
*/

(
{
 var vibrato;
 vibrato = SinOsc.ar(freq: 5, mul: 5, add: 440);
 SinOsc.ar(vibrato, mul: 0.5)
}.play
)

/*
Block Diagrams
Theremin

12.4. Theremin
*/



(
{ 
var vibrato;
vibrato = SinOsc.kr(6, mul: 0.02, add: 1);
 SinOsc.ar(
 freq: MouseY.kr(3200, 200, lag: 0.5, warp: 1) * 
 vibrato, //Vibrato 
 mul: abs(MouseX.kr(0.02, 1)) //Amplitude
 ) 
}.play
) 

/*

12.5. Better vibrato 


*/

(
//Vibrato
{
var depthChange, vibrato;
depthChange = Line.kr(0, 5, 3);
vibrato = SinOsc.ar(freq: 5, mul: depthChange, add: 440); 
SinOsc.ar(
 vibrato, 
 mul: 0.5)
}.play
)

/*

12.6. Other LFO controls 


*/
 
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
Envelopes
Triggers, Gates, messages, ar (audio rate) and kr (control rate)

12.7. Trigger and envelope 
*/

{Impulse.ar(4, mul: 0.5)}.play

{Dust.ar(5)}.play



(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 1.0), Impulse.kr(2)) 
 )
}.play
)

(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 0.3), Dust.kr(2))
 )
}.play
) 

/*

12.8. Trigger with MouseX
*/



(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 0.3), SinOsc.ar(2)) 
 )
}.play
)

(
{
 SinOsc.ar(
 440,
 mul: EnvGen.kr(Env.perc(0.001, 0.3), MouseX.kr(-0.1, 0.1))
 )
}.play
)

/*



12.9. Envelope with trigger
*/

(
{
var triggerSpeed, trigger;

triggerSpeed = 8;
trigger = Impulse.kr(triggerSpeed);

SinOsc.ar( 
 TRand.kr(100, 2000, trigger),
 mul: EnvGen.kr(
 Env.perc(0.001, 1/triggerSpeed), 
 trigger
 )
)
}.play
)

/*
Duration and Frequency [New]
Synchronized LFO Control [New]

12.10. Synchronized LFOs and Triggers
*/

(
{
SinOsc.ar(SinOsc.ar(4/10, mul: 100, add: 1000), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/10, mul: 100, add: 1000), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/10, mul: 100, add: 1000), mul: 0.1)
}.play
)


(
{
var scale = 300, offset = 500;
SinOsc.ar(SinOsc.ar(4/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(7/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(8/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(6/3, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/3, mul: scale, add: offset), mul: 0.1)
}.play
)


(
{
var scale = 600, offset = 1000, synch = 10;
SinOsc.ar(SinOsc.ar(4/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(7/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(2/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(8/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(6/synch, mul: scale, add: offset), mul: 0.1) +
SinOsc.ar(SinOsc.ar(5/synch, mul: scale, add: offset), mul: 0.1)
}.play
)

( // synchronized triggers
{
var synch = 5;
SinOsc.ar(100, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(3/synch))) +
SinOsc.ar(300, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(7/synch))) +
SinOsc.ar(500, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(5/synch))) +
SinOsc.ar(700, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(2/synch))) +
SinOsc.ar(900, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(9/synch))) +
SinOsc.ar(1100, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(6/synch))) +
SinOsc.ar(1300, mul: EnvGen.kr(Env.perc(0, 1), Impulse.kr(1/synch))) * 0.1
}.play
)


/*
Frequency and Duration Linked

12.11. Duration, attack, decay
*/

var dur, att, dec, trigFreq;

dur = 10; // ten seconds long
att = dur*0.1;
dec = dur*0.9;
trigFreq = 1/dur;

or

freq = 10; // ten in one second
att = 1/freq*0.1;
dec = 1/freq*0.9;
duration = 1/feq;
/*
Gates

12.12. Envelope using a gate
*/

(
{
 SinOsc.ar(440,
 mul: EnvGen.kr(
 //Envelope is attack, decay, sustain level, release
 Env.adsr(0.001, 0.3, 0.2, 0.1), 
 MouseX.kr(-0.1, 0.1) //gate
 )
 )
}.play
)

(
{
 SinOsc.ar(
 400 + EnvGen.kr(
 Env.adsr(0.3, 0.4, 0.2, 1), 
 MouseX.kr(-0.1, 0.1),
 1000
 ),
 mul: 0.5
 )
}.play
)

/*

12.13. Envelope with LFNoise as gate
*/

(
{
 SinOsc.ar(
 LFNoise0.kr(13, 1000, 1200),
 mul: EnvGen.kr(
 //Envelope is attack, decay, sustain level, release
 Env.adsr(0.001, 0.3, 0.2, 0.1), 
 LFNoise0.kr(3) //gate
 )
 )
}.play
)

/*

12.14. Complex envelope
*/

(
{
SinOsc.ar(
 EnvGen.kr(Env.new(
 [ 0, 0.5, 0, 0.3, 0.3, 0, 0.1, 0, 0.2, 0.3, 0.15, 0.5, 0.25 ],
 [1, 0.5, 0.5, 2, 0.7, 1, 0.3, 0.6, 0.5, 0.8, 0, 0.4])
 ) * 1000 + 200
)
}.play
)

// This will plot the array

[ 0, 0.5, 0, 0.3, 0.3, 0, 0.1, 0, 0.2, 0.3, 0.15, 0.5, 0.25 ].plot

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
12. Exercises

*/
