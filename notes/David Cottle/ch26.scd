/*
26 - Pbind, Mutation, Pfunc, Prand, Pwrand, Pseries, Pseq, 
Serialization

Pbind

26.1. Read global library
*/
 
SynthDescLib.global.read

/*

26.2. Basic Pbind
*/

Pbind(\freq, 600).play

/*

26.3. Pbind with frequency function
*/

Pbind(\freq, Pfunc({rrand(100, 900)})).play;

Pbind(
 \freq, Pfunc({rrand(100, 900)}), 
 \dur, Pfunc({rrand(0.1, 1.5)})).play

Pbind(
 \degree, Pfunc({8.rand}), 
 \oct, Pfunc({rrand(3, 7)}), //or try \octave?
 \dur, 0.2).play

Pbind(
 \scale, [0, 2, 4, 6, 8, 10],
 \degree, Pfunc({6.rand}), 
 \oct, Pfunc({rrand(3, 7)}), //or try \octave
 \dur, 0.2).play

Pbind(
 \scale, [0, 2, 3, 5, 6, 8, 10, 11],
 \degree, Pfunc({8.rand}), 
 \oct, Pfunc({rrand(3, 7)}), //or try \octave
 \dur, 0.2).play

/*

26.4. Pbind with Previous Instrument Definitions
*/

Pbind(
 \instrument, "KSpluck3",
 \midiPitch, Pfunc({rrand(34, 72)}), 
 \art, Pfunc({rrand(1.0, 2.0)}),
 \dur, 0.1
).play

/*
dur, legato, nextEvent

26.5. Pbind with previous fx
*/

Synth("delay1");

Pbind(
 \instrument, "bells",
 \freq, Pseq([100, 400, 1000, 1500, 2000])
).play;

/*

26.6. Simple serial instrument
*/

(
SynthDef("SimpleTone",
{arg midinote = 60, amp = 0.9, dur = 1, pan = 0, legato = 0.8;
 Out.ar(0, 
 Pan2.ar(
 SinOsc.ar(midinote.midicps, mul: amp)
 *
 EnvGen.kr(Env.perc(0, dur*legato), doneAction: 2),
 pan
 )
 )
}).load(s);

SynthDescLib.global.read
)

/*

26.7. Pitch Model for Mutation
*/

(
var degreeSeq, nextPitch, scale; 

scale = [0, 2, 3, 5, 7, 8, 11];

degreeSeq = [1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 
 3, 3, 5, 5, 1, 1, 4, 4, 7, 7, 2, 2] - 1;


nextPitch = Routine({
 inf.do({arg count; 
 scale.wrapAt(degreeSeq.wrapAt(count)).yield;
 })
});

Pbind(
 \instrument, "SimpleTone",
 \midinote, nextPitch + 60,
 \dur, 0.1
 ).play
)

/*

26.8. Experiment
*/

// increasing multiples
 var mul = 1;
 inf.do({arg count; 
 if(count%20 == 19, {mul = mul + 1});

// occasional random values

 inf.do({arg count; 
 if(count%6 == 5, {12.rand.yield},
 {(scale.wrapAt(degreeSeq.wrapAt(count*mul))).yield});

// occasionally dodge sequence

 if(count%6 == 5, {scale.choose.yield},
 {(scale.wrapAt(degreeSeq.wrapAt(count*mul))).yield});

// gradually change scale

 if(count%6 == 5, {scale.put(scale.size.rand, 12.rand)});
 (scale.wrapAt(degreeSeq.wrapAt(count))).yield;

/*

Prand, Pseries, Pseq

26.9. Patterns
*/

(
f = 100;

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pfunc({
 f = ([3/2, 4/3].choose) * f;
 if(f > 1000, {f = f/8}); //.fold or .wrap didn't do what I wanted
 f.cpsmidi
 }),
 \dur, 0.2
 ).play
 
)

(
Pbind(
 \instrument, "SimpleTone",
 \midinote, Prand([60, 62, 64, 65, 67, 69, 70], inf),
 \dur, 0.1
 ).play
 
)

(
// The dur array is 1s and 2s, representing eighth notes. 

Pbind(
 \instrument, "SimpleTone",
 \midinote, Pseq([70, 58, 60, 62, 60, 58, 65, 62, 70, 
 65, 62, 65, 63, 62, 63, 65, 58, 62, 65, 69], inf),
 \dur, Pseq([2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 
 2, 1, 1, 1, 1, 2, 2, 2, 2, 2] * 0.2, inf)
 ).play
)

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

/*

26. Exercises
*/
