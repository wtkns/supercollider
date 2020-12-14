

(
var routebus, src, score;
var filter, filter2, src2;
var inc, time;
var sourceFunction, filterFunction;
var routineSF1, routineFF1;
var mainRoutine;
var freqEnv, freqEnv2, varEnv, waitEnv;

Server.default = s = Server.internal.boot;

s.scope;
f = FreqScope.new;

a = s.options.numOutputBusChannels;
b = s.options.numInputBusChannels;
c = s.options.numAudioBusChannels;


a = CtkAudio.new(server: s);

src = CtkSynthDef(\src, {arg outbus, freq, numharms, pan;
	Out.ar(outbus, Pan2.ar(Blip.ar(freq, numharms, 0.1), pan))

});

filter = CtkSynthDef(\filter, {arg inbus, pan, noteDur, amp = 1, springer;
	var src, filter, env;
	src = In.ar(inbus);
	env = EnvGen.kr(
		Env([0, 0.8, 0.8, 0], [0.001, 0.8, 0.001].normalizeSum, \sin),
		timeScale: noteDur);
	filter = Friction.ar(src, friction: 5.41322e-5, mass: 8.05501, spring: (springer));
	filter = Balance.ar(filter, src, 20);
	Out.ar(0, Pan2.ar(filter * env * amp, pan))
});

freqEnv = Env([1120, 200, 6000, 300], [1, 2, 1].normalizeSum, \lin);
waitEnv = Env([1, 0.001], [1].normalizeSum, \lin);

freqEnv2 = Env([100, 200, 100, 300, 100, 1201, 400, 100, 500, 100, 400, 100, 4301, 300, 100, 200], [1, 2, 1, 2, 1, 3, 4, 5, 1, 5, 6, 7, 1, 2, 1].normalizeSum, \lin);

	sourceFunction = {arg thisBus, thisFreq, thisNumharms, thisPan, thisDur;
		var myBus;
		myBus = a;
			src.note(0.0, thisDur)
			.outbus_(myBus)
			.freq_(thisFreq)
			.numharms_(thisNumharms)
			.pan_(thisPan).play;
	};

	filterFunction = {arg thisBus, thisPan, thisDur, thisAmp, thisSpringer, targetNumb;
		var myBus;
		myBus = a;
			filter.note(0, thisDur, addAction: \tail, target: targetNumb)
			.inbus_(myBus)
			.pan_(thisPan)
			.noteDur_(thisDur)
			.amp_(thisAmp)
			.springer_(thisSpringer).play
	};

	routineSF1 = {arg numNotes, waitEnv;
		  Routine{
		  numNotes.do({arg i;
		  	sourceFunction.value(a, 3456.23, 11, 0, waitEnv[i/numNotes]);
			waitEnv[i/numNotes].wait;
		  })
		  }
	};

	routineFF1 = {arg numNotes, trig;
		  Routine{
		  numNotes.do({arg i;
		  	filterFunction.value(a, 0, 13, 1.dbamp, 0.08, trig);
			100.wait;
		  })
		  }
	};

	mainRoutine = Routine.run({
			routineSF1.value(1, waitEnv).play;
			routineFF1.value(1, 1).play;

	});
)
