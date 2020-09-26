(
var score, blip, blipOut, resonz, resonzOut, gVerb, gVerbOut, myBuses;

Server.default = s = Server.internal;
s.boot;
s.waitForBoot({
//	s.scope;
//	f = FreqScope.new; 


	// Buses
	blipOut = CtkAudio.new(server: s);
	blipOut.bus.postln;
	myBuses = [blipOut];

	// Blip Generator		
	blip = CtkSynthDef(\blip, {arg dur = 10, freq = 440, amp = 1, numharms = ((SampleRate.ir * 0.4) / freq), env, outbus = 0;
		var pulse;
		pulse = Blip.ar(freq, numharms.floor, amp.dbamp);		Out.ar(outbus, pulse *env);
	});
	
	resonz =  CtkSynthDef(\resonz, {arg dur, freq, amp, outbus, inbus;
		var env, pulse, numharms, bw, reson, bal;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
		//numharms = (SampleRate.ir * 0.4) / freq;
		// a pulse generator
		// pulse = Blip.ar(freq, numharms.floor, amp.dbamp);
		// in EnvGen, timeScale will scale the time values in the envelope.
		// if these values are percentages, this can be a useful way to alter
		// envelopes based on a notes duration.  bw will control the bandwidth
		bw = EnvGen.kr(Env([10000, 1000, 1, 1], [0.2, 0.6, 0.2]), timeScale: dur);
		// Resonz.ar(arg in, freq, rq, mul, add);
		// rq is the reciprocal of q, or bandwidth / centerfreq.
		// Resonz is a two pole filter that is effetively a resonant 
		// band pass filter
		reson = Resonz.ar(inbus, freq, (bw / freq));
		//reson = Balance.ar(reson, inbus, 20);
		Out.ar(outbus, reson * env);
	});
	
//	gVerb = CtkSynthDef(\gVerb, {arg dur, freq, amp, env, outbus, inbus;
//		var reverb, roomsize, revtime, damping, inputbw, spread, drylevel, earlylevel, taillevel;
//		reverb = GVerb.ar(
//		inbus,
//		roomsize, 
//		revtime, 
//		damping, 
//		inputbw, 
//		spread, 
//		drylevel.dbamp,
//		earlylevel.dbamp, 
//		taillevel.dbamp,
//		roomsize, 0.3);
//		
//			Out.ar(outbus, reverb * env);
//	});

	
		score = CtkScore.new;
		
		//a.note(0.0, 5.0).dur_(5.0).freq_(440).amp_(-3).play;
		
		score.add(blip.note
			(0.1, 60.0, addAction: \head,  target: 1)
			.freq_(CtkControl.env(Env([1, 11000 ], [1.0], \lin), timeScale: 60)) 
			//.numharms_(CtkControl.env(Env([30, 100], [1.0], \exp), timeScale: 60))
			.env_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.95, 0.05], \lin), timeScale: 60))
			.dur_(60)
			.outbus_(blipOut)
		);
		
		score.add(resonz.note
			(0.1, 10.0, addAction: \tail,  target: 1)
			.freq_(CtkControl.env(Env([110, 6 ], [1.0], \exp), timeScale: 10))
			.amp_(-3) 
			.dur_(10.0)
			.outbus_(0)
			.inbus_(blipOut)
		); 


 


		score.play;

})
)