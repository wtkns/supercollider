Server.default = s = Server.internal.boot;

s.waitForBoot({
	Routine.run({
		var cond;
		var myBuffers, buffer1, buffer2, buffer3;
		var sd;
		var routFunction, routine1, routine2, routine3;
		
		// set up a Condition for the sync. Server messages will tell this class 
		// if the Server is done loading memory
		cond = Condition.new;

		// declare and load the CtkBuffers
		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer2 = CtkBuffer.buffer(8192, server: s).load;
		buffer3 = CtkBuffer.buffer(8192, server: s).load;
		
		// now, do something with the CtkBuffers, and sync again
		buffer1.sine1(0.0, 1, 1, 1, 1);
		buffer2.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		buffer3.sine1(0.0, 1, 1, 1, 1.0, 0.2, 0.7, 0.1, 0.6, 0.1, 0.8);
		
		// wait until the server confirms that the buffers where loaded
		s.sync(cond);
		
		// Post a message when we move onto the rest of the code ...
		"Buffers are loaded!".postln;
		
		// create myBuffers and initialize its data to the three CtkBuffers
		myBuffers = [buffer1, buffer2, buffer3];
		
		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
			myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})
		});
		
		sd = CtkSynthDef(\osc, {arg buffer, freq, dur = 1;
			var env;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.2, 0.3, 0.5], [\sin, \lin, -4]),
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				// Osc.ar(table, freq, phase, mul, add)
				Osc.ar(buffer, freq, 0, 0.2) * env)
			)
		});
		
		routFunction = {arg buffer, duration = 1, waitTime = 0.5, freqScaler = 1;
			var routine;
			// create a Routine and return it from the Function. 'buffer' is an argument
			// that is passed in.
			routine = Routine({
				[PC(\c, 4), PC(\d, 4), PC(\ef, 4), PC(\f, 4), PC(\g, 4), PC(\af, 4), 
					PC(\b, 4), PC(\c, 5)].do({arg pc;
						sd.note(0.1, duration).buffer_(buffer).freq_(pc.freq * freqScaler)
							.dur_(duration).play;
						waitTime.wait;
					})
			});
			routine;
		};
		
		// use the defaults
		routine1 = routFunction.value(buffer1);
		// change the arg values
		routine2 = routFunction.value(buffer2, 2.2, 0.7, 2.0);
		// use keywords to change JUST specific args. Once you use keywords, you need to keep
		// using keywords after that. BUT - they don't need to be in order
		routine3 = routFunction.value(buffer3, freqScaler: 0.7, waitTime: 0.3);
				
		// now - play some notes
		Routine.run({
			routine1.play;
			2.wait;
			routine2.play;
			2.wait;
			routine3.play;
		})

	})
});	
