// Risset bell synthesis midterm 
// james watkins
// dx arts 461 autumn 2011

(
var sd, bell, defaultPartials;

	defaultPartials = Array.new(11);
	defaultPartials.add([1, 1, 0.56, 0]);   // Amplitude, Duration, Frequency, Modifier
	defaultPartials.add([0.67,0.9,0.56,1]);
	defaultPartials.add([1,0.65,0.92,0]);
	defaultPartials.add([1.8,0.55,0.92,1.7]);
	defaultPartials.add([2.67,0.325,1.19,0]);
	defaultPartials.add([1.67,0.35,1.7,0]);
	defaultPartials.add([1.46,0.25,2,0]);
	defaultPartials.add([1.33,0.2,2.74,0]);
	defaultPartials.add([1.33,0.15,3,0]);
	defaultPartials.add([1,0.1,3.76,0]);
	defaultPartials.add([1.33,0.075,4.07,0]);

bell = {arg bellFund = 440, bellDur = 10, bellAmp = -12, bellPartials = defaultPartials;	bellPartials.do({arg thisPartial, i;
		var note, partialAmp, partialDur, partialFreq, partialOffset, partialEnv;  
		#partialAmp, partialDur, partialFreq, partialOffset = thisPartial; 		partialDur = bellDur*partialDur; 
		partialFreq = (bellFund*partialFreq)+partialOffset;
		partialAmp = (bellAmp.dbamp * partialAmp).ampdb;
		partialEnv = Env([-90, -12, -90], [0.002, 0.998], \exp);

		sd.note(0.1, partialDur).freq_(partialFreq).env_(partialEnv).envDurScale_(partialDur).ampScale_(partialAmp). 		play; 
	});	
};
	
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSineWEnv, {arg freq, envDurScale = 1, ampScale;
		var osc, env, envGen;
		env = Control.names([\env]).kr(Env.newClear(8)); 
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});

	Routine.run({
		bell.value(); //default
		// bell.value(100, 20, -12); // (fundamental, duration, amplitude in dB)
	})	
})

)
