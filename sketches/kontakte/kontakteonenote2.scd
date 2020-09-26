(


// WARNING: AMPLITUDE REALLY HIGH AND NOT ADJUSTED IN THIS VERSION!!!!

// this is the wrong version of the timing for the envelopes,
// but it fixes the timing glitches that come from having multiple notes
// and uneven blip timing/pitch shifting, theres's just a LOT of simple math to convert the envelope lengths
// to a single note… (noteDur * envLength) / new note length, i am actually working on a spreadsheet to handle it, but
// i am including this version so you can see that i have a solution to the glitches in the other version
//

var score, blip, length, soundfile, sndBuf, cmdPeriod, playBuffer, playRate, playSamp, synthPan, sampPan;
var ampEnv, fundFreqEnv, formFreqEnv, bandWidthEnv, accFactorEnv, mixEnv, roomEnv, dampEnv;

Server.default = s = Server.internal;

//	INITIALIZE VARIABLES
	score = CtkScore.new;
	playRate = 1;
	playSamp = true;
	synthPan = 0;

// BOOT SERVER, LOAD METERS
	s.scope;
	f = FreqScope.new;

s.boot;
s.waitForBoot({

	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1, pan;
		var src;
		src = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer), 1,
			startPos * BufSampleRate.kr(buffer), 0 );
		Out.ar(0, Pan2.ar(src, pan));
	});

	blip = CtkSynthDef(\blip, {arg dur, pan, amp, fundFreq, accFactor, formFreq, bandWidth,  mix,room,damp;
			var env, pulse, numharms, reson, bal, rq, ampScale, reverb;
			fundFreq = fundFreq*accFactor;
			formFreq = formFreq*accFactor;
			rq = bandWidth/formFreq;
			ampScale = 1/rq;
			env = EnvGen.kr(Env([0.01, 1, 1, 0.01], [0.1, dur - 0.2, 0.1], [\sin]));
			numharms = (SampleRate.ir*0.4) / fundFreq;
			pulse = Blip.ar(fundFreq, numharms.floor, amp);
			reson = Resonz.ar((pulse*env), formFreq, rq, ampScale);
			reverb = FreeVerb.ar(reson,mix,room,damp);
			Out.ar(0, Pan2.ar(Limiter.ar(reverb, 1.0, 0.01), pan));
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
				(0.1, sndBuf.duration)
				.buffer_(sndBuf)
				.startPos_(0)
				.rate_(playRate)
				.pan_(sampPan)
				);

	}); // END IF

	// CREATE NOTES FOR THE BLIP SYNTH

		ampEnv = Env.new([1, 1, 1.5, 2.5, 3, 4, 4, 2, 1, 0 ], [0.03, 0.013, 0.013, 0.018, 0.486, 0.35, 0.05, 0.04 ], \sin);
		fundFreqEnv = Env.new([17.6, 17.6, 16.6, 8, 10.4, 8.3, 4.8, 2.6, 2.6, 0.725, 0.23, 1.75, 1.25, 0.5, 0.1 ], [1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14, 1/14], \sin);
		accFactorEnv = Env.new([10, 10, 6.5, 7.5, 3,5, 3.6363, 3.6363], [1/7, 1/7, 1/7, 1/7, 1/7, 1/7, 1/7], \sin);
		formFreqEnv = Env.new([75, 165, 155, 180, 135, 140, 65, 95, 65, 55, 54, 54, 120, 50, 45, 45, 100, 140, 220, 180, 76, 76], [1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21, 1/21], \sin);
		bandWidthEnv = Env.new([40, 40, 20, 10, 10, 7, 10, 6, 4], [1/8, 1/8, 1/8, 1/8, 1/8, 1/8, 1/8, 1/8], \sin);
		mixEnv = Env.new([0.5, 0.1, 0.1, 0.5, 0.5, 0.75, 0.85, 0.9], [1/7, 1/7, 1/7, 1/7, 1/7, 1/7, 1/7], \sin);
		roomEnv = Env.new([0.5, 0, 0, 0.75, 0.75, 0.95, 1], [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], \sin);
		dampEnv = Env.new([0.75, 0, 0.1, 0.5, 0.95, 1], [1/5, 1/5, 1/5, 1/5, 1/5], \sin);



		score.add(blip.note
			(0.1, 45, addAction: \head,  target: 1)
			.dur_(45)
			.pan_(synthPan)
			.amp_(CtkControl.env(ampEnv, timeScale: 45))
			.fundFreq_(CtkControl.env(fundFreqEnv, timeScale: 45))
			.formFreq_(CtkControl.env(formFreqEnv, timeScale: 45))
			.bandWidth_(CtkControl.env(bandWidthEnv, timeScale: 45))
			.accFactor_(CtkControl.env(accFactorEnv, timeScale: 45))
			.mix_(CtkControl.env(mixEnv, timeScale: 45))
			.room_(CtkControl.env(roomEnv, timeScale: 45))
			.damp_(CtkControl.env(dampEnv, timeScale: 45))		);



		// WRITE OUT NRT AUDIO FILE

//		score.write("~/Desktop/test.aif".standardizePath, options:
//		ServerOptions.new.numOutputBusChannels_(2));

		score.play;

})
)


