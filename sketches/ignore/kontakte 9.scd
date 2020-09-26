(
var score, blip, length, ex3,ex4,ex5,ex6,tail1;
		ex3 = 6.0;
		ex4 = 8.0;
		ex5 = 12.0;
		ex6 = 12.0;
		tail1 = 7;
		length = ex3+ex4+ex5+ex6+tail1;

Server.default = s = Server.internal;
s.boot;
s.waitForBoot({
//	s.scope;
//	f = FreqScope.new; 

blip = CtkSynthDef(\blip, {arg dur, freq, amp, cf;
			var env, pulse, numharms, reson, bal;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
			numharms = (SampleRate.ir * 0.4) / freq;
			pulse = Blip.ar(freq, numharms.floor, amp.dbamp);


	// evnvelope will start at 4 * freq, and will move to 5 * freq 
	// over 0.2 * dur in time.


	// bw is always 1% of the cf.  This can be plugged straight into the 
	// rq argument since:
	// (0.01 * cf) / cf = 0.01
			reson = Resonz.ar(pulse, cf, 0.01, 1);
	// Here, the balance greatly affects the output! Try both;
		reson = Balance.ar(reson, pulse, 50);
			Out.ar(0, reson * env);
	});
	
		score = CtkScore.new;
		score.add(blip.note
			(0.1, ex3, addAction: \head,  target: 1)
			.dur_(ex3)
			.amp_(0) 
			.freq_(400) 
			.cf_(CtkControl.env(Env([4, 5, 1, 2], [0.2, 0.7, 0.1]), levelScale: freq, timeScale: ex3))
		); 
		
		score.play;

})
)
