(

// from http://modularbrains.net/dx490a/DX490A_su2010_14.1_[Patterns].html

var score, note, pitch, dur, now, thisDur;

score = CtkScore.new;

note = CtkSynthDef(\test, {arg freq, dur;

	var env;

	env = EnvGen.kr(Env([0, 1, 0], [0.05, dur-0.05], [2, -2]));

	Out.ar(0, SinOsc.ar(freq, 0, 0.1 * env))

});


(
var pitch = Pseq([\a4, \cs5, \e5, \c5, \a4, \e4, \gs4], inf).asStream;

var dur = Pseq(2/[4, 8, 8, 4, 4, 8], inf).asStream;

var now = 0;

25.do({

	dur.next.postln;

	///score.add(note.new(now, thisDur).freq_(pitch.next.hertz).dur_(thisDur));

	//	now = now + (thisDur * 0.5)

});

)
score.play;

)
