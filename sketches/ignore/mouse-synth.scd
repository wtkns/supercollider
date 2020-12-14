(

var synth, note;

synth = CtkSynthDef(\myTest, {
	Out.ar(0, Pan2.ar(
		SinOsc.ar(
			MouseX.kr(300, 600, \exponential)
			)
		)
	)
});

note = synth.note(0.0, 10.0).play;
)
