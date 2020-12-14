(
var variation = 440;
var piecelength = 20;

var isEven = {arg n;
	(n%2==0);
};

var getDur = {arg dur, length;
	(dur / (variation / piecelength));
};

var getPrimes = { arg n;
	var p = Array.series(n, 2, 1); // fill array p with [2 through n]
	var tempPrimes = Array.new();
	while ( { p.size > 0 }, { 
		x = p[0];
		tempPrimes = tempPrimes.add(x);
		p.removeAllSuchThat({ arg item, i; item % x == 0 });
	 });
	tempPrimes
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
factors};

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

Server.default = s = Server.internal.boot;
s.scope;

s.waitForBoot({
		var data, routine, sd;
		var buffer1, cond;
		cond = Condition.new;
		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer1.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		s.sync(cond);
		"Buffers are loaded!".postln;
		
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			buffer1.free;
		});
		
		
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
		
		routine = Routine({arg fundamental, time;
			var partitions = getGoldbach.(fundamental);
			partitions.do({arg thisData, i;
				var freq, dur;
				#freq, dur = thisData;

				dur = getDur.value(dur);
				sd.note(0.2, dur).buffer_(buffer1).freq_(freq).dur_(dur).amp_(0.3).play;
			})
		});

	Routine.run({		
//		var factors = getFactors.value(variation);
		routine.value(variation);
	})
}) // end wait for boot	
)