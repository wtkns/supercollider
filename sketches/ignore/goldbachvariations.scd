(var variation = 680;
 var piecelength = 20;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	
	Routine.run({
		
		
		
		var isEven = {arg n;
		(n%2==0);};
		
		var getDur = {arg dur;
			(dur / (variation / piecelength));
		};
		
		var getFactors = { arg n;
			if(n.even)
				{ 
				  forBy (2, sqrt(n), 2, 
				  	{ arg i; 
					  	if (n%i==0 && isEven.value(n/i))
					  	{factors = factors.add([i,n/i])}
					}
				  );				
				}
				{ "the number is odd"};
		factors};
		
		var getPrimes = { arg n;
			var p = Array.series(n, 2, 1); // fill array p with [2 through n]
			var tempPrimes = Array.new();
			while ( { p.size > 0 }, { 
				x = p[0];
				tempPrimes = tempPrimes.add(x);
				p.removeAllSuchThat({ arg item, i; item % x == 0 });
			 });
		tempPrimes};
		
		var getGoldbach = { arg n;
			var testPrimes = Array.newFrom(primes);
			var results = Array.new();
			for (0, testPrimes.size-1, {arg i;
				if (testPrimes.includes(n-testPrimes[i]),
					{results = results.add([testPrimes[i], n-testPrimes[i]])}
				);
			});
		results };	
		
		var factors = getFactors.(variation).postln;
		var primes = getPrimes.(variation).postln;
		var partitions = getGoldbach.(variation).postln;
		
				
		var data, routine, sd;
		
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
		
		routine = Routine({
			partitions.do({arg thisData, i;
				var freq, dur;
				#freq, dur = thisData;
				dur = getDur.value(dur).postln;
				// see how the data is iterated over and parsed!
				[thisData, freq, dur].postln;
				sd.note(0.2, dur).freq_(freq).dur_(dur).amp_(0.3).play;
			})
		});
		
		routine.play;
		
	})	// end routine
}) // end wait for boot	
)