s.boot

(
// a SynthDef
SynthDef(\mono, {
	|freq=440, amp=0.6, out=0|
	 Out.ar(out,
		MoogFF.ar(PinkNoise.ar(amp), freq).dup)
}).send(s);
)

u=Synth.new(\mono, [freq: 1900, amp: 0.75], s, \addToHead)


u.set(\freq, 700);
u.set(\freq, 1700);
u.set(\amp, 0.25);



p = Pmono(\mono, \dur, 0.2, \freq, Pwhite(1,8) * 100, \amp, [0,0.2,0.5,0.7]).play

u.run(false)
u.free;



(
p = Pbind(
    \type, \set,    // This tells it we'll be setting parameters of an existing node...
	\server, s,
	\group, 1,
    \id, 1000,    // ...this tells it whose parameters we'll be setting
    \args, #[\freq, \amp],  // and this tells it which parameters to set
    \freq, Pwhite(100, 1000),
    \dur, 0.05,
    \amp, Pseq((1,0.99 .. 0.1), inf)
).play;
)

p.stop

g = s.defaultGroupID


// Synth('temp__0' : 1000)
// In the following pattern, the first two keys are the ones that create the monophonic behaviour:
(
p = Pbind(
    \type, \set,    // This tells it we'll be setting parameters of an existing node...
    \id, 1000,    // ...this tells it whose parameters we'll be setting
    \args, #[\freq, \amp],  // and this tells it which parameters to set
    \freq, Pwhite(100, 1000),
    \dur, 0.2,
    \amp, Pseq((1,0.99 .. 0.1), inf)
).play;
)




p.stop
x.free