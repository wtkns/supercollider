(

// using Score and NRT
var workFolder = "/Users/james/git/wtkns/solo/output/";
var oscFilePath = workFolder++"osc-test.osc";
var audioFilePath = workFolder++"audio-test.aiff";
var score = CtkScore.new;


Server.default=Server.local;
s.boot;

s.doWhenBooted({
	
	SynthDescLib.read;
	"Booted".postln;

	// a SynthDef
	CtkSynthDef(\test, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1 |
		var audio = Blip.ar(freq, nharms, amp);
		var env = Linen.kr(gate, doneAction: Done.freeSelf);
		OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
	});

	s.sync;

	p = Pbind(
		\instrument, \test,
		\nharms, Pseq([4, 10, 40], inf),
		\dur, Pseq([1, 1, 2, 1]/10, inf),
		#[freq, sustain], Ptuple([ // assignment to multiple keys
			Pseq( (1..16) * 50, 4),
			Pseq([1/10, 0.5, 1, 2], inf)
		])
	);
	

	score.add(p.asScore(12.0));

	o = ServerOptions.new.numOutputBusChannels = 2; // mono output

	// score.play;
	// score.asCompileString.postln
	
	Score.recordNRT(
		score.score,
		oscFilePath,
		audioFilePath,
		options: o); // synthesize

});

)