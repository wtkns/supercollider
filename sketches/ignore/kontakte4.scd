(
var score, blip, length;
var n1,n2,n3,n4,n5,n6;
var soundfile, sndBuf, cmdPeriod, playBuffer;
var playRate, playSamp;
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
		env = 1;//EnvGen.kr(
			//Env([0, 1, 1, 0], [0.1, BufDur.kr(buffer) - 0.2, 0.1], \sin));
		src = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer), 1,
			startPos * BufSampleRate.kr(buffer), 0 );
		Out.ar(0, Pan2.ar(src * env, 1));
	});

	blip = CtkSynthDef(\blip, {arg dur, fundFreq, formFreq, bandWidth, amp, accFactor, mix1=0,room1=0,damp1=0,mix2=0,room2=0,damp2=0;
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
		playRate = 1;
		playSamp = false;

		notes = [1.35,2,9,8,7,45-n.integrate] // / playRate;

		if ( playSamp == true, {
			score.add(playBuffer.note
				(0.1, notes[0])
				.buffer_(sndBuf).
				startPos_(0).
				rate_(playRate)
				);
	
			score.add(playBuffer.note
				(notes[0], notes[1])
				.buffer_(sndBuf).
				startPos_(notes[0]).
				rate_(playRate)
				);
	
			score.add(playBuffer.note
				(notes[0] + notes[1], notes[2])
				.buffer_(sndBuf).
				startPos_(notes[0] + notes[1]).
				rate_(playRate)
				);			
	
			score.add(playBuffer.note
				(notes[0] + notes[1] + notes[2], notes[3])
				.buffer_(sndBuf).
				startPos_(notes[0] + notes[1] + notes[2]).
				rate_(playRate)
				);
	
			score.add(playBuffer.note
				(notes[0] + notes[1] + notes[2] + notes[3], notes[4])
				.buffer_(sndBuf).
				startPos_(notes[0] + notes[1] + notes[2] + notes[3]).
				rate_(playRate)
				);
	
			score.add(playBuffer.note
				(notes[0] + notes[1] + notes[2] + notes[3]+ notes[4], notes[5])
				.buffer_(sndBuf).
				startPos_(notes[0] + notes[1] + notes[2] + notes[3]+ notes[4]).
				rate_(playRate)
				);
			
				
		});
		

		score.add(blip.note
			(0.1, notes[0], addAction: \head,  target: 1)
			.dur_(notes[0])
			.amp_(CtkControl.env(
				Env([0.75, 1, 1], [0.5, 0.5]
				, \sin), timeScale: notes[0])) 
			.fundFreq_(CtkControl.env(
				Env([17.6, 17.6], [1]
				, \sin), timeScale: notes[0]))
			.formFreq_(CtkControl.env(
				Env([70, 175], [1]
				, [\exp, \exp]), timeScale: notes[0]))			.bandWidth_(CtkControl.env(
				Env([50, 40], [1]
				, [\lin]), timeScale: notes[0]))
			.accFactor_(CtkControl.env(
				Env([10, 10,], [1]
				, \sin), timeScale: notes[0])) 	
		); 


		score.add(blip.note
			(notes[0], notes[1], addAction: \head,  target: 1)
			.dur_(notes[1])
			.amp_(CtkControl.env(
				Env([1, 1.2], [1]
				, \sin), timeScale: notes[1])) 
			.fundFreq_(CtkControl.env(
				Env([17.6, 15.6, 16.6], [0.5,0.5]
				, \sin), timeScale: notes[1]))
			.formFreq_(CtkControl.env(
				Env([175, 120, 140], [0.5,0.5]
				, [\exp, \lin]), timeScale: notes[1]))			.bandWidth_(CtkControl.env(
				Env([40, 15, 40], [0.5, 0.5]
				, \sin), timeScale: notes[1]))
			.accFactor_(CtkControl.env(
				Env([10, 6, 7.5], [0.5,0.5]
				, \sin), timeScale: notes[1])) 	
		); 



		score.add(blip.note
			(notes[0]+notes[1], notes[2], addAction: \head,  target: 1)
			.dur_(notes[2])
			.amp_(CtkControl.env(
				Env([1.2, 3], [1]
				, \sin), timeScale: notes[2])) 
			.fundFreq_(CtkControl.env(
				Env([16.6, 8, 12.4, 5.3, 6.8, 3.8], [0.3, 0.16, 0.16, 0.16, 0.16]
				, \sin), timeScale: notes[2]))
			.formFreq_(CtkControl.env(
				Env([140, 160, 80, 110, 80], [0.2,0.2,0.2,0.4]
				, \exp), timeScale: notes[2]))
			.bandWidth_(CtkControl.env(
				Env([40, 20, 30, 20], [0.5, 0.25, 0.25]
				, \sin), timeScale: notes[2]))
			.accFactor_(CtkControl.env(
				Env([7.5, 3,4, 3.6363], [1/4,1/2,1/4], \exp)
				, timeScale: notes[2])) 
		); 		


		score.add(blip.note
			(notes[0]+notes[1]+notes[2], notes[3], addAction: \head,  target: 1)
			.dur_(notes[3])
			.amp_(CtkControl.env(
				Env([3,5], [1]
				, \lin), timeScale: notes[3])) 
			.fundFreq_(CtkControl.env(
				Env([3.8, 0.725, 0.725], [0.75,0.25]
				, \sin), timeScale: notes[3]))
			.formFreq_(CtkControl.env(
				Env([80, 75, 100, 50, 75, 54, 54], [1/6,1/6,1/6,1/6,1/6,1/6]
				, \exp), timeScale: notes[3]))
			.bandWidth_(CtkControl.env(
				Env([20, 30, 20, 10], [0.25,0.25,0.5]
				, \lin), timeScale: notes[3]))
			.accFactor_(CtkControl.env(
				Env([3.6363,3.6363,], [1]
				, \lin), timeScale: notes[3]))
			.mix1_(CtkControl.env(
				Env([0.1,0.5,0.5], [0.15,0.85]
				, \exp), timeScale: notes[3]))
			.room1_(0.75)
			.damp1_(0)	
				 
		);


		score.add(blip.note
			(notes[0]+notes[1]+notes[2]+notes[3], notes[4], addAction: \head,  target: 1)
			.dur_(notes[4])
			.amp_(5) 
			.fundFreq_(CtkControl.env(
				Env([1.0, 0.45, 1.7, 0.58, 1.2, 0.82, 0.42, 0.11, 0.11], [1/8, 1/8,1/8,1/8,1/8,1/8,1/8,1/8]
				, \exp), timeScale: notes[4]))
			.formFreq_(CtkControl.env(
				Env([54, 54, 154.44, 50, 75, 54, 54], [0.05, 0.05, 0.05, 0.05, 0.4, 0.5]
				, \exp), timeScale: notes[4]))
			.bandWidth_(5)
			.accFactor_(3.6363) 
			.mix1_(CtkControl.env(
				Env([0.1,0.5,0.5], [0.15,0.85]
				, \exp), timeScale: notes[4]))
			.room1_(0.75)
			.damp1_(0)	
		);

		
		score.add(blip.note
			(notes[0]+notes[1]+notes[2]+notes[3]+notes[4], notes[5], addAction: \head,  target: 1)
			.dur_(notes[5])
			.amp_(CtkControl.env(
				Env([0.016, 0.16], [1]
				, \lin), timeScale: notes[5])) 
			.fundFreq_(0.01)
			.formFreq_(162)
			.bandWidth_(0.05)
			.accFactor_(1) 
		);
						
		score.write("~/Desktop/test.aif".standardizePath, options: 
		ServerOptions.new.numOutputBusChannels_(2));	
								
		score.play;

})
)


