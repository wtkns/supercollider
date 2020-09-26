(
var score, blip, blipOut, resonz, resonzOut, gVerb, gVerbOut, myBuses;

Server.default = s = Server.internal;
s.boot;
s.waitForBoot({
//	s.scope;
//	f = FreqScope.new; 


	// Buses
	blipOut = CtkAudio.new(server: s);
	resonzOut = CtkAudio.new(server: s);
	gVerbOut = CtkAudio.new(server: s);
	blipOut.bus.postln;
	myBuses = [blipOut];

	// Blip Generator		
	blip = CtkSynthDef(\blip, {arg dur, freq, amp, numharms, env, outbus;
		var pulse;
		numharms = (SampleRate.ir * 0.4) / freq;
		pulse = Blip.ar(freq, numharms.floor, amp.dbamp);		Out.ar(outbus, pulse *env);
	});
	
	resonz =  CtkSynthDef(\resonz, {arg dur, freq, amp, outbus, inbus, env, bw;
		var  reson, bal, src;
		src = In.ar(inbus);
		
		reson = Resonz.ar(src, 
					freq, 
					(bw / freq));
		
		//reson = Balance.ar(reson, src, 20);
		Out.ar(outbus, reson * env);
	});
	
	gVerb = CtkSynthDef(\gVerb, {arg dur, amp, env, outbus, inbus, roomsize, revtime, damping, inputbw, spread, drylevel, earlylevel, taillevel;
		var src, reverb;
		src = In.ar(inbus);

		reverb = GVerb.ar(src,
						roomsize, 
						revtime, 
						damping, 
						inputbw, 
						spread, 
						drylevel.dbamp,
						earlylevel.dbamp, 
						taillevel.dbamp
						);
			
			Out.ar(outbus, reverb);
	});

	
		score = CtkScore.new;
		
		//a.note(0.0, 5.0).dur_(5.0).freq_(440).amp_(-3).play;
		score.add(resonz.note
			(0.1, 60.0, addAction: \tail,  target: 1)
			.freq_(CtkControl.env(Env([110, 6000 ], [1.0], \exp), timeScale: 60))
			.dur_(60.0)
			.outbus_(resonzOut)
			.inbus_(blipOut)
			.env_(CtkControl.env(Env([0, 1, 1, 0], [0.05, 0.9, 0.05], \sin), timeScale: 60))
			.bw_(CtkControl.env(Env([10000, 1000, 1, 1], [0.2, 0.6, 0.2]), timeScale: 60))
		); 
		
		score.add(gVerb.note
			(0.1, 60.0, addAction: \tail,  target: 1)
			.env_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.95, 0.05], \lin), timeScale: 60))
			.dur_(60)
			.outbus_(0)
			.inbus_(resonzOut)
			.amp_(-4) 
			.roomsize_(80)
			.revtime_(4.85)
			.damping_(0.41)
			.inputbw_(0.19)
			.spread_(0)
			.drylevel_(-3)
			.earlylevel_(-9)
			.taillevel_(-11)
		); 
		


		score.add(blip.note
			(0.1, 60.0, addAction: \head,  target: 1)
			.freq_(CtkControl.env(Env([100, 30, 6 ], [0.25 0.75], \lin), timeScale: 60)) 
			.env_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.95, 0.05], \lin), timeScale: 60))
			.dur_(60)
			.outbus_(blipOut)
			.amp_(-4) 
		); 


		score.play;

})
)