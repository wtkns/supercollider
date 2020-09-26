(
s = Server.default;
ServerOptions.devices;
s.options.device_("JackRouter");
s.boot;
)

(

//with OSC

a = SynthDef(\testDef, {arg freq;
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, 0, 0.3)))
});

a.load(s);

s.sendMsg(\s_new, \testDef, 1000, 0, 1, \freq, 540);

s.sendMsg(\n_free, 1000);


)

(

// for prototyping.. repl...

c = {Pan2.ar(SinOsc.ar(440, 0, 0.3))}.play;

c.free;

)

(

// 'Normal' SuperCollider = SynthDef
a = SynthDef(\mySynthDef, {arg freq;
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, 0, 0.3)))
}).load(s);

// Ctk - CtkSynthDef - no need to load - it does it for you
(
a = CtkSynthDef(\testDef, {arg freq;
		Out.ar(0, Pan2.ar(SinOsc.ar(freq, 0, 0.3)))
	});
)
// create a 'Synth' - this is basically a formatter for OSC messages, nothing else
b = Synth(\testDef, [\freqs, 440]); // plays automatically
b.set(\freq, 550);
b.free;

// Ctk - uses the CtkSynthDef as a prototype for the notes... send it the 'note' message
b = a.note;
b.freq_(550);
b.freq; // CtkNotes store info like other instance of a class
b.play;
// change a parameter by setting another value:
b.freq_(660);
b.free;

/*
Interaction between the language and the server - a quick demo
*/

// boot the server...
Server.default = s = Server.internal;
s.boot;
// turn on the scope... this shows the samples that are being written to the output
s.scope;

)
