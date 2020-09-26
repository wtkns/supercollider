//David Heflin - Final
//For my final I was trying to give a sense of breathing throughout with the steady grain sound.
//It becomes hyponotic and wave like after a certain point, which I think allows the listener
//to become absorbed in the sound. It also allows people to accept what they're hearing and not
//be abrasive to it. My main goal was to try and make the listener engaged in a calming space. At
//times though I feel that maybe it sounds too much like the ocean or being under water. Hopefully,
//it will feel different to you since I have listened to it about 50 times. :)


(
var score, noteObj, grainBuffer, now, breath;

score = CtkScore.new;

grainBuffer = CtkBuffer.env(1024, Env([0, 1, 0], [0.5, 0.5], \sin), 1);
score.add(grainBuffer);

noteObj = CtkSynthDef(\grain, {arg envBuffer, freq1, freq2, dur, amp;
	Out.ar(0, Pan2.ar(
		SinOsc.ar(XLine.kr(freq1, freq2, dur),
			0,
			Osc.ar(envBuffer, dur.reciprocal) * amp)
		)
	);
});

now = 2;

breath = {arg startTime, breathDur, amp, freqLow, freqHigh, grainDur, density;
	var now, thisDur, thisAmp;
	now = 0;
	if(amp.isKindOf(Env), {amp.times = amp.times.normalizeSum});
	amp.postcs;
	while({
		now < breathDur;
	}, {
		thisDur = grainDur.value;
		thisAmp = if(amp.isKindOf(Env),
			{amp.at(now / breathDur).dbamp},
			{amp.dbamp});
		score.add(

			noteObj.note(now + startTime, thisDur)
				.freq1_(freqLow.rrand(freqHigh))
				.freq2_(freqLow.rrand(freqHigh))
				.dur_(thisDur)
				.amp_(thisAmp)
				.envBuffer_(grainBuffer);
			);
		now = now + (density.reciprocal);
	})
};

3.do({arg i;
breath.value((i * 10), 10, Env([-90, -24, -90], [0.1, 0.9]), 440 + (i * 20), 880 + (i * 20), 0.05, 200);
});
12.do({arg i;
breath.value((i * 3) + 25, 3, Env([-90, -24, -90, -24], [1]), 440 + (i * 100), 880 + (i * 100), 0.05, 200);
});
3.do({arg i;
breath.value((i * 10) + 30, 10, Env([-24, -60, -90, -24], [0.1, 0.9]), 880 + (i * 20), 440 + (i * 20), 0.05, 200);
});
6.do({arg i;
breath.value((i * 10) + 60, 10, Env([-90, -24, -90], [0.1, 0.9]), 440 + (i * 100), 880 + (i * 100), 0.05, 200);
});
6.do({arg i;
breath.value((i * 10) + 35, 10 - i, Env([-90, -24, -90, -24 -90], [0.1, 0.9]), 1040 - (i * 100), 1480 - (i * 100), 0.05, 200);
});
6.do({arg i;
breath.value((i * 10) + 90, 10 - i, Env([-60, -18, -24 -60], [0.1, 0.9]), 440 - (i * 20), 880 - (i * 20), 0.05, 200);
});
6.do({arg i;
breath.value((i * 10) + 85, 10, Env([-60, -18, -24 -60], [0.1, 0.9]), 440 + (i * 20), 880 + (i * 20), 0.05, 50);
});
6.do({arg i;
breath.value((i * 10) + 120, 10, Env([-60, -18, -24 -60], [0.1, 0.9]), 220 + (i * 100), 440 + (i * 100), 0.05, 50);
});
6.do({arg i;
breath.value((i * 10) + 125, 5, Env([-60, -24, -60, -24], [0.1, 0.9]), 440 + (i * 20), 880 + (i * 20), 0.05, 200);
});
12.do({arg i;
breath.value((i * 10) + 90, 3, Env([-90, -24, -90, -24], [1]), 440 + (i * 20), 880 + (i * 20), 0.05, 200);
});
12.do({arg i;
breath.value((i * 3) + 100, 3, Env([-90, -24, -90, -24], [1]), 440 + (i * 20), 880 + (i * 20), 0.05, 200);
});
3.do({arg i;
breath.value((i * 10) + 170, 10, Env([-90, -24, -90], [0.1, 0.9]), 440 + (i * 20), 880 + (i * 20), 0.05, 50);
});
3.do({arg i;
breath.value((i * 10) + 165, 10, Env([-24, -60, -90, -24], [0.1, 0.9, 0.1]), 880 + (i * 20), 440 + (i * 20), 0.05, 200);
});
6.do({arg i;
breath.value((i * 10) + 195, 10, Env([-60, (-24 - i), -60], [0.1, 0.9]), 220 + (i * 100), 440 + (i * 100), 0.05, 200);
});



score.write("~/Desktop/heflin_final.aif".standardizePath, options:
	ServerOptions.new.numOutputBusChannels_(2))


)
