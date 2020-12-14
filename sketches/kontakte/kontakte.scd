(
var score, blip, length;
var n1,n2,n3,n4,n5,n6;
var soundfile, sndBuf, cmdPeriod, playBuffer;
var playRate, playSamp, synthPan, sampPan;
Server.default = s = Server.internal;

//	INITIALIZE VARIABLES
	score = CtkScore.new;
	playRate = 1;
	playSamp = false;
	synthPan = 0;
	n1 = 1.35 / playRate;
	n2 = 4.07 / playRate;
	n3 = 15.9 / playRate;
	n4 = 2.5 / playRate;
	n5 = (45 -  (n1 + n2 + n3 + n4) ) / playRate;

// BOOT SERVER, LOAD METERS
	s.scope;
	f = FreqScope.new;

s.boot;
s.waitForBoot({

	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1, pan;
		var src, env;
		env = 1;//EnvGen.kr(Env([0.01, 1, 1, 0.01], [0.1, BufDur.kr(buffer) - 0.2, 0.1], [\sin,\sin]));
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
			env = EnvGen.kr(Env([0.01, 1, 1, 0.01], [0.1, dur - 0.2, 0.1], [\sin]));
			numharms = (SampleRate.ir*0.4) / fundFreq;
			pulse = Blip.ar(fundFreq, numharms.floor, amp);
			reson = Resonz.ar((pulse*env), formFreq, rq, ampScale);
			reverb1 = FreeVerb.ar(reson,mix1,room1,damp1);
			reverb2 = FreeVerb.ar(reverb1,mix2,room2,damp2);
			Out.ar(0, Pan2.ar(Limiter.ar(reverb2, 1.0, 0.01), pan));
	});

	if ( playSamp == true, {

		sndBuf = CtkBuffer.playbuf("~/git/wtkns/research/kontakte/KontakteExcerpt.aif".standardizePath);
		sndBuf.load; // load the buffer to memory ...
		sndBuf.addTo(score);
		s.sync;		 // and pause execution until the buffer is loaded

		cmdPeriod = {
			sndBuf.free;
			"Command Period freed buffers!".postln;
		};

		CmdPeriod.doOnce(cmdPeriod);

		// SOUNDFILE INFO
		("Info about soundfile at" + sndBuf.path +
		"Duration:"+ sndBuf.duration +
		"SampleRate: " + sndBuf.sampleRate +
		"Num Channels" + sndBuf.numChannels).postln;

		synthPan = -1; 		// SYNTH ON RIGHT CHANNEL
		sampPan = 1;  		// SAMPLE ON LEFT CHANNEL

		 // PLAY SAMPLE
			score.add(playBuffer.note
				(0.1, n1)
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
				(n1+n2+n3, n4)
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

	}); // END IF

	// CREATE NOTES FOR THE BLIP SYNTH

		score.add(blip.note
			(0.1, n1, addAction: \head,  target: 1)
			.dur_(n1)
			.pan_(synthPan)
			.amp_(1)
			.fundFreq_(17.6)
			.formFreq_(CtkControl.env(
				Env([75, 165, 155], [0.8, 0.2]
				, \sin), timeScale: n1))				.bandWidth_(40)
			.accFactor_(10)
			.mix1_(CtkControl.env(
				Env([0.5, 0], [1]
				, [\exp]), timeScale: n1))
			.room1_(CtkControl.env(
				Env([0.5, 0], [1]
				, [\exp]), timeScale: n1))
			.damp1_(0.75)

		);

		score.add(blip.note
			(n1-0.05, n2, addAction: \head,  target: 1)
			.dur_(n2)
			.pan_(synthPan)
			.amp_(CtkControl.env(
				Env([1, 1.5, 2.5, 3, 4], [0.15, 0.15, 0.20, 0.25]
				, \sin), timeScale: n2))
			.fundFreq_(CtkControl.env(
				Env([17.6, 16.6, 8, 10.4, 8.3, 4.8, 2.6], [0.06, 0.3, 0.1, 0.16, 0.16, 0.16]
				, \sin), timeScale: n2))
			.formFreq_(CtkControl.env(
				Env([155, 180, 135, 140, 65, 95, 65, 55], [1/24, 1/12,  3/24, 2/12, 3/12, 2/12, 2/12]
				, \sin), timeScale: n2))				.bandWidth_(CtkControl.env(
				Env([40, 20, 10, 10], [0.15, 0.35, 0.5]
				, \sin), timeScale: n2))
			.accFactor_(CtkControl.env(
				Env([10, 6.5], [1]
				, \sin), timeScale: n2))
		);

		score.add(blip.note
			(n1+n2 - 0.1, n3, addAction: \head,  target: 1)
			.dur_(n3)
			.pan_(synthPan)
			.amp_(4)
			.fundFreq_(CtkControl.env(
				Env([2.6, 0.725, 0.23], [0.75, 0.25], \exp)
				, timeScale: n3))
			.formFreq_(CtkControl.env(
				Env([54, 54, 120, 50, 45, 45], [0.15, 0.075, 0.025, 0.35, 0.4], \sin)
				, timeScale: n3))
			.bandWidth_(CtkControl.env(
				Env([10, 7, 10], [0.45,0.55], \exp)
				, timeScale: n3))
			.accFactor_(CtkControl.env(
				Env([7.5, 3,5, 3.6363], [2/8,5/8,1/8], \exp)
				, timeScale: n3))
			.mix1_(CtkControl.env(
				Env([0.1,0.5,0.5], [0.15,0.85]
				, \exp), timeScale: n4))
			.room1_(0.75)
			.damp1_(0)
		);

		score.add(blip.note
			(n1 +n2 + n3, n4, addAction: \head,  target: 1)
			.dur_(n4)
			.pan_(synthPan)
			.amp_(CtkControl.env(
				Env([4, 2], [1]
				, \sin), timeScale: n4))
			.fundFreq_(CtkControl.env(
				Env([1.75, 1.25], [1]
				, \sin), timeScale: n4))
			.formFreq_(CtkControl.env(
				Env([100, 140, 220, 180, 76], [1/5, 1/5, 1/5, 2/5], \step)
				, timeScale: n4))
			.bandWidth_(6)
			.accFactor_(3.6363)
			.mix1_(CtkControl.env(
				Env([0.1,0.5,0.5], [0.15,0.85]
				, \exp), timeScale: n4))
			.room1_(0.75)
			.damp1_(CtkControl.env(
				Env([0.1, 0.5], [1]
				, \sin), timeScale: n4))
		);

		score.add(blip.note
			(n1+n2+n3+n4-0.47, n5, addAction: \head,  target: 1)
			.dur_(n5)
			.pan_(synthPan)
			.amp_(CtkControl.env(
				Env([2, 1, 0], [0.8, 0.2]
				, \lin), timeScale: n5))
			.fundFreq_(CtkControl.env(
				Env([0.5, 0.1], [1]
				, \sin), timeScale: n5))
			.formFreq_(76)
			.bandWidth_(4)
			.accFactor_(3.6363)
			.mix1_(CtkControl.env(
				Env([0.75, 0.85, 0.9], [0.25, 0.75]
				, \exp), timeScale: n5))
			.room1_(CtkControl.env(
				Env([0.75, 0.95, 1], [0.25, 0.75]
				, \exp), timeScale: n5))
			.damp1_(CtkControl.env(
				Env([0.5, 0.95, 1], [0.25, 0.75]
				, \exp), timeScale: n5))
		);

		// WRITE OUT NRT AUDIO FILE

//		score.write("~/Desktop/test.aif".standardizePath, options:
//		ServerOptions.new.numOutputBusChannels_(2));

		score.play;

})
)


