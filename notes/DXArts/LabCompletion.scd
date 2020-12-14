(
/* create vars for notes and durations */
var d4, e4, fs4, g4, a4, b4, c5, d5, e5, fs5, g5, a5, b5, c6, d6, e6, q, e, x;
/* var for a Function that will create a routine to play my melody, and the melody */
var melFunc, melody, durScaler ;
/* the CtkSynthDef */
var sd;

Server.default = s = Server.internal.boot;
durScaler = 1;
s.waitForBoot({
	d4 = PC(\d, 4);
	e4 = PC(\e, 4);
	fs4 = PC(\fs, 4);
	g4 = PC(\g, 4);
	a4 = PC(\a, 4);
	b4 = PC(\b, 4);
	c5 = PC(\c, 5);
	d5 = PC(\d, 5);
	e5 = PC(\e, 5);
	fs5 = PC(\fs, 5);
	g5 = PC(\g, 5);
	a5 = PC(\a, 5);
	b5 = PC(\b, 5);
	c6 = PC(\c, 6);
	d6 = PC(\d, 6);
	e6 = PC(\e, 6);
	
	q = 1.0 * durScaler;
	e = 0.5 * durScaler;
	x = 0.25 * durScaler;
	
	sd = CtkSynthDef(\myNote, {arg freq, dur = 1;
		var env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
			timeScale: dur);
		Out.ar(0, Pan2.ar(
			SinOsc.ar(freq, 0, 0.2) * env)
		)
	});
	
	melody = [
		/* first part */
		[g5, e], [g5, e], [fs5, e], [fs5, e], [e5, e], [e5, e], [d5, e], [d5, e], 
		[c5, x], [b4, x], [c5, x], [d5, x], [b4, x], [c5, x], [d5, x], [e5, x], 
		[d5, x], [c5, x], [b4, x], [a4, x], [g4, e], [b4, e], 
		/* second part */
		[g4, x], [a4, x], [b4, x], [c5, x], [d5, e], [b4, e], [c5, e], [a4, e], 
		[fs4, e], [g4, e], [a4, x], [d4, x], [e4, x], [fs4, x], [g4, x], [a4, x], 
		[b4, x], [c5, x], [d5, e], [d6, e], [b5, e], 
		/* third part */
		[g5, x], [a5, x], [b5, x], [c6, x], [d6, x], [e6, x], [a5, e], [d6, e], 
		[g5, e], [c6, q], [b5, e], [e5, e], [a5, q], [g5, q], [fs5, e], [g5, e], 
		[d5, e]
		];
	
	// make a Function to create and play your Routines
	melFunc = {arg theMelody;
		var routine;
		routine = Routine({
			theMelody.do({arg data;
				var pc, dur, freq;
				#pc, dur = data;
				freq = pc.freq;
				sd.note(0.1, dur).freq_(freq).dur_(dur).play;
				dur.wait;
			});
		});
		routine.play;
	};
	
	Routine.run({
		3.do({
			melFunc.value(melody);
			(8 * durScaler).wait;
		})	
	})
})
)


/* a quick way to deal with global amplitude */

(
/* create vars for notes and durations */
var d4, e4, fs4, g4, a4, b4, c5, d5, e5, fs5, g5, a5, b5, c6, d6, e6, q, e, x;
/* var for a Function that will create a routine to play my melody, and the melody */
var melFunc, melody ;
/* the CtkSynthDef */
var sd;
/* set global amplitude scaler */
var globalAmp;

globalAmp = -12.dbamp;

Server.default = s = Server.internal.boot;
s.waitForBoot({
	d4 = PC(\d, 4);
	e4 = PC(\e, 4);
	fs4 = PC(\fs, 4);
	g4 = PC(\g, 4);
	a4 = PC(\a, 4);
	b4 = PC(\b, 4);
	c5 = PC(\c, 5);
	d5 = PC(\d, 5);
	e5 = PC(\e, 5);
	fs5 = PC(\fs, 5);
	g5 = PC(\g, 5);
	a5 = PC(\a, 5);
	b5 = PC(\b, 5);
	c6 = PC(\c, 6);
	d6 = PC(\d, 6);
	e6 = PC(\e, 6);
	
	q = 1.0;
	e = 0.5;
	x = 0.25;
	
	sd = CtkSynthDef(\myNote, {arg freq, dur = 1, scale = 1;
		var env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
			timeScale: dur);
		Out.ar(0, Pan2.ar(
			SinOsc.ar(freq, 0, 0.2) * env * scale)
		)
	});
	
	melody = [
		/* first part */
		[g5, e], [g5, e], [fs5, e], [fs5, e], [e5, e], [e5, e], [d5, e], [d5, e], 
		[c5, x], [b4, x], [c5, x], [d5, x], [b4, x], [c5, x], [d5, x], [e5, x], 
		[d5, x], [c5, x], [b4, x], [a4, x], [g4, e], [b4, e], 
		/* second part */
		[g4, x], [a4, x], [b4, x], [c5, x], [d5, e], [b4, e], [c5, e], [a4, e], 
		[fs4, e], [g4, e], [a4, x], [d4, x], [e4, x], [fs4, x], [g4, x], [a4, x], 
		[b4, x], [c5, x], [d5, e], [d6, e], [b5, e], 
		/* third part */
		[g5, x], [a5, x], [b5, x], [c6, x], [d6, x], [e6, x], [a5, e], [d6, e], 
		[g5, e], [c6, q], [b5, e], [e5, e], [a5, q], [g5, q], [fs5, e], [g5, e], 
		[d5, e]
		];
	
	// make a Function to create and play your Routines
	melFunc = {arg theMelody;
		var routine;
		routine = Routine({
			theMelody.do({arg data;
				var pc, dur, freq;
				#pc, dur = data;
				freq = pc.freq;
				sd.note(0.1, dur).freq_(freq).dur_(dur).scale_(globalAmp).play;
				dur.wait;
			});
		});
		routine.play;
	};
	
	Routine.run({
		3.do({
			melFunc.value(melody);
			8.wait;
		})	
	})
})
)