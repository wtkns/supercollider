(
s = Server.default;
ServerOptions.devices;
s.options.device_("JackRouter");
s.boot;
)
(
var sd, roots, partials, tonic, times, baseDur;

tonic = 80.0;
partials = [2,2.5];
baseDur = 1;
roots = [tonic, 1.25 * tonic, 2 * tonic];

thisThread.randSeed = 4;


sd = CtkSynthDef(\myNote, {arg freq, pan = 0, dur = baseDur;
	var sin, env;
	env = XLine.kr(1, 0.00001, dur);
	sin = SinOsc.ar(freq, 0, 0.15);
	Out.ar(0, Pan2.ar(sin * env, pan));
}).send(s);


roots.do({arg thisFreq, i;
	var aNote;
	aNote = sd.note(baseDur*i, baseDur).freq_(thisFreq).pan_(1).dur_(baseDur);

	partials.do({arg thisPart, u;
		var aPart;
		aPart = sd.note(baseDur*i, baseDur).freq_(thisFreq * thisPart).pan_(-1).dur_(baseDur);
		aPart.play;
	});

	aNote.play;
});

)

(

var sd, roots, partials, tonic, times;

sd = CtkSynthDef(\myNote, {arg
	freq,
	env;
	//pan;
	var sin;
	sin = SinOsc.ar(freq, 0, 0.05);
	Out.ar(0, Pan2.ar(sin));
}).send(s);

tonic = 440.0;
partials = [1.0/4.0, 2.0/4.0, 3.0/4.0];
roots = [tonic, tonic+6.rand+(tonic/(4.rand))];

roots.do({arg thisFreq, i;
	var aNote;
	aNote = sd.note(0.1, 15.rand).freq_(thisFreq);

	partials.do({arg thisPart, u;
		var aPart;
		aPart = sd.note(15.rand, 15.rand).freq_(thisFreq+thisFreq * thisPart);
		aPart.play;
	});

	aNote.play;
});

)
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;