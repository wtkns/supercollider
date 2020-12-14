s.boot

(

SynthDef(\mono_test, { arg freq, attack = 1, release = 5, t_gate = 1, sustain, amp = 0.1,
    lfoFreq = 1, midiVib = 0.5;
   
    var envShape = Env.adsr(attack, 1, 0.75, release);
    var envGen = EnvGen.ar(envShape, t_gate);
    var vibRatio = midiVib.midiratio;
    var wave = PulseDPW.ar(
        freq * SinOsc.ar(lfoFreq).range(1/vibRatio, vibRatio),
        0.5,
        amp
    );
   
    Out.ar(0, wave * envGen ! 2);
}).add;
)


(
var xxx = Synth(\mono_test, [\amp, 0]);

y = Pbindef(\testdef,
    \instrument, \mono_test,
    \type, \set,
    \id, xxx,
    \args, [\freq, \attack, \release, \t_gate, \amp],
    \attack, 0.1,
    \release, 1,
    \midinote, Pseq([50, 52, 57, 59], inf),
    \amp, 0.5,
    \dur, 1,
    \t_gate, 1
).trace.play
)

y.stop


Event.default.parent.keys

Event.eventTypes



Server.default.plotTree;

a = Pbind(\instrument, \test).trace.play;

a.stop



TestMeshBindef.run
SynthDescLib.global.browse;



Server.default = Server.local;
s.boot;



e = (degree: 2);
e.play;

e.stop

Server.default=Server.local;
s.boot;


(
n = IdentitySet.new;  // make the collection

p = Pbind(
        \dur, 0.25,
        \sustain, 4,
        \degree, Pwhite(0, 7, inf)
).collect { |event|
        n.add(event);  // and add stuff
        event  // collect function must return the event
}
.play;
)

p.stop;

n.do { |event| event[\id].postln}

//or
n.select { |event| condition }



//An obvious problem is that nodes may end on the server, but the
//corresponding events stay in the collection forever. We can use node
//notifications for this.

(
n = IdentitySet.new;

p = Pbind(
        \dur, 0.25,
        \sustain, 4,
        \degree, Pwhite(0, 7, inf)
).collect { |event|
        var resp;
        n.add(event);
        thisThread.clock.sched(0, {
                resp = OSCFunc({ |msg|
                        event[\released] = event[\released].add(msg[1]);
                        if(event[\released].size == event[\id].size) {
                                n.remove(event);
                                resp.free;  // don't keep stray responders
                        };
                }, '/n_end', s.addr, argTemplate: [event[\id]]);
        });
        event
}.play;
);

p.stop


/*
Notes:

- In the collect function, the IDs haven't been generated yet. We have to
schedule a function for "as soon as possible after play" (0 beats in the
future). Also, each invocation of collect function handles one and only one
event -- so we can keep using the 'event' argument for all the bookkeeping.

- The event may represent multiple nodes. So we have to count the node
releases, and not clean up until we got /n_end message is for all of them.
(An alternate approach would be to remove from event[\id] until the ID array
is empty.)

- argTemplate: This responder should fire only if the message matches one of
this event's IDs. The argTemplate uses a 'matchItem' interface, where the
event's \id array means "any of the elements of the array."

The OSCFunc stuff, I wouldn't expect you to figure out by yourself -- quite
a few details.

*/

		// SynthDef(synthDefName, {|
		// 	freq,
		// 	attack = 1,
		// 	release = 5,
		// 	t_gate = 1,
		// 	sustain,
		// 	amp = 0.1,
		// 	lfoFreq = 1,
		// 	midiVib = 0.5 |
   
		// 	var envShape = Env.adsr(attack, 1, 0.75, release);
		// 	var envGen = EnvGen.ar(envShape, t_gate);
		// 	var vibRatio = midiVib.midiratio;
		// 	var wave = PulseDPW.ar(
		// 		freq * SinOsc.ar(lfoFreq).range(1/vibRatio, vibRatio),
		// 		0.5,
		// 		amp
		// 	);
			
		// 	Out.ar(0, wave * envGen ! 2);
		// }).add;


(
SynthDef(\event_set, { |freq = 440, gate = 1, amp = 0.1, lagTime = 0.1,
        ffreq = 2000, detune = 1.005, out = 0|
    var    sig = Saw.ar(Lag.kr(freq, lagTime) * [1, detune]).sum * amp
            * EnvGen.kr(Env.adsr, gate, doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2);
}).add;
)

a = Synth(\event_set);

(
p = Pbind(
    \type, \set,
    \id, a,
    \instrument, \event_set,
    \args, #[],
    \freq, Pexprand(200, 600, inf),
    \dur, Pwhite(1, 5, inf) * 0.125
).play;
)

p.stop;
a.free;


Server.default = Server.local;

s.reboot;


(

SynthDef(\trigTest, { |
	out,
	t_trig=0,
	freq=440| // t_trig creates a TrigControl

	Out.ar(
		out,
		SinOsc.ar(
			freq+[0,1], 0, Decay2.kr(
				t_trig, 0.005, 1.0)));
	
}, [0, 0, 4]        // lag the freq by 4 seconds (the second arg), but not t_trig (won't work anyway)
).add;

)

a = Synth(\trigTest);

(
p = Pbind(
    \type, \set,
    \id, a,
    \instrument, \event_set,
    \args, #[],
    \freq, Pexprand(200, 600, inf),
    \dur, Pwhite(1, 5, inf) * 0.125
).play;
)

p.stop;
a.free;

SynthDescLib.global.browse



SynthDef(\stringResJames, {
| out = 0,
attime = 0.2,
dectime = 0.2,
sustime = 0.3,
reltime = 0.4,
len = 1,
sus = 1,
dec = 1,
att = 0.2,
res = 0.9,
amp = 0.25,
startfreq = 1,
endfreq = 20,
limit = 0.1,
t_gate = 0 |

var source = WhiteNoise.ar;

var delayTimeEnv = Env.new(
	levels: [startfreq, startfreq, endfreq],
	times: [0, len],
	curve: 'exp');

var delayTimeEnvGen = EnvGen.kr(
	delayTimeEnv,
	gate: t_gate,
	doneAction: 0).reciprocal;

var ampEnv = Env(
	levels: [0, 0, att, dec, sus, 0],
	times: [0, attime, dectime, sustime, reltime].normalizeSum * len,
	curve:	'lin');

var ampEnvGen = EnvGen.ar(
	ampEnv,
	gate: t_gate,
	doneAction: 0);

var resonator = Streson.ar(
	source,
	delayTime: delayTimeEnvGen,
	res: res,
	mul: (ampEnvGen * amp));

	Out.ar(out, Limiter.ar(Sanitize.ar(resonator, 0), limit, 0.01));

}).add;



(

SynthDef(\testEnvSynth, {|
out = 0,
attime = 0.2,
dectime = 0.2,
sustime = 0.3,
reltime = 0.4,
len = 1,
sus = 1,
dec = 1,
att = 0.2,
res = 0.9,
amp = 0.25,
startfreq = 1,
endfreq = 20,
limit = 0.1,
t_gate = 0 |

var source = WhiteNoise.ar;

var delayTimeEnv = Env.new(
	levels: [startfreq, startfreq, endfreq],
	times: [0, len],
	curve: 'exp');

var delayTimeEnvGen = EnvGen.kr(
	delayTimeEnv,
	gate: t_gate,
	doneAction: 0).reciprocal;

var ampEnv = Env(
	levels: [0, 0, att, dec, sus, 0],
	times: [0, attime, dectime, sustime, reltime].normalizeSum * len,
	curve:	'lin');

var ampEnvGen = EnvGen.ar(
	ampEnv,
	gate: t_gate,
	doneAction: 0);

var resonator = Streson.ar(
	source,
	delayTime: delayTimeEnvGen,
	res: res,
	mul: (ampEnvGen * amp));

	Out.ar(out, Limiter.ar(Sanitize.ar(resonator, 0), limit, 0.01));

}).add;


)


s.boot

(
p = Pmono(\testEnvSynth,
    \dur, Pdefn(\srM1dur, 5, inf),
	\out, Pdefn(\srM1out, Prand([0, 1], inf)),
    \startfreq, Pdefn(\srM1startfreq, 40, inf),
    \endfreq, Pdefn(\srM1endfreq, 40, inf),
    \len, Pdefn(\srM1len, 3, inf),
    \gate, Pdefn(\srM1t_gate, 1, inf),
    \res, Pdefn(\srM1res, 0.99, inf),
    \amp, Pdefn(\srM1amp, 0.01, inf),
    \att, Pdefn(\srM1att, 0.5, inf),
    \dec, Pdefn(\srM1dec, 0.5, inf),
    \sus, Pdefn(\srM1sus, 0.5, inf),
    \attime, Pdefn(\srM1attime, 1, inf),
    \dectime, Pdefn(\srM1dectime, 1, inf),
    \sustime, Pdefn(\srM1sustime, 1, inf),
	\reltime, Pdefn(\srM1reltime, 0.5, inf)
).play;
)


Pdefn(\srM1t_gate, 1, inf)

p.stop;

)


