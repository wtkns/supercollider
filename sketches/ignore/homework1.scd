// part a - melody
(
var data, routine, sd;
var do, re, mi, fa, sol, la, ti, hiDo, hiRe, hiMi, hiFa, hiSol, hiLa, hiTi, loDo, loRe, loMi, loFa, loSol, loLa, loTi;

loDo = PitchClass(\g, 3);
loRe = PitchClass(\a, 3);
loMi = PitchClass(\b, 3);
loFa = PitchClass(\c, 3);
loSol = PitchClass(\d, 4);
loLa = PitchClass(\e, 4);
loTi = PitchClass(\fs, 4);
do = PitchClass(\g, 4);
re = PitchClass(\a, 4);
mi = PitchClass(\b, 4);
fa = PitchClass(\c, 5);
sol = PitchClass(\d, 5);
la = PitchClass(\e, 5);
ti = PitchClass(\fs, 5);
hiDo = PitchClass(\g, 5);
hiRe = PitchClass(\a, 5);
hiMi = PitchClass(\b, 5);
hiFa = PitchClass(\c, 6);
hiSol = PitchClass(\d, 6);
hiLa = PitchClass(\e, 6);
hiTi = PitchClass(\fs, 6);

sd = CtkSynthDef(\note, {arg freq, amp, dur;
	var env;
	env = EnvGen.kr(
		Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
		timeScale: dur);
	Out.ar(0, Pan2.ar(
		SinOsc.ar(freq, 0, amp) * env
		)
	)
});

data = [
[hiDo, 0.5, 0.3], [hiDo, 0.5, 0.3], 
[ti, 0.5, 0.3], [ti, 0.5, 0.3], 
[la, 0.5, 0.3], [la, 0.5, 0.3], 
[sol, 0.5, 0.3], [sol, 0.5, 0.3], 
[fa, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.35], [sol, 0.25, 0.35], 
[mi, 0.25, 0.35], [fa, 0.25, 0.35], [sol, 0.25, 0.35], [la, 0.25, 0.25],
[sol, 0.25, 0.35], [fa, 0.25, 0.35], [mi, 0.25, 0.35], [re, 0.25, 0.25], 
[do, 2.0, 2.1], [mi, 0.5, 0.5],

[do, 0.25, 0.35], [re, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.25],
[sol, 0.5, 0.3], [mi, 0.5, 0.3],
[fa, 0.5, 0.3], [re, 0.5, 0.3],
[sol, 0.5, 0.55], [mi, 0.5, 0.5],
[re, 0.25, 0.35], [loSol, 0.25, 0.35], [loLa, 0.25, 0.35], [loTi, 0.25, 0.35], 
[do, 0.25, 0.35], [re, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.25],
[sol, 0.5, 0.5], [hiSol, 0.5, 0.5],
[hiMi, 2.0, 2.1], [hiDo, 0.25, 0.35],[hiRe, 0.25, 0.35],

[hiMi, 0.25, 0.35], [hiFa, 0.25, 0.35], [hiSol, 0.25, 0.35], [hiLa, 0.25, 0.25],
[hiRe, 0.5, 0.3], [hiSol, 0.5, 0.3],
[hiDo, 0.25, 0.35],
[hiFa, 0.5, 0.3],[hiMi, 0.5, 0.3],
[la, 0.25, 0.35],
[hiRe, 0.5, 0.5],
[hiDo, 0.25, 0.35],[hiDo, 0.25, 0.35],[ti, 0.25, 0.35],
[hiDo, 2.0, 2.1], [sol, 0.5, 0.5],
];

routine = Routine({
	data.do({arg eachNote, i;
		var pc, noteFreq, noteDur, noteArtic;
		// noteDur is duration in meter
		// noteArtic is actual duration due to staccatos and slurs
		#pc, noteDur, noteArtic = eachNote;
		noteFreq = pc.freq;
		[noteFreq.round(0.1), noteDur, noteArtic].postln; // for reference
		sd.note(0.2, noteDur).freq_(noteFreq).dur_(noteArtic).amp_(0.3).play;
		noteDur.wait;
	})
});

routine.play;
)

// part B - Canon

(
Server.default = s = Server.internal.boot;

s.waitForBoot({
	Routine.run({
				
		var data, sd;
		var routFunction, routine1, routine2, routine3;
		var do, re, mi, fa, sol, la, ti, hiDo, hiRe, hiMi, hiFa, hiSol, hiLa, hiTi, loDo, loRe, loMi, loFa, loSol, loLa, loTi;
			loDo = PitchClass(\g, 3); loRe = PitchClass(\a, 3);
			loMi = PitchClass(\b, 3); loFa = PitchClass(\c, 3);
			loSol = PitchClass(\d, 4); loLa = PitchClass(\e, 4);
			loTi = PitchClass(\fs, 4); do = PitchClass(\g, 4);
			re = PitchClass(\a, 4); mi = PitchClass(\b, 4);
			fa = PitchClass(\c, 5); sol = PitchClass(\d, 5);
			la = PitchClass(\e, 5); ti = PitchClass(\fs, 5);
			hiDo = PitchClass(\g, 5); hiRe = PitchClass(\a, 5);
			hiMi = PitchClass(\b, 5); hiFa = PitchClass(\c, 6);
			hiSol = PitchClass(\d, 6); hiLa = PitchClass(\e, 6); hiTi = PitchClass(\fs, 6);
		
		sd = CtkSynthDef(\note, {arg freq, amp, dur;
			var env;
			env = EnvGen.kr(
				Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				SinOsc.ar(freq, 0, amp) * env
				)
			)
		});
		
		data = [
		[hiDo, 0.5, 0.3], [hiDo, 0.5, 0.3], 
		[ti, 0.5, 0.3], [ti, 0.5, 0.3], 
		[la, 0.5, 0.3], [la, 0.5, 0.3], 
		[sol, 0.5, 0.3], [sol, 0.5, 0.3], 
		[fa, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.35], [sol, 0.25, 0.35], 
		[mi, 0.25, 0.35], [fa, 0.25, 0.35], [sol, 0.25, 0.35], [la, 0.25, 0.25],
		[sol, 0.25, 0.35], [fa, 0.25, 0.35], [mi, 0.25, 0.35], [re, 0.25, 0.25], 
		[do, 2.0, 2.1], [mi, 0.5, 0.5],
		
		[do, 0.25, 0.35], [re, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.25],
		[sol, 0.5, 0.3], [mi, 0.5, 0.3],
		[fa, 0.5, 0.3], [re, 0.5, 0.3],
		[sol, 0.5, 0.55], [mi, 0.5, 0.5],
		[re, 0.25, 0.35], [loSol, 0.25, 0.35], [loLa, 0.25, 0.35], [loTi, 0.25, 0.35], 
		[do, 0.25, 0.35], [re, 0.25, 0.35], [mi, 0.25, 0.35], [fa, 0.25, 0.25],
		[sol, 0.5, 0.5], [hiSol, 0.5, 0.5],
		[hiMi, 2.0, 2.1], [hiDo, 0.25, 0.35],[hiRe, 0.25, 0.35],
		
		[hiMi, 0.25, 0.35], [hiFa, 0.25, 0.35], [hiSol, 0.25, 0.35], [hiLa, 0.25, 0.25],
		[hiRe, 0.5, 0.3], [hiSol, 0.5, 0.3],
		[hiDo, 0.25, 0.35],
		[hiFa, 0.5, 0.3],[hiMi, 0.5, 0.3],
		[la, 0.25, 0.35],
		[hiRe, 0.5, 0.5],
		[hiDo, 0.25, 0.35],[hiDo, 0.25, 0.35],[ti, 0.25, 0.35],
		[hiDo, 2.0, 2.1], [sol, 0.5, 0.5]
		];
		
		
		routFunction = {
			var routine;
			routine = Routine({
				data.do({arg eachNote, i;
					var pc, noteFreq, noteDur, noteArtic;
					// noteDur is duration in meter
					// noteArtic is actual duration due to staccatos and slurs
					#pc, noteDur, noteArtic = eachNote;
					noteFreq = pc.freq;
					[noteFreq.round(0.1), noteDur, noteArtic].postln; // for reference
					sd.note(0.2, noteDur).freq_(noteFreq).dur_(noteArtic).amp_(0.3).play;
					noteDur.wait;
				})
			});
			routine;
		};
		
		routine1 = routFunction.();
		routine2 = routFunction.();
		routine3 = routFunction.();
		
		Routine.run({
					routine1.play;
					8.wait;
					routine2.play;
					16.wait;
					routine3.play;
		})
	})
})				
)

//part C: Goldbach Variations

(
// main variation variables:
		var variation = 1640;
		var piecelength = 40;

// main functions:
		var isEven = {arg n;
			(n%2==0);
		};
		
		var getDur = {arg dur, length;
			(dur / (variation / length));
		};
		
		var getPrimes = { arg n;
			var tempPrimes = Array.new();
			var p = Array.series(n, 2, 1); // fill array p with [2 through n]
			while ( { p.size > 0 }, { 
				x = p[0];
				tempPrimes = tempPrimes.add(x);
				p.removeAllSuchThat({ arg item, i; item % x == 0 });
			 });
			tempPrimes;
		};
		
		var getFactors = { arg n;
			var factors;
			if(n.even)
				{forBy (2, sqrt(n), 2, 
				  	{ arg i; 
					  	if (n%i==0 && isEven.value(n/i))
					  	{factors = factors.add([i,n/i])}
					});				
				}{ "the number is odd"};
			factors;
		};
		
		var getGoldbach = { arg n;
			var testPrimes = getPrimes.value(n);
			var results = Array.new();
			for (0, testPrimes.size-1, {arg i;
				if (testPrimes.includes(n-testPrimes[i]),
					{results = results.add([testPrimes[i], n-testPrimes[i]])}
				);
			});
			results
		};

// boot server
	Server.default = s = Server.internal.boot;
	s.scope;
	s.waitForBoot({	
		
		// prepare buffer
		var data, routFunction, sd, myBuffers, buffer1,buffer2,buffer3, cond;
		cond = Condition.new;

		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer2 = CtkBuffer.buffer(8192, server: s).load;
		buffer3 = CtkBuffer.buffer(8192, server: s).load;

		buffer1.sine1(0.0, 1, 1, 1, 1);
		buffer2.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		buffer3.sine1(0.0, 1, 1, 1, 1.0, 0.2, 0.7, 0.1, 0.6, 0.1, 0.8);
		
		s.sync(cond);
		"Buffers are loaded!".postln;
		
		myBuffers = [buffer1, buffer2, buffer3];
		
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
						myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})

		});
		
		
		// define SynthDef
		sd = CtkSynthDef(\note, {arg buffer, freq, amp, dur;
			var env;
			env = EnvGen.kr(
				Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), 
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				Osc.ar(buffer, freq, 0, amp) * env
				)
			)
		});

		routFunction = {arg fundamental = variation, length = piecelength, buffer = buffer1, pause = 0;
			var routine;
			var partitions = getGoldbach.(fundamental);			routine = Routine({
				pause.wait;
				partitions.do({arg thisData, i;
					var freq, dur;
					#freq, dur = thisData;
					dur = getDur.value(dur, length);
					sd.note(0.2, dur).buffer_(buffer).freq_(freq).dur_(dur).amp_(0.3).play;
					
				});
			});
			routine;	
		};
	
		Routine.run({	
			var factors, length, routine, pause;
			routine = [routFunction.value().play];
			routine = routine.add(routFunction.value(length: piecelength-20, pause:10, buffer: buffer2).play;);
			routine = routine.add(routFunction.value(length: piecelength-30, pause:20, buffer: buffer3).play;);
		})
}) // end wait for boot	
)