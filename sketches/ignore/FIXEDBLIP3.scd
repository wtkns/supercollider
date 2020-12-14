(
var score, blipgen, blipOut, moogy, moogOut, myBuses;
thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	s.scope;
	f = FreqScope.new; 


	// Buses
	blipOut = CtkAudio.new(server: s);
	moogOut = CtkAudio.new(server: s);
	blipOut.bus.postln;
	myBuses = [blipOut, moogOut];

	// Blip Generator		
	blipgen = CtkSynthDef(\blipgen, {arg env, freq, numharms, dur, outbus;
		Out.ar(outbus, Blip.ar(freq, numharms, env))
	});
	
	// Moog filter
	moogy = CtkSynthDef(\moogy, {arg pan, env, amp = 1, dur, outbus, inbus;
		var src, filter;
		src = In.ar(inbus);
		filter = MoogFF.ar(src,SinOsc.kr(LFNoise0.kr(0.42).range(0.001,2.2)).range(30,4200), 0.83 * 4);
	 	Out.ar(outbus, Pan2.ar(filter, pan, env));
	 });

	score = CtkScore.new;

		score.add(blipgen.note
			(0.2, 20.0, addAction: \head,  target: 1)
			.freq_(CtkControl.env(Env([10, 100], [1.0], \exp), timeScale: 20)) 
			.numharms_(CtkControl.env(Env([10, 100], [1.0], \exp), timeScale: 20))
			.env_(CtkControl.env(Env([0.01, 0.95, 0.01], [0.05, 0.95], \lin), timeScale: 20))
			.dur_(20)
			.outbus_(blipOut)
		); 

	10.do({arg i;		
		score.add(moogy.note
			(0.1, 20, addAction: \tail, target: 1) 
			.inbus_(blipOut)
			.pan_(CtkControl.env(Env([-0.8, 0.8, 0], [0.2, 0.8], \lin), timeScale: 20))
			.env_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.9, 0.05], \lin), timeScale: 20))
			.dur_(20)
			.amp_(0.8)
			.outbus_(o)
		);
	});
	
	score.play;

	s.queryAllNodes;

});	
)