//beep

// sample modal drone
// james watkins
// 29.12.2015


/*

1. initialize metadata for song
** Populate freqArray
*** use

*/

(
s = Server.default;
ServerOptions.devices;
s.options.device_("JackRouter");
s.boot;
)


(
var sd, root, scale, partials, tonic, times, baseDur, phraseLength, sectionLength, prob;

// section
root = 200.0;
partials = [1, 1.5];
baseDur = 0.5;
scale = [1/1,5/4,3/2,7/4,11/8,13/8,17/16,19/16];
prob = 0.5;
sectionLength = 10;
phraseLength = 10;
thisThread.randSeed = 4;


sd = CtkSynthDef(\myNote, {arg freq, pan = 0, dur;
	var sin, env;
	env = XLine.kr(1, 0.00001, dur);
	sin = SinOsc.ar(freq, 0, 0.15);
	Out.ar(0, Pan2.ar(sin * env, pan));
}).send(s);

scale.do({arg thisNote, i;
	i.postln;
	partials.do({arg thisPart, u;
		var aNote = sd.note(baseDur*i, baseDur*50).freq_(root*thisNote*thisPart).dur_(baseDur*20.rand).pan_(0);
		(root*thisNote*thisPart).postln;
		aNote.play;
	});
	"".postln;
});

)
