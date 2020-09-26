(
var score, blipgen, blipOut, moogy;
thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	s.scope;
	f = FreqScope.new; 
	score = CtkScore.new;
	blipOut = CtkAudio.new(server: s);
	blipOut.bus.postln;


	// source - out on bus 'blip'
	blipgen = CtkSynthDef(\blipOut, {
		Out.ar(blipOut, Blip.ar(Line.kr(1,100,20), Line.kr(1,100,20), 0.8))
	});
	
	// filter
	moogy = CtkSynthDef(\moogy, {
		var src, filter;
		src = In.ar(blipOut);
		filter = MoogFF.ar(src,SinOsc.kr(LFNoise0.kr(0.42).range(0.001,2.2)).range(30,4200), 0.83 * 4);
	 	
	 	Out.ar(0, Pan2.ar(filter, 0))
	 });

	score.add(blipgen.note(0.1, 60.0));
	score.add(moogy.note(0.1, 20.0));
	score.add(moogy.note(6.0, 15.0));

	score.play;

});	
)
