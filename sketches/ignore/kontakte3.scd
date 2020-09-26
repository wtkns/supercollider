(
var score, blip, length;
var ex3,ex4,ex5,ex6,tail1;
var soundfile, sndBuf, cmdPeriod, playBuffer;
var playRate;

	playRate = 1/4;
	ex3 = 1.2 / playRate;
	ex4 = 2.5 / playRate;
	ex5 = 14.5 / playRate;
	ex6 = 21.5 / playRate;
	tail1 = 12 / playRate;
	
	length = ex3+ex4+ex5+ex6+tail1;
		

Server.default = s = Server.internal;
s.boot;
s.waitForBoot({
	
	sndBuf = CtkBuffer.playbuf("~/dx461-au11-james/Kontakte/KontakteExcerpt.aif".standardizePath);
	
	cmdPeriod = {
		sndBuf.free;
		"Command Period freed buffers!".postln;
	};
	
	CmdPeriod.doOnce(cmdPeriod);
	
	sndBuf.load; // load the buffer to memory ...
	s.sync;		 // and pause execution until the buffer is loaded
	
		("Info about soundfile at" + sndBuf.path + 
		"Duration:"+ sndBuf.duration +
		"SampleRate: " + sndBuf.sampleRate +
		"Num Channels" + sndBuf.numChannels).postln;
		
	s.scope;
	f = FreqScope.new; 

	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1;
		var src, env;
		env = EnvGen.kr(
			Env([0, 1, 1, 0], [0.1, BufDur.kr(buffer) - 0.2, 0.1], \sin));
		src = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer), 1,
			startPos * BufSampleRate.kr(buffer), 0 );
		Out.ar(0, Pan2.ar(src * env, 1));
	});

	blip = CtkSynthDef(\blip, {arg dur, fundFreq, formFreq, bandWidth, amp, accFactor, 			mix1=0,room1=0,damp1=0,mix2=0,room2=0,damp2=0;
			var env, pulse, numharms, reson, bal, rq, ampScale, reverb1, reverb2;
			fundFreq = fundFreq*accFactor;
			formFreq = formFreq*accFactor;
			rq = bandWidth/formFreq;
			ampScale = 1/rq;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.1, dur - 0.2, 0.1], \lin));
			numharms = (SampleRate.ir*0.4) / fundFreq;
			pulse = Blip.ar(fundFreq, numharms.floor, amp);
			reson = Resonz.ar((pulse*env), formFreq, rq, ampScale);
			reverb1 = FreeVerb.ar(reson,mix1,room1,damp1);
			reverb2 = FreeVerb.ar(reverb1,mix2,room2,damp2);
			Out.ar(0, Pan2.ar(reverb2, -1));
	});
	
		score = CtkScore.new;

		score.add(blip.note
			(0.1, ex3, addAction: \head,  target: 1)
			.dur_(ex3)
			.amp_(CtkControl.env(
				Env([1.66, 2], [1]
				, \lin), timeScale: ex3)) 
			.fundFreq_(17.6)
			.formFreq_(CtkControl.env(
				Env([100, 250], [1]
				, \sin), timeScale: ex3))	
			.bandWidth_(250)
			.accFactor_(10) 
			.mix1_(CtkControl.env(
				Env([1,1,0], [0.75,0.25]
				, \lin), timeScale: ex3))
			.room1_(CtkControl.env(
				Env([1,0], [1]
				, \exp), timeScale: ex3))
			.damp1_(CtkControl.env(
				Env([1,0], [1]
				, \exp), timeScale: ex3))		
		); 

		score.add(blip.note
			(ex3, ex4, addAction: \head,  target: 1)
			.dur_(ex4)
			.amp_(CtkControl.env(
				Env([2, 1], [1]
				, \lin), timeScale: ex4)) 
			.fundFreq_(CtkControl.env(
				Env([17.6, 16.6, 8, 9.4, 5.3, 6.8, 4.0], [0.6, 0.3, 0.16, 0.16, 0.16, 0.16]
				, \exp), timeScale: ex4))
			.formFreq_(CtkControl.env(
				Env([250, 150, 20, 150], [0.1,0.45,0.45]
				, \exp), timeScale: ex4))
			.bandWidth_(70)
			.accFactor_(CtkControl.env(
				Env([10,7], [1], \lin)
				, timeScale: ex4)) 
		); 		

		score.add(blip.note
			(ex3+ex4-0.2, ex5, addAction: \head,  target: 1)
			.dur_(ex5)
			.amp_(CtkControl.env(
				Env([1, 1, 0.25], [0.3,0.7]
				, \lin), timeScale: ex5)) 
			.fundFreq_(CtkControl.env(
				Env([4.0, 0.725], [1]
				, \exp), timeScale: ex5))
			.formFreq_(CtkControl.env(
				Env([150, 200, 125, 75, 100, 50, 75, 54, 54], [1/14,1/14,1/14,1/14,1/14,1/14,1/14,1/14]
				, \exp), timeScale: ex5))
			.bandWidth_(CtkControl.env(
				Env([70, 30, 20, 10], [0.25,0.25,0.5]
				, \lin), timeScale: ex5))
			.accFactor_(CtkControl.env(
				Env([7,3.6363,3.6363,], [0.3,0.7]
				, \lin), timeScale: ex5)) 
		);

		score.add(blip.note
			(ex3+ex4+ex5+0.25, ex6, addAction: \head,  target: 1)
			.dur_(ex6)
			.amp_(CtkControl.env(
				Env([0.25, 0.33, 0.11, 0.03, 0.016], [0.25,0.25,0.25,0.25]
				, \lin), timeScale: ex6)) 
			.fundFreq_(CtkControl.env(
				Env([1.0, 0.45, 1.7, 0.58, 1.2, 0.82, 0.42, 0.11, 0.11], [1/8, 1/8,1/8,1/8,1/8,1/8,1/8,1/8]
				, \exp), timeScale: ex6))
			.formFreq_(CtkControl.env(
				Env([54, 54, 154.44, 50, 75, 54, 54], [1/6, 1/6, 1/6, 1/6, 1/6, 1/6]
				, \exp), timeScale: ex6))
			.bandWidth_(CtkControl.env(
				Env([10, 10, 100, 5, 0.1, 0.1], [0.16, 0.01, 0.07, 0.46, 0.3]
				, \lin), timeScale: ex6))
			.accFactor_(3.6363) 
		);
		
		score.add(blip.note
			(ex3+ex4+ex5+ex6+0.25, tail1, addAction: \head,  target: 1)
			.dur_(tail1)
			.amp_(CtkControl.env(
				Env([0.016, 0.16], [1]
				, \lin), timeScale: tail1)) 
			.fundFreq_(0.01)
			.formFreq_(162)
			.bandWidth_(0.05)
			.accFactor_(1) 
		);
		
		score.add(playBuffer.note
			(0.1, sndBuf.duration)
			.buffer_(sndBuf).
			startPos_(0).
			rate_(playRate)
			);
			
		score.write("~/Desktop/test.aif".standardizePath, options: 
		ServerOptions.new.numOutputBusChannels_(2));	
								
		score.play;

})
)


