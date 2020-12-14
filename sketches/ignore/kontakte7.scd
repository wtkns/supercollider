(
var score, blip, length;
var n1,n2,n3,n4,n5,n6;
var soundfile, sndBuf, cmdPeriod, playBuffer;
var playRate, playSamp, synthPan, sampPan;
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

	score = CtkScore.new;
	playRate = 1;
	playSamp = true;
	synthPan = 0;
	n1 = 1.35 / playRate;
	n2 = 2 / playRate;
	n3 = 9 / playRate;
	n4 = 8 / playRate;
	n5 =  7/ playRate;
	n6 = (45 -  (n1 + n2 + n3 + n4 + n5) ) / playRate;

	
		("Info about soundfile at" + sndBuf.path + 
		"Duration:"+ sndBuf.duration +
		"SampleRate: " + sndBuf.sampleRate +
		"Num Channels" + sndBuf.numChannels).postln;
		
	s.scope;
	f = FreqScope.new; 

	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1, pan;
		var src, env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.1, BufDur.kr(buffer) - 0.2, 0.1], \sin));
		src = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer), 1,
			startPos * BufSampleRate.kr(buffer), 0 );
		Out.ar(0, Pan2.ar(src * env, pan));
	});

	blip = CtkSynthDef(\blip, {arg dur, fundFreq, formFreq, bandWidth, amp, accFactor, pan, mix1=0,room1=0,damp1=0,mix2=0,room2=0,damp2=0;
			var env, pulse, numharms, reson, bal, rq, ampScale, reverb1, reverb2;
			fundFreq = fundFreq*accFactor;
			formFreq = formFreq*accFactor;
			rq = bandWidth/formFreq;
			ampScale = 1/rq;
			env = EnvGen.kr(Env([0.01, 1, 1, 0.01], [0.1, dur - 0.2, 0.1], \exp));
			numharms = (SampleRate.ir*0.4) / fundFreq;
			pulse = Blip.ar(fundFreq, numharms.floor, amp);
			reson = Resonz.ar((pulse*env), formFreq, rq, ampScale);
			reverb1 = FreeVerb.ar(reson,mix1,room1,damp1);
			reverb2 = FreeVerb.ar(reverb1,mix2,room2,damp2);
			Out.ar(0, Pan2.ar(reverb2, pan));
	});
	
		if ( playSamp == true, {
			synthPan = -1;
			sampPan = 1;

			score.add(playBuffer.note
				(0, n1)
				.buffer_(sndBuf)
				.startPos_(0)
				.rate_(playRate)
				.pan_(sampPan)
				);
	
			score.add(playBuffer.note
				(n1, n2)
				.buffer_(sndBuf)
				.startPos_(n1)
				.rate_(playRate)
				.pan_(sampPan)
				);
	
			score.add(playBuffer.note
				(n1 + n2, n3)
				.buffer_(sndBuf)
				.startPos_(n1 + n2)
				.rate_(playRate)
				.pan_(sampPan)
				);			
	
			score.add(playBuffer.note
				(n1 + n2 + n3, n4)
				.buffer_(sndBuf)
				.startPos_(n1 + n2 + n3)
				.rate_(playRate)
				.pan_(sampPan)
				);
	
			score.add(playBuffer.note
				(n1 + n2 + n3 + n4, n5)
				.buffer_(sndBuf)
				.startPos_(n1 + n2 + n3 + n4)
				.rate_(playRate)
				.pan_(sampPan)
				);
	
			score.add(playBuffer.note
				(n1 + n2 + n3 + n4 + n5, n6)
				.buffer_(sndBuf)
				.startPos_(n1 + n2 + n3 + n4 + n5)
				.rate_(playRate)
				.pan_(sampPan)
				);
				
		});
		

		score.add(blip.note
			(0.1, n1, addAction: \head,  target: 1)
			.dur_(n1)
			.pan_(synthPan)
			.amp_(CtkControl.env(
				Env([0.75, 1, 1], [0.5, 0.5]
				, \sin), timeScale: n1)) 
			.fundFreq_(17.6)
			.formFreq_(CtkControl.env(
				Env([70, 175], [1]
				, [\exp, \exp]), timeScale: n1))			.bandWidth_(CtkControl.env(
				Env([50, 40], [1]
				, [\lin]), timeScale: n1))
			.accFactor_(CtkControl.env(
				Env([10, 10,], [1]
				, \sin), timeScale: n1)) 	
		); 


		score.add(blip.note
			(n1, n2, addAction: \head,  target: 1)
			.dur_(n2)
			.pan_(synthPan)
			.amp_(CtkControl.env(
				Env([1, 1.2], [1]
				, \sin), timeScale: n2)) 
			.fundFreq_(CtkControl.env(
				Env([17.6, 15.6, 16.6], [0.5,0.5]
				, \sin), timeScale: n2))
			.formFreq_(CtkControl.env(
				Env([175, 120, 140], [0.5,0.5]
				, [\exp, \lin]), timeScale: n2))			.bandWidth_(CtkControl.env(
				Env([40, 15, 30], [0.5, 0.5]
				, \sin), timeScale: n2))
			.accFactor_(CtkControl.env(
				Env([10, 6, 7.5], [0.5,0.5]
				, \sin), timeScale: n2)) 	
		); 



		score.add(blip.note
			(n1+n2, n3, addAction: \head,  target: 1)
			.dur_(n3)
			.pan_(synthPan)
			.amp_(CtkControl.env(
				Env([1.2, 3], [1]
				, \sin), timeScale: n3)) 
			.fundFreq_(CtkControl.env(
				Env([16.6, 8, 12.4, 5.3, 6.8, 3.8], [0.3, 0.16, 0.16, 0.16, 0.16]
				, \sin), timeScale: n3))
			.formFreq_(CtkControl.env(
				Env([140, 160, 80, 110, 80], [0.2,0.2,0.2,0.4]
				, \exp), timeScale: n3))
			.bandWidth_(CtkControl.env(
				Env([30, 10, 20, 30], [0.5, 0.25, 0.25]
				, \sin), timeScale: n2))
			.accFactor_(CtkControl.env(
				Env([7.5, 3,4, 3.6363], [1/4,1/2,1/4], \exp)
				, timeScale: n3)) 
		); 		


		score.add(blip.note
			(n1+n2+n3, n4, addAction: \head,  target: 1)
			.dur_(n4)
			.pan_(synthPan)
			.amp_(2) 
			.fundFreq_(CtkControl.env(
				Env([3.8, 0.725, 0.725], [0.75,0.25]
				, \sin), timeScale: n4))
			.formFreq_(CtkControl.env(
				Env([80, 75, 100, 50, 75, 54, 54], [1/6,1/6,1/6,1/6,1/6,1/6]
				, \exp), timeScale: n4))
			.bandWidth_(CtkControl.env(
				Env([30, 20, 30, 10], [0.25,0.25,0.5]
				, \lin), timeScale: n4))
			.accFactor_(CtkControl.env(
				Env([3.6363,3.6363,], [1]
				, \lin), timeScale: n4))
			.mix1_(CtkControl.env(
				Env([0.1,0.5,0.5], [0.15,0.85]
				, \exp), timeScale: n4))
			.room1_(0.75)
			.damp1_(0)	
		);

		score.add(blip.note
			(n1+n2+n3+n4, n5, addAction: \head,  target: 1)
			.dur_(n5)
			.pan_(synthPan)
			.amp_(2) 
			.fundFreq_(CtkControl.env(
				Env([1.0, 0.11], [1]
				, \sin), timeScale: n5))
			.formFreq_(CtkControl.env(
				Env([54, 54, 154.44, 50, 75, 54, 54], [0.05, 0.05, 0.05, 0.05, 0.4, 0.5]
				, \exp), timeScale: n5))
			.bandWidth_(5)
			.accFactor_(3.6363) 
			.mix1_(0.5)
			.room1_(0.75)
			.damp1_(0)	
		);

		score.add(blip.note
			(n1+n2+n3+n4+n5, n6, addAction: \head,  target: 1)
			.dur_(n6)
			.pan_(synthPan)
			.amp_(CtkControl.env(
				Env([2, 0.5, 0], [0.2, 0.8]
				, \lin), timeScale: n6)) 
			.fundFreq_(0.11)
			.formFreq_(50)
			.bandWidth_(5)
			.accFactor_(3.6363) 
			.mix1_(0.5)
			.room1_(0.75)
			.damp1_(0)	
		);
						
//		score.write("~/Desktop/test.aif".standardizePath, options: 
//		ServerOptions.new.numOutputBusChannels_(2));

		score.play;

})
)


