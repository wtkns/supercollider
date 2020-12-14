(
var score, blip, length, ex3,ex4,ex5,ex6,tail1;
		ex3 = 4.1;
		ex4 = 4.07;
		ex5 = 14.5;
		ex6 = 21.5;
		tail1 = 12;
		length = ex3+ex4+ex5+ex6+tail1;

Server.default = s = Server.internal;
s.boot;
s.waitForBoot({
//	s.scope;
//	f = FreqScope.new; 

blip = CtkSynthDef(\blip, {arg dur, fundFreq, formFreq, bandWidth, amp, accFactor;
			var env, pulse, numharms, reson, bal, rq;
			fundFreq = fundFreq*accFactor;
			formFreq = formFreq*accFactor;
			rq = bandWidth/formFreq;
			//env = EnvGen.kr(Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01], \sin));
			numharms = (SampleRate.ir*0.4) / fundFreq;
			pulse = Blip.ar(fundFreq, numharms.floor, amp.dbamp);
			reson = Resonz.ar(pulse, formFreq, rq, 1);
			//reson = Balance.ar(reson, pulse, 50);
			Out.ar(0, reson);
	});
	
		score = CtkScore.new;
		score.add(blip.note
			(0.1, ex3, addAction: \head,  target: 1)
			.dur_(ex3)
			.amp_(30) 
			.fundFreq_(17.6)
			.formFreq_(CtkControl.env(
				Env([20, 40, 30, 60,50, 100, 75, 150], [0.125,0.125,0.125,0.125,0.125,0.125, 0.25]
				, \exp), timeScale: ex3))
			.bandWidth_(70)
			.accFactor_(10) 
			//.accFactor_(CtkControl.env(Env([10,7], [1], \lin), timeScale: ex3)) 
		); 
		
		score.play;

})
)

