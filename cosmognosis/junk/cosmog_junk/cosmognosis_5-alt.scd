(
var blip, note;
var pevents, func;

// boot the server
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.boot;
s.waitForBoot({
	// CtkSynthDef with all relevant parameters
	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp, outbus, ratio;
		var env, pulse, numharms, reson, rq, ampScale, reverb, out;
		rq = bandWidth/formFreq; 
		ampScale = 1/rq;
		numharms = (SampleRate.ir*0.4) / fundFreq;
		pulse = Blip.ar(fundFreq*ratio, numharms.floor, 1);
		reson = Resonz.ar(pulse, formFreq*ratio, rq, ampScale);
		reverb = FreeVerb.ar(reson, mix, room, damp);
		out = Limiter.ar(reverb, 1.0, 0.01);
		Out.ar(outbus, out);
	});

		func = {arg id, amp, env, rat;
			var proc;
			proc = ProcModR.new(env, amp, 2, 0, id: id);
			proc.function_({arg group, routebus, server;
				Task({
					loop({
						// start a new synth... run it inside this ProcMod's group,
						// and read control values off the envbus
						blip.note(target: group)
							.ratio_(rat)
							.fundFreq_(100)
							.formFreq_(100)
							.bandWidth_(50)
							.room_(0.5)
							.damp_(0.5)
							.mix_(0.5)
							.outbus_(routebus)
							.play;
						})
					});
			});
		};
	
	pevents = ProcEvents.new([
	
	/* 0 */		[   // create \ev1, release nothing
					func.value(\ev1, 0.9, Env([0, 1, 0], [2, 10], \sin, 1), 					rat: 1), 
					nil
				], 

	/* 1 */		[   // create \ev1, release nothing
					func.value(\ev2, 0.9, Env([0, 1, 0], [2, 10], \sin, 1), 					rat: 3),
					nil
				], 			
	
	/* 2 */		[nil, [\ev1, \ev2]]	
				], 0.dbamp, id: "test");

	// show the ProcModR GUIs
	pevents.showPMGUIs = true; 
	// show the performance GUI
	pevents.perfGUI;
});

)