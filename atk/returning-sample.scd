// -----------------------------------------------------------------
// returning
// 2018.10.31
// code under GPLv3
// -----------------------------------------------------------------
 (
fork{
	// System options
	s.options.numOutputBusChannels = 200;
	s.options.numAudioBusChannels = 1024 * 2; // default is 1024
	s.options.numWireBufs = 64 * 16;

	s.waitForBoot({
		// Number of listening channles aka physical speakers
		var listeningChannels = 2;

		// Generate buffer tables for the wavetable synth
		var tables = 100;
		var wavetableSize = 1024;

		// Routines variables
		var mainRoutineTempo = TempoClock(1);
		var random1 = 0;
		var random2 = 0;
		var random3 = 0;

		var event1Counter = 0;
		var event2Counter = 0;
		var event3Counter = 0;

		var randomGenerator1;
		var randomGenerator2;
		var randomGenerator3;

		var event1IsPlaying = false;
		var event2IsPlaying = false;
		var event3IsPlaying = false;


		s.sync;

		// Allocate buffers for the wavetable synth
		tables.do{
			|i|
			currentEnvironment.put(
				("buf"++i).asSymbol, Buffer.alloc(s, wavetableSize * 2, bufnum: i);
			);
		};

		s.sync;

		// Generate random wavetables of X points
		tables.do{
			|i|

			var points = 12;

			(currentEnvironment.at(("buf"++i).asSymbol)).setn(i, Env([0] ++ Array.fill(points - 2, {1.0.rand2}) ++ 0, Array.fill(points -1, {1.0.rand}), Array.fill(points -1, {4.0.rand2})).asSignal(wavetableSize).asWavetable);

		};

		s.sync;

		// Load ATK encoder and decoder
		~encoder = FoaEncoderKernel.newSpread(sampleRate: 48000);
		~decoder = FoaDecoderKernel.newListen(sampleRate: 48000);
		~decoderBA = FoaDecoderMatrix.newBtoA;
		~postEncoderAB = FoaEncoderMatrix.newAtoB;

		s.sync;

		// Add SynthDefs
		SynthDef(\darkKick, {
			|outBus, attack, release, doneAction, gain, amp, dryAmp, lagTime|

			var env1, env2, freqEnv, sig1, sig2, sig3, sig, output, wetAmp;

			wetAmp = 1 - dryAmp;

			env1 = EnvGen.ar(Env([0, 1, 0], [attack, release], curve: [4, -4]), 1, 2, doneAction: doneAction);
			env2 = EnvGen.ar(Env([0, 1, 0], [attack, release], curve: [4, -4]), 1, gain, doneAction: doneAction);

			freqEnv = EnvGen.ar(Env([0, 90, 60], [attack, release], curve: [4, -4]), 1, doneAction: doneAction);

			sig1 = SinOsc.ar(freqEnv, 0, env1) * dryAmp;
			sig2 = SinOsc.ar(freqEnv, 0, env2).wrap2 * wetAmp;

			sig1 = HPF.ar(sig1, 60);
			sig2 = LPF.ar(sig2, 7000);
			sig2 = LPF.ar(sig2, LFNoise2.kr(2).range(4000, 5000));

			sig = sig1 + sig2;

			sig = LeakDC.ar(sig);

			output = Out.ar(outBus, sig * Lag2.kr(amp, lagTime));

		}).add;

		SynthDef(\saw, {
			|outBus, attack, decay, sustain, release, timeScale, doneAction, osc1Freq, osc2Freq, osc1FilterFreq, osc2FilterFreq, osc1FilterReso, osc2FilterReso, amp1, amp2, amp, lagTime|

			var env1, env2, osc1, osc2, filter1, filter2, sig, output;

			env1 = EnvGen.ar(Env([0, 1, 0.7, 0], [attack, decay, sustain, release], curve: [4, -4, -4, -4]), 1, 1, timeScale: timeScale, doneAction: doneAction);
			env2 = EnvGen.ar(Env([0, 1, 0.7, 0], [attack, decay, sustain, release], curve: [4, -4, -4, -4]), 1, 1, doneAction: doneAction);

			osc1 = Saw.ar(osc1Freq) * amp1;
			osc2 = Saw.ar(osc2Freq) * amp2;

			filter1 = RLPF.ar(osc1, osc1FilterFreq, osc1FilterReso, env1).distort;
			filter2 = RLPF.ar(osc2, osc2FilterFreq, osc2FilterReso, env1).distort;

			sig = filter1 + filter2;

			output = Out.ar(outBus, sig * Lag2.kr(amp, lagTime));

		}).add;

		SynthDef(\drone, {
			|outBus, attack, sustain, release, timeScale, doneAction, osc1FundFreq, beating, modIndex, gain, phaseRate, dryLevel, amp, bassAmp, lagTime|

			var env, nPartials, partials, partialsAmp, osc2FundFreq, modFreq, bassFreq, modSignal, ampSignal, phaseSignal, bassSignal, osc1, osc2, sig, wetLevel, delay, reverb, output;

			wetLevel = 1 - dryLevel;

			env = EnvGen.ar(Env([0, 1, 0.7, 0], [attack, sustain, release], curve: [4, -4, -4]), 1, 1, timeScale: timeScale, doneAction: doneAction);

			nPartials = (1..4);
			partialsAmp = (1 / nPartials).normalizeSum;
			partials = Array.fill(nPartials.size, {|i = 0| i + (pi / 1.61803398875)});

			osc2FundFreq = osc1FundFreq / 1.3348246800541 + 0.25;
			modFreq = osc1FundFreq / 3.9998960715028 - pi/3;
			bassFreq = osc1FundFreq / 5.3394839067703;

			modSignal = SinOscFB.ar(modFreq * partials, 0.5, partialsAmp * modIndex);
			phaseSignal =  LFNoise2.kr(phaseRate).range(-0.6, 0.6);

			osc1 = Pulse.ar(([osc1FundFreq, osc1FundFreq + beating] * partials), phaseSignal, partialsAmp * gain).distort;
			osc2 = Saw.ar(([osc2FundFreq, osc2FundFreq + beating] * partials) + modSignal, partialsAmp);

			bassSignal = SinOsc.ar(bassFreq, 0, bassAmp);

			sig = Mix(osc1 + osc2).distort + bassSignal;

			sig = HPF.ar(sig, 80);
			sig = LPF.ar(sig, 3160);
			sig = LPF.ar(sig, 960);

			delay = DelayC.ar(sig!2, 0.1, 0.06, wetLevel * 0.5);
			reverb = GVerb.ar(sig, 4, pi, 0.55, spread: 75, mul: wetLevel * 0.5);

			sig = delay + reverb + (sig!2 * dryLevel);
			sig = CompanderD.ar(sig, 0.7);
			sig = Limiter.ar(sig, 0.98);

			output = Out.ar(outBus, sig * Lag2.kr(amp, lagTime) * env)

		}).add;

		SynthDef(\waveTable, {
			|outBus, attack, decay, sustain, release, timeScale, doneAction, waveMod1, waveMod2, osc1Freq, osc2Freq, osc1Beating, osc2Beating, osc1Octave, osc2Octave, osc1Amp, osc2Amp, mod1Rate, mod2Rate, mod1Index, mod2Index, noiseAmp, filterFreq, filterReso, filterGain, amp, lagTime|

			var env, waveTableLimit, osc1, osc2, mod1, mod2, noise, filter, filterIn, output;

			env = EnvGen.ar(Env([0, 1, 0.7, 0], [attack, sustain, release], curve: [4, -4, -4]), 1, 1, doneAction: doneAction);

			waveTableLimit = tables - 2;


			mod1 = VOsc.ar(waveMod1, mod1Rate, 0, mod1Index).distort;
			mod2 = VOsc.ar(waveMod2, mod2Rate, 0, mod2Index).distort;

			osc1 = VOsc.ar(Clip.ar(mod1.range(0, waveTableLimit) + mod2, 0, waveTableLimit), [osc1Freq,  (osc1Freq + osc1Beating)] * osc1Octave, 0, osc1Amp);
			osc2 = VOsc.ar(Clip.ar(mod2.range(0, waveTableLimit) + mod1, 0, waveTableLimit), [osc2Freq,  (osc2Freq + osc2Beating)] * osc2Octave, 0, osc2Amp);

			noise = WhiteNoise.ar(noiseAmp * mod1);

			filterIn = Mix([Mix(osc1), Mix(osc2), noise]);

			filter = MoogFF.ar(filterIn!2, [mod1.range(120, 15000), mod2.range(120, 15000)], filterGain);

			output = Out.ar(outBus, filter * Lag2.kr(amp, lagTime) * env);

		}).add;

		SynthDef(\overdrive, {
			|outBus, inBus0, inBus1, inBus2, inBus3, gain, amp, bufferSize = 2048, numPartials, ratio, strenght, dryAmp, lagTime|
			// outBus, inBus, gain = 10, amp = 0.15, bufferSize = 2048, numPartials = 2, ratio = 4, strenght = 3, dryAmp = 0.1

			var wetAmp, input0, input1, input2, input3, inDist, fundSig, partialsSig, buffer, chain, process, output;

			wetAmp = 1 - dryAmp;

			input0 = In.ar(inBus0, 1);
			input1 = In.ar(inBus1, 1);
			input2 = In.ar(inBus2, 1);
			input3 = In.ar(inBus3, 1);


			inDist = ([input0, input1, input2, input3] * gain).distort * wetAmp;

			buffer = LocalBuf(bufferSize);

			chain = FFT({buffer}!4, inDist);

			process = PV_SpectralEnhance(chain, numPartials, ratio, strenght);

			output = (([input0, input1, input2, input3] * dryAmp) + IFFT(process));
			output = Limiter.ar(output, 0.98);
			output = Out.ar(outBus, output * Lag2.kr(amp, lagTime));

		}).add;

		SynthDef(\chorus, {
			|outBus, inBus, modRate, del2_amount, fbGain, lpfHz, dryAmp, amp, lagTime|
			// outBus, inBus, modRate = 0.03, del2_amount = 0.0159, fbGain = 2, lpfHz = 7000, dryAmp = 0.0, amp = 0.5

			var input, wetAmp, fbIn, fbOut, ampMod, delay1, delay2, delay3, output;

			input = In.ar(inBus, 4);

			wetAmp = 1 - dryAmp;

			fbIn = LocalIn.ar(4);

			ampMod = SinOsc.ar(modRate); // max 10 Hz

			delay1 = DelayC.ar(input, 0.2, 0.2) * ampMod;
			delay1 = HPF.ar(delay1, 20);

			delay2 = DelayN.ar(delay1, 0.2, 0.2)  * (ampMod * 0.95);

			delay3 = DelayL.ar(delay2 + fbIn, 0.065, del2_amount, 0.98);
			delay3 = ((delay3 * fbGain).softclip) * 0.5;

			fbOut = LocalOut.ar(delay3);

			delay3 = LPF.ar(delay3, lpfHz);

			output = (delay3 * wetAmp) * Lag2.kr(amp, lagTime);
			output = Out.ar(outBus, output);

		}).add;

		SynthDef(\granDelay, {
			|inBus, outBus, fbGain, windowSize, pitchRatio, pitchDispersion, timeDispersion, delAmount, dryAmp, amp, lagTime|
			// inBus, outBus, fbGain = 0.99, windowSize = 0.2, pitchRatio = 3, pitchDispersion = 0.1, timeDispersion = 0, delAmount = 0.1, dryAmp = 0, amp = 0.5

			var input, wetAmp, fbIn, pitchShifter, delay, fbOut, output;

			input = In.ar(inBus, 4);

			wetAmp = 1 - dryAmp;

			fbIn = LocalIn.ar(4); // feedback in

			pitchShifter = PitchShift.ar(input + Clip.ar(fbIn * fbGain, -1, 0.99), windowSize, pitchRatio.clip2(4), pitchDispersion, timeDispersion.clip2(windowSize)); // granular pitch shifter of the signla and clipped fb

			delay = DelayC.ar(pitchShifter, 0.3, delAmount); // delay the pitchShifter

			fbOut = LocalOut.ar(delay); // feedback output

			output = ((input * dryAmp) + (delay * wetAmp)) * Lag2.kr(amp, lagTime); // dry/wet;
			output = Out.ar(outBus, output)

		}).add;

		SynthDef(\encoder, {
			|inBus, outBus, amp, dryAmp, lagTime|

			var input, encoder, decoderBA, output;

			input = Mix(In.ar(inBus, 2));

			encoder = FoaEncode.ar(input, ~encoder);

			decoderBA = FoaDecode.ar(encoder, ~decoderBA);

			output = Out.ar(outBus, decoderBA * Lag2.kr(amp, 0.1));

		}).add;

		SynthDef(\postEncoder, {
			|wetInBus, dryInBus, outBus, amp, dryAmp|

			var wetInput, dryInput, input, wetAmp, encoder, output;

			wetAmp = 1 - dryAmp;

			dryInput = In.ar(dryInBus, 4) * dryAmp;

			wetInput = In.ar(wetInBus, 4) * wetAmp;

			input = dryInput + wetInput;

			encoder = FoaEncode.ar(input, ~postEncoderAB);

			output = Out.ar(outBus, encoder * Lag2.kr(amp, 0.1));

		}).add;

		SynthDef(\decoder, {
			|inBus, outBus, amp, lagTime|

			var input, decoder, output;

			input = In.ar(inBus, 4);

			decoder = FoaDecode.ar(input, ~decoder);

			output = Out.ar(outBus, decoder * Lag2.kr(amp, lagTime));

		}).add;

		SynthDef(\foaRotate, {
			|inBus, outBus, lfo1InBus, lfo2InBus, lfo3InBus, minRangeRot, maxRangeRot, minRangeTilt, maxRangeTilt, minRangeTumb, maxRangeTumb|

			var input, rotationAngle, tiltAngle, tumbleAngle, transformer, output;

			input = In.ar(inBus, 4);

			rotationAngle = In.kr(lfo1InBus);
			tiltAngle = In.kr(lfo1InBus);
			tumbleAngle = In.kr(lfo1InBus);

			// Min Max range for all the parameters should be
			// range(pi * -2, pi * 2)
			transformer = FoaTransform.ar(input, 'rtt', rotationAngle.range(minRangeRot, maxRangeRot), tiltAngle.range(minRangeTilt, maxRangeTilt), tumbleAngle.range(minRangeTumb, maxRangeTumb));

			output = Out.ar(outBus, transformer);

		}).add;

		SynthDef(\sineLFO, {
			|rate, outBus|

			var signal, output;

			signal = SinOsc.kr(rate);

			output = Out.kr(outBus, signal);

		}).add;

		SynthDef(\sawLFO, {
			|rate, outBus|

			var signal, output;

			signal = LFSaw.kr(rate);

			output = Out.kr(outBus, signal);

		}).add;

		SynthDef(\noise0LFO, {
			|rate, outBus|

			var signal, output;

			signal = LFNoise0.kr(rate);

			output = Out.kr(outBus, signal);

		}).add;

		SynthDef(\noise2LFO, {
			|rate, outBus|

			var signal, output;

			signal = LFNoise2.kr(rate);

			output = Out.kr(outBus, signal);

		}).add;

		s.sync;

		SynthDef(\oscTr, {
			|outBus, rate|

			var trigger, output;

			trigger = SendTrig.ar(Impulse.ar(rate), 0, 0);

			output = Out.ar(outBus, trigger);

		}).add;

		s.sync;

		// Create new groups
		s.sendMsg(\g_new, 10);
		s.sendMsg(\g_new, 11);
		s.sendMsg(\g_new, 12);
		s.sendMsg(\g_new, 20);
		s.sendMsg(\g_new, 21);
		s.sendMsg(\g_new, 30);
		s.sendMsg(\g_new, 31);

		s.sync;

		// Create the random generators
		randomGenerator1 = Routine({
			loop{
				random1 = gauss(0.0, 30.0);
				random1.round.asInteger;

				if((random1 > 10) && (random1 < 20)){

					event1Counter = event1Counter + 1;
					("Event1Counter is: " ++ event1Counter.asString).postln;

				} // else
				{

				};
				10.wait;
			}
		});

		randomGenerator1.play(mainRoutineTempo);

		randomGenerator2 = Routine({
			loop{
				random2 = gauss(0.0, 30.0);
				random2.round.asInteger;

				if((random2 > 0) && (random2 < 10)){

					event2Counter = event2Counter + 1;
					("Event2Counter is: " ++ event3Counter.asString).postln;

				} // else
				{

				};
				10.wait;
			}
		});

		randomGenerator2.play(mainRoutineTempo);

		randomGenerator3 = Routine({
			loop{
				random3 = gauss(0.0, 30.0);
				random3.round.asInteger;

				if((random3 > 20) && (random3 < 30)){

					event3Counter = event3Counter + 1;
					("Event3Counter is: " ++ event3Counter.asString).postln;

				} // else
				{

				};
				10.wait;
			}
		});

		randomGenerator3.play(mainRoutineTempo);

		s.sync;

		// Create the OSC trigger
		s.sendMsg(\s_new, "oscTr", 100, 1, 1, \outBus, listeningChannels + 200, \rate, 40);

		s.sync;

		// The piece
		OSCdef(\tr, {
			|msg|

			if((event1IsPlaying == false) && (event1Counter >= 3)){
				fork{
					event1IsPlaying = true;
					event1Counter = 0;

					"Event1 plays".postln;


					s.sendMsg(\s_new, "drone", 2000, 1, 10, \outBus, listeningChannels + 1, \attack, 1, \sustain, 1, \release, 1, \timeScale, exprand(30, 40), \doneAction, 13, \osc1FundFreq, [55, 73.42, 87.31].choose, \beating, 0.1, \modIndex, 100, \gain, 10, \phaseRate, 0.1, \dryLevel, 0.1, \amp, 0.5, \bassAmp, 0.8, \lagTime, rrand(2.0, 3.0));
					s.sendMsg(\s_new, "encoder", 2010, 1, 10, \inBus, listeningChannels + 1, \outBus, listeningChannels + 4, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "postEncoder", 2020, 1, 10, \dryInBus, listeningChannels + 4, \wetInBus, listeningChannels + 9, \outBus, listeningChannels + 14, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "foaRotate", 2040, 1, 10, \inBus,  listeningChannels + 14, \outBus, listeningChannels + 19, \lfo1InBus, 0, \lfo2InBus, 0, \lfo3InBus, 0, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 2050, 1, 10, \inBus, listeningChannels + 19, \outBus, 0, \amp, 1, \lagTime, 0.1);

					rrand(15, 30).wait;

					s.sendMsg(\s_new, "drone", 2001, 1, 11, \outBus, listeningChannels + 24, \attack, 1, \sustain, 1, \release, 1, \timeScale, exprand(30, 40), \doneAction, 13, \osc1FundFreq, [55, 73.42, 87.31].choose, \beating, 0.1, \modIndex, 100, \gain, 100, \phaseRate, 0.5, \dryLevel, 0.1, \amp, 0.5, \bassAmp, 0.8, \lagTime, rrand(2.0, 3.0));
					s.sendMsg(\s_new, "encoder", 2011, 1, 11, \inBus, listeningChannels + 24, \outBus, listeningChannels + 27, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "postEncoder", 2021, 1, 11, \dryInBus, listeningChannels + 27, \wetInBus, listeningChannels + 32, \outBus, listeningChannels + 37, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "sineLFO", 2031, 1, 11, \outBus, 0, \rate, 0.5);
					s.sendMsg(\s_new, "foaRotate", 2041, 1, 11, \inBus,  listeningChannels + 37, \outBus, listeningChannels + 42, \lfo1InBus, 0, \lfo2InBus, 40, \lfo3InBus, 40, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 2051, 1, 11, \inBus, listeningChannels + 42, \outBus, 0, \amp, 1, \lagTime, 0.1);

					rrand(60, 80).wait;

					//  First drone reattacks
					s.sendMsg(\s_new, "drone", 2002, 1, 12, \outBus, listeningChannels + 47, \attack, 1,  \sustain, 1, \release, 1, \timeScale, exprand(30, 40), \doneAction, 13, \osc1FundFreq, [55, 73.42, 87.31].choose, \beating, 0.1, \modIndex, 100, \gain, exprand(100, 150), \phaseRate, rrand(0.6, 0.7), \dryLevel, 0.1, \amp, 0.5, \bassAmp, 0.8, \lagTime, rrand(2.0, 3.0));
					s.sendMsg(\s_new, "encoder", 2012, 1, 12,\inBus, listeningChannels + 47, \outBus, listeningChannels + 50, \amp, 1);
					s.sendMsg(\s_new, "overdrive", 2062, 1, 12, \inBus0, listeningChannels + 50, \inBus1, listeningChannels + 51, \inBus2, listeningChannels + 52, \inBus3, listeningChannels + 53, \outBus, listeningChannels + 55, \gain, rrand(10, 15), \amp, 1, \bufferSize, 2048, \numPartials, 4, \ratio, 1.14, \strenght, 4, \dryAmp, 0.999, \lagTime, 60);
					s.sendMsg(\s_new, "noise2LFO", 2032, 1, 12, \outBus, 1, \rate, rrand(0.4, 0.6));
					s.sendMsg(\s_new, "noise2LFO", 2033, 1, 12, \outBus, 2, \rate, rrand(0.25, 0.67));
					s.sendMsg(\s_new, "sineLFO", 2034, 1, 12, \outBus, 3, \rate, rrand(0.1, 0.333));
					s.sendMsg(\s_new, "postEncoder", 2022, 1, 12, \dryInBus, listeningChannels + 50, \wetInBus, listeningChannels + 55, \outBus, listeningChannels + 60, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "foaRotate", 2042, 1, 12, \inBus, listeningChannels + 60, \outBus, listeningChannels + 65, \lfo1InBus, 2, \lfo2InBus, 3, \lfo3InBus, 4, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 2052, 1, 12, \inBus, listeningChannels + 65, \outBus, 0, \amp, 1, \lagTime, 0.1);

					40.wait;

					event1IsPlaying = false;
					"Event1 will die".postln;
					event1Counter = 0;
				};


			} // else
			{

			};

			if((event2IsPlaying == false) && (event2Counter >= 3)){
				fork{
					var tempo = TempoClock(175/60);
					var darkKickDur = Pdef(\darkKickDur, Pdefn(\darkKickDur, Prand([Prand([0.5, Rest(0.5), 0.5], inf), Prand([0.5, Rest(0.5), 0.5, 0.5], inf)])));
					var timeForSomeToDie = 0;
					event2IsPlaying = true;
					event2Counter = 0;

					"Event2 plays".postln;

					~waveTable = Pbind(
						\type, \on,
						\id, 3000,
						\group, 20,
						\instrument, \waveTable,
						\args, #[\outBus, \attack, \decay, \sustain, \release, \waveMod1, \waveMod2, \osc1Freq, \osc2Freq, \osc1Beating, \osc2Beating, \osc1Octave, \osc2Octave, \osc1Amp, \osc2Amp, \mod1Rate, \mod2Rate, \mod1Index, \mod2Index, \noiseAmp, \filterFreq, \filterGain, \amp],
						\outBus, listeningChannels + 70,
						\attack, 0.05,
						\decay, 0.02,
						\sustain, 0.05,
						\release, 0.05,
						\timeScale, 1,
						\doneAction, 2,
						\waveMod1, Pwhite(0.0, 98, inf),
						\waveMod2, Pwhite(0.0, 98, inf),
						\osc1Freq, Pseq([Prand([161.82, 128.43, 216, 342.88], inf), Prand([161.82, 192.43, 242.45, 288.33], inf)], inf),
						\osc2Freq,  Pseq([Prand([161.82, 128.43, 216, 342.88], inf), Prand([161.82, 192.43, 242.45, 288.33], inf)], inf),
						\osc1Beating, Pwhite(0.1, 1, inf),
						\osc2Beating, Pwhite(0.1, 1, inf),
						\osc1Octave, 1,
						\osc2Octave, Prand([0.505, 0.495], inf),
						\osc1Amp, Pwhite(0.2, 0.5),
						\osc2Amp, Pwhite(0.1, 0.5),
						\mod1Rate, Pwhite(0.01, 0.1, inf),
						\mod2Rate, Pwhite(0.01, 0.1, inf),
						\mod1Index, Pwhite(10, 100, inf),
						\mod2Index, Pwhite(10, 100, inf),
						\noiseAmp,  Pwhite(0.4, 1, inf),
						\filterFreq, Pwhite(100, 12000, inf),
						\filterGain, Pwhite(1, 3, inf),
						\amp, Pwhite(0.3, 0.5, inf),
						\lagTime, 0.01,
						\dur, darkKickDur
					).collect({ |event|
						~lastWaveEvent = event;
					}).play(tempo, quant: Quant(quant: 1, timingOffset: 0.01));

					s.sendMsg(\s_new, "encoder", 3012, 1, 20,\inBus, listeningChannels + 70, \outBus, listeningChannels + 73, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "overdrive", 3062, 1, 20, \inBus0, listeningChannels + 73, \inBus1, listeningChannels + 74, \inBus2, listeningChannels + 75, \inBus3, listeningChannels + 76, \outBus,  listeningChannels + 78, \gain, rrand(0.5, 1), \amp, 1, \bufferSize, 1024, \numPartials, 20, \ratio, 6/5, \strenght, 1, \dryAmp, 0.25, \lagTime, 0.1);

					~overdrive = Pbind(
						\type, \set,
						\id, 3062,
						\group, 20,
						\instrument, \overdrive,
						\args, #[\gain,\amp, \bufferSize, \numPartials, \ratio, \strenght, \dryAmp, \amp, \lagTime],
						\gain, Pwhite(5, 10, inf),
						\amp, Pwhite(0.7, 1, inf),
						\bufferSize, Prand([256, 512, 1024, 2048, 4096], inf),
						\numPartials, Prand([10, 4,  2, 6], inf),
						\ratio, Prand([6/5, 7/6, 128/75], inf),
						\strenght, Pwhite(1, 2, inf),
						\dryAmp, 0,
						\amp, Pwhite(0.8, 1),
						\lagTime, 0.01,
						\dur,  Pfunc { ~lastWaveEvent[\dur ] }
					).play(tempo, quant: 1);

					s.sendMsg(\s_new, "noise0LFO", 3032, 1, 20, \outBus, 4, \rate, [145/60, 175/60].choose);
					s.sendMsg(\s_new, "noise2LFO", 3033, 1, 20, \outBus, 5, \rate, rrand(1, 2));
					s.sendMsg(\s_new, "noise2LFO", 3034, 1, 20, \outBus, 6, \rate, rrand(1, 2));
					s.sendMsg(\s_new, "postEncoder", 3022, 1, 20, \dryInBus, listeningChannels + 73, \wetInBus, listeningChannels + 78, \outBus, listeningChannels + 83, \amp, 1, \dryAmp, 0.4);
					s.sendMsg(\s_new, "foaRotate", 3042, 1, 20, \inBus, listeningChannels + 83, \outBus, listeningChannels + 88, \lfo1InBus, 4, \lfo2InBus, 5, \lfo3InBus, 6, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 3052, 1, 20, \inBus, listeningChannels + 88, \outBus, 0, \amp, 1, \lagTime, 0.1);

					~darkKick = Pbind(
						\type, \on,
						\id, 4010,
						\group, 20,
						\instrument, \darkKick,
						\args, #[\outBus, \attack, \release, \gain, \amp, \dryAmp],
						\outBus, listeningChannels + 93,
						\attack, 0.001,
						\release, 0.15,
						\doneAction, 2,
						\gain, 6,
						\amp,  Pwhite(0.7, 1, inf),
						\dryAmp, 0.95,
						\lagTime, 0.01,
						\dur, Pfunc { ~lastWaveEvent[\dur ] }
					).play(tempo, quant: 1);

					s.sendMsg(\s_new, "encoder", 4012, 1, 20, \inBus, listeningChannels + 93, \outBus, listeningChannels + 95, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "noise2LFO", 4032, 1, 20, \outBus, 7, \rate, rrand(0.4, 0.6));
					s.sendMsg(\s_new, "noise2LFO", 4033, 1, 20, \outBus, 8, \rate, rrand(0.5, 0.7));
					s.sendMsg(\s_new, "sineLFO", 4034, 1, 20, \outBus, 9, \rate, rrand(0.1, 0.3));
					s.sendMsg(\s_new, "postEncoder", 4022, 1, 20, \dryInBus, listeningChannels + 95, \wetInBus, listeningChannels + 100, \outBus, listeningChannels + 105, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "foaRotate", 4042, 1, 20, \inBus, listeningChannels + 105, \outBus, listeningChannels + 110, \lfo1InBus, 2, \lfo2InBus, 3, \lfo3InBus, 4, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 4052, 1, 20, \inBus, listeningChannels + 110, \outBus, 0, \amp, 1, \lagTime, 0.1);

					rrand(30, 40).wait;


					s.sendMsg(\s_new, "waveTable", 3001, 1, 21, \outBus, listeningChannels + 115, \attack, rrand(30, 40), \decay, rrand(30, 40), \sustain, rrand(30, 40), \release, rrand(30, 40), \timeScale, 1, \doneAction, 13, \waveMod1, rrand(10, 98).round.asInteger, \waveMod2, rrand(10, 98).round.asInteger, \filterGain, rrand(1, 3),  \osc1Freq, rrand(1, 4), \mod1Rate, rrand(1000,  2000), \mod2Rate, rrand(1000, 2000), \osc2Freq, rrand(2, 6), \noiseAmp, rrand(0.5, 0.7), \mod1Index, rrand(100, 200), \mod2Index, rrand(100, 200), \osc1Beating, rrand(0.4, 1), \osc2Beating, rrand(0.01, 0.1), \amp, rrand(0.8, 1));
					s.sendMsg(\s_new, "encoder", 3013, 1, 21,\inBus, listeningChannels + 115, \outBus, listeningChannels + 119, \amp, 1, \lagTime, 30);
					s.sendMsg(\s_new, "overdrive", 3063, 1, 21, \inBus0, listeningChannels + 119, \inBus1, listeningChannels + 120, \inBus2, listeningChannels + 121, \inBus3, listeningChannels + 122, \outBus, listeningChannels + 124, \gain, rrand(10, 20), \amp, rrand(0.7, 1, inf), \bufferSize, [2048, 4096].choose, \numPartials, [10, 20, 2, 6, 100].choose, \ratio, [6/5, 7/6].choose, \strenght, 1, \dryAmp, 0, \lagTime, 30);

					~overdrive2 = Pbind(
						\type, \set,
						\id, 3063,
						\group, 21,
						\instrument, \overdrive,
						\args, #[\gain,\amp, \bufferSize, \numPartials, \ratio, \strenght, \dryAmp, \amp, \lagTime],
						\gain, Pwhite(5, 10, inf),
						\amp, Pwhite(0.7, 1, inf),
						\bufferSize, Prand([2048, 4096], inf),
						\numPartials, Prand([10, 4,  2, 6], inf),
						\ratio, Prand([6/5, 7/6, 128/75], inf),
						\strenght, Pwhite(1, 2, inf),
						\dryAmp, 0,
						\amp, Pwhite(0.8, 1),
						\lagTime, 0.01,
						\dur, darkKickDur,

					).play(tempo);

					s.sendMsg(\s_new, "noise2LFO", 3035, 1, 21, \outBus, 7, \rate, rrand(0.4, 0.6));
					s.sendMsg(\s_new, "noise2LFO", 3036, 1, 21, \outBus, 8, \rate, rrand(0.5, 0.7));
					s.sendMsg(\s_new, "sineLFO", 3037, 1, 21, \outBus, 9, \rate, rrand(0.1, 0.3));
					s.sendMsg(\s_new, "postEncoder", 3023, 1, 21, \dryInBus, listeningChannels + 119, \wetInBus, listeningChannels + 124, \outBus, listeningChannels + 129, \amp, 1, \dryAmp, 0);
					s.sendMsg(\s_new, "foaRotate", 3043, 1, 21, \inBus, listeningChannels + 129, \outBus, listeningChannels + 134, \lfo1InBus, 7, \lfo2InBus, 8, \lfo3InBus, 9, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 3053, 1, 21, \inBus, listeningChannels + 134, \outBus, 0, \amp, 0.8, \lagTime, 30);



					timeForSomeToDie = rrand(50, 60);
					timeForSomeToDie.wait;

					s.sendMsg(\n_set, 3052, \lagTime, timeForSomeToDie, \amp, 0);
					s.sendMsg(\n_set, 4052, \lagTime, timeForSomeToDie, \amp, 0);

					(timeForSomeToDie + 10).wait;

					~waveTable.stop;
					~overdrive.stop;
					~darkKick.stop;
					s.sendMsg(\g_freeAll, 20);

					30.wait;

					~overdrive2.stop;

					event2IsPlaying = false;
					"Event2 will die".postln;
					event2Counter = 0;

				};

			} // else
			{

			};

			if((event3IsPlaying == false) && (event3Counter >= 3)){
				fork{
					var tempo = TempoClock(180/60);
					var darkSawDur = Pdef(\darkSawDur, Pdefn(\darkSawDur, Prand([Prand([0.5, Rest(0.5), 0.5], inf), Prand([0.5, Rest(0.5), 0.5, 0.5], inf)])));
					var timeForSomeToDie = 0;
					event3IsPlaying = true;
					event3Counter = 0;


					"Event3 plays".postln;


					~saw = Pbind(
						\type, \on,
						\id, 5001,
						\group, 30,
						\instrument, \saw,
						\args, #[\outBus, \attack, \decay, \sustain, \release, \timeScale, \osc1Freq, \osc2Freq, \osc1FilterFreq, \osc2FilterFreq, \osc1FilterReso, \osc2FilterReso, \amp1, \amp2, \amp, \lagTime],
						\outBus, listeningChannels + 139,
						\attack, 0.01,
						\decay, 0.02,
						\sustain, 0.05,
						\release, 0.05,
						\timeScale, 1,
						\doneAction, 2,
						\osc1Freq, Pseq([Prand([85.72, 108, 128.43, 171.44], inf), Prand([216, 256.87, 323.63, 432], inf)], inf),
						\osc2Freq,  Pseq([Prand([85.72, 108, 128.43, 171.44], inf), Prand([216, 256.87, 323.63, 432], inf)], inf) * Prand([0.505, 0.495, 2.05], inf),
						\osc1FilterFreq, Pwhite(11400, 19000, inf),
						\osc2FilterFreq, Pwhite(100, 15000, inf),
						\osc1FilterReso, Pwhite(0.2, 0.65, inf),
						\osc2FilterReso, Pwhite(0.1, 0.4, inf),
						\amp1, Pwhite(0.4, 0.5),
						\amp2, Pwhite(0.4, 0.5),
						\amp, Pwhite(0.8, 1, inf),
						\lagTime, 0.01,
						\dur, darkSawDur
					).play(tempo);

					s.sendMsg(\s_new, "encoder", 5011, 1, 30, \inBus, listeningChannels + 139, \outBus, listeningChannels + 141, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "chorus", 5061, 1, 30, \inBus, listeningChannels + 141, \outBus,  listeningChannels + 146, \modRate, 0.03, \del2_amount, 0.0159, \fbGain, 2, \lpfHz, 7000, \amp, 1, \lagTime, 0.1);

					s.sendMsg(\s_new, "noise2LFO", 5031, 1, 30, \outBus, 10, \rate, [145/60, 170/60].choose);
					s.sendMsg(\s_new, "noise2LFO", 5032, 1, 30, \outBus, 11, \rate, rrand(0.5, 0.7));
					s.sendMsg(\s_new, "sineLFO", 5033, 1, 30, \outBus, 12, \rate, rrand(0.1, 0.3));
					s.sendMsg(\s_new, "postEncoder", 5021, 1, 30, \dryInBus, listeningChannels + 141, \wetInBus, listeningChannels + 146, \outBus, listeningChannels + 151, \amp, 1, \dryAmp, 0);
					s.sendMsg(\s_new, "foaRotate", 5041, 1, 30, \inBus, listeningChannels + 151, \outBus, listeningChannels + 156, \lfo1InBus, 10, \lfo2InBus, 11, \lfo3InBus, 12, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 5051, 1, 30, \inBus, listeningChannels + 156, \outBus, 0, \amp, 1, \lagTime, 0.1);


					rrand(30, 40).wait;

					"drone strats".postln;

					s.sendMsg(\s_new, "drone", 5002, 1, 31, \outBus, listeningChannels + 161, \attack, 1,  \sustain, 1, \release, 1, \timeScale, exprand(30, 40), \doneAction, 13, \osc1FundFreq, [54, 64.22, 72.08, 85.72].choose, \beating, 0.1, \modIndex, 100, \gain, exprand(100, 150), \phaseRate, rrand(0.6, 0.7), \dryLevel, 0.1, \amp, 0.5, \bassAmp, 0.8, \lagTime, rrand(2.0, 3.0));

					s.sendMsg(\s_new, "encoder", 5012, 1, 31, \inBus, listeningChannels + 161, \outBus, listeningChannels + 164, \amp, 1, \dryAmp, 1);
					s.sendMsg(\s_new, "granDelay", 5062, 1, 31, \inBus, listeningChannels + 164, \outBus, listeningChannels + 169, \fbGain, 0.99, \windowSize, 0.2, \pitchRatio, 3, \pitchDispersion, 0.1, \timeDispersion, 0, \delAmount, 0.1, \dryAmp, 0, \amp, 0.5, \lagTime, 0.1);

					~granDelay = Pbind(
						\type, \set,
						\id, 5012,
						\group, 31,
						\instrument, \granDelay,
						\args, #[\fbGain, \windowSize, \pitchRatio, \pitchDispersion, \timeDispersion, \delAmount, \dryAmp, \amp],
						\fbGain, Pwhite(10, 100),
						\windowSize, 0.2,
						\pitchRatio, Pwhite(0, 1, inf),
						\pitchDispersion, Pwhite(0.1, 0.5, inf),
						\timeDispersion, Pwhite(0.0, 0.2),
						\delAmount, Pwhite(0.06, 0.2),
						\dryAmp, 0,
						\amp, Pwhite(0.8, 1.0, inf),
						\dur, darkSawDur
					).play(tempo);

					s.sendMsg(\s_new, "sineLFO", 5034, 1, 31, \outBus, 13, \rate, rrand(0.01, 0.1));
					s.sendMsg(\s_new, "sineLFO", 5035, 1, 31, \outBus, 14, \rate, rrand(0.01, 0.1));
					s.sendMsg(\s_new, "sineLFO", 5036, 1, 31, \outBus, 15, \rate, rrand(0.01, 0.1));
					s.sendMsg(\s_new, "postEncoder", 5022, 1, 31, \dryInBus, listeningChannels + 164, \wetInBus, listeningChannels + 169, \outBus, listeningChannels + 174, \amp, 1, \dryAmp, 0.1);
					s.sendMsg(\s_new, "foaRotate", 5042, 1, 31, \inBus, listeningChannels + 174, \outBus, listeningChannels + 179, \lfo1InBus, 13, \lfo2InBus, 14, \lfo3InBus, 15, \minRangeRot, -pi * 2, \maxRangeRot, pi * 2, \minRangeTilt, -pi * 2,\maxRangeTilt, -pi * 2, \minRangeTumb, -pi * 2, \maxRangeTumb, pi * 2);
					s.sendMsg(\s_new, "decoder", 5052, 1, 31, \inBus, listeningChannels + 179, \outBus, 0, \amp, 0.8, \lagTime, 0.1);

					timeForSomeToDie = rrand(30, 40);

					timeForSomeToDie.wait;

					s.sendMsg(\n_set, 5051, \lagTime, timeForSomeToDie, \amp, 0);

					(timeForSomeToDie + 10).wait;

					~saw.stop;
					s.sendMsg(\g_freeAll, 30);

					30.wait;

					~granDelay.stop;

					event3IsPlaying = false;
					"Event3 will die".postln;
					event3Counter = 0;

				};

			} // else
			{

			};


		},
		'/tr',
		s.addr,
		);

	});
};
);

